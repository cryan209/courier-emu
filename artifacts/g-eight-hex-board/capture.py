"""Capture known read-only DSP queries through the eight-digit G form."""
from pathlib import Path
from datetime import datetime, timezone
import json
import sys
from courier_emu.dsp_mailbox import MailboxPort, Session, _transact
from courier_emu.flash_dump import validate_identity, parse_page

OUT=Path(sys.argv[1]);OUT.mkdir(parents=True,exist_ok=True)
assert not (OUT/'transcript.json').exists()
ALLOWED={'ATG00620000','ATG00070000','ATG002D0000','ATG0007A55A'}
class QueryPort(MailboxPort):
    def query(self,command,timeout=4.0):
        if command in ALLOWED:return _transact(self,command,timeout)
        return super().query(command,timeout)
report={'started_utc':datetime.now(timezone.utc).isoformat(),'hardware_tested':True,'device':sys.argv[2],'steps':[]}
with QueryPort(sys.argv[2],115200,allow_ram=True) as port:
    s=Session(port)
    try:
        s.command('AT')
        identity=s.command('ATI7');_,target=validate_identity(identity)
        assert target==('7.4.16','3.1.2'),target
        report['identity']=identity.decode('ascii')
        def snapshot():
            raw=s.command('ATGLK2=0000:0100')
            ram=parse_page(raw,0x100,allow_ram=True)[0]
            return {'queue_tail':int.from_bytes(ram[0x94:0x96],'little'),
                    'queue_head':int.from_bytes(ram[0x96:0x98],'little'),
                    'queue_hex':ram[0x98:0xc8].hex(),
                    'ports':s.ports((0x1c,0x1e,0x58,0x5a,0x5c,0x5e))}
        report['before']=snapshot()
        for command in ('ATG00620000','ATG00070000','ATG002D0000','ATG00620000','ATG0007A55A'):
            raw=s.command(command)
            observed=snapshot()
            report['steps'].append({'command':command,'response':raw.decode('ascii'),**observed})
            print(json.dumps(report['steps'][-1]),flush=True)
        s.command('AT');report['responds_after']=True
    finally:
        (OUT/'transcript.json').write_text(json.dumps(s.transcript,indent=2)+'\n')
        (OUT/'hardware.json').write_text(json.dumps(report,indent=2)+'\n')
