"""Drive the CPU/DSP mailbox on a physical Courier through the ATGLK2 monitor.

The supervisor's own mailbox interrupt at `0fda9` establishes the protocol
(see `docs/dsp-rom-probe.md`, "The supervisor's half of the mailbox"): an
outbound message is a 16-bit tag word on ports `58`/`5a` and a 16-bit value on
`5c`/`5e`, and it is committed by answering the board's standing request -
writing bit 0 back to port `1c`. A first attempt without that edge,
`artifacts/dsp-mailbox-write-01/`, observed nothing.

This tool writes I/O ports on a live modem. It writes only the six mailbox
registers; the board latches at `0x10`, `0x12` and `0x14`, which carry the hook
relay and the NVRAM strobe, are refused outright. It issues no memory write,
no flash operation and no firmware upload - the monitor has no selector for
any of those.

Two experiments:

`queue` seeds the DSP's own outbound ring at data `0bd0` and resets its two
pointers, so the resident sender at `83d6` reports a chosen word the next time
it runs. It depends on no other datapump code path, so a null result implicates
the host write and nothing else.

`read` writes the index cell at data `03e6` that the `e732` loop uses, asking
for one program word at `e870 + index`. That loop rewrites its own index every
iteration and only runs when the datapump reaches it, so a null result here is
ambiguous - run `queue` first.
"""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import re
import select
import time

from .flash_dump import SerialPort, TERMINAL, validate_identity

# The four data registers and the two status registers, and nothing else.
TAG_PORTS = (0x58, 0x5A)
VALUE_PORTS = (0x5C, 0x5E)
STATUS_PORT, COMMAND_PORT = 0x1C, 0x1E
WRITABLE = (*TAG_PORTS, *VALUE_PORTS, STATUS_PORT, COMMAND_PORT)
# Board latch 0 drives the hook relay and the NVRAM chip select; latch 2 drives
# the carrier-detect pair. None of them is part of the mailbox.
FORBIDDEN = (0x10, 0x12, 0x14)
# Answering the board's standing request is what commits the window.
COMMIT = 0x01

# The DSP's host-command dispatcher at 839b reads the tag from ASIC cell ff5e
# and the data word from ff5f, rejects any tag above 7f, and branches through a
# 121-entry jump table in program memory. So a tag is a command selector, not a
# data address - which is why seeding a ring through it could never have worked.
DISPATCH_TABLE = 0x8401     # program word 8401 + tag
MAX_TAG = 0x7F

# Handlers that are a bare `ret` at program 8222. Sending one of these is a
# complete no-op on the board and is the null control for a port observation.
NO_OP_TAGS = (0x0B, 0x2C, 0x2D, 0x31, 0x6C, 0x6D, 0x6E, 0x6F)

# Tag 07's handler at 84cb is three instructions: enqueue 8031, enqueue the
# word at data 0818, return. It consumes no host data, writes nothing and
# changes no state, so it is a pure query. Bit 15 of 8031 makes the sender at
# 83e6 emit the following word too, and it masks the bit off, so the tag
# reaches the CPU's inbound register as 31.
QUERY_TAG = 0x07
QUERY_REPLY_TAG = 0x8031 & 0x7FFF

# Tag 62's handler at c4b4 sums a sample buffer and reports under 8069. It is
# heavier than tag 07 - about a hundred words of arithmetic - but it is the
# only other short handler that reports a constant, so it is what moves the
# inbound register off 31 and back again.
SECOND_QUERY_TAG = 0x62
SECOND_QUERY_REPLY_TAG = 0x8069 & 0x7FFF

# Every tag whose handler stores the host's own 16-bit word to a fixed DSP
# data address, recovered from the jump table by following each handler. This
# is the actual host-write primitive the board offers: not an arbitrary
# address, but a choice of 29 destinations. Cells at ff00 and above are ASIC
# or high data space; the rest are ordinary DSP RAM.
#
# Neither 03db, the index of the unscaled program reader at 84d3, nor 03e6,
# the index of the e732 loop, is among them - so neither of the read chains
# recorded in docs/dsp-rom-probe.md has a host entry point through this table.
# Only 032a feeds a table read at all, and both its writers clamp it below the
# six-entry jump table it indexes. Tag 41's clamp is thirteen against that same
# six entries, so values above five fetch instruction words as routine
# addresses - entry six is 7a80, outside both the downloaded image and the
# C52's 0000..0fff mask-ROM window. Its installed contents are unknown. Never
# send it.
HOST_WRITE_CELLS = {
    0x02: 0xFF62, 0x0F: 0x039D, 0x10: 0x03A6, 0x11: 0x03A6, 0x14: 0x03A6,
    0x17: 0x03A6, 0x19: 0x03AD, 0x1A: 0x0392, 0x1B: 0x03F1, 0x1F: 0x03AE,
    0x2B: 0x081C, 0x39: 0x032A, 0x3C: 0xFFF0, 0x40: 0x03DC, 0x41: 0x032A,
    0x42: 0x0346, 0x48: 0xFFB1, 0x49: 0xFFB5, 0x51: 0xFFF2, 0x52: 0xFF2E,
    0x53: 0xFF2F, 0x5F: 0x03A6, 0x70: 0xFFF1, 0x71: 0xFFF3, 0x74: 0xF99D,
    0x76: 0xF99B, 0x77: 0xF99C,
}
# Tag 42's handler at b05e is the cleanest of them: store and return, with no
# range check and no state change.
SIMPLE_WRITE_TAG = 0x42
# Tag 41 accepts 0..12 but indexes a six-entry table; 6..12 send the DSP to a
# routine address decoded from instruction words, one of them in the mask ROM.
UNSAFE_WRITES = {0x41: range(6, 13)}

# The 60/62 window. The DSP's sender - 84b7 in 3.0.13, 849e in 3.1.2 - is
# `out *, 0060` followed by `lacl #04 ; samm @57`, and that 4 is the status bit
# the CPU reads as 1c bit 2, which the mailbox interrupt answers by calling the
# chain vector: [0x2d3] under supervisor 7.3.14, [0x01cd] under 7.4.16. So the
# window's producer is the DSP, one word per interrupt, and tag 06 - handler
# 8489 in 3.0.13, 8470 in 3.1.2 - is what starts it. The supervisor's own
# trigger arms the vector and then sends exactly this tag with this data byte:
# 6d08 in 7.3.14, 6d52 in 7.4.16. See STREAM_PROFILES and CHAIN_PROFILES.
STREAM_TAG, STREAM_DATA = 0x06, 0x3F
# Acknowledging bit 2 is what resumes the DSP through 039e and makes it emit
# the next word, exactly as bit 0 commits a mailbox message.
PUMP_ACK = 0x04
# Tag 06's streamer sends these DSP data cells in order, one per pump, then
# enters a loop. The values are live state, so what is predictable is
# the sequence's existence and length, not its contents.
STREAM_SOURCES = (0x0307, 0x03BA, 0x0385, 0x030F, 0x031C, 0x0BE6)
# The streamer does not stop at those six. Its last step calls a packer that
# reads DP-007 cells 0381 and 0383, NORMs the sum, and leaves an exponent and
# mantissa in scratch cell 007d, which is then streamed like any other source.
# So a pump run carries a seventh word that is computed rather than a cell
# read. Both board images do this; the six-entry list above was incomplete.
STREAM_DERIVED = 0x007D
STREAM_DERIVED_INPUTS = (0x0381, 0x0383)

# Where that streamer lives, per DSP revision. The handler and the `out *, 0060`
# site move between builds; the six sources, the packer and the scratch cell do
# not - verified by disassembling both captured board images. Tag 46 is
# deliberately absent for 3.1.2: its handler moved to 84ba and reads a different
# table, so PROGRAM_STREAM_BASE and the 03db index are not established there.
STREAM_PROFILES = {
    "3.0.13": {"handler": 0x8489, "streamer": 0x84B7, "packer": 0x84BC,
               "arms": (STREAM_TAG, 0x46)},
    "3.1.2": {"handler": 0x8470, "streamer": 0x849E, "packer": 0x84A3,
              "arms": (STREAM_TAG,)},
}

# Tag 46 arms the same streamer over ff80, but fills ff80..ff83 first with four
# PROGRAM words table-read from 860b + the index at 03db. That index is not
# host-controlled - ae12 yields 0..5 - but every one of the six possibilities
# is a known tuple out of the payload image, so the first four words a pump
# produces can be predicted exactly. This is the check that says whether the
# window really carries DSP program memory to the host.
PROGRAM_STREAM_TAG = 0x46
PROGRAM_STREAM_BASE = 0x860B
# `tblr *+` post-increments the auxiliary register, not the accumulator, so a
# pair of them re-reads one address. The four words are therefore two addresses
# each read twice, six apart - established by the hardware run, which corrected
# a (0, 1, 7, 8) reading of the same four instructions.
PROGRAM_STREAM_OFFSETS = (0, 0, 6, 6)
MAX_INDEX = 6               # ae12 bit-scans a status word and returns 0..5

# What ae12 scans. ade8 returns [ffb0] & [ffb1] & [ffb2] & [ffb3], and ae12
# priority-encodes bits 1..5 of it, highest first. Tag 48's handler is a bare
# `smmr @7a, #ffb1 ; ret` with no clamp, so one of those four AND terms is
# host-writable with a full 16-bit word. Because it is an AND, a host can only
# clear bits - but if ffb1 is what is currently masking the index to zero, then
# writing it all-ones reveals whatever ffb0, ffb2 and ffb3 carry.
INDEX_MASK_TAG = 0x48
INDEX_MASK_CELL = 0xFFB1
ARM_TAGS = (STREAM_TAG, PROGRAM_STREAM_TAG)


def predicted_program_words(payload: dict[int, int]) -> dict[int, tuple[int, ...]]:
    """The six tuples tag 46 can produce, one per value ae12 can return."""
    return {
        index: tuple(payload[PROGRAM_STREAM_BASE + index + step]
                     for step in PROGRAM_STREAM_OFFSETS)
        for index in range(MAX_INDEX)
    }
WINDOW_PORTS = (0x60, 0x62)
# The chain state and the four buffers it fills, all readable with ATGLK2=.
# These are supervisor addresses, and they move between builds. 7.4.16's set
# was derived from the captured images rather than assumed: `mov [cell], imm`
# writes whose immediate is a nearby code address pick out the self-chaining
# vector uniquely - 14 of them on 02D3 in 7.3.14, 14 on 01CD in 7.4.16, with
# the code shifted a constant +0x32 and the arm site moving 6d08 -> 6d52. The
# countdown and header keep their offsets either side of the vector, and each
# is referenced the same number of times inside the chain region (3 and 2).
# The buffers were mapped by reading 7.4.16 at the same instruction offsets,
# a constant -0x10C, with the length/count/pointer trio intact at -4/-3/-2.
CHAIN_PROFILES = {
    "7.3.14": {
        "countdown": 0x02D1, "vector": 0x02D3, "header": 0x02D5,
        "parked": 0x200C,   # a bare `ret`
        "steps": (0x1FDB, 0x1FE6, 0x200C, 0x201E, 0x202A, 0x2037, 0x205A, 0x206B,
                  0x2077, 0x2084, 0x20AA, 0x20BB, 0x20C7, 0x20D4, 0x20FA, 0x210B,
                  0x2117, 0x2124),
        "buffers": {0x08A4: (0x08A0, 0x08A1, 0x08A2),
                    0x09C2: (0x09BE, 0x09BF, 0x09C0),
                    0x08F2: (0x08EE, 0x08EF, 0x08F0),
                    0x0946: (0x0942, 0x0943, 0x0944)},
    },
    "7.4.16": {
        "countdown": 0x01CB, "vector": 0x01CD, "header": 0x01CF,
        "parked": 0x203E,   # a bare `ret`, 200C + 0x32
        "steps": (0x200D, 0x2018, 0x203E, 0x2050, 0x205C, 0x2069, 0x208C, 0x209D,
                  0x20A9, 0x20B6, 0x20DC, 0x20ED, 0x20F9, 0x2106, 0x212C, 0x213D,
                  0x2149, 0x2156),
        "buffers": {0x0798: (0x0794, 0x0795, 0x0796),
                    0x08B6: (0x08B2, 0x08B3, 0x08B4),
                    0x07E6: (0x07E2, 0x07E3, 0x07E4),
                    0x083A: (0x0836, 0x0837, 0x0838)},
    },
}
# The 7.3.14 names stay, because everything written against them means 7.3.14.
CHAIN_COUNTDOWN = CHAIN_PROFILES["7.3.14"]["countdown"]
CHAIN_VECTOR = CHAIN_PROFILES["7.3.14"]["vector"]
CHAIN_HEADER = CHAIN_PROFILES["7.3.14"]["header"]
CHAIN_BUFFERS = CHAIN_PROFILES["7.3.14"]["buffers"]
CHAIN_STEPS = CHAIN_PROFILES["7.3.14"]["steps"]
CHAIN_PARKED = CHAIN_PROFILES["7.3.14"]["parked"]

# DSP data addresses, all at page 0 and all ordinary RAM above the C5x's
# memory-mapped registers.
QUEUE_BASE = 0x0BD0         # the ring 83ca loads into ar0
QUEUE_READ = 0x0079         # @79, the sender's read pointer
QUEUE_WRITE = 0x0078        # @78, the enqueue's write pointer
INDEX_CELL = 0x03E6         # @66 at page 7, the e732 loop's index
LOOP_BASE = 0xE870          # the program address that index is added to

# The eleven inbound tags command mode dispatches on; a reply whose low byte is
# one of these is acted upon by the supervisor rather than merely latched.
COMMAND_MODE_TAGS = (0x76, 0x05, 0x06, 0x04, 0x12, 0x13, 0x88, 0x89, 0x0D, 0x0E, 0x83)

READ_REPLY = re.compile(rb"\r\r\n([0-9A-F]{2})\r\nOK\r\n")


class MailboxPort(SerialPort):
    """A SerialPort that also permits the six mailbox port operations.

    The inherited `query` is a read-only gate: it rejects anything but `AT`,
    `ATI7` and a canonical `ATGLK2=` memory read. Port operations are admitted
    here, through their own allowlist, and everything else still falls through
    to that gate.
    """

    def query(self, command: str, timeout: float = 4.0) -> bytes:
        read = re.fullmatch(r"ATGLK2I00([0-9A-F]{2})", command)
        write = re.fullmatch(r"ATGLK2O00([0-9A-F]{2}),([0-9A-F]{2})", command)
        if not (read or write):
            return super().query(command, timeout)
        port = int((read or write)[1], 16)
        if port in FORBIDDEN:
            raise ValueError(f"port {port:02x} drives the board latches; refused")
        if write and port not in WRITABLE:
            raise ValueError(f"port {port:02x} is not a mailbox register; refused")
        return _transact(self, command, timeout)


def _transact(port: SerialPort, command: str, timeout: float) -> bytes:
    """Transmit one command and read back to its terminal result code."""
    data = (command + "\r").encode("ascii")
    deadline = time.monotonic() + timeout
    while data:
        left = deadline - time.monotonic()
        if left <= 0 or not select.select([], [port.fd], [], left)[1]:
            raise TimeoutError("serial write timed out")
        data = data[os.write(port.fd, data):]
    response = bytearray()
    while time.monotonic() < deadline:
        left = max(0, deadline - time.monotonic())
        if not select.select([port.fd], [], [], min(0.2, left))[0]:
            continue
        chunk = os.read(port.fd, 4096)
        if not chunk:
            continue
        response.extend(chunk)
        if len(response) > 16384:
            raise RuntimeError("response exceeds expected maximum length")
        if TERMINAL.search(response):
            break
    return bytes(response)


class Session:
    """One mailbox conversation, recording every command it issues."""

    def __init__(self, port: MailboxPort) -> None:
        self.port = port
        self.transcript: list[dict] = []
        self.chain_profile = CHAIN_PROFILES["7.3.14"]

    def command(self, text: str) -> bytes:
        raw = self.port.query(text)
        self.transcript.append({"cmd": text, "raw": raw.decode("ascii", "replace")})
        if not TERMINAL.search(raw) or TERMINAL.search(raw)[1] != b"OK":
            raise RuntimeError(f"{text} did not answer OK")
        return raw

    def read_port(self, port: int) -> int:
        match = READ_REPLY.search(self.command(f"ATGLK2I00{port:02X}"))
        if not match:
            raise RuntimeError(f"unparsable reply reading port {port:02x}")
        return int(match[1], 16)

    def write_port(self, port: int, value: int) -> None:
        self.command(f"ATGLK2O00{port:02X},{value & 0xFF:02X}")

    def ports(self, numbers) -> dict[str, str]:
        return {f"{port:02X}": f"{self.read_port(port):02X}" for port in numbers}

    def page(self, base: int) -> bytes:
        """One 256-byte page of CPU RAM, through the read-only `=` selector."""
        from .flash_dump import command_for, parse_page
        raw = self.port.query(command_for(base, allow_ram=True))
        self.transcript.append({"cmd": f"page {base:05x}", "raw": "<256 bytes>"})
        return parse_page(raw, base, allow_ram=True)[0]

    def chain(self) -> dict:
        """The 60/62 chain's vector, countdown, header and four buffers."""
        import struct
        profile = self.chain_profile
        countdown, vector_cell = profile["countdown"], profile["vector"]
        header_cell, buffers = profile["header"], profile["buffers"]
        pages = {base: self.page(base) for base in sorted(
            {cell & 0xF00 for cell in (countdown, vector_cell, header_cell)}
            | {cell & 0xF00 for buffer, trio in buffers.items()
               for cell in (buffer, buffer + 14, *trio)})}

        def word(address: int) -> int:
            return struct.unpack_from("<H", pages[address & 0xF00], address & 0xFF)[0]

        def byte(address: int) -> int:
            return pages[address & 0xF00][address & 0xFF]

        return {
            "vector": f"{word(vector_cell):04X}",
            "countdown": f"{byte(countdown):02X}",
            "header": [f"{word(header_cell + 2 * i):04X}" for i in range(6)],
            "buffers": {
                f"{buffer:04X}": {
                    "length": f"{byte(length):02X}", "count": f"{byte(count):02X}",
                    "pointer": f"{word(pointer):04X}",
                    "words": [f"{word(buffer + 2 * i):04X}" for i in range(8)],
                }
                for buffer, (length, count, pointer) in buffers.items()
            },
        }

    def window(self) -> dict[str, str]:
        return {f"{port:02X}": f"{self.read_port(port):02X}"
                for port in (STATUS_PORT, COMMAND_PORT, *TAG_PORTS, *VALUE_PORTS)}

    def send(self, tag: int, value: int) -> None:
        """One host-to-DSP message, ending with the commit the interrupt makes."""
        for port, word in ((TAG_PORTS, tag), (VALUE_PORTS, value)):
            self.write_port(port[0], word & 0xFF)
            self.write_port(port[1], (word >> 8) & 0xFF)
        self.write_port(COMMAND_PORT, 0x00)
        self.write_port(STATUS_PORT, COMMIT)


def poll(session: Session, rounds: int, baseline: dict[str, str]) -> tuple[list[dict], dict | None]:
    """Watch the inbound registers for a word the supervisor will not file.

    Command mode's dispatcher drops any tag outside its table of eleven without
    storing it, so the ASIC's own registers are the only place to look.
    """
    samples, reply = [], None
    for _ in range(rounds):
        sample = {f"{port:02X}": f"{session.read_port(port):02X}"
                  for port in (*TAG_PORTS, *VALUE_PORTS)}
        samples.append(sample)
        if reply is None and sample != {k: baseline[k] for k in sample}:
            reply = {
                "tag": (int(sample["5A"], 16) << 8) | int(sample["58"], 16),
                "value": (int(sample["5E"], 16) << 8) | int(sample["5C"], 16),
                "at_sample": len(samples),
            }
    return samples, reply


def run(session: Session, *, experiment: str, target: int, rounds: int,
        tags: list[int] | None = None, arm: int = STREAM_TAG,
        payload: dict[int, int] | None = None,
        premessage: tuple[int, int] | None = None) -> dict:
    report: dict = {
        "experiment": experiment,
        "protocol": "tag word on 58/5a, value word on 5c/5e, committed by 1c bit 0",
        "memory_write_commands": False,
        "firmware_upload": False,
        "ports_written": [f"{port:02X}" for port in WRITABLE],
        "started_utc": datetime.now(timezone.utc).isoformat(),
    }
    session.command("AT")
    report["identity"] = validate_identity(session.command("ATI7"))
    _, revision = report["identity"]
    supervisor, dsp_revision = revision
    if supervisor not in CHAIN_PROFILES:
        raise ValueError(f"the 60/62 chain is not decoded for supervisor {supervisor}")
    session.chain_profile = CHAIN_PROFILES[supervisor]
    report["chain_profile"] = {"supervisor": supervisor,
                               "vector_cell": f"{session.chain_profile['vector']:04X}"}
    no_op_tags = NO_OP_TAGS
    if revision == ("7.4.16", "3.1.2"):
        from .mailbox_compare import NOOPS
        no_op_tags = NOOPS
        if not (experiment == "command"
                or (experiment == "pump" and arm in STREAM_PROFILES["3.1.2"]["arms"])):
            raise ValueError("this experiment is decoded for DSP 3.0.13, not 3.1.2")
    if experiment == "command":
        # Validate the entire sequence before the first port write. In 3.1.2,
        # former no-op 0b selects a real handler at ec63.
        for tag in tags or []:
            if tag not in (QUERY_TAG, SECOND_QUERY_TAG, *no_op_tags):
                raise ValueError(f"tag {tag:02x} has no verified outcome for DSP {revision[1]}")
    baseline = session.window()
    report["before"] = baseline

    if experiment == "queue":
        if (target & 0xFF) in COMMAND_MODE_TAGS:
            # The dispatcher would act on the reply instead of merely leaving
            # it in the inbound registers for the poll below to read.
            raise ValueError(
                f"low byte {target & 0xFF:02x} is a tag command mode dispatches on"
            )
        report["writes"] = [
            {"address": f"{QUEUE_BASE:04X}", "value": f"{target:04X}",
             "why": "the first cell of the ring the sender at 83d6 drains"},
            {"address": f"{QUEUE_READ:04X}", "value": f"{QUEUE_BASE:04X}",
             "why": "@79, rewound to that cell"},
            {"address": f"{QUEUE_WRITE:04X}", "value": f"{QUEUE_BASE + 1:04X}",
             "why": "@78, one past it, so the sender sees exactly one word"},
        ]
        session.send(QUEUE_BASE, target)
        session.send(QUEUE_READ, QUEUE_BASE)
        session.send(QUEUE_WRITE, QUEUE_BASE + 1)
    elif experiment == "pump":
        report["writes"] = [
            {"tag": f"{STREAM_TAG:02X}", "data": f"{STREAM_DATA:02X}",
             "why": "arms the DSP streamer at 039e; emits nothing by itself"},
            {"port": f"{STATUS_PORT:02X}", "value": f"{PUMP_ACK:02X}",
             "why": "one acknowledgement of bit 2 per word, x%d" % rounds},
        ]
        if arm not in ARM_TAGS:
            raise ValueError(f"tag {arm:02x} does not arm the streamer; refused")
        if arm == STREAM_TAG:
            profile = STREAM_PROFILES.get(dsp_revision)
            if profile is None:
                raise ValueError(f"tag 06's streamer is not decoded for DSP {dsp_revision}")
            report["stream_profile"] = {
                "revision": dsp_revision,
                "handler": f"{profile['handler']:04X}",
                "streamer": f"{profile['streamer']:04X}",
                "packer": f"{profile['packer']:04X}"}
            report["expected_sources"] = [f"{cell:04X}" for cell in STREAM_SOURCES]
            report["expected_derived_word"] = {
                "cell": f"{STREAM_DERIVED:04X}",
                "inputs": [f"{cell:04X}" for cell in STREAM_DERIVED_INPUTS],
                "why": "packed by the streamer's last step; not a plain cell read"}
        else:
            report["expected_program_words"] = {
                str(index): [f"{value:04X}" for value in tuple_]
                for index, tuple_ in predicted_program_words(payload or {}).items()
            }
        report["before_window"] = session.ports(WINDOW_PORTS)
        report["before_chain"] = session.chain()
        vector = int(report["before_chain"]["vector"], 16)
        report["vector_is_a_known_step"] = vector in session.chain_profile["steps"]
        if not report["vector_is_a_known_step"]:
            raise RuntimeError(
                f"chain vector {vector:04x} is not a step of the known chain; "
                "the supervisor would consume the stream through it blind")
        if premessage is not None:
            tag, value = premessage
            if tag not in HOST_WRITE_CELLS:
                raise ValueError(f"tag {tag:02x} does not store the host's word; refused")
            if tag in UNSAFE_WRITES and value in UNSAFE_WRITES[tag]:
                raise ValueError(f"tag {tag:02x} value {value:04x} is in its unsafe range")
            report["premessage"] = {
                "tag": f"{tag:02X}", "value": f"{value:04X}",
                "cell": f"{HOST_WRITE_CELLS[tag]:04X}"}
            session.send(tag, value)
        report["arm_tag"] = f"{arm:02X}"
        session.send(arm, STREAM_DATA)
        report["after_arming"] = session.ports(WINDOW_PORTS)
        pumps = []
        for index in range(rounds):
            session.write_port(COMMAND_PORT, 0x00)
            session.write_port(STATUS_PORT, PUMP_ACK)
            # The supervisor reads the high half first; follow it.
            high = session.read_port(0x62)
            low = session.read_port(0x60)
            pumps.append({"pump": index + 1, "62": f"{high:02X}", "60": f"{low:02X}",
                          "word": f"{(high << 8) | low:04X}",
                          "1C": f"{session.read_port(STATUS_PORT):02X}"})
        report["pumps"] = pumps
        seen = [entry["word"] for entry in pumps]
        report["distinct_words"] = sorted(set(seen))
        if arm == PROGRAM_STREAM_TAG and payload:
            first_four = tuple(int(word, 16) for word in seen[:4])
            matches = [index for index, tuple_ in predicted_program_words(payload).items()
                       if tuple_ == first_four]
            report["program_words_observed"] = [f"{v:04X}" for v in first_four]
            report["matching_index"] = matches[0] if matches else None
            report["predictions_held"] = bool(matches)
        baseline_word = (int(report["before_window"]["62"], 16) << 8) \
            | int(report["before_window"]["60"], 16)
        report["window_moved"] = any(int(w, 16) != baseline_word for w in seen)
        report["after_chain"] = session.chain()
        report["after"] = session.window()
        session.command("AT")
        report["modem_responds_after"] = True
        report["finished_utc"] = datetime.now(timezone.utc).isoformat()
        return report
    elif experiment == "stream":
        # Read-mostly. The one write is the supervisor's own trigger, and the
        # CPU-side fill it starts is bounded by a length byte the caller has
        # already read back.
        report["writes"] = [{"tag": f"{STREAM_TAG:02X}", "data": f"{STREAM_DATA:02X}",
                             "why": "the trigger 6d08 sends for the 60/62 stream"}]
        report["before_window"] = session.ports(WINDOW_PORTS)
        report["before_chain"] = session.chain()
        vector = int(report["before_chain"]["vector"], 16)
        report["vector_is_a_known_step"] = vector in session.chain_profile["steps"]
        if not report["vector_is_a_known_step"]:
            raise RuntimeError(
                f"chain vector {vector:04x} is not a step of the known chain; "
                "triggering the stream would call it blind")
        session.send(STREAM_TAG, STREAM_DATA)
        report["window_polls"] = [session.ports(WINDOW_PORTS) for _ in range(rounds)]
        report["after_window"] = session.ports(WINDOW_PORTS)
        report["after_chain"] = session.chain()
        report["window_moved"] = report["after_window"] != report["before_window"]
        report["chain_moved"] = report["after_chain"] != report["before_chain"]
        report["after"] = session.window()
        session.command("AT")
        report["modem_responds_after"] = True
        report["finished_utc"] = datetime.now(timezone.utc).isoformat()
        return report
    elif experiment == "command":
        # Each step names, in advance, the byte the inbound register must show
        # if the message arrived. A no-op tag predicts whatever stood before.
        expected = {QUERY_TAG: QUERY_REPLY_TAG,
                    SECOND_QUERY_TAG: SECOND_QUERY_REPLY_TAG}
        steps, standing, held = [], int(baseline["58"], 16), True
        for tag in tags or []:
            if tag > MAX_TAG:
                raise ValueError(f"tag {tag:02x} is above 7f; the dispatcher rejects it")
            if tag not in expected and tag not in no_op_tags:
                raise ValueError(f"tag {tag:02x} has no predicted outcome; refused")
            predicted = expected.get(tag, standing)
            session.send(tag, 0x0000)
            observed = {f"{p:02X}": f"{session.read_port(p):02X}"
                        for p in (*TAG_PORTS, *VALUE_PORTS)}
            actual = int(observed["58"], 16)
            steps.append({
                "tag": f"{tag:02X}",
                "kind": "no-op (handler is a bare ret)"
                        if tag in no_op_tags else "query",
                "predicted_58": f"{predicted:02X}",
                "observed": observed,
                "held": actual == predicted,
            })
            held &= actual == predicted
            standing = actual
        report["steps"] = steps
        report["predictions_held"] = held
        report["after"] = session.window()
        session.command("AT")
        report["modem_responds_after"] = True
        report["finished_utc"] = datetime.now(timezone.utc).isoformat()
        return report
    elif experiment == "read":
        index = (target - LOOP_BASE) & 0xFFFF
        report["writes"] = [
            {"address": f"{INDEX_CELL:04X}", "value": f"{index:04X}",
             "why": f"the e732 loop's index, for program word {target:04X}"},
        ]
        report["program_word_requested"] = f"{target:04X}"
        session.send(INDEX_CELL, index)
    else:
        raise ValueError(f"unknown experiment {experiment!r}")

    samples, reply = poll(session, rounds, baseline)
    report["polls"] = samples
    report["reply"] = reply
    report["after"] = session.window()
    session.command("AT")
    report["modem_responds_after"] = True
    report["finished_utc"] = datetime.now(timezone.utc).isoformat()
    return report


def _payload() -> dict[int, int]:
    """The DSP program image, so a program-word prediction can be computed."""
    import struct
    from pathlib import Path as _Path
    capture = _Path("artifacts/courier-board-21210-capture-01/courier-board.rom")
    if not capture.exists():
        return {}
    data = capture.read_bytes()
    return {0x8000 + index: struct.unpack_from("<H", data, 0x29080 + 2 * index)[0]
            for index in range((0x368FC - 0x29080) // 2)}


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--device", required=True)
    parser.add_argument("--baud", type=int, default=57600)
    parser.add_argument("--output", type=Path, required=True,
                        help="new directory for the manifest and transcript")
    parser.add_argument("--experiment",
                        choices=("queue", "read", "command", "stream", "pump"),
                        default="command")
    parser.add_argument("--target", default="0",
                        help="queue: the word to report; read: the program address")
    parser.add_argument("--premessage", default=None,
                        help="pump: TAG,VALUE hex sent before arming")
    parser.add_argument("--arm", default="06",
                        help="pump: which tag arms the streamer, 06 or 46")
    parser.add_argument("--tags", default="2D,07,2D,07",
                        help="command: the tag sequence to send, hex, comma separated")
    parser.add_argument("--rounds", type=int, default=24)
    args = parser.parse_args(argv)

    args.output.mkdir(parents=True, exist_ok=False)
    with MailboxPort(args.device, args.baud, allow_ram=True) as port:
        port.drain()
        session = Session(port)
        try:
            report = run(session, experiment=args.experiment,
                         target=int(args.target, 16), rounds=args.rounds,
                         tags=[int(t, 16) for t in args.tags.split(",") if t],
                         arm=int(args.arm, 16), payload=_payload(),
                         premessage=tuple(int(x, 16) for x in args.premessage.split(","))
                         if args.premessage else None)
        finally:
            (args.output / "transcript.json").write_text(
                json.dumps(session.transcript, indent=2) + "\n")
    (args.output / "manifest.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps({k: report[k] for k in ("reply", "steps") if k in report}
                     | {"output": str(args.output)}, indent=1))
    return 0 if (report.get("reply") or report.get("predictions_held")
                 or report.get("window_moved") or report.get("chain_moved")) else 1


if __name__ == "__main__":
    raise SystemExit(main())
