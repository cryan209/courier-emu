"""The NEC gate array's register table, as the two buses see it.

The ASIC is the only thing on the 80186's I/O bus - the CPU's own peripheral
block is in memory at 0xff00-0xffff, and flash and SRAM are memory too, so
whatever answers an `IN` is this part (docs/asic-port-map.md). It is also the
DSP's *entire* external interface: all sixteen C52 data lines are on the
package, along with `IS`, `R/W`, `STRB` and `INT2`, and it clocks the part
(docs/asic-pinout.md).

So it has a decoder on each side, and they number independently. The two
spaces collide on one number and mean different things there:

    CPU port 0x5e  is the HIGH BYTE OF THE WORD
    DSP reg  0x5e  is the TAG

Only eight CPU data lines reach the package - `AD8`-`AD15` go to the CPU's
SRAMs and appear nowhere on it - so one 16-bit DSP register is two 8-bit CPU
ports, and the width conversion is a function of this part. That is why the
mailbox has two CPU ports per DSP register.

This table is the one place that says which CPU port and which DSP register
are the same piece of silicon. `bridge.py` builds its mailbox constants from
it rather than restating them, so a value meant for one bus cannot be written
to the other's address by writing a plausible-looking literal - which is
exactly how the status latch came to be published into the DSP's tag register.

`panel.py` owns the panel and DIP bit maps and is not driven from here; the
panel rows below record which registers those are, with the firmware
addresses their meanings were recovered from, so the whole chip is described
in one place even though only the mailbox is wired through it.

Caveat, from docs/asic-pinout.md: the 16-bit/8-bit finding was traced on the
2806 and the CPU-side port sweep taken on the 20.16 MHz board. The widths
below follow the trace; they are not established for one single unit.
"""
from __future__ import annotations

from dataclasses import dataclass


@dataclass(frozen=True)
class AsicRegister:
    """One register, with the address each bus reaches it at.

    `cpu` is the 80186's byte ports, low half first, and is empty for a
    register that bus cannot see. `dsp` is the C52's register address - what
    `lamm`/`samm` land on after masking to 0x7f - and is None for a register
    that side has no path to.
    """

    name: str
    cpu: tuple[int, ...]
    dsp: int | None
    note: str

    @property
    def width(self) -> int:
        """Bits, as the DSP sees it. Two CPU ports mean a 16-bit register."""
        return 16 if len(self.cpu) == 2 else 8


REGISTERS: tuple[AsicRegister, ...] = (
    # --- the mailbox: the only group with a host on both sides ---
    AsicRegister(
        "status", (0x1C,), 0x57,
        "The handshake. CPU bit 0 is input-register free, bit 1 a reply "
        "waiting, bit 2 the stream. The DSP reads the same latch with the "
        "opposite sense through the 0x23f0 helper with `#ff57`; bit 1 there "
        "means it may send. One flag read from each side, not a shared word.",
    ),
    AsicRegister(
        "tag", (0x58, 0x5A), 0x5E,
        "The message tag. The resident's sender writes it at 0x83eb with "
        "`out @7d, 005e`; the CPU takes it low half first from 0x58.",
    ),
    AsicRegister(
        "word", (0x5C, 0x5E), 0x5F,
        "The message word. Written at 0x83ee, and again at 0x83f6 for each "
        "further word of a block; read back on the DSP side through the "
        "0x23f0 helper with `#ff5f`.",
    ),
    AsicRegister(
        "stream", (0x60, 0x62), 0x60,
        "The stream lane, raised by the sender at 0x849e.",
    ),
    AsicRegister(
        "transfer-command", (0x18,), 0x56,
        "The program-download handshake, and the two sides are exact "
        "mirrors. The supervisor spins at 0x8e4c3 on `test al, 1`, pushes "
        "eight bytes into a window, and commits with `out 0x18, 1`; then "
        "waits on bit 1 and commits the other bank with `out 0x18, 2`. The "
        "C5x mask ROM's loader at 0x0638 does the same from the other side - "
        "`bit 0, @56`, `rpt #03 / bldp *+` for FOUR WORDS, `lacl #01 / samm "
        "@56`, then bit 1 and 2 for the other bank - and finishes with "
        "`lacl #04 / samm @56`, which is ROM_CHECKSUM_STROBE. Eight bytes in "
        "and four words out is the 16-to-8 conversion, and the per-bank "
        "handshake is what makes the two widths agree on a boundary. "
        "`BIT dma, code` tests bit (15 - code), so the DSP polls bits 15, 14 "
        "and 13 - the ASIC's ready flags - and acknowledges in bits 0, 1 and "
        "2. High half inbound, low half outbound, on one register.",
    ),
    # --- CPU-side only. No DSP path: the part has no reason to see these. ---
    AsicRegister(
        "status-latch", (0x5C, 0x5E), None,
        "The ASIC's own 16-bit status latch, which the supervisor's "
        "rate/status routine reads on the same two ports as the word. It is "
        "an ASIC latch, NOT a C50 register - publishing it with a write to "
        "DSP 0x5e overwrote a tag the part was waiting to have collected. "
        "The bridge holds it; see `_publish_connected_event`.",
    ),
    AsicRegister(
        "panel-latch", (0x0E,), None,
        "Panel latch driver. Bit map in panel.py, recovered from the "
        "supervisor's read-modify-write driver at physical 0x5e2b0.",
    ),
    AsicRegister(
        "hook", (0x10,), None,
        "Bit 0 is OH and the hook relay (docs/dsp-rom-probe.md).",
    ),
    AsicRegister(
        "indicators-mr", (0x12,), None,
        "Bit 1 is MR; bit 0x20 is the DTR-override strap on the XMF "
        "supervisor, recovered at 0x63d31/0x63d48. Bit 0x02 drives "
        "id-strap-drive-b.",
    ),
    AsicRegister(
        "indicators-cd", (0x14,), None,
        "Active low: CD, CS, AA, ARQ, HS, SYN. Also the board-ID strap "
        "matrix - drives at 0x40/0x10/0x20, sense at 0x08 - read once at "
        "boot by the scan at 0x5bfc6. Not the DIP bank.",
    ),
)

#: By name, for the accessors below.
BY_NAME = {register.name: register for register in REGISTERS}


def dsp_register_for_cpu_port(port: int) -> tuple[int, int] | None:
    """The DSP register a CPU byte port reaches, and which half of it.

    Returns (dsp register, half) where half 0 is the low byte, or None when
    the port is not a two-sided register. This is the only sanctioned way to
    cross from one bus's numbering to the other's: `port` is CPU space and
    the first element of the result is DSP space, and they are different
    spaces even where they are the same number.
    """
    for register in REGISTERS:
        if register.dsp is None:
            continue
        for half, cpu_port in enumerate(register.cpu):
            if cpu_port == port:
                return register.dsp, half
    return None


def cpu_ports(name: str) -> tuple[int, ...]:
    """The 80186 byte ports for a named register, low half first."""
    return BY_NAME[name].cpu


def dsp_register(name: str) -> int:
    """The C52 register address for a named register.

    Raises for a register the DSP cannot see, rather than returning
    something that would be written into the part's address space.
    """
    register = BY_NAME[name]
    if register.dsp is None:
        raise KeyError(
            f"{name!r} is a CPU-side ASIC register: the DSP has no path to it, "
            "and writing one into the part's register space overwrites "
            "whatever the C50 had there"
        )
    return register.dsp


def mirror(*names: str) -> dict[int, tuple[int, int]]:
    """CPU byte port -> (DSP register, half), for the named registers.

    Derived from the table rather than restated, so a caller's mirror and
    this file cannot drift apart. Naming the registers keeps the caller
    explicit about which ones it mirrors: a bridge that mirrors the tag and
    word does not thereby mirror the status, whose acknowledgement sets bits
    rather than replacing the latch.
    """
    result: dict[int, tuple[int, int]] = {}
    for name in names:
        register = BY_NAME[name]
        if register.dsp is None:
            raise KeyError(f"{name!r} has no DSP address to mirror to")
        for half, port in enumerate(register.cpu):
            result[port] = (register.dsp, half)
    return result


#: Every two-sided register, for callers that want the whole chip.
CPU_TO_DSP: dict[int, tuple[int, int]] = mirror(
    "status", "tag", "word", "stream")
