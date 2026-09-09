"""Probe the '$' prefix the a4f40 parser special-cases, and AT$L1.

The dispatch at a4f63 indexes a6685 by command letter, and entry 11 ('L')
writes [0x04f2] - the CF gate cell that must be 1. Plain ATL does not reach
it. The parser handles 0x24 ('$') immediately before its A-Z range, so this
tests whether a '$' prefix does.

Read-only apart from the commands themselves. On-hook throughout, no dialling,
no &W, no flash access.
"""
from pathlib import Path
from datetime import datetime, timezone
import json, struct, sys
from courier_emu.dsp_mailbox import MailboxPort, Session, _transact
from courier_emu.flash_dump import validate_identity

OUT = Path(sys.argv[1]); DEV = sys.argv[2]
OUT.mkdir(parents=True, exist_ok=True)
assert not (OUT / 'dollar.json').exists(), "refusing to overwrite an existing capture"

PROBES = ['AT$', 'AT$L1', 'AT$T1', 'AT$N0']
CELLS = {'04c6': 0x04C6, '04f2': 0x04F2, '04f8': 0x04F8, '057c': 0x057C,
         '098a': 0x098A, '049e': 0x049E, '0d28': 0x0D28, '0568': 0x0568}

class Probe(MailboxPort):
    def query(self, c, t=6.0):
        return _transact(self, c, t) if c in PROBES else super().query(c, t)

report = {'started_utc': datetime.now(timezone.utc).isoformat(), 'hardware_tested': True,
          'off_hook': False, 'device': DEV, 'steps': []}
with Probe(DEV, 115200, allow_ram=True) as port:
    s = Session(port)

    def read():
        pg = {p: s.page(p) for p in (0x0100, 0x0300, 0x0400, 0x0500, 0x0900, 0x0D00)}
        h3ff = pg[0x0300][0xFF] | (pg[0x0400][0x00] << 8)
        return ({n: pg[a & 0xFF00][a & 0xFF] for n, a in CELLS.items()},
                struct.unpack_from('<H', pg[0x0100], 0x92)[0], h3ff)

    def show(label, response=None):
        cells, h192, h3ff = read()
        gate = (cells['04c6'] & 0x40) == 0 and cells['04f2'] == 1 and \
               (cells['04f8'] == 0 or cells['04f8'] > 3)
        report['steps'].append({'label': label, 'response': response,
                                'cells': cells, 'h192': f'{h192:04x}',
                                'h3ff': f'{h3ff:04x}', 'cf_gate': gate})
        print(f"{label:8s} " + ' '.join(f'{n}={v:02x}' for n, v in cells.items()) +
              f"  192={h192:04x} 3ff={h3ff:04x}  CF gate {'PASSES' if gate else 'fails'}",
              flush=True)

    try:
        s.command('AT')
        identity = s.command('ATI7'); _, target = validate_identity(identity)
        assert target == ('7.4.16', '3.1.2'), target
        report['identity'] = identity.decode('ascii')
        show('before')
        for cmd in PROBES:
            raw = port.query(cmd)
            text = raw.decode('ascii', 'replace').strip().replace('\r\n', ' | ')
            s.transcript.append({'cmd': cmd, 'raw': text})
            print(f'  {cmd} -> {text[:110]}', flush=True)
            show(cmd, text)
        s.command('AT'); report['responds_after'] = True
    finally:
        (OUT / 'transcript.json').write_text(json.dumps(s.transcript, indent=2) + '\n')
        (OUT / 'dollar.json').write_text(json.dumps(report, indent=2) + '\n')
