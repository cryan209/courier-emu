"""Time-resolved read of the host RAM pages that moved between the two live
passes, to fit a rate to every 16-bit cell in them. Read-only: the `=` page
selector is the same gate the RAM captures used. No port writes, no mailbox."""
import json, struct, sys, time
from courier_emu.dsp_mailbox import MailboxPort, Session

PAGES = (0x000, 0x100, 0x300, 0x400, 0xD00)
SWEEPS = 14

with MailboxPort('/dev/cu.usbserial-21210', 115200, allow_ram=True) as port:
    port.drain()
    s = Session(port)
    s.command('AT')
    samples = []
    t0 = time.monotonic()
    for _ in range(SWEEPS):
        sweep = {}
        for base in PAGES:
            sweep[base] = (time.monotonic() - t0, s.page(base))
        samples.append(sweep)
    s.command('AT')

def unwrap(seq):
    out, add = [], 0
    for i, v in enumerate(seq):
        if i and v + add < out[-1] - 32768:
            add += 65536
        out.append(v + add)
    return out

rows = []
for base in PAGES:
    for off in range(0, 256, 2):
        ts  = [sw[base][0] for sw in samples]
        val = [struct.unpack_from('<H', sw[base][1], off)[0] for sw in samples]
        if len(set(val)) == 1:
            continue
        u = unwrap(val)
        span = ts[-1] - ts[0]
        rate = (u[-1] - u[0]) / span if span else 0.0
        # monotone in the unwrapped series?
        mono = all(b >= a for a, b in zip(u, u[1:]))
        rows.append({'address': base + off, 'rate_hz': round(rate, 2),
                     'monotone': mono, 'distinct': len(set(val)),
                     'first': val[0], 'last': val[-1]})
rows.sort(key=lambda r: -abs(r['rate_hz']))
print(json.dumps({'sweeps': SWEEPS,
                  'span_s': round(samples[-1][PAGES[-1]][0] - samples[0][PAGES[0]][0], 2),
                  'moving_cells': len(rows), 'cells': rows}, indent=1))
