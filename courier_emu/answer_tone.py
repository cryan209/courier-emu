"""Render DSP 3.1.2's own answer tone through its mixer and serial ISR.

The dial path's DTMF generator is not the only thing this datapump can drive.
The resident bank carries a family of oscillator callbacks - `874f` for one
tone, `8743` for the DTMF pair that falls through into it, and `8739`, which
inverts the oscillator's phase on a counter and then falls through to `874f`.
The arming routine at `86d1` takes a phase increment in the accumulator, stores
it at data `0x3f2`, installs `874f`, sets the amplitude at `0x3f3` and clears
the phase at `0x3c0`.

Its caller at program `9f40` passes `#4aab`. At the dial path's 7200 Hz that is
2100.04 Hz - the V.25 answer tone - and the reversal counter `9f46` loads is
`0x0ca7`, 3239 samples, or 449.9 ms, which is V.25's 450 ms reversal period.

This module arms the tone with the firmware's own instruction words, lifted
from `9f40`, `9f46`, `9f4c` and `9f58`, then runs the same main-loop mixer and
serial ISR body that `courier_emu.audio312` runs for DTMF. As there, the
harness supplies frame scheduling, idle RAM and one buffer pair; it does not
boot the board, and it does not measure a physical codec clock.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
import struct
import wave
from pathlib import Path

from .dsp import NativeC5x
from .mailbox_compare import program, validate

# The dial path's rate, inferred in docs/audio-312-path.md from the labelled
# DTMF phase increments, and corroborated here by 0x4aab and 0x0ca7.
RATE = 7200

# The V.25 answer tone as this firmware asks for it.
ANSWER_INCREMENT = 0x4AAB

# The four oscillator callbacks the selector at 9f4c/9f53/9f56 can install.
# 874f is the bare tone; 8739 prefixes it with the phase-reversal counter;
# 8712 and 8716 run the same two and then fall into 8718, which advances a
# second oscillator at increment 0x0089 - 15.05 Hz at 7200 Hz - and multiplies
# the tone by it. That is V.8's ANSam amplitude modulation.
VARIANTS = {'ans': 0x874F, 'ans-reversals': 0x8739,
            'ansam': 0x8712, 'ansam-reversals': 0x8716}
MODULATION_INCREMENT = 0x0089

# Sites whose instruction words this harness replays verbatim.
ARM = 0x9F40           # lacc #4aab ; call 86d1
REVERSAL_COUNT = 0x9F46  # splk @75, #0ca7
REVERSAL_CALLBACK = 0x9F4C  # splk @1a, #8739
REVERSAL_AMPLITUDE = 0x9F58  # splk @73, #06cf

MIXER_TOP, SAMPLE_BODY = 0x80C3, 0x80C7
ISR_BODY, ISR_TRANSMIT = 0x8178, 0x8199
BUFFER, CALLBACK = 0x0BC1, 0x39A
# Data page 7 bases at 0x380, so the oscillator's cells are @72/@73/@40/@75.
INCREMENT, AMPLITUDE, PHASE, REVERSAL_RELOAD = 0x3F2, 0x3F3, 0x3C0, 0x3F5

# The idle-RAM fixtures the audio path needs, as in audio312.
FIXTURES = ((0x3FB, 1), (0x3F1, 0x0C08), (0x392, 0x3000),
            (0x39B, 0x8128), (0x390, 0x0BC0), (0x398, 3), (0x399, 3))


def render(rom, count=7200, increment=ANSWER_INCREMENT,
           variant='ans-reversals'):
    """Return (samples, serial_state, armed) for `count` output samples."""
    if variant not in VARIANTS:
        raise ValueError(f'unknown variant {variant!r}')
    validate(rom)
    if count <= 0:
        raise ValueError('expected a positive sample count')
    w = program(rom)
    if w[0x86D4] != 0x874F or w[0x8742] != 0x874F or w[ARM] != 0xBF80:
        raise ValueError('answer-tone generator does not match DSP 3.1.2')

    # Frame preamble, then the firmware's own arming words.
    # Enter at the mixer's own sample body, not at the callback call: 80c9
    # sets ARP to 1, which the reversal callback's BANZ depends on.
    frame = [0xBC07, 0xBF01, 0xBF0F, 0x0BC0, 0x7980, SAMPLE_BODY]
    arm = [0xBC07, w[ARM], increment, w[ARM + 2], w[ARM + 3]]
    if variant != 'ans':
        # The selector's own amplitude and reversal reload, then the callback
        # this variant wants in place of 86d1's bare 874f.
        arm += [w[REVERSAL_COUNT], w[REVERSAL_COUNT + 1],
                w[REVERSAL_AMPLITUDE], w[REVERSAL_AMPLITUDE + 1],
                w[REVERSAL_CALLBACK], VARIANTS[variant]]
    arm += [0x7980, 0]
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
            raise RuntimeError(f'audio path did not reach {pc:04x}: {core.state()}')

        # Run the arming words, then record what they installed.
        until(0, 200)
        armed = {'callback': core.data(CALLBACK), 'increment': core.data(INCREMENT),
                 'amplitude': core.data(AMPLITUDE), 'phase': core.data(PHASE),
                 'reversal_counter': core.data(REVERSAL_RELOAD)}

        samples = []
        for _ in range(count):
            until(MIXER_TOP, 500)
            sample = core.data(BUFFER)
            core.set_pc(ISR_BODY)
            until(ISR_TRANSMIT, 100)
            tx = core.serial_state()['dxr']
            if tx != sample:
                raise RuntimeError('serial transmitter differs from the firmware buffer')
            samples.append(tx if tx < 32768 else tx - 65536)
            core.set_data(0x390, 0x0BC0)
            core.set_pc(0)
        return samples, core.serial_state(), armed


def measure(samples):
    """Dominant frequency by Goertzel scan, plus detected phase reversals."""
    def magnitude(frequency, block):
        return abs(sum(x * complex(math.cos(2 * math.pi * frequency * i / RATE),
                                   math.sin(2 * math.pi * frequency * i / RATE))
                       for i, x in enumerate(block)))

    if not any(samples):
        return {'frequency_hz': None, 'silent': True, 'rms': 0.0, 'peak': 0,
                'sideband_ratio': {}, 'reversals': [],
                'reversal_period_samples': [], 'reversal_period_ms': []}
    window = samples[:min(len(samples), 2048)]
    coarse = max(range(300, 3500, 10), key=lambda f: magnitude(f, window))
    peak = max((coarse - 10 + n * 0.25 for n in range(81)),
               key=lambda f: magnitude(f, window))

    # A reversal shows up as a sign flip in the tone's analytic phase. Compare
    # each block against a reference oscillator and watch the argument jump.
    block = 64
    phases, reversals = [], []
    for start in range(0, len(samples) - block, block):
        chunk = samples[start:start + block]
        value = sum(x * complex(math.cos(2 * math.pi * peak * (start + i) / RATE),
                                math.sin(2 * math.pi * peak * (start + i) / RATE))
                    for i, x in enumerate(chunk))
        phases.append((start, math.atan2(value.imag, value.real)))
    for (a, pa), (b, pb) in zip(phases, phases[1:]):
        step = abs(math.atan2(math.sin(pb - pa), math.cos(pb - pa)))
        if step > 2.0:
            reversals.append(b)
    spacing = [b - a for a, b in zip(reversals, reversals[1:])]
    # ANSam's 15 Hz modulation appears as a sideband pair around the carrier.
    # Resolving 15 Hz needs a long window, so use the whole run.
    carrier = magnitude(peak, samples)
    sidebands = {round(peak + offset, 2): round(magnitude(peak + offset, samples) / carrier, 4)
                 for offset in (-15.05, 15.05, 40)}
    return {'frequency_hz': round(peak, 2),
            'silent': False,
            'sideband_ratio': sidebands,
            'rms': round(math.sqrt(sum(x * x for x in samples) / len(samples)), 1),
            'peak': max(abs(x) for x in samples),
            'reversals': reversals,
            'reversal_period_samples': spacing,
            'reversal_period_ms': [round(s / RATE * 1000, 1) for s in spacing]}


def write_wave(path, samples):
    with wave.open(str(path), 'wb') as out:
        out.setnchannels(1)
        out.setsampwidth(2)
        out.setframerate(RATE)
        out.writeframes(struct.pack('<%dh' % len(samples), *samples))


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument('--rom', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--seconds', type=float, default=1.5)
    parser.add_argument('--increment', type=lambda s: int(s, 0),
                        default=ANSWER_INCREMENT)
    parser.add_argument('--variant', choices=sorted(VARIANTS),
                        default='ans-reversals')
    args = parser.parse_args()

    from .rom import CourierRom
    rom = CourierRom.load(args.rom)
    count = int(args.seconds * RATE)
    samples, serial, armed = render(rom, count, args.increment, args.variant)

    args.output.mkdir(parents=True, exist_ok=True)
    write_wave(args.output / 'answer-tone.wav', samples)
    pcm = struct.pack('<%dh' % len(samples), *samples)
    manifest = {
        'rate_hz': RATE,
        'samples': len(samples),
        'increment': hex(args.increment),
        'nominal_hz': round(args.increment / 65536 * RATE, 2),
        'variant': args.variant,
        'armed': {k: hex(v) for k, v in armed.items()},
        'measured': measure(samples),
        'pcm_sha256': hashlib.sha256(pcm).hexdigest(),
        'serial': serial,
    }
    (args.output / 'manifest.json').write_text(
        json.dumps(manifest, indent=2, sort_keys=True, default=str) + '\n')
    print(json.dumps(manifest, indent=2, sort_keys=True, default=str))


if __name__ == '__main__':
    main()
