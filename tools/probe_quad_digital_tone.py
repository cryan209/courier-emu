"""Produce a G.711 tone by executing a C50 frame interrupt routine.

This is a board-interface diagnostic, not a replacement for QF060003's call
overlay. The digital call supplies only clocking and an idle receive timeslot;
the codewords written to DXR are produced by instructions executed in the same
native C50 core used by the Quad endpoint.
"""
from __future__ import annotations

import argparse
import json
import struct
from pathlib import Path

from courier_emu.dsp import NativeC5x
from courier_emu.quad_c50 import QuadC50Endpoint, ROM_FRAME_IRQ

ROOT = Path(__file__).resolve().parents[1]


def tone_program() -> bytes:
    # Main: Quad byte-format SPC, IRQ5 enabled, idle until each 8 kHz frame.
    words = [0xAE22, 0x40CC, 0xAE04, 1 << ROM_FRAME_IRQ,
             0xBE40, 0xBE22, 0x7980, 0x8005]
    words += [0x8B00] * (0x10 - len(words))
    # ISR: flip the G.711 sign bit in data 0x60, write DXR, return-and-enable.
    words += [0x6960, 0xBFD0, 0x0080, 0x9060, 0x9021, 0xBE3A]
    return struct.pack(f'<{len(words)}H', *words)


def probe(law: str, milliseconds: int) -> tuple[dict[str, object], bytes]:
    levels = {'mu': (0x1C, 0x9C), 'a': (0x2A, 0xAA)}
    core = NativeC5x.from_program(0x8000, tone_program())
    endpoint = QuadC50Endpoint(core=core, started=True)
    try:
        core.set_data(0x60, levels[law][0])
        endpoint.connect_digital_call(law=law)
        core.configure_line_frame_interrupt(ROM_FRAME_IRQ, 0x8010)
        # Frames are cycle-paced. Run long enough for the requested number,
        # then trim startup latency rather than pretending it is audio.
        wanted = milliseconds * 8
        core.set_pc(0x8000)
        core.step(wanted * 2_520 + 256)
        codewords = endpoint.transmit_g711()
        while codewords and codewords[0] not in levels[law]:
            codewords = codewords[1:]
        codewords = codewords[:wanted]
        state = core.serial_state()
        report = {
            'producer': 'executed TMS320C50 frame ISR',
            'law': law,
            'sample_rate': 8_000,
            'sample_bits': 8,
            'milliseconds': milliseconds,
            'codewords': len(codewords),
            'levels': [f'{value:02x}' for value in levels[law]],
            'unique_codewords': [f'{value:02x}' for value in sorted(set(codewords))],
            'dxr_writes': state['dxr_writes'],
            'last_dxr_pc': f"{state['last_dxr_pc']:04x}",
            'frame_period_cycles': core.codec_state()['frame_period'],
        }
        return report, codewords
    finally:
        core.close()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--law', choices=('mu', 'a'), default='mu')
    parser.add_argument('--milliseconds', type=int, default=1_000)
    parser.add_argument('--output', type=Path,
                        default=ROOT / 'artifacts/quad-digital-tone-20260910')
    args = parser.parse_args()
    if args.milliseconds <= 0:
        raise SystemExit('--milliseconds must be positive')
    report, codewords = probe(args.law, args.milliseconds)
    args.output.mkdir(parents=True, exist_ok=True)
    (args.output / 'tone.g711').write_bytes(codewords)
    (args.output / 'results.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))
