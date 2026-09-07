from pathlib import Path
import json,sys
from unittest.mock import patch
from courier_emu.dsp_probe import RomProbe,ORIGIN,ROM_DUMP_BUFFER,ROM_DUMP_TAG_BASE
from courier_emu.probe_transport import build_diagnostic,TransportMachine
out=Path(sys.argv[1]);out.mkdir(parents=True,exist_ok=False)
w=[0xBE41,0xBC00,0x5D07,0x0030,0xBF0A,ROM_DUMP_BUFFER,0x8B8A]
labels=[]
def capture(label,code):
 w.extend(code);w.extend([0x8B8A,0x90A0]);labels.append(label)
def sentinels():
 w.extend([0xBF80,0xEEEE,0x8819,0xBF80,0xDDDD,0x8818])
capture('run_marker',[0xBF80,0x9203])
for value in (None,0x0200,0x0300,0):
 if value is not None:w.extend([0xBF80,value,0x8857])
 capture(f'pa7.after_{value}',[0x0857])
for ndx in (0,1):
 w.extend([0x5E07,0xFFFB] if not ndx else [0x5D07,4])
 for name,code in [('other_lar',[0xBF09,0x4567]),('ar0_increment',[0xBF08,0x1234,0x8B88,0x8BA0]),('ar0_decrement',[0xBF08,0x1234,0x8B88,0x8B90])]:
  sentinels();w.extend(code)
  for reg,op in [('arcr',0x0819),('indx',0x0818),('ar0',0x0810)]:capture(f'ndx{ndx}.{name}.{reg}',[op])
w.extend([0xAE7C,ROM_DUMP_TAG_BASE,0xBF09,ROM_DUMP_BUFFER])
poll=ORIGIN+len(w)
w.extend([0xBF0A,0xFF57,0x8B8A,0x1080,0x0880,0x8B89,0x907D,0x4E7D,0xE200,poll,0x0C7C,0x005E,0x0CA0,0x005F,0xB902,0x8857,0x697C,0xB801,0x907C,0xBFA0,ROM_DUMP_TAG_BASE+len(labels),0xE308,poll])
halt=ORIGIN+len(w);w.extend([0x7980,halt])
while len(w)%8:w.append(0x8B00)
probe=RomProbe(tuple(w),ORIGIN+ROM_DUMP_BUFFER,halt)
with patch('courier_emu.probe_transport.build_port_fold_probe',return_value=probe):
 d=build_diagnostic(Path('IDSDL302.ROM'),port_fold=True,fold_samples=len(labels))
(out/'diagnostic-ram.bin').write_bytes(d.ram);(out/'probe-c5x.bin').write_bytes(probe.payload)
(out/'labels.json').write_text(json.dumps(labels,indent=2))
r=TransportMachine(d).run();(out/'emulator.json').write_text(json.dumps(r,indent=2));print(r['serial_text']);print(len(d.ram),len(labels))
