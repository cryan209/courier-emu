"""Dump the C5x on-chip ROM with a TBLR loop executed from SARAM.

The point of running the loop out of SARAM rather than from the downloaded
bank at 0x8000: TI's program-memory protection option blocks instructions
fetched from off-chip memory, DARAM B0, external DMA and the emulator from
reading on-chip program memory.  SARAM is not on that list.  The firmware's
own prologue already shows the technique - a `bldp` block move from data
memory into program memory at BMAR, which is how it installs its mailbox
helper at 0x23f0.
"""
import ctypes, sys
sys.path.insert(0, '.'); sys.path.insert(0, 'tools')
from c5x_disasm import disassemble
from courier_emu.dsp import NativeC5x

GADGET_AT   = 0x0900          # in SARAM (0x0800-0x2bff), mapped by PMST.RAM
BUFFER_AT   = 0x1000          # SARAM seen through data space, by PMST.OVLY
ROM_WORDS   = 0x0800          # a 'C50's 2K on-chip ROM at 0x0000-0x07ff

# The loop that does the reading, executed from SARAM.
GADGET = [0x8B8A, 0xBF0A, BUFFER_AT, 0xBF80, 0x0000, 0xBEC4, ROM_WORDS - 1,
          0xA6A0, 0xEF00]
GADGET_SRC = 0x8040           # where the gadget words sit in the kernel image

def kernel():
    w = [0xBE41, 0xBC00]                      # setc intm ; ldp #000
    w += [0x5D07, 0x0030]                     # opl @07, #0030 -> RAM|OVLY
    w += [0xBF80, GADGET_AT, 0x881F]          # BMAR = the SARAM destination
    w += [0x8B89, 0xBF09, GADGET_SRC]         # ar1 -> the gadget's words
    w += [0xBEC4, len(GADGET) - 1, 0x57A0]    # rpt ; bldp *+   (data -> program)
    w += [0x7A80, GADGET_AT]                  # call the gadget, now on-chip
    w += [0xBE41]                             # setc intm
    halt = 0x8000 + len(w) + 2
    w += [0x7980, halt]                       # b halt
    while len(w) < GADGET_SRC - 0x8000:
        w.append(0)
    w += GADGET
    return w

def main():
    words = kernel()
    if '--disasm' in sys.argv:
        mem = [0] * 0x10000
        mem[0x8000:0x8000 + len(words)] = words
        for ins in disassemble(mem, 0x8000, 0x8000 + 20):
            print(f'  {ins.pc:04x}  {" ".join("%04x"%x for x in ins.words):<10} {ins.text}')
        print('  ... gadget, executed from SARAM:')
        for ins in disassemble(mem, GADGET_SRC, GADGET_SRC + len(GADGET)):
            print(f'  {ins.pc:04x}  {" ".join("%04x"%x for x in ins.words):<10} {ins.text}')
        return 0

    # Offline validation: a synthetic ROM stands in for the part's own.
    rom = [(0xC000 | (a ^ 0x5A5A)) & 0xFFFF for a in range(ROM_WORDS)]

    class Image:
        def dsp_program_segments(self):
            import struct
            return [(0x8000, struct.pack(f'<{len(words)}H', *words))]

    core = NativeC5x(Image())
    import struct
    core.load_rom(struct.pack(f'<{ROM_WORDS}H', *rom))
    core.set_mpmc_pin(0)                      # microcomputer mode: ROM at 0x0000
    core.set_pc(0x8000)
    core.step(40_000)
    got = [core.data(BUFFER_AT + i) for i in range(ROM_WORDS)]
    ok = got == rom
    print(f'  read back {len(got)} words from data {BUFFER_AT:04x}')
    print(f'  first four: {" ".join("%04x"%x for x in got[:4])}')
    print(f'  expected  : {" ".join("%04x"%x for x in rom[:4])}')
    print(f'  match: {ok}')
    core.close()
    return 0 if ok else 1

sys.exit(main())
