"""Render DSP 3.1.2's own FSK modulator: V.21 and Bell 103.

This is a modulation rather than a signalling tone. The resident bank carries a
transmitter at program `d95f` that selects one of two phase increments with a
data bit, accumulates the chosen one into a phase, takes a sine, and pushes the
result through a shaping filter into the mixer's output cell:

```text
d95f  bit    7, @50     ; the data bit
d960  lacc16 @72        ; mark increment
d961  xc     1, ntc
d962  lacc16 @73        ; ...or space
d963  add16  @63        ; frequency offset
d964  add16  @40        ; phase accumulator
d966  calld  8b0f       ; sine
d970  calld  8a88       ; shaping filter, coefficients at @5f
d975  mpy    @67        ; amplitude
d977  sach   @47, 1     ; the transmit sample
```

Eight setup routines at `d790`-`d7d7` fill those cells, and eight dispatch
entries at `d7d8`-`d812` pair a transmitter with a receiver. Read at 7200 Hz
the transmit pairs are exactly the four 300 bps bands, and the receive carriers
are their band centres.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
import struct
from pathlib import Path

from .answer_tone import FIXTURES, RATE, measure, write_wave
from .dsp import NativeC5x
from .mailbox_compare import program, validate

MODULATOR = 0xD95F
DATA_CELL, GATE_CELL = 0x3D0, 0x3F0   # @50 and @70
DATA_BIT = 0x0100                     # `bit 7, @50` tests bit 8
MIXER_TOP, SAMPLE_BODY = 0x80C3, 0x80C7
ISR_BODY, ISR_TRANSMIT = 0x8178, 0x8199

# The transmit setup routines, and the two frequencies each installs. The
# increments are the ROM's; the frequencies are those increments read at 7200.
MODES = {
    'v21-originate': (0xD790, 980, 1180),
    'bell103-originate': (0xD79A, 1270, 1070),
    'v21-answer': (0xD7B4, 1650, 1850),
    'bell103-answer': (0xD7BE, 2225, 2025),
}

# The receiver setup routines and their carrier frequencies.
RECEIVERS = {0xD7A4: 1750, 0xD7AC: 2125, 0xD7C8: 1080, 0xD7D0: 1170}

# The dispatch entries, each a transmit routine paired with a receiver. Four
# put the receiver on the band the transmitter is using: that is the modem
# listening to itself, which is what analogue loopback with self-test needs.
PAIRS = {
    0xD7D8: (0xD7BE, 0xD7AC), 0xD7E3: (0xD7BE, 0xD7D0),
    0xD7E9: (0xD79A, 0xD7D0), 0xD7F4: (0xD79A, 0xD7AC),
    0xD7FC: (0xD7B4, 0xD7A4), 0xD802: (0xD7B4, 0xD7C8),
    0xD808: (0xD790, 0xD7C8), 0xD80E: (0xD790, 0xD7A4),
}


def loopback_pairs():
    """Entries whose receiver sits on the transmitter's own band."""
    found = {}
    for entry, (tx, rx) in PAIRS.items():
        _, mark, space = next(v for v in MODES.values() if v[0] == tx)
        centre = RECEIVERS[rx]
        found[entry] = min(mark, space) <= centre <= max(mark, space)
    return found


def render(rom, bits, samples_per_bit=24, mode='v21-answer'):
    """Modulate `bits` and return (samples, armed)."""
    validate(rom)
    if mode not in MODES:
        raise ValueError(f'unknown mode {mode!r}')
    w = program(rom)
    setup, mark, space = MODES[mode]
    if w[MODULATOR] != 0xBE07 and w[setup] != 0xBC07:
        raise ValueError('FSK modulator does not match DSP 3.1.2')

    frame = [0xBC07, 0xBF01, 0xBF0F, 0x0BC0, 0x7980, SAMPLE_BODY]
    arm = [0xBC07, 0x7A80, setup,      # call the ROM's own transmit setup
           0xAE1A, MODULATOR,          # splk @1a, #d95f
           0xAE1B, 0x8128,             # splk @1b, #8128 (no receiver)
           0x7980, 0]
    driver = frame + arm

    with NativeC5x(rom) as core:
        core.load_rom(struct.pack('<%dH' % len(driver), *driver))
        core.set_mpmc_pin(0)
        for address, value in FIXTURES:
            core.set_data(address, value)
        core.set_pc(len(frame))

        def until(pc, limit):
            for _ in range(limit):
                core.step(1)
                if core.state()['pc'] == pc:
                    return
            raise RuntimeError(f'modulator did not reach {pc:04x}: {core.state()}')

        until(0, 300)
        armed = {'increment_mark': core.data(0x3F2),
                 'increment_space': core.data(0x3F3),
                 'coefficients': core.data(0x3DF),
                 'amplitude': core.data(0x3E7),
                 'callback': core.data(0x39A)}

        out = []
        for bit in bits:
            for _ in range(samples_per_bit):
                core.set_data(DATA_CELL, DATA_BIT if bit else 0)
                core.set_data(GATE_CELL, 0xFFFF)   # the transmitter's enable
                until(MIXER_TOP, 700)
                core.set_pc(ISR_BODY)
                until(ISR_TRANSMIT, 120)
                tx = core.serial_state()['dxr']
                out.append(tx - 65536 if tx >= 32768 else tx)
                core.set_data(0x390, 0x0BC0)
                core.set_pc(0)
        return out, armed


# The receiver's own bring-up, in the order dispatch entry d829 calls it:
# install the modulator, initialise the AGC, install the receiver and clear its
# delay lines.
BRINGUP = (0xD94E, 0xD895, 0xD879)

# Each dispatch entry's receive setup, paired with its transmit setup.
RECEIVE_SETUP = {'v21-originate': 0xD7C8, 'bell103-originate': 0xD7D0,
                 'v21-answer': 0xD7A4, 'bell103-answer': 0xD7AC}

# The receiver raises INTR 17 every sample. Its vector at program 0x0022 is not
# in the resident bank, so the harness supplies a bare RETE there.
INTR17_VECTOR, RETE = 0x0022, 0xBE3A

SOFT_DECISION = 0x3EA          # @6a, the receiver's integrate-and-dump output
LOOPBACK_SAMPLES_PER_BIT = 48  # measured: see docs/fsk-modulation.md


def loopback(rom, bits, samples_per_bit=LOOPBACK_SAMPLES_PER_BIT,
             mode='v21-answer'):
    """Run the firmware's own transmitter into its own receiver.

    Every transmitted word is fed back as the next received word, which is what
    the codec's analogue loopback does in hardware. Returns the per-sample soft
    decisions the receiver produces at `@6a`.
    """
    validate(rom)
    if mode not in MODES:
        raise ValueError(f'unknown mode {mode!r}')
    setup, _, _ = MODES[mode]

    frame = [0xBC07, 0xBF01, 0xBF0F, 0x0BC0, 0x7980, SAMPLE_BODY]
    arm = [0xBC07]
    for target in (setup, RECEIVE_SETUP[mode], *BRINGUP):
        arm += [0x7A80, target]         # call, as the ROM's own entry does
    arm += [0x7980, 0]
    driver = frame + arm
    driver += [0] * (INTR17_VECTOR + 1 - len(driver))
    driver[INTR17_VECTOR] = RETE

    with NativeC5x(rom) as core:
        core.load_rom(struct.pack('<%dH' % len(driver), *driver))
        core.set_mpmc_pin(0)
        for address, value in FIXTURES:
            core.set_data(address, value)
        core.set_pc(len(frame))

        def until(pc, limit):
            for _ in range(limit):
                core.step(1)
                if core.state()['pc'] == pc:
                    return
            raise RuntimeError(f'loopback did not reach {pc:04x}: {core.state()}')

        until(0, 600)
        armed = {'modulator': core.data(0x39A), 'receiver': core.data(0x39B)}
        if armed['receiver'] != 0xD8AA:
            raise RuntimeError('the ROM did not install its own receiver')

        transmitted, soft, echo = [], [], 0
        for bit in bits:
            for _ in range(samples_per_bit):
                cell = core.data(DATA_CELL)
                core.set_data(DATA_CELL,
                              (cell | DATA_BIT) if bit else (cell & ~DATA_BIT))
                core.queue_codec_rx([echo & 0xFFFF])   # the loop itself
                until(MIXER_TOP, 900)
                core.set_pc(ISR_BODY)
                until(ISR_TRANSMIT, 200)
                echo = core.serial_state()['dxr']
                transmitted.append(echo - 65536 if echo >= 32768 else echo)
                value = core.data(SOFT_DECISION)
                soft.append(value - 65536 if value >= 32768 else value)
                core.set_data(0x390, 0x0BC0)
                core.set_pc(0)
        return transmitted, soft, armed


def slice_bits(soft, count, samples_per_bit, offset, mode='v21-answer'):
    """One decision per bit, at a fixed offset into the symbol.

    The receiver mixes against its band centre, so the sign of its output says
    whether the tone is above or below that centre - not which bit it is. V.21
    puts mark below the centre and Bell 103 puts it above, so the polarity is a
    property of the modulation and is taken from the frequency table.
    """
    _, mark, space = MODES[mode]
    inverted = mark < space
    return [(1 if soft[i * samples_per_bit + offset] > 0 else 0) ^ inverted
            for i in range(count)]


def best_offset(soft, bits, samples_per_bit, mode='v21-answer'):
    """The sampling instant that recovers the most bits: the receiver's delay."""
    scored = []
    for offset in range(samples_per_bit):
        recovered = slice_bits(soft, len(bits), samples_per_bit, offset, mode)
        errors = sum(a != b for a, b in zip(bits, recovered))
        scored.append((errors, offset))
    return min(scored)[1]


def demodulate(samples, mark, space, samples_per_bit):
    """Non-coherent detection: whichever tone has more energy in the bit."""
    bits = []
    for start in range(0, len(samples) - samples_per_bit + 1, samples_per_bit):
        block = samples[start:start + samples_per_bit]

        def energy(frequency):
            return abs(sum(x * complex(math.cos(2 * math.pi * frequency * i / RATE),
                                       math.sin(2 * math.pi * frequency * i / RATE))
                           for i, x in enumerate(block)))
        bits.append(1 if energy(mark) > energy(space) else 0)
    return bits


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument('--rom', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--mode', choices=sorted(MODES), default='v21-answer')
    parser.add_argument('--bits', default='')
    parser.add_argument('--samples-per-bit', type=int, default=24)
    parser.add_argument('--loopback', action='store_true',
                        help="run the ROM's transmitter into its own receiver")
    args = parser.parse_args()

    from .rom import CourierRom
    rom = CourierRom.load(args.rom)
    if args.bits:
        bits = [int(c) for c in args.bits if c in '01']
    else:
        # A 511-bit maximal-length sequence, the pattern V.54 self-test uses.
        state, bits = 0x1FF, []
        for _ in range(511):
            bit = state & 1
            state = (state >> 1) | (((state ^ (state >> 4)) & 1) << 8)
            bits.append(bit)

    setup, mark, space = MODES[args.mode]
    if args.loopback:
        spb = (LOOPBACK_SAMPLES_PER_BIT if args.samples_per_bit == 24
               else args.samples_per_bit)
        samples, soft, armed = loopback(rom, bits, spb, args.mode)
        offset = best_offset(soft, bits, spb, args.mode)
        recovered = slice_bits(soft, len(bits), spb, offset, args.mode)
        armed = {**armed, 'sampling_offset': offset}
        args.samples_per_bit = spb
    else:
        samples, armed = render(rom, bits, args.samples_per_bit, args.mode)
        recovered = demodulate(samples, mark, space, args.samples_per_bit)
    errors = sum(a != b for a, b in zip(bits, recovered))

    args.output.mkdir(parents=True, exist_ok=True)
    write_wave(args.output / ('loopback.wav' if args.loopback else 'fsk.wav'),
               samples)
    pcm = struct.pack('<%dh' % len(samples), *samples)
    manifest = {
        'mode': args.mode, 'rate_hz': RATE,
        'loopback': args.loopback,
        'mark_hz': mark, 'space_hz': space,
        'bits': len(bits), 'samples_per_bit': args.samples_per_bit,
        # This harness's keying rate, not a measurement of the firmware's own
        # bit clock - see docs/fsk-modulation.md.
        'harness_keying_rate': round(RATE / args.samples_per_bit, 2),
        'armed': {k: hex(v) for k, v in armed.items()},
        'bit_errors': errors,
        'measured': measure(samples),
        'pcm_sha256': hashlib.sha256(pcm).hexdigest(),
    }
    (args.output / 'manifest.json').write_text(
        json.dumps(manifest, indent=2, sort_keys=True, default=str) + '\n')
    print(json.dumps(manifest, indent=2, sort_keys=True, default=str))


if __name__ == '__main__':
    main()
