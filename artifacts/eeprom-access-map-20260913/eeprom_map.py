import sys, re, json, collections
from courier_emu.images import load_image
from courier_emu.machine import CourierMachine
from courier_emu.nvram import CourierNvram
img = sys.argv[1]; cmd = sys.argv[2].encode() + b"\r"; n = int(sys.argv[3])
nv = CourierNvram.idsl302_fixture()
m = CourierMachine(load_image(img), with_dsp=True, nvram=nv, serial_input=cmd)
m.run(n)
order, counts = [], collections.Counter()
for line in nv.trace:
    mm = re.match(r"(read|write|erase) (0x[0-9a-f]+)", line)
    if mm:
        a = int(mm.group(2), 16); counts[(mm.group(1), a)] += 1
        if a not in order: order.append(a)
print("trace entries:", len(nv.trace), "| reads:", nv.reads, "writes:", nv.writes)
print("distinct words touched:", len(order))
print("first-touch order:", " ".join(f"{a:#04x}" for a in order))
rd = sorted(a for (k, a) in counts if k == "read")
print("read words:", " ".join(f"{a:#04x}" for a in rd))
wr = sorted(a for (k, a) in counts if k == "write")
print("written words:", " ".join(f"{a:#04x}" for a in wr) or "(none)")
print("\nfirst 25 trace lines:")
for line in nv.trace[:25]: print("  ", line)
