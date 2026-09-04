"""ATDT123 with the DTMF short-circuit disabled, to see if the firmware dials."""
import json, sys, collections
from pathlib import Path
from courier_emu.cli import load_image
from courier_emu.machine import CourierMachine
from courier_emu.daa import CourierDaa
from courier_emu.mailbox_tap import MailboxTap

IMAGE, COUNT = "main211.xmf", int(sys.argv[1]) if len(sys.argv) > 1 else 9_000_000
DISABLE = "--keep" not in sys.argv
OUT = Path(sys.argv[2]) if len(sys.argv) > 2 else None

machine = CourierMachine(load_image(IMAGE), with_dsp=True,
                         serial_input=b"ATDT123\r", daa=CourierDaa("dial-tone"))
bridge = machine.dsp_bridge
calls = []
core = bridge.core
real = core.set_dtmf_digits

def patched(digits, *a, **k):
    calls.append(digits)
    if DISABLE:
        return None            # short-circuit removed: firmware must dial itself
    return real(digits, *a, **k)

core.set_dtmf_digits = patched
tap = MailboxTap(bridge).attach()
result = machine.run(COUNT)
tap.flush(); tap.detach()

tags = {k: v["count"] for k, v in sorted(tap.tag_summary().items())}
tones = collections.Counter(m["audio"]["dtmf"] for m in tap.correlate() if m["audio"]["dtmf"])
print(f"short-circuit {'DISABLED' if DISABLE else 'kept'}")
print(f"  set_dtmf_digits calls intercepted: {len(calls)} {calls[:4]}")
print(f"  mailbox messages: {len(tap.messages)}   tags: {tags}")
print(f"  audio samples: {tap._next_sample}   detected tones: {dict(tones) or 'none'}")
print(f"  tags 0x20/0x21 present: {any(m.tag in (0x20,0x21) for m in tap.messages)}")
d = result.to_dict()
print(f"  serial_text: {d.get('serial_text','')!r}  status={d.get('status')} "
      f"instructions={d.get('instructions')}")
if OUT:
    OUT.mkdir(parents=True, exist_ok=True)
    tap.write_json(OUT / "mailbox.json"); (OUT / "report.txt").write_text(tap.report() + "\n")
    (OUT / "run.json").write_text(json.dumps(d, sort_keys=True, indent=2) + "\n")
