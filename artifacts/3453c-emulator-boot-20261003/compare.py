"""Run the 3453C supervisor and save DSP state without copying hardware RAM into it."""
import json,sys,shutil,struct
from pathlib import Path
from courier_emu import worker
out=Path(__file__).resolve().parent
original=worker.CourierMachine
class ObservedMachine(original):
    def run(self,*args,**kwargs):
        core=self.dsp_bridge.core
        old_close=core.close
        def capture():
            if getattr(core,"_handle",None):
                self.capture(core)
            old_close()
        core.close=capture
        result=super().run(*args,**kwargs)
        report=json.loads((out/'idle-comparison.json').read_text())
        report['serial_text']=result.to_dict()['serial_text']
        (out/'idle-comparison.json').write_text(json.dumps(report,indent=2)+'\n')
        return result
    def capture(self,core):
        data=b''.join(core.data(i).to_bytes(2,'little') for i in range(0x100,0x400))
        (out/'emulator-idle-data-0100-03ff.bin').write_bytes(data)
        hardware=(out/'hardware-idle-data-0100-03ff.bin').read_bytes()
        different=[i+0x100 for i,(a,b) in enumerate(zip(struct.unpack('<768H',hardware),struct.unpack('<768H',data))) if a!=b]
        report={'pmst_hardware':'18B8','pmst_emulator':f'{core.register(7):04X}',
                'registers_emulator':{f'{i:02X}':f'{core.register(i):04X}' for i in [4,6,7,0x22,0x25,0x26,0x28,0x29,0x2a]},
                'words_compared':768,'matching_words':768-len(different),'differing_addresses':[f'{i:04X}' for i in different],
                'differences':[{'address':f'{i+256:04X}','hardware':f'{x:04X}','emulator':f'{y:04X}'} for i,(x,y) in enumerate(zip(struct.unpack('<768H',hardware),struct.unpack('<768H',data))) if x!=y],
                'dsp_state':core.state(),
                'monitor_note':'Hardware has the diagnostic DSP hook installed; snapshots are sequential live reads.'}
        (out/'idle-comparison.json').write_text(json.dumps(report,indent=2)+'\n')
worker.CourierMachine=ObservedMachine
params=out/'private-parameters.sav'
shutil.copyfile(out.parent/'3453c-parameter-sector-20261003/f8000-fbfff.bin',params)
sys.argv=['compare','2_3_33.XMF','--with-dsp','--daa-codec','--instructions','4000000','--board-id','0','--parameter-flash',str(params),'--serial-input-hex',b'AT\r'.hex()]
worker.main()
