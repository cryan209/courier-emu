"""Sample the datapump gate cells and state pointers through an &T1 analog loopback.

&T1 loops the modem's transmitter to its own receiver and trains, so it is a
complete datapump exercise with no far end and no line. Entry 19 of the
ampersand table is the &T router, whose AL=1 sets flag C [0x057c].

Always ends the test with &T0 and hangs up. Read-only apart from &T1/&T0.
"""
from pathlib import Path
from datetime import datetime, timezone
import json, os, select, struct, sys, time
from courier_emu.dsp_mailbox import MailboxPort, Session, _transact
from courier_emu.flash_dump import validate_identity

OUT = Path(sys.argv[1]); DEV = sys.argv[2]
OUT.mkdir(parents=True, exist_ok=True)
assert not (OUT / 'loopback.json').exists(), "refusing to overwrite an existing capture"

CMDS = ['AT&T1', 'AT&T0', 'ATH0']
CELLS = {'04c6': 0x04C6, '04f2': 0x04F2, '04f8': 0x04F8, '057c': 0x057C,
         '098a': 0x098A, '049e': 0x049E, '0d28': 0x0D28}
PAGES = (0x0100, 0x0300, 0x0400, 0x0500, 0x0900, 0x0D00)

class Loop(MailboxPort):
    def query(self, c, t=8.0):
        return _transact(self, c, t) if c in CMDS else super().query(c, t)

report = {'started_utc': datetime.now(timezone.utc).isoformat(), 'hardware_tested': True,
          'device': DEV, 'test': '&T1 analog loopback', 'samples': []}
with Loop(DEV, 115200, allow_ram=True) as port:
    s = Session(port)
    t0 = time.monotonic()

    def drain(quiet=0.5, cap=8.0):
        end, last = time.monotonic() + cap, time.monotonic()
        while time.monotonic() < end:
            if select.select([port.fd], [], [], 0.2)[0]:
                if os.read(port.fd, 4096):
                    last = time.monotonic()
            elif time.monotonic() - last > quiet:
                return

    def escape():
        time.sleep(1.2); os.write(port.fd, b'+++'); time.sleep(1.2); drain()

    def sample(label):
        drain()
        try:
            pg = {p: s.page(p) for p in PAGES}
        except ValueError:
            escape()
            pg = {p: s.page(p) for p in PAGES}
        cells = {n: pg[a & 0xFF00][a & 0xFF] for n, a in CELLS.items()}
        h192 = struct.unpack_from('<H', pg[0x0100], 0x92)[0]
        h3ff = pg[0x0300][0xFF] | (pg[0x0400][0x00] << 8)
        row = {'label': label, 't': round(time.monotonic() - t0, 2), 'cells': cells,
               'h192': f'{h192:04x}', 'h3ff': f'{h3ff:04x}'}
        report['samples'].append(row)
        flag = '  <== FLAG C SET' if cells['057c'] & 1 else ''
        ovl = '  <== OVERLAY ID' if cells['0d28'] else ''
        print(f"{row['t']:6.2f} {label:12s} " + ' '.join(f'{n}={v:02x}' for n, v in cells.items()) +
              f"  192={row['h192']} 3ff={row['h3ff']}{flag}{ovl}", flush=True)

    started = False
    try:
        s.command('AT')
        identity = s.command('ATI7'); _, target = validate_identity(identity)
        assert target == ('7.4.16', '3.1.2'), target
        report['identity'] = identity.decode('ascii')
        sample('before')
        raw = port.query('AT&T1'); started = True
        report['t1_response'] = raw.decode('ascii', 'replace').strip().replace('\r\n', ' | ')
        print('  AT&T1 ->', report['t1_response'], flush=True)
        end = time.monotonic() + 18
        n = 0
        while time.monotonic() < end:
            sample(f'loopback {n}'); n += 1
    finally:
        if started:
            drain()
            for c in ('AT&T0', 'ATH0'):
                try:
                    port.query(c)
                except Exception:
                    escape()
                    try: port.query(c)
                    except Exception as exc: print(f'{c} failed: {exc}', flush=True)
                drain(0.4, 4)
        try:
            s.command('AT'); report['responds_after'] = True
        except Exception:
            report['responds_after'] = False
        sample('after')
        report['flag_c_ever'] = any(r['cells']['057c'] & 1 for r in report['samples'])
        report['overlay_ever'] = any(r['cells']['0d28'] for r in report['samples'])
        print('\nflag C ever set:', report['flag_c_ever'],
              '| overlay id ever non-zero:', report['overlay_ever'])
        (OUT / 'transcript.json').write_text(json.dumps(s.transcript, indent=2) + '\n')
        (OUT / 'loopback.json').write_text(json.dumps(report, indent=2) + '\n')
