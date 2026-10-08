# Remote feature-bit writer in supervisor 7.1.4

Analysis uses only the saved ROM. No physical modem queries or writes.

## Verified offline

The real 80186 instructions were executed using courier_emu.x86_interpreter.
Entry was CPU 8000:cd32, after the upstream receive buffer selection. RAM
0x1a80 held the candidate frame and SI/CX selected it. A valid feature
record encoding decimal 15 was installed at RAM 0x748. The hardware EEPROM
writer at 8000:da13 was intercepted and returned immediately: no physical
EEPROM or emulated port activity was needed. The actual record decoder,
bit setter and three-copy encoder executed unmodified.

Frame bytes 01 02 0a 02 25, and address variant 03 02 0a 02 25, both
changed the feature record from 28 0f 12 (15) to 68 17 02 (31) and
reached the EEPROM writer. Controls with P/F bit 0x10 set and subcommand
01 did not write. The tested unnumbered branch did not check link state;
this does not prove that the upstream receive machinery admits such a
frame without a live connection.

## Instruction path (file offsets)

- 0xcd32 calls address/control parser 0xcc00, consuming LAPM address and control bytes.
- 0xcd39 tests control bit 0x02 and selects the unnumbered dispatch at 0xcd6b.
- 0xcd7a indexes the table at 0xcb86; control 02 selects 0xc515.
- 0xc515 checks DL bit 0x10 through 0xc290; set means reject.
- 0xc53e recognizes first payload byte 0x0a.
- 0xc554 uses the next byte as a subcommand index into table 0xc559.
- Subcommand 02 selects 0xc5a9, the set-bit handler. Subcommand 06
  selects 0xc59a, the clear-bit handler (not included in execution cases).
- 0xc5b9 consumes packed selector 0x25: high nibble 2 is record 2,
  low nibble 5 produces 1 << (5 - 1), or 0x10.
- 0xc5a9 ORs that mask into the decoded record.
- 0xc5b2 calls 0xd99e, then encoder 0xd9c3 and EEPROM writer 0xda13.
  This path bypasses the C8 validity/write-permission gate.

There is no password or enable-key check in this traced inner path.
Upstream link handling, frame admission, CRC/FCS and escaping have not
been exercised by this harness. These five bytes are a decoded frame
candidate, not a complete wire transmission and not an AT command.
Typing them at the terminal is not equivalent to receiving this control
frame. A second endpoint capable of supplying vendor control frames or
another independently verified entry mechanism is needed for hardware use.

This identifies a mechanism consistent with USR remote activation; it
does not establish which exact exchange the historical USR service used.

Run: PYTHONPATH=. .venv/bin/python artifacts/courier-714-221-flash-20261007/remote-analysis/check_handler.py

## V.42 transmitter to firmware boundary test

`tx_frame.c` links the existing v90modem SpanDSP static library. It starts
V.42 with v42_restart(), inserts 01 02 0a 02 25 into its control ring,
and clocks v42_tx_bit() into an HDLC receiver. The receiver emits the exact
five octets with ok=1 (valid FCS). That decoded output, rather than a
separately hardcoded frame, was fed to check_handler.run(). The firmware
produced the record encoding for 31 and reached its EEPROM writer.
Result: tx-to-firmware-result.json.

Build:
```
cc -I /opt/homebrew/include -I /Users/scottcryan/v90modem/spandsp-master/src tx_frame.c /Users/scottcryan/v90modem/spandsp-master/src/.libs/libspandsp.a -lm -o /private/tmp/courier-x2-tx-frame
```

Scope: actual V.42 control queue, bit-level HDLC encode/decode and firmware
address/control dispatch onwards. It does not boot the whole Courier,
establish a modulated connection, exercise its own HDLC/FCS receive logic,
or program EEPROM. The write is intercepted. No production v90modem
files were changed, and no physical modem access occurred.
