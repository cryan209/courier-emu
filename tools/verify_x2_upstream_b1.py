#!/usr/bin/env python3
"""Execute Courier's B1 setup/mapper from a retained original DSP snapshot.

Controlled invocation verifies mapping, not the call scheduler. The symbol
counter decrement models the outer scheduler; stopping before B08C avoids
running the transmit pulse shaper. Output symbols are unscaled Q9.7.
"""
import hashlib
import json
import struct
import sys
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from courier_emu.dsp import NativeC5x
from tools.recover_3453c_x2 import listing
OUT = ROOT / 'artifacts/x2-upstream-b1-20261005'
SEEDS = {0x39f: 0x4060, 0x340: 0xf37c, 0x941: 0x3fe, 0x3db: 4, 0x3fb: 1}


def invoke(core, entry, stop=0x7008):
    core.load_program(struct.pack('<9H', 0xbc07, 0x8b89, 0xbe47, 0xbe42,
                                  0xbe4a, 0xbf01, 0x7a80, entry, 0x8b00), 0x7000)
    core.set_pc(0x7000)
    for _ in range(50000):
        if core.state()['pc'] == stop:
            return
        core.step(1)
    raise AssertionError(core.state())


def main():
    program = (OUT / 'analog-dsp-program.bin').read_bytes()
    data = (OUT / 'analog-dsp-data.bin').read_bytes()
    words = struct.unpack('<65536H', data)
    with NativeC5x.from_program(0, program) as core:
        for address in range(32, 65536):
            core.set_data(address, words[address])
        for address, value in SEEDS.items():
            core.set_data(address, value)
        invoke(core, 0xb1a1)
        parameters = {f'{i:04x}': core.data(i) for i in range(0x3a2, 0x3ae)}
        assert parameters['03a4'] == 60  # 60 bits / eight symbols at 3200 baud
        assert parameters['03a5'] == 3   # Q=3
        core.set_data(0x3ca, 0)
        core.set_data(0x6f, 0x0a43)      # bit 2 clear selects constant-one source
        symbols = []
        for i in range(480):
            invoke(core, 0xaf99 if i == 0 else core.data(0x3c8), 0xb08c)
            symbols.append([v - 65536 if v & 0x8000 else v
                            for v in (core.data(0x3f8), core.data(0x3f9))])
            core.set_data(0x3ca, (core.data(0x3ca) - 1) & 65535)
    (OUT / 'native-symbols.json').write_text(json.dumps(symbols) + '\n')
    program_words = struct.unpack('<65536H', program)
    (OUT / 'mapper.asm').write_text(''.join(listing(program_words, a, b) for a, b in
        [(0xb1a1, 0xb20b), (0xa63a, 0xa682), (0xa71b, 0xa7f0),
         (0xaf99, 0xafff), (0xb006, 0xb08c), (0xb347, 0xb373)]))
    report = {'qualification': 'Controlled original-instruction mapper execution with seeded received MP and rate mask; snapshot supplies lookup tables. Not a complete call.',
              'snapshot_source': '/private/tmp/x2-mp-record/9754',
              'program_sha256': hashlib.sha256(program).hexdigest(),
              'data_sha256': hashlib.sha256(data).hexdigest(),
              'seeds': {f'{a:04x}': f'{v:04x}' for a, v in SEEDS.items()},
              'parameters': parameters, 'symbols': len(symbols),
              'upstream_bps': parameters['03a4'] * 3200 // 8}
    (OUT / 'native-verification.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))

if __name__ == '__main__':
    main()
