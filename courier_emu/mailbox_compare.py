"""Offline DSP 3.1.2 mailbox comparison against a saved hardware capture.

Runs the real dispatcher and sender, entered by a small test driver. This is
not a full-board boot: queue pointers and idle data RAM are fixtures. The ASIC
status adapter preserves unrelated bits on acknowledgement; it does not model
interrupt latency. No serial device is opened.
"""
from __future__ import annotations
import argparse
import hashlib
import json
from pathlib import Path
import struct

from .dsp import NativeC5x
from .rom import CourierRom

TABLE, DISPATCH, SENDER = 0x83E9, 0x8387, 0x83BF
NOOPS = (0x2D, 0x31, 0x6C, 0x6D, 0x6E, 0x6F)


def program(rom):
    words = [0] * 65536
    for origin, data in rom.dsp_program_segments():
        words[origin:origin + len(data)//2] = struct.unpack('<%dH' % (len(data)//2), data)
    return words


def validate(rom):
    w = program(rom)
    checks = [
        w[0x839E:0x83A6] == [0x697D, 0xBA7F, 0xEF04, 0xBF90, 0x8468, 0xA67C, 0x107C, 0xBE20],
        w[TABLE + 7] == 0x84B2,
        w[0x84B2:0x84BA] == [0x7E80, 0x83B1, 0xBF80, 0x8031, 0x7D80, 0x83B1, 0xBC10, 0x1018],
        w[TABLE + 0x62] == 0xC490,
        w[0xC4E0:0xC4E4] == [0xBF80, 0x8069, 0x7A80, 0x83B1],
        all(w[w[TABLE + tag]] == 0xEF00 for tag in NOOPS),
    ]
    if not all(checks):
        raise ValueError('ROM does not match the verified DSP 3.1.2 mailbox profile')


def execute(rom, tag, *, acknowledge=True):
    validate(rom)
    if tag not in (7, 0x62, *NOOPS):
        raise ValueError('unverified command')
    with NativeC5x(rom) as core:
        driver = (0x8B89, 0x7A80, DISPATCH, 0x8B89, 0x7A80, SENDER, 0x7980, 6)
        core.load_rom(struct.pack('<8H', *driver))
        core.set_mpmc_pin(0)
        core.set_data(0x78, 0xFF50)
        core.set_data(0x79, 0xFF50)
        core.set_io(0x57, 3)  # host request pending and room for DSP reply
        core.set_io(0x5E, tag)
        core.set_io(0x5F, 0)
        core.set_pc(0)
        status, seen = 3, 0
        for _ in range(2000):
            core.step(1)
            events = core.io_events()
            for event in events[seen:]:
                if acknowledge and event['write'] and event['port'] == 0x57:
                    status &= ~event['value']
                    core.set_io(0x57, status)
            seen = len(events)
            if core.state()['pc'] == 6:
                break
        else:
            raise RuntimeError('dispatcher/sender did not return')
        writes = [e for e in events if e['write']]
        tags = [e['value'] for e in writes if e['port'] == 0x5E]
        values = [e['value'] for e in writes if e['port'] == 0x5F]
        return {'reply': [tags[-1], values[-1]] if tags and values else None,
                'instructions': core.state()['instructions'], 'writes': writes}


def compare(rom, capture):
    standing = [int(capture['before']['58'], 16) | int(capture['before']['5A'], 16) << 8,
                int(capture['before']['5C'], 16) | int(capture['before']['5E'], 16) << 8]
    steps = []
    for step in capture['steps']:
        tag = int(step['tag'], 16)
        result = execute(rom, tag)
        if result['reply'] is not None:
            standing = result['reply']
        observed = step['observed']
        hardware = [int(observed['58'], 16) | int(observed['5A'], 16) << 8,
                    int(observed['5C'], 16) | int(observed['5E'], 16) << 8]
        steps.append({'command': tag, 'hardware': hardware, 'emulated': standing[:],
                      'tag_matches': standing[0] == hardware[0],
                      'value_matches': standing[1] == hardware[1], **result})
    return {'rom_sha256': hashlib.sha256(rom.data).hexdigest(),
            'scope': 'Real DSP dispatcher and sender; fixture RAM and ASIC acknowledgement adapter; no boot or timing equivalence claimed',
            'steps': steps}


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument('--rom', type=Path, required=True)
    parser.add_argument('--capture', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    report = compare(CourierRom.load(args.rom), json.loads(args.capture.read_text()))
    args.output.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
