import time, serial, re, json
s = serial.Serial("/dev/cu.usbserial-1420", 57600, timeout=2.0)
time.sleep(0.2); s.reset_input_buffer()
def cmd(l, t=2.0):
    s.timeout=t; s.write((l+"\r").encode()); return s.read_until(b"\r\nOK\r\n").decode("latin1")
def read(a):
    r = cmd(f"ATGLK2={a & ~0xFF:04X}")
    for l in r.splitlines():
        t = l.strip()
        if t.startswith(f"0000:{a & ~0x0F:04X}"):
            return t.split()[1 + (a & 0x0F)]
    return "??"
addrs = [0x1600,0x1800,0x1A00,0x1C00,0x1E00,0x2100,0x2200,0x2400,0x2800,0x2B00,
         0x2C00,0x2E00,0x3000,0x3A00,0x4000,0x5000,0x6000,0x7000,0x7D00,
         0x8000,0x9000,0xA000,0xB000,0xC000,0xD000,0xE000,0xF000]
for a in addrs: cmd(f"ATGLK2W{a:04X},5A")
before = {a: read(a) for a in addrs}
print("markers placed:", sum(1 for v in before.values() if v == "5A"), "/", len(addrs))

s.timeout = 1.0
s.write(b"ATDT9099\r")
t0 = time.time(); log = ""
result = None
while time.time() - t0 < 60:
    c = s.read(4096).decode("latin1")
    if c:
        log += c
        for code in ("CONNECT", "NO CARRIER", "BUSY", "NO DIALTONE", "NO ANSWER", "ERROR", "RING"):
            if code in log:
                result = code; break
    if result: break
print(f"dial result after {time.time()-t0:.1f}s: {result!r}")
print("raw:", repr(log[-200:]))

if result == "CONNECT":
    print("connected - holding 8s then escaping")
    time.sleep(8)
    time.sleep(1.2); s.write(b"+++"); time.sleep(1.2)
    print("escape:", repr(s.read(200).decode("latin1")))
s.timeout = 2.0
h = cmd("ATH0")
print("hangup:", repr(h[-40:]))
time.sleep(1.0); s.reset_input_buffer()
print("AT:", "OK" in cmd("AT"))

after = {a: read(a) for a in addrs}
print(f"\n{'addr':>8}  after  verdict")
survived, cleared, changed = [], [], []
for a in addrs:
    v = after[a]
    if v == "5A": survived.append(a)
    elif v == "00": cleared.append(a)
    else: changed.append((a, v))
    print(f"{a:#08x}  {v:>4}   {'SURVIVED' if v=='5A' else ('cleared' if v=='00' else 'changed')}")
print("\nsurvived:", [hex(a) for a in survived])
print("cleared: ", [hex(a) for a in cleared])
print("changed: ", [(hex(a), v) for a, v in changed])
