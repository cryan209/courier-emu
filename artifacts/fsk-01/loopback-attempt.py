import struct
from courier_emu.dsp import NativeC5x
from courier_emu.mailbox_compare import program
from courier_emu.rom import CourierRom
from courier_emu.answer_tone import FIXTURES
rom=CourierRom.load('artifacts/courier-board-21210-capture-403/courier-board.rom')
w=program(rom)
# Replay the ROM's own bring-up for dispatch entry d7fc (V.21 answer, receiver
# on the transmitter's own band): tx config, rx config, then d829's three calls.
frame=[0xBC07,0xBF01,0xBF0F,0x0BC0,0x7980,0x80C7]
arm=[0xBC07]
for target in (0xd7b4,0xd7a4,0xd94e,0xd895,0xd879):
    arm += [0x7A80,target]
arm += [0x7980,0]
drv=frame+arm
drv += [0]*(0x23-len(drv))
drv[0x22]=0xBE3A   # rete: a handler for the receiver's INTR 17 strobe
SPB=24
bits=[1,0,1,1,0,0,1,0,1,0,0,1,1,1,0,1]*3
with NativeC5x(rom) as c:
    c.load_rom(struct.pack('<%dH'%len(drv),*drv)); c.set_mpmc_pin(0)
    for a,v in FIXTURES: c.set_data(a,v)
    c.set_pc(len(frame))
    def until(pc,lim):
        prev=None
        for _ in range(lim):
            c.step(1)
            n=c.state()['pc']
            if n==0x22: strobe[0]+=1
            prev=n
            if n==pc: return
        raise RuntimeError(hex(pc)+' '+str(c.state()))
    strobe=[0]
    until(0,600)
    print('armed: @1a=%04x @1b=%04x @50=%04x @70=%04x @72=%04x @73=%04x'%(
        c.data(0x39A),c.data(0x39B),c.data(0x3D0),c.data(0x3F0),c.data(0x3F2),c.data(0x3F3)))
    soft=[]
    tx_prev=0
    for bi,bit in enumerate(bits):
        for k in range(SPB):
            d=c.data(0x3D0)
            c.set_data(0x3D0,(d|0x0100) if bit else (d & ~0x0100))
            c.queue_serial_rx([tx_prev])          # analogue loopback: our own output
            until(0x80C3,900)
            c.set_pc(0x8178); until(0x8199,150)
            tx=c.serial_state()['dxr']
            tx_prev=tx
            ss=c.serial_state()
            if len(soft)<14:
                def sg(x): return x-65536 if x>=32768 else x
                print(' n=%2d bit=%d dxr=%6d drr=%6d @47=%6d @50=%04x @70=%04x @40=%04x buf=%04x'%(
                    len(soft),bit,sg(tx),sg(ss['drr']),sg(c.data(0x3C7)),c.data(0x3D0),c.data(0x3F0),c.data(0x3C0),c.data(0x0BC1)))
            v=c.data(0x3EA)
            soft.append(v-65536 if v>=32768 else v)
    # one decision per bit, taken at the centre of the symbol
    dec=[1 if soft[i*SPB+SPB//2]>0 else 0 for i in range(len(bits))]
    print('tx :',''.join(map(str,bits)))
    print('rx :',''.join(map(str,dec)))
    print('soft range', min(soft), max(soft), 'INTR17 strobes', strobe[0], 'samples', len(soft))
