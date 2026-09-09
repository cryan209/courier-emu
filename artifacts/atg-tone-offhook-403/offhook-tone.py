"""Arm the DTMF tone through the eight-digit ATG form with the line seized.

On-hook query 62 sits at a clamp value and cannot see the transmitter. Off
hook on a connected line the hybrid returns transmit into the receive path,
so query 62 becomes a usable detector - provided dial tone does not already
saturate it, which the off-hook baseline below establishes either way.

Seizes the line with ATH1 and always releases it with ATH0. No dialling, no
write, no flash access. The off-hook window is a few seconds.
"""
from pathlib import Path
from datetime import datetime, timezone
import json, sys, time
from courier_emu.dsp_mailbox import MailboxPort, Session, _transact
from courier_emu.flash_dump import validate_identity

OUT = Path(sys.argv[1]); OUT.mkdir(parents=True, exist_ok=True)
assert not (OUT / 'tone.json').exists(), "refusing to overwrite an existing capture"

ARM = ['ATG001A32C8', 'ATG001B0C08', 'ATG00130006']
STOP, ENERGY, MARK = 'ATG00160000', 'ATG00620000', 'ATG00070000'
HOOK = {'ATH1', 'ATH0'}
ALLOWED = set(ARM) | {STOP, ENERGY, MARK} | HOOK


class TonePort(MailboxPort):
    def query(self, command, timeout=4.0):
        if command in ALLOWED:
            return _transact(self, command, timeout)
        return super().query(command, timeout)


report = {'started_utc': datetime.now(timezone.utc).isoformat(),
          'hardware_tested': True, 'line_seized': True,
          'device': sys.argv[2], 'steps': []}
with TonePort(sys.argv[2], 115200, allow_ram=True) as port:
    s = Session(port)

    def reply():
        lo, hi = s.read_port(0x58), s.read_port(0x5A)
        dlo, dhi = s.read_port(0x5C), s.read_port(0x5E)
        return f'{(hi << 8) | lo:04x}:{(dhi << 8) | dlo:04x}'

    def energy(label):
        s.command(MARK)
        held = reply()
        s.command(ENERGY)
        step = {'label': label, 'after_mark': held, 'reply': reply()}
        report['steps'].append(step)
        print(f"{label:22s} mark={held} 62={step['reply']}", flush=True)

    off_hook = False
    try:
        s.command('AT')
        identity = s.command('ATI7')
        _, target = validate_identity(identity)
        assert target == ('7.4.16', '3.1.2'), target
        report['identity'] = identity.decode('ascii')

        energy('on-hook baseline')
        s.command('ATH1'); off_hook = True
        time.sleep(0.5)
        for n in range(3):
            energy(f'off-hook dial tone {n}')
        for command in ARM:
            s.command(command)
            print(f'sent {command}', flush=True)
        for n in range(4):
            energy(f'off-hook armed {n}')
            time.sleep(0.2)
        s.command(STOP)
        energy('off-hook after stop')
    finally:
        if off_hook:
            try:
                s.command('ATH0'); report['released'] = True
            except Exception as exc:      # the line must not be left seized
                report['released'] = f'FAILED: {exc!r}'
                print('WARNING: ATH0 failed:', exc, flush=True)
        try:
            s.command('AT'); report['responds_after'] = True
        except Exception:
            report['responds_after'] = False
        (OUT / 'transcript.json').write_text(json.dumps(s.transcript, indent=2) + '\n')
        (OUT / 'tone.json').write_text(json.dumps(report, indent=2) + '\n')
