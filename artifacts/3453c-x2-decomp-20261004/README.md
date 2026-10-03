# 3453C x2 DSP decompilation, first pass

Source: `docs/3453C_v2.3.33/2_3_33.XMF`, SHA256
`c8d44a1c984a203f6e9a91b14c77382706ea05fc2b860081f986c47b6fa7c41e`.

`x2_dsp_lift.c` is a **manual C semantic reconstruction** of the identified
x2 setup and shared PCM routines. It compiles, but is not recovered vendor
source or a complete modem datapump. Function and variable names are ours.
The DSP uses separate program/data spaces and overlay-dependent program
addresses; a single flat disassembly would mix incompatible code.

## Files

- `x2_dsp_lift.c`: readable C equivalents, with original PCs and preconditions.
- `x2-focused.asm`: the original words and decoded instructions for the lifted
  routines and their immediate negotiation context.
- `overlay-5.asm` through `overlay-8.asm`: full linear listings of each
  downloaded image, extracted using the supervisor's own overlay table.
- `verification.json`: input image identity and native execution results.
- `../../tools/recover_3453c_x2.py`: reproducible extractor and verifier.

The complete listings include tables and data that decode as plausible
instructions. Inclusion in a listing is not a claim of code reachability.
Only the specifically identified routines are semantically lifted here.

## Reconstructed routines

| Routine | Image | DSP PC | Evidence |
|---|---|---|---|
| x2 command 70 capability setup | low overlay 7 | 08f8 | Supervisor x2 caller and native execution |
| Shared command 71 rate mask | low overlay 7 | 090b | Dispatch table and native execution |
| Shared command 72 parameter | low overlay 7 | 0921 | Dispatch table and native execution |
| Shared command 74 enable | low overlay 7 | 091c | Dispatch table and native execution |
| Shared command 76 six-bit parameter | low overlay 7 | 0912 | Dispatch table and native execution |
| Shared command 77 parameter | low overlay 7 | 0919 | Dispatch table and native execution |
| PCM state selector | resident 5 | 5b17 | Native execution, stopping at tail target 112b |
| Initial capability-copy fragment | overlay 6 | 1dc9 | Native execution, stopping before call 088d |
| Batch scrambler | low overlay 7 | 0890 | C/native/scalar recurrence agreement |
| Batch descrambler | low overlay 7 | 08b0 | C/native/scalar recurrence agreement |
| Fixed-GPC training generator | PCM overlay 8 | 6421 | C/native/scalar recurrence agreement |
| Peer qualification fragment | low overlay 7 | 0e4f | Native execution through 0e68 |
| Negotiation cleanup fragment | low overlay 7 | 09a0 | Native execution through 09a7 |

The mailbox dispatcher is also lifted, but has not been independently
execution-tested as a C equivalent.

The peer qualification lift preserves the raw bit meanings: peer word
`[7f00]` bit 12 clear sets `[7fe8]` bit 8. A rate-dependent margin
`4a00 - ((peer << 5) & 0f00) - signed([7f26])` determines bit 14. No
unverified proprietary x2 label is assigned to those fields.

The parallel [server bundle](../x2-server-decomp-20261004/README.md) now
reconstructs the pre-V.90 I-modem capability writer and sample transforms,
with separate shared x2/V.90 Quad PCM helpers.

## What the code says

Command 70 applies:

```c
capability = (host_argument | 0x4000) & 0x7fff;
pcm_flags = 0x8000;
pcm_status |= 1;
```

The batch scrambler is shared V.34/PCM machinery. It selects GPC
`1 + x^-18 + x^-23` or GPA `1 + x^-5 + x^-23` from data `[006f]` bit 0;
the receiver selects the opposite recurrence from bit 1. The C lift uses
an equivalent bit-at-a-time implementation instead of the original batched
fixed-point operations. Tests cover widths 1..9, both roles, and random
23-bit histories.

The training generator at `6421..6432` is the same 18-word body as the
x2-only build's `ed2e..ed3f` and the 4.03 build's `f938..f949`. Its caller
at `63f8..6400` explicitly requests six scrambled-one bits with mask `003f`.
This proves retained x2-era PCM training machinery; it does not establish
the proprietary name of that wire sequence or distinguish every x2 call
from V.90.

One notable boundary: overlay 6's entry at `1dc9` initializes INFO-related
buffers from `[7fec]`, whereas command 70 writes `[7feb]`. There is no
identified direct read of `[7feb]` in this pass beyond its own setup handler.
Indexed/indirect consumption remains possible. The original x2 capability
word's route into transmitted negotiation has **not** been reconstructed
for 3453C. Retained setup code alone therefore cannot prove x2 works.

## Verification

From the repository root:

```sh
.venv/bin/python tools/recover_3453c_x2.py
```

Requires the repository's native DSP emulator and `clang`. The verifier
compiles the actual C file into a temporary shared library and compares it
against original firmware instructions. All **1,769 cases passed**:

- 1,152 scrambler/descrambler cases.
- 256 training-generator cases, including 768 continuous bits from zero state.
- 12 command-70 cases, including preservation of existing status bits.
- 20 adjacent mailbox-handler cases.
- Six state-selector cases and three initial-capability fragment cases.
- 256 peer-qualification and 64 negotiation-cleanup cases.

No modem hardware is accessed. These are isolated routine checks, not a
complete x2 call simulation. Peer recognition, proprietary modulation
parameters, PCM mapping, and the complete training state machine still need
further reconstruction.
