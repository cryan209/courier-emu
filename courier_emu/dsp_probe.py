"""Small C5x ROM-read experiment and an offline 20 MHz download-path check.

This emits a DSP kernel, not an SDL image. It cannot flash or contact a modem.
The integrated launch/mailbox/serial experiment is in probe_transport.py;
physical hardware behavior remains to be established.
"""
from __future__ import annotations

import argparse
from dataclasses import dataclass
from hashlib import sha256
import json
from pathlib import Path
import struct

ORIGIN = 0x8000
BUFFER = 0x0300
SAMPLE_WORDS = 32
MAPPING_SAMPLE_WORDS = 16
CONTROL = (0x1357, 0x2468, 0xA55A, 0x5AA5, 0x0000, 0xFFFF, 0x8001, 0x7FFE)
HEADER = (0xC051, 1, 0, SAMPLE_WORDS, 0, 8, 0, 0)
MAPPING_HEADER = (0xC052, 2, 0, MAPPING_SAMPLE_WORDS, 0, 8,
                  MAPPING_SAMPLE_WORDS, 0)
COMPLETE = 0xD00E


@dataclass(frozen=True)
class RomProbe:
    words: tuple[int, ...]
    control_address: int
    halt_address: int

    @property
    def payload(self) -> bytes:
        return struct.pack(f"<{len(self.words)}H", *self.words)

    def dsp_program_segments(self):
        return [(ORIGIN, self.payload)]


def build_probe(*, mailbox: bool = False) -> RomProbe:
    # Absolute addresses avoid dependencies on resident firmware's DP/ARP.
    # The optional sender uses the reference's tag/data/strobe mailbox pattern.
    words = [0xBE41, 0xBC06, 0x8B89]  # SETC INTM; LDP #6; MAR *,AR1
    for index, value in enumerate(HEADER):
        words.extend((0xAE00 | index, value))  # SPLK header word at DP|index
    words.extend((0xBF09, BUFFER + len(HEADER)))
    control_references = []
    for source, count in ((None, len(CONTROL)), (0, SAMPLE_WORDS), (None, len(CONTROL))):
        words.extend((0xBF80, source or 0))  # LACC #source
        if source is None:
            control_references.append(len(words) - 1)
        words.extend((0xBB00 | (count - 1), 0xA6A0))  # RPT; TBLR *+
    words.extend((0xAE04, COMPLETE))
    if mailbox:
        words.extend((0xAE7C, 0x5200, 0xBF09, BUFFER))
        poll = ORIGIN + len(words)
        # Reproduce the external-address read followed by the MMR read seen
        # in the resident's 23f0 helper, without calling absent mask-ROM code.
        words.extend((0xBF0A, 0xFF57, 0x8B8A, 0x1080, 0x0880, 0x8B89,
                      0x907D, 0x4E7D, 0xE200, poll))
        words.extend((0x0C7C, 0x005E, 0x0CA0, 0x005F, 0xB902, 0x8857,
                      0x697C, 0xB801, 0x907C, 0xBFA0, 0x5238, 0xE308, poll))
    halt = ORIGIN + len(words)
    words.extend((0x7980, halt))  # B self, with interrupts masked
    control_address = ORIGIN + len(words)
    for index in control_references:
        words[index] = control_address
    words.extend(CONTROL)
    while len(words) % 8:
        words.append(0x8B00)  # transfer routine rounds to 16-byte chunks
    return RomProbe(tuple(words), control_address, halt)


def build_mapping_probe(*, mailbox: bool = False) -> RomProbe:
    """Compare low external program memory with the mapped C52 ROM window.

    The program executes at 8000, so changing PMST.MP/MC cannot unmap the
    executing probe. PMST is deliberately reduced to just MP/MC while the
    external sample is taken, then cleared to map ROM for the internal sample.
    This is a standalone takeover diagnostic and does not return to firmware.
    """
    words = [0xBE41, 0xBC06, 0x8B89]  # SETC INTM; LDP #6; MAR *,AR1
    for index, value in enumerate(MAPPING_HEADER):
        words.extend((0xAE00 | index, value))
    words.extend((0xBF09, BUFFER + len(MAPPING_HEADER)))
    control_references = []

    # Known program-RAM control before changing the mapping.
    words.extend((0xBF80, 0))
    control_references.append(len(words) - 1)
    words.extend((0xBB00 | (len(CONTROL) - 1), 0xA6A0))

    # LMMR writes a data-memory value to a memory-mapped register. Keep the
    # temporary just beyond the 56-word result buffer; SPLK alone would use DP
    # and write ordinary data RAM rather than PMST.
    mapping_temp = BUFFER + 56
    # PMST.MP/MC=1: low program addresses are external.
    words.extend((0xAE38, 0x0008, 0x8907, mapping_temp,
                  0xBF80, 0x0000,
                  0xBB00 | (MAPPING_SAMPLE_WORDS - 1), 0xA6A0))
    # PMST.MP/MC=0: the C52's 0000..0fff ROM is mapped.
    words.extend((0xAE38, 0x0000, 0x8907, mapping_temp,
                  0xBF80, 0x0000,
                  0xBB00 | (MAPPING_SAMPLE_WORDS - 1), 0xA6A0))

    words.extend((0xBF80, 0))
    control_references.append(len(words) - 1)
    words.extend((0xBB00 | (len(CONTROL) - 1), 0xA6A0, 0xAE04, COMPLETE))
    if mailbox:
        words.extend((0xAE7C, 0x5200, 0xBF09, BUFFER))
        poll = ORIGIN + len(words)
        words.extend((0xBF0A, 0xFF57, 0x8B8A, 0x1080, 0x0880, 0x8B89,
                      0x907D, 0x4E7D, 0xE200, poll))
        words.extend((0x0C7C, 0x005E, 0x0CA0, 0x005F, 0xB902, 0x8857,
                      0x697C, 0xB801, 0x907C, 0xBFA0, 0x5238, 0xE308, poll))
    halt = ORIGIN + len(words)
    words.extend((0x7980, halt))
    control_address = ORIGIN + len(words)
    for index in control_references:
        words[index] = control_address
    words.extend(CONTROL)
    while len(words) % 8:
        words.append(0x8B00)
    return RomProbe(tuple(words), control_address, halt)


def inspect_buffer(words: list[int]) -> dict:
    expected_length = len(HEADER) + len(CONTROL) * 2 + SAMPLE_WORDS
    if len(words) != expected_length:
        raise ValueError(f"expected {expected_length} words")
    before = words[8:16]
    sample = words[16:48]
    after = words[48:56]
    valid = words[:4] == list(HEADER[:4]) and words[5:8] == list(HEADER[5:8])
    valid = valid and words[4] == COMPLETE and before == list(CONTROL) and after == list(CONTROL)
    return {"status": "sample-captured" if valid else "invalid-or-incomplete",
            "control_before": before, "sample": sample, "control_after": after,
            "complete": words[4] == COMPLETE,
            "rom_access_proven": False,
            "interpretation": "A valid buffer proves execution and program-RAM reads. A ROM sample still needs mapping/protection checks; all-zero/all-one data is inconclusive."}


def inspect_mapping_buffer(words: list[int]) -> dict:
    if len(words) != 56:
        raise ValueError("expected 56 words")
    before = words[8:16]
    external = words[16:32]
    internal = words[32:48]
    after = words[48:56]
    valid = words[:4] == list(MAPPING_HEADER[:4])
    valid = valid and words[5:8] == list(MAPPING_HEADER[5:8])
    valid = valid and words[4] == COMPLETE
    valid = valid and before == after == list(CONTROL)
    return {
        "status": "mapping-samples-captured" if valid else "invalid-or-incomplete",
        "control_before": before,
        "external_sample": external,
        "internal_sample": internal,
        "control_after": after,
        "complete": words[4] == COMPLETE,
        "samples_differ": external != internal,
        "rom_readable": valid and external != internal,
        "interpretation": (
            "Distinct stable samples prove that enabling the internal window changes "
            "the low program mapping. Equal, uniform, or bus-like samples are inconclusive "
            "without repeated captures and external-bus observation."
        ),
    }


def simulate_mapping_probe(probe: RomProbe) -> dict:
    from .dsp import NativeC5x
    rom = tuple((0x1234 + i * 0x0193) & 0xFFFF for i in range(0x1000))
    external = tuple((0xA55A ^ i * 0x0101) & 0xFFFF
                     for i in range(MAPPING_SAMPLE_WORDS))
    core = NativeC5x(probe)
    try:
        core.load_rom(struct.pack("<4096H", *rom))
        core.load_program(struct.pack(f"<{len(external)}H", *external), 0)
        core.set_io(0x57, 2)  # ready level used only by mailbox-emitting probes
        core.set_pc(ORIGIN)
        for _ in range(2000):
            if core.state()["pc"] == probe.halt_address:
                break
            core.step(1)
        else:
            raise RuntimeError("mapping probe did not complete")
        result = inspect_mapping_buffer(
            [core.data(BUFFER + i) for i in range(56)])
        result.update(
            external_matches_fixture=result["external_sample"] == list(external),
            internal_matches_fixture=result["internal_sample"] == list(rom[:MAPPING_SAMPLE_WORDS]),
            protection_modeled=False,
            io_events=core.io_events(),
        )
        return result
    finally:
        core.close()


def simulate_probe(probe: RomProbe, *, rom_mapped: bool) -> dict:
    from .dsp import NativeC5x
    rom = tuple((0x1234 + i * 0x0193) & 0xFFFF for i in range(0x1000))
    external = tuple((0xA55A ^ i * 0x0101) & 0xFFFF for i in range(SAMPLE_WORDS))
    core = NativeC5x(probe)
    try:
        core.load_rom(struct.pack("<4096H", *rom))
        core.load_program(struct.pack("<32H", *external), 0)
        core.set_mpmc_pin(0 if rom_mapped else 1)
        core.set_io(0x57, 2)  # ready level used only by mailbox-emitting probes
        core.set_pc(ORIGIN)
        for _ in range(2000):
            if core.state()["pc"] == probe.halt_address:
                break
            core.step(1)
        else:
            raise RuntimeError("probe did not complete")
        result = inspect_buffer([core.data(BUFFER + i) for i in range(56)])
        result.update(fixture="synthetic-rom" if rom_mapped else "external-program-memory",
                      expected_sample=list(rom[:SAMPLE_WORDS] if rom_mapped else external),
                      io_events=core.io_events())
        result["sample_matches_fixture"] = result["sample"] == result["expected_sample"]
        return result
    finally:
        core.close()


def verify_download(image_path: str | Path, probe: RomProbe) -> dict:
    """Run the reference's checksum and download loops on the probe bytes.

    This exercises 80188 instructions and window strobes. Device ready bits
    are synthetic; capturing the window does NOT prove the real DSP boot ROM
    accepts the payload, launches it at 8000, or exposes the result buffer.
    """
    from unicorn import Uc, UcError, UC_ARCH_X86, UC_MODE_16, UC_HOOK_CODE, UC_HOOK_INSN
    from unicorn import x86_const as r
    from .rom import CourierRom
    image = CourierRom.load(image_path)
    anchors = {0xE447: "068bf02bc8d1e9", 0xE46E: "c606360e01c706370e4000",
               0xE4B4: "b808a98ec0", 0x29080: "00bc57aeffff41be"}
    for address, expected in anchors.items():
        data = bytes.fromhex(expected)
        if image.data[address:address + len(data)] != data:
            raise ValueError(f"unsupported 20 MHz reference: anchor {address:#x}")
    cpu = Uc(UC_ARCH_X86, UC_MODE_16)
    cpu.mem_map(0, 0x20000)
    cpu.mem_map(0x80000, 0x80000)
    cpu.mem_write(0x80000, image.data)
    # Substitute only the emulator's source window, never the input image.
    cpu.mem_write(0xA9080, probe.payload)
    window = bytearray(8)
    captured = bytearray()
    writes = []
    checksum_sent = None
    returned = False
    def code(cpu, address, size, _):
        nonlocal returned
        if address == 0x80200:
            returned = True
            cpu.emu_stop()
    def output(cpu, port, size, value, _):
        nonlocal checksum_sent
        writes.append({"pc": cpu.reg_read(r.UC_X86_REG_CS) * 16 + cpu.reg_read(r.UC_X86_REG_IP),
                       "port": port, "size": size, "value": value})
        if 0x40 <= port <= 0x4E and port % 2 == 0:
            window[(port - 0x40) // 2] = value
        elif port == 0x18 and value == 1:
            captured.extend(window)
        elif port == 0x18 and value == 4:
            checksum_sent = int.from_bytes(window[:2], "little")
    cpu.hook_add(UC_HOOK_CODE, code)
    cpu.hook_add(UC_HOOK_INSN, output, None, 1, 0, r.UC_X86_INS_OUT)
    cpu.hook_add(UC_HOOK_INSN, lambda *_: 7, None, 1, 0, r.UC_X86_INS_IN)
    for entry in (0xE447, 0xE46E):
        returned = False
        for name, value in (("CS", 0x8000), ("IP", entry), ("DS", 0), ("SS", 0),
                            ("SP", 0xF000), ("AX", 0), ("CX", len(probe.payload)), ("EFLAGS", 2)):
            cpu.reg_write(getattr(r, "UC_X86_REG_" + name), value)
        cpu.mem_write(0xF000, b"\x00\x02")
        try:
            cpu.emu_start(0x80000 + entry, 0x100000, count=10000)
        except UcError as exc:
            raise RuntimeError(f"reference transfer failed: {exc}") from exc
        if not returned or cpu.reg_read(r.UC_X86_REG_EFLAGS) & 1:
            raise RuntimeError(f"reference routine {entry:#x} did not return successfully")
    expected_checksum = sum(probe.words) & 0xFFFF
    return {"reference_sha256": image.digest, "source_file_unchanged": image.path.read_bytes() == image.data,
            "captured_hex": captured.hex(), "matches_kernel": captured == probe.payload,
            "checksum_sent": checksum_sent, "expected_checksum": expected_checksum,
            "checksum_matches": checksum_sent == expected_checksum, "writes": writes,
            "ready_bits": "IN returns 7 (synthetic)",
            "hardware_launch_proven": False, "hardware_readback_proven": False}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--reference", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True,
                        help="new output directory; must not already exist")
    parser.add_argument("--mapping-test", action="store_true",
                        help="compare MP/MC external and internal low mappings")
    parser.add_argument("--mailbox", action="store_true",
                        help="emit all 56 result words through the DSP mailbox")
    parser.add_argument("--skip-download-verification", action="store_true",
                        help="build after native C5x checks when Unicorn is unavailable")
    args = parser.parse_args()
    if args.output.exists():
        parser.error("output directory already exists; choose a new directory")
    probe = (build_mapping_probe(mailbox=args.mailbox) if args.mapping_test else
             build_probe(mailbox=args.mailbox))
    # Verify before writing artifacts. mkdir without exist_ok prevents source
    # collisions, accidental overwrites and ambiguous stale manifests.
    download = ({"verified": False, "reason": "explicitly skipped; Unicorn unavailable"}
                if args.skip_download_verification else
                verify_download(args.reference, probe))
    result = {"hardware_tested": False, "uploadable_sdl_image": False,
              "program_origin": ORIGIN, "result_buffer": BUFFER, "result_words": 56,
              "mailbox_sender": args.mailbox,
              "kernel_sha256": sha256(probe.payload).hexdigest(),
              "download": download,
              "simulations": ([simulate_mapping_probe(probe)] if args.mapping_test else
                              [simulate_probe(probe, rom_mapped=m) for m in (True, False)]),
              "limitations": ["Raw C5x kernel only; do not send this file as an SDL update.",
                              "Actual modem bootstrap entry and serial readback are not connected.",
                              "C5x core models an unprotected C52 ROM; C51 size and mask-ROM protection are not tested.",
                              "Reference IDSDL302 is a modified release, not a verified stock image."]}
    if (not args.skip_download_verification and
            (not download["matches_kernel"] or not download["checksum_matches"])):
        raise RuntimeError("download verification failed")
    if args.mapping_test:
        sample = result["simulations"][0]
        if (sample["status"] != "mapping-samples-captured" or
                not sample["external_matches_fixture"] or
                not sample["internal_matches_fixture"]):
            raise RuntimeError("mapping kernel verification failed")
    elif any(s["status"] != "sample-captured" or not s["sample_matches_fixture"]
             for s in result["simulations"]):
        raise RuntimeError("kernel verification failed")
    args.output.mkdir(parents=True)
    (args.output / "probe-c5x.bin").write_bytes(probe.payload)
    (args.output / "manifest.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({"output": str(args.output.resolve()), "status": "offline-probe-verified",
                      "hardware_tested": False, "uploadable_sdl_image": False}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
