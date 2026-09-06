"""Check the on-chip ROM dump kernel: disassemble it, and run it offline.

The kernel itself lives in `courier_emu.dsp_probe.build_rom_dump_probe`, so
that this check and `courier_emu.probe_transport` carry the same one. What is
here is the verification: print it through this repository's own disassembler
rather than trusting hand-assembled opcodes, and execute it in the native core
against a synthetic ROM, checking both what the TBLR loop leaves in data memory
and what actually goes out through the mailbox.

The loop is staged into SARAM rather than run where it sits because TI's
program-memory protection option blocks instructions fetched from off-chip
memory, DARAM B0, external DMA and the emulator from reading on-chip program
memory, and does not name SARAM. See docs/dsp-rom-probe.md.

    python tools/rom_dump_gadget.py            # execute it offline
    python tools/rom_dump_gadget.py --disasm   # print it
"""
import struct
import sys

sys.path.insert(0, '.')
sys.path.insert(0, 'tools')

from c5x_disasm import disassemble
from courier_emu.dsp import NativeC5x
from courier_emu.dsp_probe import (ORIGIN, ROM_DUMP_BUFFER, ROM_DUMP_TAG_BASE,
                                   ROM_DUMP_WORDS, SEND_FREE_BIT,
                                   build_rom_dump_probe)


def main() -> int:
    probe = build_rom_dump_probe()

    if '--disasm' in sys.argv:
        memory = [0] * 0x10000
        memory[ORIGIN:ORIGIN + len(probe.words)] = probe.words
        print(f'  {len(probe.words)} words, {len(probe.payload)} bytes')
        for line in disassemble(memory, ORIGIN, ORIGIN + len(probe.words)):
            body = ' '.join('%04x' % word for word in line.words)
            print(f'  {line.pc:04x}  {body:<12} {line.text}')
        return 0

    # A synthetic ROM stands in for the part's own. Nothing here is recovered
    # from a Courier: this checks the kernel, not the silicon.
    rom = [(0xC000 | (address ^ 0x5A5A)) & 0xFFFF
           for address in range(ROM_DUMP_WORDS)]

    core = NativeC5x(probe)
    core.load_rom(struct.pack(f'<{ROM_DUMP_WORDS}H', *rom))
    core.set_mpmc_pin(0)                       # microcomputer mode: ROM at 0
    # The ASIC's status latch, reached through MMR 0x57: hold the send window
    # open so the poll never stalls. On the board that bit is the ASIC's.
    core.set_io(0x57, 1 << SEND_FREE_BIT)
    core.set_pc(ORIGIN)
    core.step(400_000)

    read_back = [core.data(ROM_DUMP_BUFFER + index)
                 for index in range(ROM_DUMP_WORDS)]

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
    rebuilt = [sent.get(ROM_DUMP_TAG_BASE + index)
               for index in range(ROM_DUMP_WORDS)]
    core.close()

    read_ok, sent_ok = read_back == rom, rebuilt == rom
    print(f'  TBLR into data {ROM_DUMP_BUFFER:04x}: {len(read_back)} words, '
          f'match {read_ok}')
    print(f'  mailbox sends captured: {len(sent)} tag/word pairs')
    print(f'  reassembled from tags {ROM_DUMP_TAG_BASE:04x}..'
          f'{ROM_DUMP_TAG_BASE + ROM_DUMP_WORDS - 1:04x}: match {sent_ok}')
    return 0 if read_ok and sent_ok else 1


sys.exit(main())
