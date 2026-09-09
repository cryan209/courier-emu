"""Run the Quad card with its C50 endpoint answering, and watch for parameter 0x1f2.

The endpoint steps a C5x core on an instruction budget alongside the CPU and
raises the strobed ready bit on 0x98 only once the DSP has pulled the queued
words, so the CPU waits on the DSP instead of on a floating bus.
"""
import json
import sys
from pathlib import Path

from courier_emu.machine import CourierMachine
from courier_emu.quad_image import QuadImage
from courier_emu.quad_c50 import QuadC50Endpoint
from courier_emu.nvram import CourierNvram, IDSDL403_NVRAM

ROOT = Path(__file__).resolve().parents[1]
IN = ROOT / 'artifacts/quad-identify-20260910'
OUT = ROOT / 'artifacts/quad-c50-live-20260910'

WATCH = {
    0xCEC04: 'dsp_load_entry', 0xCEC2D: 'dsp_load_ok', 0xCEE5D: 'dsp_load_fail',
    0xCEC26: 'dsp_give_up', 0xF3D24: 'msg_cursor_seed', 0xF4975: 'msg_buffer_fill',
    0xF4889: 'param_id_compare', 0xF88DB: 'param_1f2_handler',
}

if __name__ == '__main__':
    OUT.mkdir(parents=True, exist_ok=True)
    limit = int(sys.argv[1]) if len(sys.argv) > 1 else 6_000_000
    endpoint = QuadC50Endpoint()
    image = QuadImage.modem((IN/'flash.bin').read_bytes(), (IN/'ram.bin').read_bytes())
    machine = CourierMachine(image, quad_terminal=True, tick_ms=5, quad_c50=endpoint,
                             nvram=CourierNvram(data=bytearray(IDSDL403_NVRAM)),
                             serial_input=b'ATQ0V1\r')
    counts: dict[int, int] = {}
    machine._code_observer = lambda pc: counts.__setitem__(pc, counts.get(pc, 0) + 1) \
        if pc in WATCH else None
    result = machine.run(limit)
    report = dict(status=result.status, instructions=result.instructions,
                  endpoint=endpoint.status(),
                  dsp_status_mmr=(hex(endpoint.core.library.courier_c5x_get_io(
                      endpoint.core.handle, 0x57)) if endpoint.core else None),
                  watched={name: counts.get(pc, 0) for pc, name in WATCH.items()})
    (OUT/'results.json').write_text(json.dumps(report, indent=1)+'\n')
    print(json.dumps(report, indent=1))
