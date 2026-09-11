#!/usr/bin/env python3
"""Compare unpatched Ie030002 startup with and without mailbox IRQ13 service.

Requires Unicorn JIT execution (outside the macOS sandbox).
The endpoint captures commands; no DSP replies are synthesized.
"""
import argparse
import json
from pathlib import Path
import struct
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from courier_emu.isdn import IsdnMachine
from courier_emu.xmp import XmpImage


def probe(image, instructions, enabled):
    machine = IsdnMachine(image, mailbox_service=enabled)
    result = machine.run(instructions)
    def words(address, count):
        return list(struct.unpack('<' + 'H' * count,
                                  machine.machine.mem_read(address, count * 2)))
    return {'service_enabled': enabled, 'run': result.to_dict(),
            'ring_pointers': words(0x329ae, 2),
            'staged_word': words(0x3299d, 1)[0],
            'irq13_vector': words(0x2d * 4, 2),
            'service_pointer': words(0x32893, 2),
            'handler_entries': machine.pc_counts[0xb3d90],
            'ring_wait_visits': machine.pc_counts[0xa543b],
            'ring_timeout_visits': machine.pc_counts[0xa5446]}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--image', type=Path, default=Path('Ie030002.xmp'))
    parser.add_argument('--instructions', type=int, default=5_000_000)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    image = XmpImage.load(args.image)
    if image.payload[0x73d90:0x73d95] != bytes.fromhex('fbfe06edc8'):
        raise ValueError('probe addresses require Ie030002')
    cases = [probe(image, args.instructions, enabled) for enabled in (False, True)]
    report = {'image_sha256': image.digest, 'cases': cases}
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2) + '\n')
    for case in cases:
        print(json.dumps({k: v for k, v in case.items() if k != 'run'}))
        print(json.dumps(case['run']['mailbox']))
    before, after = cases
    assert before['handler_entries'] == 0
    assert after['handler_entries'] > 0
    assert after['run']['mailbox']['committed'] > 0
    assert after['ring_pointers'][0] == after['ring_pointers'][1]
    assert after['ring_timeout_visits'] < before['ring_timeout_visits']
    assert after['run']['error'] is None


if __name__ == '__main__':
    main()
