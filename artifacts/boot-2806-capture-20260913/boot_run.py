import json, sys
from courier_emu.images import load_image
from courier_emu.machine import CourierMachine
from courier_emu.nvram import CourierNvram
m = CourierMachine(load_image(sys.argv[1]), with_dsp=True, tick_ms=5,
                   board_id=7, nvram=CourierNvram.idsl302_fixture(),
                   serial_input=b"ATI7\r")
d = m.run(int(sys.argv[2])).to_dict()
print(json.dumps({k: d[k] for k in ('instructions','status','error','serial_text')}))
