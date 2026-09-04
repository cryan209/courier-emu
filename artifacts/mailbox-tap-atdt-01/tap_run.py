"""ATDT123 on the 403 capture with the mailbox tap attached."""
import json, sys, time
from pathlib import Path
from courier_emu.cli import load_image
from courier_emu.machine import CourierMachine
from courier_emu.daa import CourierDaa
from courier_emu.mailbox_tap import MailboxTap

IMAGE = sys.argv[1] if len(sys.argv) > 1 else "main211.xmf"
COUNT = int(sys.argv[2]) if len(sys.argv) > 2 else 9_000_000
OUT   = Path(sys.argv[3]) if len(sys.argv) > 3 else Path("artifacts/mailbox-tap-atdt-01")

machine = CourierMachine(
    load_image(IMAGE),
    with_dsp=True,
    serial_input=(sys.argv[4].encode()+b"\r") if len(sys.argv)>4 else b"ATDT123\r",
    daa=CourierDaa("dial-tone"),
)
bridge = getattr(machine, "dsp_bridge", None)
print("dsp_bridge:", type(bridge).__name__ if bridge else None, flush=True)
if bridge is None:
    raise SystemExit("no dsp_bridge on the machine; cannot tap")

tap = MailboxTap(bridge).attach()
start = time.time()
result = machine.run(COUNT)
tap.flush(); tap.detach()
elapsed = time.time() - start

OUT.mkdir(parents=True, exist_ok=True)
summary = result.to_dict() if hasattr(result, "to_dict") else {}
(OUT / "run.json").write_text(json.dumps(summary, sort_keys=True, indent=2) + "\n")
tap.write_json(OUT / "mailbox.json")
(OUT / "report.txt").write_text(tap.report() + "\n")
print(f"\n{elapsed:.1f}s, {COUNT} instructions -> {OUT}")
print(tap.report())
