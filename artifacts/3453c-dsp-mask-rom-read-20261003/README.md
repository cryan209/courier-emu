# Recovered 3453C DSP mask ROM

`dsp-mask-rom-0000-0fff.bin` contains **4,096 words / 8,192 bytes**, little-endian, at DSP program addresses **0000..0FFF**.

SHA256: `262e4baa49590bb6ca4a473dffb8a8aee67c9fae020ce92ac3f59e077314f1d6`.

Two independently requested 0000..1FFF mapped windows matched exactly. Their upper half, 1000..1FFF, matches the patched resident downloaded from flash, including the monitor dispatcher hook, establishing that this upper region remains external RAM. The lower 4K words differ from unmapped program RAM at 4,090 of 4,096 positions and contain a coherent vector table beginning with `B 0F46`. Boot code at 0F46 uses I/O 8057/8058, matching the 3453 board’s first-download protocol.

Live PMST was **18B8 before and after** each capture. The monitor returned D541 afterward. Each individual ROM read masked interrupts, temporarily cleared only PMST.MP/MC, read one word, and restored mapping and status before replying. The revision remains installed.

The observed image supports a 4K-word ROM compatible with the suspected C52-class part; this is not a broader confirmation of the exact die model. The older 302/403-board ROM is a different image.

`manifest.json`, `sample-verification.json`, and `window-verification.json` preserve provenance and checks. `boot-loader.asm` is the bootstrap excerpt; `mask-rom-linear.asm` is a linear decoding that also includes tables/constants.

The older Courier comparison in `rom-comparison.json` finds 157 same-address
word matches within the first 4K, with substantial relocated blocks (including
496 words at old 0250 / new 00D0). The layouts and bootstrap protocols differ;
this is not a code-similarity percentage. No Cisco MICA DSP ROM is available
for a binary comparison. Its MP/MC switching alone does not establish ROM
compatibility.

The acquisition and extraction scripts preserve the original procedure. They
reference the local diagnostic monitor, patched firmware and unmapped program
capture from the investigation; those prerequisites are recorded in the
manifest and are separate from this ROM evidence bundle.
