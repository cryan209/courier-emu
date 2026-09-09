"""Watch the supervisor's state pointers on the board through a real dial.

[0x0192] is the state handler invoked by `call word ptr [0x0192]`; [0x03ff] is
the second handler slot the installer family writes alongside it, and 0x1cde
there is the router that reaches the datapump-gate setters. Both hold offsets
into segment a4e2. Sampled continuously across an ATDT<n>; dial, which keeps
command mode with the line seized and attempts no handshake.

Read-only. Always releases the line.
"""
from pathlib import Path
from datetime import datetime, timezone
import json, struct, sys, time
from courier_emu.dsp_mailbox import MailboxPort, Session, _transact
from courier_emu.flash_dump import validate_identity

OUT = Path(sys.argv[1]); NUMBER = sys.argv[2]; DEV = sys.argv[3]
OUT.mkdir(parents=True, exist_ok=True)
assert not (OUT / 'trajectory.json').exists(), "refusing to overwrite an existing capture"
assert NUMBER.isdigit()
CS = 0xA4E20
DIAL = f'ATDT{NUMBER};'
GATE = {'098a': 0x098A, '049e': 0x049E, '057c': 0x057C,
        '04c6': 0x04C6, '04f2': 0x04F2, '04f8': 0x04F8, '0d28': 0x0D28}
PAGES = (0x0100, 0x0300, 0x0400, 0x0500, 0x0900, 0x0D00)

class DialPort(MailboxPort):
    def query(self, c, t=4.0):
        return _transact(self, c, t) if c in {DIAL, 'ATH0'} else super().query(c, t)

report = {'started_utc': datetime.now(timezone.utc).isoformat(), 'hardware_tested': True,
          'line_seized': True, 'device': DEV, 'number': NUMBER, 'samples': []}
with DialPort(DEV, 115200, allow_ram=True) as port:
    s = Session(port)
    t0 = time.monotonic()

    def sample(label):
        pg = {p: s.page(p) for p in PAGES}
        h192 = struct.unpack_from('<H', pg[0x0100], 0x92)[0]
        h3ff = pg[0x0300][0xFF] | (pg[0x0400][0x00] << 8)   # straddles the page break
        row = {'label': label, 't': round(time.monotonic() - t0, 2),
               'h192': f'{h192:04x}', 'h192_lin': f'{CS + h192:05x}',
               'h3ff': f'{h3ff:04x}', 'h3ff_lin': f'{CS + h3ff:05x}',
               'b403': f'{pg[0x0400][0x03]:02x}',
               'gate': {n: pg[a & 0xFF00][a & 0xFF] for n, a in GATE.items()}}
        report['samples'].append(row)
        mark = '  <== ROUTER' if h3ff == 0x1CDE else ''
        g = ''.join(f'{v:02x}' for v in row['gate'].values())
        print(f"{row['t']:6.2f} {label:14s} 192={row['h192']}->{row['h192_lin']} "
              f"3ff={row['h3ff']} 403={row['b403']} gate={g}{mark}", flush=True)
        return row

    dialled = False
    try:
        s.command('AT')
        identity = s.command('ATI7'); _, target = validate_identity(identity)
        assert target == ('7.4.16', '3.1.2'), target
        report['identity'] = identity.decode('ascii')
        for n in range(2):
            sample('idle')
        s.command(DIAL); dialled = True
        end = time.monotonic() + 20
        n = 0
        while time.monotonic() < end:
            sample(f'off-hook {n}'); n += 1
    finally:
        if dialled:
            try:
                s.command('ATH0'); report['released'] = True
            except Exception as exc:
                report['released'] = f'FAILED: {exc!r}'
                print('WARNING: ATH0 failed:', exc, flush=True)
        try:
            s.command('AT'); report['responds_after'] = True
        except Exception:
            report['responds_after'] = False
        sample('after release')
        seen = sorted({r['h192'] for r in report['samples']})
        report['distinct_h192'] = seen
        report['router_seen'] = any(r['h3ff'] == '1cde' for r in report['samples'])
        print('\ndistinct [0192]:', ' '.join(seen))
        print('router ever installed:', report['router_seen'])
        (OUT / 'transcript.json').write_text(json.dumps(s.transcript, indent=2) + '\n')
        (OUT / 'trajectory.json').write_text(json.dumps(report, indent=2) + '\n')
