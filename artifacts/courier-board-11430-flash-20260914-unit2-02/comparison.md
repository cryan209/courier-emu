# Second Courier `/dev/cu.usbserial-11430` capture comparison

Captured read-only on 2026-09-14. All 2,048 flash pages matched across two
reads, there were no failed attempts, and the anchors matched again after the
sweep.

## Identity

- Product: Australia External
- Serial: `21OWZ849PS95`
- Clock: 20.16 MHz
- Supervisor: `061-7.6.7`, dated 1998-12-02
- DSP: `3.1.2`, dated 1998-09-09
- ATI0 product code: `5607B`
- ATI1 ROM checksum: `2F89`
- Flash SHA-256: `d68f6fd8c1a2fcc047f88d05ec9f581b2186d660b93e3bb3866f433820c1cc7e`
- Reset entry: `FC00:0FE7`

## Closest distributed image

The decoded `firmware/legacy-usrobotics/SDL1202I/V90XX.XMD` body is the closest
known image: 518,091 of 524,288 bytes match (98.8180%).

| Flash offsets | Interpretation | Different bytes |
|---|---|---:|
| `00000..3ffff` | application and DSP area | 0 |
| `40000..77fff` | supervisor area | 4 |
| `78000..7bfff` | late/erased area | 0 |
| `7c000..7f7ff` | board boot block | 6,190 |
| `7f800..7ffff` | parameters and vectors | 3 |

The four supervisor-area bytes are the normal programmed checksum bytes at
`77ffc..77fff`. The installed application and DSP payload therefore matches
`V90XX.XMD` byte-for-byte; the material difference is the Australian boot
block.

## Difference from the first Australian unit

The two Australian units have an identical boot block, late/erased region,
parameters, and vectors. They are different firmware generations: only
47.8439% of the complete images match. The second unit differs from the first
in 254,291 bytes in the application/DSP area and 19,157 bytes in the supervisor
area.

## RAM and settings

Two lower-RAM passes captured `00000..0feff`; 39 live bytes changed. Two upper
passes captured `10000..1ffff`; 33 live bytes changed. Five stable sampled
upper pages matched the corresponding lower pages exactly, again supporting a
mirror rather than extra memory.

The legacy 18-byte EEPROM-cache offsets were stable zeros, so that decoder does
not locate valid records on this Australian firmware. This is not a complete
physical 93C66 EEPROM dump.

The modem's own `ATI5` display reports 115200 baud, 8N1, pulse dialling, `M1`,
`X7`, `&X0`, and `S0=2`; phone-number slots and stored command are empty.
`ATY14` reports `000,000,030,007,031,014`. DIP switches are OFF, OFF, ON, OFF,
ON, OFF, OFF, ON, OFF, OFF.
