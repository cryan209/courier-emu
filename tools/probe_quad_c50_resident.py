"""Decode the C50 resident's host-link I/O sequence, with no CPU attached.

Runs the captured resident on its own and reports which MMRs it touches, in
what order, so the request/acknowledge protocol on the host link can be read
off real execution rather than guessed from the CPU side.
"""
import ctypes
import json
from collections import Counter
from pathlib import Path

from courier_emu.dsp import NativeC5x
from courier_emu.quad_c50 import RESIDENT_ORIGIN, RESIDENT_WORDS

ROOT = Path(__file__).resolve().parents[1]
STREAM = ROOT / 'artifacts/quad-c50-20260910/stream.bin'
OUT = ROOT / 'artifacts/quad-c50-resident-20260910'


def events(core, limit):
    library, handle = core.library, core.handle
    core.step(limit)
    count = int(library.courier_c5x_get_io_event_count(handle))
    result = []
    for index in range(count):
        values = (ctypes.c_uint64 * 5)()
        library.courier_c5x_get_io_event(handle, index, values, 5)
        result.append(dict(write=bool(values[0]), port=int(values[1]),
                           value=int(values[2]), pc=int(values[3]),
                           instruction=int(values[4])))
    return result


if __name__ == '__main__':
    OUT.mkdir(parents=True, exist_ok=True)
    # The stream carries the eight 0x0083 lane-init words before the image.
    image = STREAM.read_bytes()[16:16 + RESIDENT_WORDS * 2]
    core = NativeC5x.from_program(RESIDENT_ORIGIN, image)
    core.set_pc(RESIDENT_ORIGIN)
    log = events(core, 200_000)
    ports = Counter((event['port'], 'write' if event['write'] else 'read') for event in log)
    # The steady-state cycle, taken from the tail so start-up is excluded.
    cycle = [f"{'W' if e['write'] else 'r'} {e['port']:02x}" for e in log[-12:]]
    report = dict(
        events=len(log),
        ports={f"{port:02x} {kind}": n for (port, kind), n in sorted(ports.items())},
        setup=[dict(port=e['port'], value=e['value'], pc=e['pc'])
               for e in log if e['instruction'] < 2000],
        steady_cycle=cycle,
        read_pcs=sorted({e['pc'] for e in log if not e['write']}),
        write_pcs=sorted({e['pc'] for e in log if e['write']}),
    )
    (OUT/'results.json').write_text(json.dumps(report, indent=1)+'\n')
    print(json.dumps(report, indent=1))
