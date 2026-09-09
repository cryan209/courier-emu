import re, sys; sys.path.insert(0,'tools')
from c5x_disasm import decode
from courier_emu.mailbox_compare import program
from courier_emu.rom import CourierRom
w = program(CourierRom.load('artifacts/courier-board-21210-capture-403/courier-board.rom'))
TABLE, REPLY = 0x83E9, {0x83b1, 0x83a6}
TX = {0x0390:'work ptr',0x0392:'gain',0x039a:'callback',0x03c0:'phaseA',0x03c1:'phaseB',
      0x03c7:'MIXER ACC',0x03f1:'ampsrc',0x03f2:'incA',0x03f3:'ampA',0x03f4:'incB',0x03f5:'ampB'}
TX.update({a:f'TXBUF{a:03x}' for a in range(0x0bc0,0x0be0)})

def body(entry, budget=200):
    out, stack, seen = [], [(entry,0)], set()
    while stack:
        pc, dp = stack.pop()
        for _ in range(budget):
            if pc in seen or not 0x8100 <= pc < 0x10000: break
            seen.add(pc)
            try: ins = decode(w, pc)
            except Exception: break
            m = re.match(r'ldp\s+#([0-9a-f]+)', ins.text)
            if m: dp = int(m[1],16)
            out.append((pc,dp,ins))
            if ins.flow=='call' and ins.target and ins.target not in REPLY and 0x8100<=ins.target<0x10000:
                stack.append((ins.target,dp))
            if ins.flow=='return': break
            pc += ins.size
    return out

def cell(dp, ins):
    m = re.search(r'@([0-9a-f]{2})\b', ins.text)
    return dp*128 + int(m[1],16) if m else None

for tag in range(0x80):
    h = w[TABLE+tag]
    if not 0x8000 <= h < 0x10000: continue
    b = body(h)
    sites = [k for k,(pc,dp,i) in enumerate(b) if i.target in REPLY]
    if not sites: continue
    srcs=[]
    for k in sites:
        for pc,dp,i in b[k+1:k+3]:            # the delay slots carry the value
            c = cell(dp,i)
            srcs.append((TX.get(c) or (f'{c:04x}' if c is not None else i.text.split()[-1]), i.text))
    tx = [s for s,_ in srcs if not re.fullmatch(r'[0-9a-f]{4}|#.*', s)]
    flag = '   <== TRANSMIT-SIDE' if any(s in TX.values() for s,_ in srcs) else ''
    print(f'tag {tag:02x} -> {h:04x}  replies with: ' + ', '.join(s for s,_ in srcs[:6]) + flag)
