"""Read the 403 datapump-gate cells off the board. Read-only, command mode."""
from pathlib import Path
from datetime import datetime, timezone
import json, sys
from courier_emu.dsp_mailbox import MailboxPort, Session
from courier_emu.flash_dump import validate_identity

OUT = Path(sys.argv[1]); OUT.mkdir(parents=True, exist_ok=True)
assert not (OUT / 'cells.json').exists(), "refusing to overwrite an existing capture"

# docs/datapump-gate-403-addresses.md
CELLS = {
    '098a': 'flag A, discriminator tests & 2',
    '049e': 'flag B, discriminator tests & 1',
    '057c': 'flag C, discriminator tests & 1',
    '04c6': 'CF gate, tested & 0x40',
    '04f2': 'CF gate, compared to 1',
    '04f8': 'CF gate, compared to 0 then 3',
    '0d28': 'overlay id, gates the download',
}
PAGES = sorted({int(a, 16) & 0xFF00 for a in CELLS})

report = {'started_utc': datetime.now(timezone.utc).isoformat(),
          'hardware_tested': True, 'device': sys.argv[1 + 1], 'samples': []}
with MailboxPort(sys.argv[2], 115200, allow_ram=True) as port:
    s = Session(port)
    try:
        s.command('AT')
        identity = s.command('ATI7')
        _, target = validate_identity(identity)
        assert target == ('7.4.16', '3.1.2'), target
        report['identity'] = identity.decode('ascii')
        for label in ('as found', 'repeat'):
            pages = {p: s.page(p) for p in PAGES}
            sample = {'label': label,
                      'cells': {a: pages[int(a, 16) & 0xFF00][int(a, 16) & 0xFF]
                                for a in CELLS},
                      'page_sha': {f'{p:04x}': __import__('hashlib').sha256(pages[p]).hexdigest()
                                   for p in PAGES}}
            report['samples'].append(sample)
            print(label, {a: f'{v:02x}' for a, v in sample['cells'].items()}, flush=True)
        s.command('AT'); report['responds_after'] = True
    finally:
        (OUT / 'transcript.json').write_text(json.dumps(s.transcript, indent=2) + '\n')
        (OUT / 'cells.json').write_text(json.dumps(report, indent=2) + '\n')
