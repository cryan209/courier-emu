# Configuration command analysis: Courier 7.1.4 / DSP 2.2.1

Source: courier-board.rom in this directory. Addresses below are file offsets;
CPU physical addresses are file offsets plus 0x80000.

- G handler at 0x24f0d requires the literal LK2 prefix. A mismatch returns carry set at 0x24ee4.
- N subcommand at 0x24ffc sets bit 0 of RAM byte 0x025e and returns carry clear. Command: ATGLK2N.
- C selector table at 0x0d8d7 is decimal 10, 8, 23, 39, 56, 74.
- C8 selects record 2, the three encoded bytes at RAM 0x0748.
- Initialization at 0x00908 reads record 2. At 0x00933 its bit 0x10 sets runtime capability byte [0x0893] bit 0x20.
- IMPORTANT: C write handler calls the record decoder at 0x0d8ed and branches to failure on carry clear at 0x0d8f0. The decoder returns carry clear for a valid record. Therefore a valid provisioned record cannot be overwritten simply by ATGLK2N followed by ATC8=31.
- Only after the record validity gate fails does 0x0d8f2 test the permission bit. The allowed write path encodes all three copies at 0x0d9c3 and persists changed EEPROM words at 0x0da13.
- The G subcommand dispatch has no W memory-write case in this build. Its = and R cases read memory; O writes an I/O port. Do not reuse ATGLK2W recipes from other builds.

This analysis used the saved ROM only. No configuration writes were sent to the modem.
