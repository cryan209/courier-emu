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
TAG_BASE   = 0x5200           # the outbound tag counter, one per word sent
STATUS_MMR = 0xFF57           # status latch, read as an address then as an MMR
# `BIT dma, code` on the C5x tests bit (15 - code), not bit `code`: the core
# evaluates (~op >> 8) & 0xf. The resident's poll is 0x4e7d, which this
# repository's disassembler prints as "bit 14, @7d" - so the bit the ASIC has
# to set for the send window to read as free is bit 1.
SEND_FREE_CODE = 14
SEND_FREE_BIT = 15 - SEND_FREE_CODE

def sender(origin, count):
    """The resident's outbound pattern, as dsp_probe.py already reproduces it.

    Tag to port 0x5e, word to port 0x5f, then 2 into @57 to complete the send,
    with the tag doubling as a sequence number so the host can reassemble. The
    status poll reads 0xff57 as an address and then as an MMR, which is the
    two-step the 302 helper at 0x23f0 performs.
    """
    w = [0xAE7C, TAG_BASE, 0xBF09, BUFFER_AT]      # splk @7c,#tag ; lar ar1,#buf
    poll = origin + len(w)
    w += [0xBF0A, STATUS_MMR, 0x8B8A,              # lar ar2,#ff57 ; mar *,ar2
          0x1080, 0x0880, 0x8B89,                  # lacc * ; lamm * ; mar *,ar1
          0x907D, 0x4E7D, 0xE200, poll]            # sacl @7d ; bit 14 ; wait
    w += [0x0C7C, 0x005E,                          # out  @7c, 5e   the tag
          0x0CA0, 0x005F,                          # out  *+,  5f   the word
          0xB902, 0x8857,                          # lacl #2 ; samm @57
          0x697C, 0xB801, 0x907C,                  # tag = tag + 1
          0xBFA0, (TAG_BASE + count) & 0xFFFF,     # sub  #tag_end
          0xE308, poll]                            # bcnd poll, neq
    return w


def kernel():
    w = [0xBE41, 0xBC00]                      # setc intm ; ldp #000
    w += [0x5D07, 0x0030]                     # opl @07, #0030 -> RAM|OVLY
    w += [0xBF80, GADGET_AT, 0x881F]          # BMAR = the SARAM destination
    w += [0x8B89, 0xBF09, GADGET_SRC]         # ar1 -> the gadget's words
    w += [0xBEC4, len(GADGET) - 1, 0x57A0]    # rpt ; bldp *+   (data -> program)
    w += [0x7A80, GADGET_AT]                  # call the gadget, now on-chip
    w += sender(0x8000 + len(w), ROM_WORDS)   # ship it out through the mailbox
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
    # The ASIC's status latch, reached through MMR 0x57: hold the send window
    # open so the poll never stalls. On the board that bit is the ASIC's, and
    # the loop waits on it.
    core.set_io(0x57, 1 << SEND_FREE_BIT)
    core.set_pc(0x8000)
    core.step(400_000)

    got = [core.data(BUFFER_AT + index) for index in range(ROM_WORDS)]
    read_ok = got == rom

    # Reassemble what actually left through the mailbox: the tag goes to port
    # 0x5e and the word to 0x5f, and the tag orders them.
    sent: dict[int, int] = {}
    tag = None
    for event in core.io_events():
        if not event['write']:
            continue
        if event['port'] == 0x5E:
            tag = int(event['value'])
        elif event['port'] == 0x5F and tag is not None:
            sent[tag] = int(event['value'])
    rebuilt = [sent.get(TAG_BASE + index) for index in range(ROM_WORDS)]
    sent_ok = rebuilt == rom

    print(f'  TBLR into data {BUFFER_AT:04x}: {len(got)} words, match {read_ok}')
    print(f'  mailbox sends captured: {len(sent)} tag/word pairs')
    print(f'  reassembled from tags {TAG_BASE:04x}..{TAG_BASE + ROM_WORDS - 1:04x}:'
          f' match {sent_ok}')
    print(f'  first four sent: '
          f'{" ".join("%04x" % w for w in rebuilt[:4] if w is not None)}')
    print(f'  expected       : {" ".join("%04x" % w for w in rom[:4])}')
    core.close()
    return 0 if read_ok and sent_ok else 1

sys.exit(main())
