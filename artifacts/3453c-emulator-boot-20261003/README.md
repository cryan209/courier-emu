# 3453C recovered-ROM integration and idle comparison

The emulator now executes the board's recovered 4,096-word mask ROM. The
supervisor transfers the stock resident (52,160 bytes) through the host window;
the DSP ROM's IN instructions write it into shared external data/program RAM.
Every transferred group is verified against program memory. No host shortcut
installs the resident or branches around its loader.

The resident then installs the 4,096-word low overlay using its own IN/BLDP
loop at 1150–1171. The CPU reaches its main loop at 61D0C. The previous 2.3
profile's command entry A7A0 was inside an instruction; A7B0 is the verified
2.3.33 callback. Serial TX capture also now covers the 2.3 UART write at 5944D.

`ati0-run.json` records a firmware-generated `3368` followed by `OK`. This is
an execution check, **not a verified board identity**: the physical board reports
5608A. `ATI7` prints its profile header, then stops at INT 0A's boot-block
flash-ID service, which is not yet modeled for this update payload. Bare AT
currently emits no result. Si3034 audio/register transactions, complete board
identity and call operation remain unvalidated.

## Hardware comparison

`hardware-idle-data-0100-03ff.bin` captures all 768 accessible DARAM words,
sequentially through the installed diagnostic monitor. PMST read afterward
was 18B8, unchanged. The capture's metadata includes its hash and elapsed time.

`compare.py` executes stock firmware using a private copy of the captured
parameter flash, and records DSP state immediately before the core closes.
It never initializes DSP RAM from the hardware snapshot. The final comparison
has **763/768 matching words**, and PMST matches **18B8**. An earlier snapshot
had 764 matches: the ring pointers and interrupt phase are live state.

The final differing addresses are 038D, 038E, 0390, 0391 and 0399. The initial
comparison also differed at gain cell 039D (hardware 1200, emulator 0000).
These are startup/configuration and live serial-loop differences; matching
mostly-zero DARAM is not proof of modem training or codec correctness.
Only PMST was captured from hardware registers; other register values in
`idle-comparison.json` are emulator diagnostics, not hardware measurements.

## Reproduce

```
./courier run 2_3_33.XMF --with-dsp --instructions 4000000 --summary --at ATI0
.venv/bin/python artifacts/3453c-emulator-boot-20261003/compare.py
```

`private-parameters.sav` is ignored because the board parameter sector includes
dial-security credentials. Intermediate numbered runs preserve debugging
failures; use `ati0-run.json`, `comparison-run.json` and `idle-comparison.json`
as the final evidence.

The C52 profile's 4K ROM size is measured. No SARAM is modeled pending a
physical alias probe. The external data/program alias at 1000–7FFF is required
by the recovered loader and resident transfers. Mailbox diagnostics use
canonical 005x port names for guest 805x accesses. Frame interrupt timing uses
the existing Courier clock model, not a new 3453C timing measurement.

This findings bundle records experimental working-tree emulator results.
Reproducing them requires the separate emulator integration changes and the
private hardware parameter capture; neither is included in the ROM/findings
commit. Numbered intermediate runs are retained locally.
