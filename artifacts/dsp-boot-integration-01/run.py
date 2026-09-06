from courier_emu.machine import CourierMachine
from courier_emu.images import load_image
from courier_emu.nvram import CourierNvram
from dataclasses import asdict
from pathlib import Path
import json
for name,p in [('302','IDSDL302.ROM'),('403','artifacts/courier-board-21210-capture-403/courier-board.rom')]:
 m=CourierMachine(load_image(p),nvram=CourierNvram.idsl302_fixture(),tick_ms=5,board_id=7,serial_input=b'AT\rATI7\r',with_dsp=True)
 d=asdict(m.run(60000000))
 Path('artifacts/dsp-boot-integration-01/'+name+'.json').write_text(json.dumps(d,indent=2))
 text = bytes(byte & 0x7f for byte in m.serial).decode('ascii')
 Path('artifacts/dsp-boot-integration-01/'+name+'.txt').write_text(text)
 bridge = d['dsp_bridge']
 assert text.count('\r\nOK\r\n') == 2
 assert d['serial_input_remaining'] == 0
 assert bridge['error'] is None and bridge['bootstrap_match']
 assert bridge['dsp_memory_map']['rom_present']
 assert bridge['dsp_memory_map']['rom_holes'] == 0
 assert bridge['dsp_memory_map']['iptr'] == 0
 print(name, text, bridge['dsp'], flush=True)
