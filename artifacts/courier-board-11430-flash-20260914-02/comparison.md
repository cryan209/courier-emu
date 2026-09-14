# Courier `/dev/cu.usbserial-11430` capture comparison

Captured read-only on 2026-09-14. The flash collector sent only `AT`, `ATI7`,
and `ATGLK2` reads. All 2,048 256-byte pages matched across two reads, there
were no failed attempts, and both flash anchors matched again after the sweep.

## Identity

- Product: Australia External
- Serial: `0409550000376154`
- Clock: 20.16 MHz
- Supervisor: `061-7.4.16`, dated 1998-04-30
- DSP: `3.0.13`, dated 1998-03-13
- ATI0 product code: `5607A`
- ATI1 ROM checksum: `B60A`
- Flash SHA-256: `85665f6db32b06b256dd70d631be3e0e0a120890b31b04c0f571f72497a22bcb`
- Reset entry: `FC00:0FE7`

## Closest image

The decoded body of `SV_49.XMD` is the closest known image: 518,091 of
524,288 bytes match (98.8180%). The comparison divides cleanly:

| Flash offsets | Interpretation | Different bytes |
|---|---|---:|
| `00000..3ffff` | application and DSP area | 0 |
| `40000..77fff` | supervisor area | 4 |
| `78000..7bfff` | late/erased area | 0 |
| `7c000..7f7ff` | board boot block | 6,190 |
| `7f800..7ffff` | parameters and vectors | 3 |

The four supervisor-area bytes are at `77ffc..77fff`, the downloader-programmed
checksum location. Thus the installed application and DSP payload is `SV_49`
byte-for-byte; the material difference is the board/regional boot block.

For broader context, the full flash is 76.6766% identical to the previous
20.16 MHz IDSDL 4.03 hardware capture, 48.5929% identical to the prior 20.16
MHz stock 3.02 hardware capture, and 47.9553% identical to the 25 MHz stock
hardware capture.

## RAM and stored settings

Two lower-RAM passes captured `00000..0feff`; 46 live bytes changed. The known
18-byte EEPROM-cache offsets were stable but all zero, so that decoder does not
locate usable records in this firmware variant. This is not a dump of the
physical 93C66 EEPROM.

Two upper-window passes captured `10000..1ffff`; 45 live bytes changed. Five
stable sampled pages matched the corresponding lower-RAM pages exactly. The
page around address zero differed only in active working bytes. This strongly
supports the upper window being a mirror of lower RAM, not extra memory.

The modem's own `ATI5` formatter reports a stored profile at 115200 baud, 8N1,
tone dialling, with `S0=2`; stored phone numbers and stored command are empty.
`ATY14` reports `000,000,031,007,015,014`. The DIP switches reported by
`ATY15` are OFF, OFF, ON, OFF, ON, OFF, OFF, ON, ON, OFF.

## NVRAM limitation

No proven read-only AT command in this repository directly dumps all 256 words
of the board's physical 93C66 EEPROM. The RAM images and `ATI5` output preserve
the accessible settings views without claiming to be a full EEPROM image.
