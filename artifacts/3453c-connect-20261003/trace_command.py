"""Trace a 3453C AT command using disposable copies of the captured parameters."""
import argparse
import json
from pathlib import Path
import shutil
from tempfile import TemporaryDirectory

from courier_emu.machine import CourierMachine
from courier_emu.xmf import XmfImage
from courier_emu.codec import CodecBringUp, SiliconDaa
from courier_emu.daa import CourierDaa
from courier_emu.flash import ParameterFlash

p = argparse.ArgumentParser()
p.add_argument('command')
p.add_argument('--output', type=Path, required=True)
p.add_argument('--instructions', type=int, default=2_500_000)
a = p.parse_args()
with TemporaryDirectory() as tmp:
    params = Path(tmp) / 'parameters.bin'
    shutil.copyfile('artifacts/3453c-parameter-sector-20261003/f8000-fbfff.bin', params)
    m = CourierMachine(XmfImage.load('2_3_33.XMF'), with_dsp=True, board_id=0,
        tick_ms=5, serial_input=(a.command+'\r').encode(),
        daa=CourierDaa('disconnected'), codec=CodecBringUp(SiliconDaa(1, revision=19)),
        parameter_flash=ParameterFlash.load(params),
        pc_watch={v:hex(v) for v in [0x816a5,0x816c9,0x816cf,0x816d3,0x816d5,
            0x816e1,0x81cc3,0x81cd0,0x81cd5,0x81d55,0x81d6f,0x81d71,
            0x81ca1,0x62d98,0x62ee1,0x59ff6,0x813e6,0x8142e]})
    r = m.run(a.instructions).to_dict()
    a.output.write_text(json.dumps(r, indent=2)+'\n')
    print(repr(r['serial_text']))
    for row in r['pc_watch']:
        print(row['pc'],row['ax'],row['bx'],row['cx'],row['si'],row['flags'])
