"""Reproduce Quad startup without patching firmware or forcing interrupts."""
import json
from pathlib import Path
from types import SimpleNamespace
from zipfile import ZipFile
from courier_emu.nac import NacImage
from courier_emu.machine import CourierMachine
from courier_emu.quad_usart import QuadUsart

out = Path(__file__).resolve().parent
root = out.parents[1]
source = out / 'QF060003.NAC'
source.write_bytes(ZipFile(root / 'docs/x2/Qf060003.zip').read('QF060003.NAC'))
base, data = NacImage.load(source).flatten()
image = SimpleNamespace(data=data, load_base=base, entry_segment=0x8000,
                        entry_offset=0, entry_physical=base, emulates_interrupts=True)
rows = []
for position in (0, 1):
    link = QuadUsart()
    link.queue(b'22\x02')
    machine = CourierMachine(image, port_values={0x260: position << 4},
        quad_usart=link, tick_ms=5, serial_input=b'AT\r', max_io_events=100,
        pc_watch={0x819e6:'chassis_rx', 0x80730:'copy_image',
                  0x93804:'dsp_load', 0x80260:'service_loop'})
    result = machine.run(8_000_000)
    row = dict(position=position, status=result.status, ticks=machine.ticks,
        timer_interrupts=machine.timer_interrupts, usart=link.state(),
        serial_remaining=len(machine.serial_rx), serial_hex=bytes(machine.serial).hex(),
        watch_counts=dict(machine.pc_watch_counts), last_addresses=[hex(a) for a in machine.last_addresses],
        ram={hex(a):bytes(machine.uc.mem_read(a,n)).hex()
             for a,n in [(0x213,2),(0x22e,3),(0x45c,2)]},
        io_counts={f'{op}:{port:#x}:{size}':count
                   for (op,port,size),count in machine.io_counts.items()})
    rows.append(row)
    print(json.dumps(row),flush=True)
(out / 'results.json').write_text(json.dumps(rows,indent=2)+'\n')
source.unlink()
