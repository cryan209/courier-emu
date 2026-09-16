"""The C5x's own mask ROM.

This is a property of the **part**, not of the firmware image it runs. A
TMS320C5x with MP/MC low maps 0x2000 words of on-chip ROM at program
0x0000-0x1fff, and that window holds the interrupt vector table: 2-word slots
of `lamm @6x ; bacc`, which read a handler address out of DARAM block B2 at
data 0x60-0x6a and branch to it. The firmware installs handlers by writing that
RAM table - the resident's cold start does it at 0x8030 with a `blpd` of 11
words - and cannot change the vectors themselves.

Without this ROM the vectors are absent, so every `intr` in the firmware
branches into whatever the harness left at low program addresses. `INTR 17`,
which the receiver arms at `d879`, is the visible casualty: its handler is
`0x81a6`, the routine that packs two scaled samples into TDXR.

`bridge.py` gated this on a **firmware** hash, which is the wrong axis: the
same board runs several firmware revisions and the mask ROM does not change
with them. The dump's own checksum is the thing worth asserting, because that
is the hardware fact being claimed.
"""
from hashlib import sha256
from pathlib import Path

# Recovered from the 20.16 MHz board, 2026-09-15, and byte-identical over
# 0x0000-0x07ff to the 25 MHz 2806 board's dump - which is what mask ROM looks
# like and downloaded code does not.
MASK_ROM = (Path(__file__).resolve().parent.parent /
            "artifacts/dsp-onchip-rom-20mhz-8k/c5x-onchip-rom-8k.bin")
MASK_ROM_SHA256 = "d57bc46e1bcd6d4dc8872b97bba2d98ba8fb6b8661440c566b534f0b3f82fac9"
ROM_WORDS = 0x2000

# The vector table, and the B2 cells it dispatches through.
VECTOR_TABLE = 0x0000
DISPATCH_FIRST, DISPATCH_COUNT = 0x0060, 0x000B
INTR17_VECTOR = 0x0022          # `lamm @69 ; bacc`
INTR17_DISPATCH = 0x0069


def mask_rom() -> bytes:
    """The dump, checked against the hardware it was read from."""
    image = MASK_ROM.read_bytes()
    if len(image) != ROM_WORDS * 2:
        raise ValueError(f"expected {ROM_WORDS} words of mask ROM, got {len(image) // 2}")
    digest = sha256(image).hexdigest()
    if digest != MASK_ROM_SHA256:
        raise ValueError(f"mask ROM checksum mismatch: {digest}")
    return image


def install(core) -> bytes:
    """Map the on-chip ROM the way MP/MC low maps it on the board."""
    image = mask_rom()
    core.load_rom(image)
    core.set_mpmc_pin(0)
    return image


def dispatch_table(core) -> tuple[int, ...]:
    """The handler addresses the vector slots read, as the part sees them."""
    return tuple(core.data(DISPATCH_FIRST + n) for n in range(DISPATCH_COUNT))


# The resident's prologue says whether the part maps its ROM, and says it in
# the one place that is about the pin rather than about the build: the `opl`
# that sets PMST. `apl @07, #07f8` preserves bit 3, so a resident that leaves
# MP/MC alone runs with the ROM mapped and vectors at 0x0000, while one that
# sets bit 3 unmaps it and brings its own table. Reading that beats an
# allowlist of firmware hashes, which has to be extended for every revision of
# a board whose silicon never changed.
PMST_PROLOGUE = (0x5E07, 0x07F8)        # apl @07, #07f8
PMST_SET = 0x5D07                       # opl @07, #....
PMST_MPMC = 0x0008
PROLOGUE_WINDOW = 0x40


def pmst_setting(words, origin: int) -> int | None:
    """The PMST value the resident's prologue `opl`s in, or None."""
    for pc in range(origin, origin + PROLOGUE_WINDOW):
        if (words[pc], words[pc + 1]) == PMST_PROLOGUE and words[pc + 2] == PMST_SET:
            return words[pc + 3]
    return None


def maps_onchip_rom(words, origin: int) -> bool:
    """Does this resident run with the part's on-chip ROM in the program map?

    True for the B series (`opl #00b0`: IPTR 0, MP/MC left at the pin, so the
    vectors are the ROM's own table). False for the C series (`opl #18b8`:
    MP/MC forced to 1, vectors moved to 0x1800 inside the download).
    """
    value = pmst_setting(words, origin)
    return value is not None and not value & PMST_MPMC


# Circular buffer 2 carries the CPU/DSP character window on AR6, so its extent
# is the part's, not a constant worth repeating. Both directions share it: the
# transmit fetch at 82c1 and the receive delivery at 8320.
def window_first(core) -> int:
    return core.register(0x1C)          # CBSR2


def window_last(core) -> int:
    return core.register(0x1D)          # CBER2
