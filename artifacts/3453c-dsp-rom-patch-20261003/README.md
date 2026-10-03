# DSP ROM-mapping monitor revision

Built from hardware-verified 3453C stock 2.3.33. Adds two exact DSP requests:

- `ATG008Baaaa`: read program word aaaa with PMST.MP/MC temporarily cleared,
  allowed 0000..1FFF. Returns 0072 just like ordinary program reads.
- `ATG008C0000`: read live PMST without changing it. Returns 0071.
- `ATGEssssEEEE`: stream inclusive mapped-ROM reads, bounded within 0000..1FFF.
- `ATGDssssEEEE`: existing ordinary program stream, unchanged address bounds.

Each mapped read executes at 75E0 or above, outside the candidate ROM window.
It saves ST0 and ST1, masks interrupts, saves complete PMST on the hardware stack,
clears only bit 3, table-reads the requested word, and restores PMST before
restoring interrupt enable and status. INTM restoration is explicit: LST does
not restore INTM. Restoring ST0 after ST1 also preserves ARP despite ARB differences.
The existing reply queue now uses the same correct interrupt/status restoration.
The monitor occupies 116 words, 75E0..7653. Known overlays end below this area.

27 tests pass, including 18 DSP and 20 CPU isolated instruction executions.
The DSP cases use a simulated C51 ROM to verify mapped reads and exact PMST
restoration, with masked and unmasked entry plus full-queue failures. The emulator
does not model this unit's silicon ROM or its optional protection feature.
TI documents that external instructions may receive invalid bus data when ROM
protection is enabled (SPRU056D, section 8.2.4). Captures require hardware analysis
before they can be identified as mask ROM.

Host examples:

```
.venv/bin/python tools/3453c_monitor.py pmst
.venv/bin/python tools/3453c_monitor.py dump rom 0000 1fff --fast --output window.bin
```

The 8K-word window includes external memory if the silicon ROM ends earlier.
The upper boundary is a probe bound, not a claim that this part has 8K words of ROM.

## Hardware result

All 5,888 flash blocks were acknowledged without retries; reset and ATGU succeeded. Live PMST was 18B8 before and after mapped reads. Two independently requested 0000..1FFF windows matched exactly, and the 4K-word internal ROM at 0000..0FFF was extracted successfully. The upper window matches downloaded RAM. ROM protection did not block this read route. See hardware-verification.json and ../3453c-dsp-mask-rom-read-20261003/README.md. The ROM-capable revision remains installed.
