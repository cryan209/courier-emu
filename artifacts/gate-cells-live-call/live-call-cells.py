"""Read the 403 datapump-gate cells while a call is up.

Idle they are all zero (docs/datapump-gate-403-addresses.md). The open
question is whether call setup sets them. Two modes:

  voice  ATDT<number>;  - dials and returns to command mode still off hook,
         so the cells can be read during dialling and ringing. No data
         handshake is attempted, so this may never exercise the gate.
  data   ATDT<number>   - a full data call. Waits for CONNECT, escapes with
         +++ to command mode with the call still up, reads, then hangs up.
         This is the mode that actually runs the datapump.

Always releases the line. Bounded off-hook time, no retries, read-only.
"""
from pathlib import Path
from datetime import datetime, timezone
import json, os, select, sys, time
from courier_emu.dsp_mailbox import MailboxPort, Session, _transact
from courier_emu.flash_dump import validate_identity

OUT = Path(sys.argv[1]); MODE = sys.argv[2]; NUMBER = sys.argv[3]; DEV = sys.argv[4]
OUT.mkdir(parents=True, exist_ok=True)
assert MODE in ('voice', 'data', 'attempt')
assert not (OUT / 'cells.json').exists(), "refusing to overwrite an existing capture"
assert NUMBER.replace('-', '').isdigit(), "digits only"

CELLS = {'098a': 'flag A &2', '049e': 'flag B &1', '057c': 'flag C &1',
         '04c6': 'CF gate &0x40', '04f2': 'CF gate ==1', '04f8': 'CF gate ==0/3',
         '0d28': 'overlay id'}
PAGES = sorted({int(a, 16) & 0xFF00 for a in CELLS})
DIAL = f'ATDT{NUMBER};' if MODE == 'voice' else f'ATDT{NUMBER}'
RESULTS = (b'CONNECT', b'NO CARRIER', b'BUSY', b'NO ANSWER', b'NO DIALTONE', b'ERROR')
MAX_OFF_HOOK = 90.0


class _Done(Exception):
    """Sampling finished; fall through to the release in `finally`."""

class CallPort(MailboxPort):
    def query(self, c, t=4.0):
        return _transact(self, c, t) if c in {DIAL, 'ATH0', 'ATO'} else super().query(c, t)

report = {'started_utc': datetime.now(timezone.utc).isoformat(), 'hardware_tested': True,
          'mode': MODE, 'line_seized': True, 'device': DEV, 'samples': [], 'events': []}

with CallPort(DEV, 115200, allow_ram=True) as port:
    s = Session(port)
    started = None

    def drain(settle=0.25):
        """Read until the line has been quiet for `settle`.

        A result code arriving mid-read desyncs the next page parse, so this
        must wait for silence rather than only for what has already landed."""
        while True:
            if not select.select([port.fd], [], [], settle)[0]:
                return
            if not os.read(port.fd, 4096):
                return

    def sample(label):
        drain()
        try:
            pages = {p: s.page(p) for p in PAGES}
        except ValueError:                      # a straggling result code
            drain(0.6)
            pages = {p: s.page(p) for p in PAGES}
        row = {'label': label, 'elapsed': round(time.monotonic() - started, 1) if started else None,
               'cells': {a: pages[int(a, 16) & 0xFF00][int(a, 16) & 0xFF] for a in CELLS}}
        report['samples'].append(row)
        print(f"{label:24s} " + ' '.join(f'{a}={v:02x}' for a, v in row['cells'].items()), flush=True)
        return row

    def raw(text, wait, expect):
        """Write bare text and read until one of `expect` appears."""
        os.write(port.fd, text.encode('ascii'))
        end, buf = time.monotonic() + wait, bytearray()
        while time.monotonic() < end:
            if select.select([port.fd], [], [], 0.3)[0]:
                buf.extend(os.read(port.fd, 4096))
                if any(e in buf for e in expect):
                    break
        got = bytes(buf).decode('ascii', 'replace').strip().replace('\r\n', ' | ')
        report['events'].append({'sent': text.strip(), 'got': got})
        print(f'  <{text.strip()!r} -> {got}>', flush=True)
        return bytes(buf)

    dialled = False
    try:
        s.command('AT')
        identity = s.command('ATI7'); _, target = validate_identity(identity)
        assert target == ('7.4.16', '3.1.2'), target
        report['identity'] = identity.decode('ascii')
        sample('idle, on-hook')

        started = time.monotonic(); dialled = True
        if MODE == 'voice':
            s.command(DIAL)                     # returns OK, stays off hook
            for n in range(6):
                sample(f'off-hook ringing {n}')
                time.sleep(1.0)
        elif MODE == 'data':
            got = raw(DIAL + '\r', 60, RESULTS)
            report['connected'] = b'CONNECT' in got
            assert report['connected'], 'call did not connect; nothing to sample'
            time.sleep(1.2); raw('+++', 3, (b'OK',)); time.sleep(1.2)
            for n in range(6):
                sample(f'connected {n}')
                time.sleep(1.0)
        else:
            # A real handshake attempt. We cannot read during it, so try the
            # escape mid-handshake first - if the firmware honours it we get
            # command mode with the datapump running, which is the whole
            # question. Otherwise wait for the result code and sample straight
            # after it, in case the flags survive the failure.
            os.write(port.fd, (DIAL + '\r').encode('ascii'))
            report['events'].append({'sent': DIAL, 'got': '<not awaited>'})
            # Wait for a result code. Only if none arrives within 25 s is the
            # modem still handshaking, which is when the escape is worth trying.
            end, buf = time.monotonic() + 25, bytearray()
            while time.monotonic() < end and not any(r in buf for r in RESULTS):
                if select.select([port.fd], [], [], 0.3)[0]:
                    buf.extend(os.read(port.fd, 4096))
            early = bytes(buf).decode('ascii', 'replace').strip().replace('\r\n', ' | ')
            report['events'].append({'sent': '<wait 25s>', 'got': early})
            print('  during:', early or '<silence>', flush=True)
            if any(r in buf for r in RESULTS):
                # The call ended on its own. Sample straight away, in case the
                # flags survive the failure path.
                report['result_code'] = early
                report['escaped_mid_handshake'] = False
                for n in range(8):
                    sample(f'post-result {n}')
                raise _Done
            got = raw('+++', 4, (b'OK',) + RESULTS)
            report['escaped_mid_handshake'] = b'OK' in got and not any(r in got for r in RESULTS)
            if report['escaped_mid_handshake']:
                print('  ESCAPED MID-HANDSHAKE', flush=True)
                for n in range(6):
                    sample(f'mid-handshake {n}')
                    time.sleep(0.5)
            else:
                end = time.monotonic() + 75
                buf = bytearray(got)
                while time.monotonic() < end and not any(r in buf for r in RESULTS):
                    if select.select([port.fd], [], [], 0.3)[0]:
                        buf.extend(os.read(port.fd, 4096))
                report.setdefault('result_code', bytes(buf).decode('ascii', 'replace').strip().replace('\r\n', ' | '))
                print('  result:', report['result_code'], flush=True)
                for n in range(8):
                    sample(f'post-escape {n}')
    except _Done:
        pass
    finally:
        if dialled:
            try:
                s.command('ATH0'); report['released'] = True
            except Exception as exc:
                report['released'] = f'FAILED: {exc!r}'
                print('WARNING: ATH0 failed:', exc, flush=True)
            report['off_hook_seconds'] = round(time.monotonic() - started, 1)
        try:
            s.command('AT'); report['responds_after'] = True
        except Exception:
            report['responds_after'] = False
        sample('after release')
        (OUT / 'transcript.json').write_text(json.dumps(s.transcript, indent=2) + '\n')
        (OUT / 'cells.json').write_text(json.dumps(report, indent=2) + '\n')
