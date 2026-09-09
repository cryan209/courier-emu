"""Capture what the Quad streams to its C50 datapumps, without perturbing it.

Runs the modem and reassembles the DSP download from the machine's own recorded
port writes, so the tap cannot change timing. Prints what was captured and how
it compares with the source region the supervisor streams from.
"""
import json
from pathlib import Path

from courier_emu.machine import CourierMachine
from courier_emu.quad_image import QuadImage
from courier_emu.quad_c50 import QuadC50Link
from courier_emu.nvram import CourierNvram, IDSDL403_NVRAM

ROOT = Path(__file__).resolve().parents[1]
IN = ROOT / 'artifacts/quad-identify-20260910'
OUT = ROOT / 'artifacts/quad-c50-20260910'

if __name__ == '__main__':
    OUT.mkdir(parents=True, exist_ok=True)
    image = QuadImage.modem((IN/'flash.bin').read_bytes(), (IN/'ram.bin').read_bytes())
    machine = CourierMachine(image, quad_terminal=True, tick_ms=5,
                             max_io_events=4_000_000,
                             nvram=CourierNvram(data=bytearray(IDSDL403_NVRAM)),
                             serial_input=b'ATQ0V1\r')
    result = machine.run(4_000_000)
    link = QuadC50Link.from_io_events(machine.io_events)
    payload = link.image()
    (OUT/'stream.bin').write_bytes(payload)
    # The supervisor streams from es:si with es = 0x2000, ax = 0 and cx = 0xf450
    # (0xced12), so the source is physical 0x20000..0x2f450.
    source = bytes(machine.uc.mem_read(0x20000, 0xF450))
    report = dict(status=result.status, instructions=result.instructions,
                  link=link.status(), stream_bytes=len(payload),
                  source_bytes=len(source),
                  stream_is_prefix_of_source=source.startswith(payload[:len(source)]),
                  first_pass_matches_source=payload[:len(source)] == source,
                  source_nonzero=sum(1 for b in source if b),
                  stream_head=payload[:32].hex(' '), source_head=source[:32].hex(' '))
    (OUT/'results.json').write_text(json.dumps(report, indent=1)+'\n')
    print(json.dumps(report, indent=1))
