"""Arm the DTMF tone by hand over the eight-digit ATG form, on-hook.

Sends the dial block's own three tags - 1a gain, 1b second amplitude,
13 digit - then reads the sample-energy query 62 across the window, then
restores the idle callback with tag 16. No hook change, no line seizure,
no write, no flash access.
"""
from pathlib import Path
from datetime import datetime, timezone
import json, sys, time
from courier_emu.dsp_mailbox import MailboxPort, Session, _transact
from courier_emu.flash_dump import validate_identity

OUT = Path(sys.argv[1]); OUT.mkdir(parents=True, exist_ok=True)
assert not (OUT / 'tone.json').exists(), "refusing to overwrite an existing capture"

ARM = ['ATG001A32C8', 'ATG001B0C08', 'ATG00130006']
STOP = 'ATG00160000'
ENERGY = 'ATG00620000'
ALLOWED = set(ARM) | {STOP, ENERGY}


class TonePort(MailboxPort):
    def query(self, command, timeout=4.0):
        if command in ALLOWED:
            return _transact(self, command, timeout)
        return super().query(command, timeout)


def reply(s):
    """The held reply tag:data, from the four byte registers."""
    lo, hi = s.read_port(0x58), s.read_port(0x5A)
    dlo, dhi = s.read_port(0x5C), s.read_port(0x5E)
    return f'{(hi << 8) | lo:04x}:{(dhi << 8) | dlo:04x}'


report = {'started_utc': datetime.now(timezone.utc).isoformat(),
          'hardware_tested': True, 'off_hook': False,
          'device': sys.argv[2], 'steps': []}
with TonePort(sys.argv[2], 115200, allow_ram=True) as port:
    s = Session(port)
    try:
        s.command('AT')
        identity = s.command('ATI7')
        _, target = validate_identity(identity)
        assert target == ('7.4.16', '3.1.2'), target
        report['identity'] = identity.decode('ascii')

        def energy(label):
            s.command(ENERGY)
            step = {'label': label, 'reply': reply(s)}
            report['steps'].append(step)
            print(label, step['reply'], flush=True)

        energy('baseline')
        energy('baseline repeat')
        for command in ARM:
            s.command(command)
            report['steps'].append({'label': f'sent {command}', 'reply': reply(s)})
            print(f'sent {command}', report['steps'][-1]['reply'], flush=True)
        for n in range(4):
            energy(f'armed {n}')
            time.sleep(0.2)
        s.command(STOP)
        energy('after stop')
        s.command('AT'); report['responds_after'] = True
    finally:
        (OUT / 'transcript.json').write_text(json.dumps(s.transcript, indent=2) + '\n')
        (OUT / 'tone.json').write_text(json.dumps(report, indent=2) + '\n')
