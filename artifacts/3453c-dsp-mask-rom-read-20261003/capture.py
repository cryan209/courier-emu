"""Read a small mapped/unmapped sample, then optionally repeated ROM windows."""
from pathlib import Path
import json,runpy,sys
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT))
from courier_emu.xmodem_sdl import Port
host=runpy.run_path(str(ROOT/'tools/3453c_monitor.py'))
out=Path(__file__).resolve().parent
full='--full' in sys.argv
with Port('/dev/cu.usbserial-FT4TQOFT',19200) as port:
    m=host['Monitor'](port);before=m.request(0x8c)
    assert before&8, 'Expected initial external mapping'
    if not full:
        host['dump_range'](m,'program',0,31,out/'external-sample-0000-001f.bin',fast=True)
        host['dump_range'](m,'rom',0,31,out/'mapped-sample-0000-001f.bin',fast=True)
        external=(out/'external-sample-0000-001f.bin').read_bytes()
        mapped=(out/'mapped-sample-0000-001f.bin').read_bytes()
        report={'pmst_before':f'{before:04X}','different':external!=mapped,
                'external_hex':external.hex(),'mapped_hex':mapped.hex()}
        target=out/'sample-verification.json'
    else:
        reports=[]
        for index in (1,2):
            reports.append(host['dump_range'](m,'rom',0,0x1fff,out/f'mapped-window-0000-1fff-read{index}.bin',fast=True))
        report={'pmst_before':f'{before:04X}','captures':reports,
                'identical_repeated_windows':(out/'mapped-window-0000-1fff-read1.bin').read_bytes()==(out/'mapped-window-0000-1fff-read2.bin').read_bytes()}
        target=out/'window-verification.json'
    after=m.request(0x8c);assert after==before,'DSP mapping changed after capture'
    assert m.request(0x88)==0xd541
    report.update(pmst_after=f'{after:04X}',pmst_restored=True,post_capture_identification='D541')
    target.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))
