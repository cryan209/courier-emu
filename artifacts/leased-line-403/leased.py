"""Sample the overlay id and gate cells on the board while &L1 is live.

AT&L1 sets [0x04f2]=1, which passes the CF gate at 0x8b8a1 and, in the
emulator, reaches 0x8bc06 (overlay id <- 6) and the loader at 0x8e60a. This
asks whether the board's [0x0d28] does the same.

Leased-line mode seizes the loop, so the window is kept short and the line is
always released with &L0 and ATH0.
"""
from pathlib import Path
from datetime import datetime, timezone
import json, os, select, struct, sys, time
from courier_emu.dsp_mailbox import MailboxPort, Session, _transact
from courier_emu.flash_dump import validate_identity

OUT = Path(sys.argv[1]); DEV = sys.argv[2]
OUT.mkdir(parents=True, exist_ok=True)
assert not (OUT / 'leased.json').exists(), "refusing to overwrite an existing capture"

CMDS = ['AT&L1', 'AT&L0', 'ATH0']
CELLS = {'0d28': 0x0D28, '04f2': 0x04F2, '04c6': 0x04C6, '04f8': 0x04F8,
         '057c': 0x057C, '098a': 0x098A, '049e': 0x049E, '0d92': 0x0D92}
PAGES = (0x0100, 0x0300, 0x0400, 0x0500, 0x0900, 0x0D00)
WINDOW = 20.0

class Leased(MailboxPort):
    def query(self, c, t=8.0):
        return _transact(self, c, t) if c in CMDS else super().query(c, t)

report = {'started_utc': datetime.now(timezone.utc).isoformat(), 'hardware_tested': True,
          'line_seized': True, 'device': DEV, 'samples': []}
with Leased(DEV, 115200, allow_ram=True) as port:
    s = Session(port); t0 = time.monotonic()

    def drain(quiet=0.3, cap=5.0):
        end, last = time.monotonic() + cap, time.monotonic()
        while time.monotonic() < end:
            if select.select([port.fd], [], [], 0.15)[0]:
                if os.read(port.fd, 4096):
                    last = time.monotonic()
            elif time.monotonic() - last > quiet:
                return

    def sample(label):
        drain()
        try:
            pg = {p: s.page(p) for p in PAGES}
        except ValueError:
            drain(0.8, 4)
            pg = {p: s.page(p) for p in PAGES}
        cells = {n: pg[a & 0xFF00][a & 0xFF] for n, a in CELLS.items()}
        h192 = struct.unpack_from('<H', pg[0x0100], 0x92)[0]
        h3ff = pg[0x0300][0xFF] | (pg[0x0400][0x00] << 8)
        row = {'label': label, 't': round(time.monotonic() - t0, 2), 'cells': cells,
               'h192': f'{h192:04x}', 'h3ff': f'{h3ff:04x}'}
        report['samples'].append(row)
        mark = '   <== OVERLAY ID' if cells['0d28'] else ''
        print(f"{row['t']:6.2f} {label:12s} " + ' '.join(f'{n}={v:02x}' for n, v in cells.items()) +
              f"  192={row['h192']} 3ff={row['h3ff']}{mark}", flush=True)

    armed = False
    try:
        s.command('AT')
        identity = s.command('ATI7'); _, target = validate_identity(identity)
        assert target == ('7.4.16', '3.1.2'), target
        report['identity'] = identity.decode('ascii')
        sample('before')
        port.query('AT&L1'); armed = True
        end = time.monotonic() + WINDOW
        n = 0
        while time.monotonic() < end:
            sample(f'&L1 live {n}'); n += 1
    finally:
        if armed:
            drain()
            for c in ('AT&L0', 'ATH0'):
                try:
                    port.query(c)
                except Exception as exc:
                    print(f'  {c} failed: {exc}', flush=True)
                drain(0.4, 4)
        try:
            s.command('AT'); report['responds_after'] = True
        except Exception:
            report['responds_after'] = False
        sample('restored')
        report['overlay_ever'] = any(r['cells']['0d28'] for r in report['samples'])
        print('\noverlay id ever non-zero:', report['overlay_ever'])
        (OUT / 'transcript.json').write_text(json.dumps(s.transcript, indent=2) + '\n')
        (OUT / 'leased.json').write_text(json.dumps(report, indent=2) + '\n')
