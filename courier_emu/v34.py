"""Load overlay 6 - the V.34 datapump - and arm it the way the firmware does.

Slot 0 of the datapump table is overlay 6's entry `9d00`
(docs/datapump-slots.md). Nothing in this project had ever executed it: the
supervisor's DSP download carries only the resident bank, `8000..eea7`, so
program `9d00` holds resident words and the V.34 image stays in flash.

This module publishes the overlay and enters it through the firmware's own
dispatcher rather than by jumping at `9d00`. The route, read off `9b34` and
measured here:

* `9b34` (originate, table `9b48`) and `9b38` (answer, table `9b51`) each
  `splk @7c` with their table base, **on data page 0** - `9b41`'s `ldp #000`
  is what `add @7c` reads back, so entering these with DP 7 makes `tblr` read
  program `0000` and the dispatch lands anywhere.
* `9b3c` calls `9b2c`, which is a `retd`/`lacb`/`sacl @27` tail: **it
  overwrites the mode flags** from `d648`'s return. Setting `@27` before the
  call cannot work; the flags come from a descriptor list at data `fea1`,
  walked with ARP 1.
* `d665` matches the first list word whose low five bits are 5, and `d64d`
  takes bits 5-7 of it. `#0045` is the word that yields `@27` = 2, whose bit 1
  is the flag `9b5a` tests for slot 0.
* `9b40`'s `retc ntc` then falls through and `bacc`s to `9d00`.

What that produces is recorded in `arm()`'s result and pinned by the tests:
the entry runs about 2,240 instructions, returns cleanly, writes the marker
`#4042` to `@6f` - the value docs/fsk-modulation.md predicted for this entry
from the disassembly alone - and installs two callbacks, `aafb` and `9daf`.

**It does not yet produce a tone.** `aafb` returns in 278 instructions and
advances its own chain (`splk @1a, #ab3f`), and overlay 6 touches no converter
at all (docs/vpcm-datapump.md), so the samples would have to reach the line
through the resident mixer. Driven that way the transmit chain runs and the
output buffer stays zero: a V.34 modulator with no start-up state and no data
source is silent, which is the expected result rather than a failure.
`transmit_callback()` is here so that stays measured rather than assumed.
"""
from __future__ import annotations

import struct

from .answer_tone import FIXTURES
from .dsp import NativeC5x
from .mailbox_compare import program, validate

OVERLAY_INDEX = 6
OVERLAY_ENTRY = 0x9D00

# The two start commands' dispatch entries, and the tables they select.
DISPATCH = {'originate': 0x9B34, 'answer': 0x9B38}

# The capability list `9b2d` points AR1 at, and the word that selects slot 0.
DESCRIPTOR_LIST = 0xFEA1
V34_DESCRIPTOR = 0x0045

# Mode flags on page 7, the marker on page 0, and the two callback cells.
MODE_CELL, MODE_BIT = 0x03A7, 1        # @27
MARKER_CELL, MARKER = 0x006F, 0x4042   # @6f, set by 9d00 itself
TRANSMIT_CALLBACK, RECEIVE_CALLBACK = 0x039A, 0x039B   # @1a, @1b

# What the entry installs, measured.
TRANSMIT_CHAIN, RECEIVE_CHAIN = 0xAAFB, 0x9DAF

# The resident "no receiver" stub fsk.render installs, and the mixer's buffer.
NO_RECEIVER, BUFFER = 0x8128, 0x0BC1

# ldp #000 ; mar *, ar1 ; call <dispatch> ; b 4
_DRIVER = (0xBC00, 0x8B89, 0x7A80, None, 0x7980, 4)
_HALT = 4


def overlay(rom):
    """Return (entry word, image bytes) for the V.34 overlay in `rom`."""
    for row in rom.dsp_overlays:
        if row.index == OVERLAY_INDEX:
            return row.entry_word, rom.data[row.offset:row.offset + row.length]
    raise ValueError('this ROM carries no overlay 6')


def _core(rom, side):
    if side not in DISPATCH:
        raise ValueError(f'unknown side {side!r}')
    validate(rom)
    w = program(rom)
    if w[0x9B48] != OVERLAY_ENTRY or w[0x9B51] != OVERLAY_ENTRY:
        raise ValueError('datapump table slot 0 is not overlay 6 in this ROM')
    entry, image = overlay(rom)
    driver = tuple(DISPATCH[side] if word is None else word for word in _DRIVER)
    core = NativeC5x(rom)
    core.load_rom(struct.pack('<%dH' % len(driver), *driver))
    core.set_mpmc_pin(0)
    core.load_program(image, entry)
    for address, value in FIXTURES:
        core.set_data(address, value)
    core.set_data(DESCRIPTOR_LIST, V34_DESCRIPTOR)
    core.set_pc(0)
    return core


def _until_halt(core, limit):
    entered = False
    for step in range(limit):
        core.step(1)
        pc = core.state()['pc']
        if pc == OVERLAY_ENTRY:
            entered = True
        if pc == _HALT:
            return entered, step + 1
    return entered, None


def arm(rom, side='originate', limit=100_000):
    """Dispatch the V.34 slot and report what its entry installed."""
    with _core(rom, side) as core:
        entered, steps = _until_halt(core, limit)
        return {'side': side,
                'entered_overlay': entered,
                'returned': steps is not None,
                'instructions': steps,
                'mode_flags': core.data(MODE_CELL),
                'marker': core.data(MARKER_CELL),
                'transmit_callback': core.data(TRANSMIT_CALLBACK),
                'receive_callback': core.data(RECEIVE_CALLBACK)}


def transmit_callback(rom, count=64, side='originate', limit=100_000):
    """Arm, then call the installed transmit callback `count` times.

    Returns (samples, chain), the mixer buffer after each call and the callback
    cell's value at the end. The chain advances itself, so the cell is re-read
    every call rather than assumed constant.
    """
    if count <= 0:
        raise ValueError('expected a positive call count')
    with _core(rom, side) as core:
        entered, steps = _until_halt(core, limit)
        if not (entered and steps):
            raise RuntimeError('the V.34 slot did not arm')
        core.set_data(RECEIVE_CALLBACK, NO_RECEIVER)
        samples = []
        for _ in range(count):
            callback = core.data(TRANSMIT_CALLBACK)
            core.load_rom(struct.pack('<5H', 0xBC07, 0x7A80, callback, 0x7980, 3))
            core.set_data(0x0390, 0x0BC0)
            core.set_pc(0)
            for _ in range(limit):
                core.step(1)
                if core.state()['pc'] == 3:
                    break
            else:
                raise RuntimeError('the transmit callback did not return')
            value = core.data(BUFFER)
            samples.append(value - 65536 if value >= 32768 else value)
        return samples, core.data(TRANSMIT_CALLBACK)
