"""Render DSP 3.1.2's own DTMF code through its buffer and serial ISR.

A component harness supplies frame scheduling, idle RAM, and one buffer pair.
It does not boot the board or claim a physical codec clock measurement. The
7200 Hz rate is inferred from the firmware's DTMF phase increments.
"""
from __future__ import annotations
import argparse
import hashlib
import json
import math
from pathlib import Path
import struct
import wave
from .dsp import NativeC5x
from .mailbox_compare import program, validate
from .rom import CourierRom

RATE = 7200
DIGITS = '0123456789#*ABCD'
ROWS, COLUMNS = (697, 770, 852, 941), (1209, 1336, 1477, 1633)


def render(rom, digit, count=1440):
    validate(rom)
    if digit not in DIGITS or count <= 0:
        raise ValueError('expected one DTMF digit and positive sample count')
    w = program(rom)
    if w[0x818F] != 0x8821 or w[0xEE2B] != 0x8743:
        raise ValueError('audio path does not match DSP 3.1.2')
    with NativeC5x(rom) as core:
        # Frame entry sets DP/PM and the work pointer, then enters the original
        # callback/mixer. Initial entry additionally invokes the tone selector.
        driver = [0xBC07, 0xBF01, 0xBF0F, 0x0BC0, 0x7980, 0x80D3,
                  0xBC07, 0x7A80, 0xEE20, 0x7980, 0]
        core.load_rom(struct.pack('<%dH' % len(driver), *driver))
        core.set_mpmc_pin(0)
        for address, value in [(0x7A, DIGITS.index(digit)), (0x3FB, 1),
                               (0x3F1, 0x0C08), (0x392, 0x3000),
                               (0x39B, 0x8128), (0x390, 0x0BC0),
                               (0x398, 3), (0x399, 3)]:
            core.set_data(address, value)
        core.set_pc(6)
        samples = []
        def until(pc, limit):
            for _ in range(limit):
                core.step(1)
                if core.state()['pc'] == pc:
                    return
            raise RuntimeError(f'audio path did not reach {pc:04x}: {core.state()}')
        for _ in range(count):
            until(0x80C3, 500)
            sample = core.data(0x0BC1)
            # Enter the real ISR body; stop before RETE because the harness
            # supplies the scheduling rather than simulating an IRQ context.
            core.set_pc(0x8178)
            until(0x8199, 100)
            tx = core.serial_state()['dxr']
            if tx != sample:
                raise RuntimeError('serial transmitter differs from the firmware buffer')
            samples.append(tx if tx < 32768 else tx - 65536)
            core.set_data(0x390, 0x0BC0)
            core.set_pc(0)
        return samples, core.serial_state()


def spectrum(samples):
    def magnitude(frequency):
        return abs(sum(x * complex(math.cos(2*math.pi*frequency*i/RATE),
                                   math.sin(2*math.pi*frequency*i/RATE))
                       for i, x in enumerate(samples)))
    bins = {f: magnitude(f) for f in (*ROWS, *COLUMNS)}
    return {'row': max(ROWS, key=bins.get), 'column': max(COLUMNS, key=bins.get),
            'magnitudes': bins}


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument('--rom', type=Path, required=True)
    parser.add_argument('--digits', default='123456789*0#ABCD')
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    if not args.digits or any(d not in DIGITS for d in args.digits):
        parser.error('invalid digits')
    args.output.mkdir(parents=True, exist_ok=False)
    rom = CourierRom.load(args.rom)
    combined, reports = [], []
    for digit in args.digits:
        samples, serial = render(rom, digit)
        combined.extend(samples)
        combined.extend([0] * (RATE // 10))
        reports.append({'digit': digit, 'peak': max(map(abs, samples)),
                        'sample_sha256': hashlib.sha256(struct.pack('<%dh'%len(samples), *samples)).hexdigest(),
                        'spectrum': spectrum(samples),
                        'drr_reads': serial['drr_reads'], 'dxr_writes': serial['dxr_writes'],
                        'last_dxr_pc': hex(serial['last_dxr_pc'])})
    with wave.open(str(args.output / 'firmware-dtmf.wav'), 'wb') as wav:
        wav.setnchannels(1); wav.setsampwidth(2); wav.setframerate(RATE)
        wav.writeframes(struct.pack('<%dh' % len(combined), *combined))
    report = {'rom_sha256': hashlib.sha256(rom.data).hexdigest(),
              'sample_rate': RATE, 'sample_rate_basis': 'inferred from labelled DTMF phase increments; not measured on hardware',
              'scope': 'Firmware tone selector, oscillator, mixer, buffer and serial ISR; harness supplies frame context',
              'tones': reports}
    (args.output / 'manifest.json').write_text(json.dumps(report, indent=2)+'\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
