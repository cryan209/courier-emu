# The ISDN Courier's DSP image against the analog one

Same machine, same four-image structure, different generation of the code.
`IDSDL302.ROM` (ISDN 3.0.2) and the analog `MAIN_*.XMF` payloads both carry a
C52 resident bank plus three overlays, loaded by the table
[dsp-overlays.md](dsp-overlays.md) describes, and both flash payloads are
`0xb8000` bytes based at `0x40000`.

## The structure is identical

Read out of each supervisor's own overlay table (`courier_emu.rom`'s table and
segment patterns applied to `XmfImage.supervisor`):

| image | resident | ov6 | ov7 | ov8 |
|---|---:|---:|---:|---:|
| ISDN 3.0.2 | 27,710 w @ `8000` | 11,510 w @ `9d00` | 7,499 w @ `b000` | 7,350 w @ `dc00` |
| analog 2.1.1 | 30,170 w @ `8000` | 11,929 w @ `9d00` | 7,328 w @ `af50` | 6,211 w @ `dc00` |
| analog 2.2.05 | 30,170 w @ `8000` | 11,937 w @ `9d00` | 7,328 w @ `af00` | 6,218 w @ `dc00` |
| analog 2.3.12 | 26,080 w | 11,832 w | 4,090 w | 6,197 w |
| analog 2.3.31 / 2.3.33 | 26,080 w | 11,832 w | 4,094 w | 6,197 w |

Four images, the same slot numbering, the same load addresses for the resident
bank and overlay 6, and overlay 8 at `dc00` throughout.  The 2.3.x rows'
*entry* words come back implausible from this pattern (`1000`, `1dc9`, `0`),
so only their lengths are quoted; the 2.1.1/2.2.05 entries parse cleanly and
match the ISDN's to within overlay 7's `af50`/`af00` versus `b000`.

## The content is a fork of the 2.1.x line

Coverage measured as the fraction of each ISDN overlay's bytes lying in runs of
≥12 bytes that also occur in the analog payload - byte-exact, so relocation and
re-assembly push it down, which is why the baselines matter:

| analog pair | DSP coverage |
|---|---:|
| 2.3.33 vs 2.3.31 | 100.0% (one run - the DSP image is unchanged) |
| 2.3.12 vs 2.3.31 | 82.6% |
| 2.2.05 vs 2.3.31 | 50.7% |
| 2.1.1 vs 2.3.31 | 50.5% |

So 50% is what "a different generation of the same code" looks like here, and
the analog DSP was substantially rebuilt between 2.2.05 and 2.3.12.

| ISDN overlay | vs analog 2.1.1 | vs analog 2.2.05 | vs analog 2.3.31 |
|---|---:|---:|---:|
| resident (`8000`) | 54.6% | 54.5% | 45.8% |
| ov6 (`9d00`, V.34) | 36.8% | 36.7% | 33.3% |
| ov7 (`b000`, V.FC) | **63.1%** | 62.8% | 18.7% |
| ov8 (`dc00`, PCM) | 22.4% | 22.4% | 22.0% |

Three things fall out:

* **The ISDN image descends from the 2.1.x/2.2.x analog line.** Every overlay
  is closer to 2.1.1 than to 2.3.31, and overlay 7 decisively so - 63% against
  19%, with a single shared run of 1,084 bytes.  The 2.3.x analog builds cut
  overlay 7 from ~7,300 words to ~4,090; the ISDN kept the long one.
* **Overlay 6 is the least shared of the three carried-over images** (37%),
  which is where V.34 lives - the part most reworked on both sides.
* **Overlay 8 is nobody's cousin**: 22% against every analog build, the same
  figure whether the analog is 2.1.1 or 2.3.33.  The PCM downstream layer
  ([pcm-x2-v90.md](pcm-x2-v90.md)) is a separate build in the ISDN image, even
  though `IDSDL302.ROM` carries the same `64000/x2` and `64000/V90` result
  strings.

The resident bank at 46-55% is the honest summary of the whole comparison: the
same program, two branches apart, with the ISDN branch cut from the older
trunk.
