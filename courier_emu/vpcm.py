"""Assemble DSP 3.1.2's V.90 DIL descriptor by running its own code.

Overlay 8 is the V.PCM datapump. Near its end it builds the Ja descriptor into
a data buffer: the fixed fields are copied out of program memory, and the 197
training Ucodes are generated arithmetically rather than tabulated. This runs
that code in the C5x core and returns what it produced.

This is a component run, not a boot. It enters the assembler directly, so it
supplies the one piece of caller state that routine depends on - see ENTRY.
"""
from __future__ import annotations
import struct

from .dsp import NativeC5x

OVERLAY_ENTRY = 0xDC00
ASSEMBLER, DONE = 0xE7E8, 0xE837
BUFFER = 0x0940
FIELD_WORDS = 20            # N, LSP/LTP, 5 SP, 5 TP, 4 H, 4 REF
# The assembler reaches its build buffer through `*`, which selects whichever
# auxiliary register ARP names - not AR1, despite the `lar ar1` that precedes
# it. Its real caller arrives with ARP already 1; entering at ASSEMBLER without
# setting it sends every store through AR0, and the descriptor lands nowhere.
# The driver below selects AR1 the way the firmware's own `mar *, ar1` does.
MAR_MASK = 0x7


def overlay(rom):
    """The V.PCM overlay, identified by where it loads rather than by index."""
    for candidate in rom.dsp_overlays:
        if candidate.entry_word == OVERLAY_ENTRY:
            return candidate
    raise ValueError('this ROM has no overlay at the V.PCM entry')


def assemble(rom, *, limit=400_000):
    """Run the descriptor assembler and return the fields it wrote."""
    entry = overlay(rom)
    image = rom.data[entry.offset:entry.end]
    word = lambda pc: struct.unpack_from('<H', image, (pc - OVERLAY_ENTRY) * 2)[0]
    mar_ar1 = (word(0xE806) & ~MAR_MASK) | 1
    with NativeC5x(rom) as core:
        core.set_mpmc_pin(0)
        core.load_program(image, entry.entry_word)
        core.load_rom(struct.pack('<3H', mar_ar1, 0x7980, ASSEMBLER))
        core.set_pc(0)
        for _ in range(limit):
            core.step(1)
            if core.state()['pc'] == DONE:
                break
        else:
            raise RuntimeError(f'assembler did not finish: {core.state()}')
        buffer = [core.data(BUFFER + index) for index in range(0x80)]
        instructions = core.state()['instructions']
    n = buffer[0]
    ucodes = []
    for packed in buffer[FIELD_WORDS:]:
        ucodes += [packed & 0xFF, packed >> 8]
    return {
        'n': n,
        'lsp': (buffer[1] & 0xFF) + 1,
        'ltp': (buffer[1] >> 8) + 1,
        'sp': buffer[2:7],
        'tp': buffer[7:12],
        'h': buffer[12:16],
        'ref': buffer[16:20],
        'ucodes': ucodes[:n],
        'instructions': instructions,
    }


# --- reference arithmetic, not recovered from the ROM -----------------------
# A DIL is scored by comparing what arrives against the level each training
# Ucode should have produced. The mapping is the G.711 chord decomposition:
# chord = u >> 4 selects the segment, step = u & 15 the position in it. In the
# unbiased form, and scaled to a 16-bit linear sample, Ucode 100 is 10496.
#
# This is the standard's arithmetic written out here for comparison against a
# capture. **No routine computing it has been located in the firmware** - the
# images hold no companding table of any kind, so whatever does the matching
# computes it, but that code has not been found. Do not cite this as a finding
# about the ROM.
MU_BIAS = 33


def ucode_level(ucode: int, *, bits: int = 16) -> int:
    """The linear magnitude a mu-law training Ucode stands for."""
    if not 0 <= ucode <= 127:
        raise ValueError('a training Ucode is 0..127')
    chord, step = ucode >> 4, ucode & 15
    magnitude = (2 * step + MU_BIAS) << chord
    return magnitude << (bits - 14)


def ladder_levels(descriptor, *, bits: int = 16) -> list[int]:
    """The descriptor's training ladder, as linear levels."""
    return [ucode_level(u, bits=bits) for u in descriptor['ucodes']]
