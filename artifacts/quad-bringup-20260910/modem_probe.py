from pathlib import Path
from types import SimpleNamespace
from courier_emu.machine import CourierMachine
import json
out = Path(__file__).resolve().parent
image = SimpleNamespace(data=(out/'position-0-channel-0-flash.bin').read_bytes(),
    load_base=0xc0000, entry_segment=0xf000, entry_offset=0xfff0,
    entry_physical=0xffff0, emulates_interrupts=True, quad_profile=True, quad_role="modem",
    initial_memory=((0,(out/'position-0-channel-0-ram.bin').read_bytes()),))
m=CourierMachine(image,tick_ms=5,serial_input=b'AT\r',track_executed=True,max_io_events=200)
r=m.run(8_000_000)
row=dict(registers=r.registers,instructions=r.instructions,last=[hex(a) for a in m.last_addresses],status=r.status,error=r.error,serial=bytes(m.serial).hex(),left=len(m.serial_rx),
         hot=[(hex(a),n) for a,n in m.executed.most_common(30)],
         io={f'{op}:{p:#x}:{s}':n for (op,p,s),n in m.io_counts.items()},
         events=[vars(e) for e in m.io_events], timers=m.timers.status(),
         vectors=r.interrupt_vectors)
print(json.dumps({k:v for k,v in row.items() if k not in ("events", "vectors", "io", "timers")}),flush=True)
(out/'modem-results.json').write_text(json.dumps(row,indent=2)+'\n')
(out/'modem-memory.bin').write_bytes(m.uc.mem_read(0,0x100000))
