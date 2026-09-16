# Quad server answer bring-up (2026-09-11, remeasured 2026-09-17)

The QF server is **not yet a negotiation peer**. A fresh controller boot,
CPU-streamed DSP resident and `ATQ0V1` / `ATA` no longer abort the answer, but
no runtime overlay request occurs and the transmitted timeslot is a stuck DC
rail. This does not test V.8 interoperability. The sections below are dated:
the 2026-09-11 blocker no longer reproduces - see the 2026-09-17 section.

Run from the repository root:

```sh
PYTHONPATH=. .venv/bin/python tools/probe_quad_c50_live.py \
  --archive docs/x2/Qf060003.zip --digital-call --law mu \
  --command ATA --instructions 12000000 \
  --output /tmp/quad-server
```

The report includes command input, terminal output, call setup and abort
traces, writes to call flags, DSP boot/PCM state and overlay counters.
`current-dsp-tx.g711` contains only the current DSP instance's output; a CPU
reset discards previous samples, so an empty final capture is not proof that
no earlier frames occurred. The byte-terminal autobaud adapter and existing
Courier NVRAM seed remain harness assumptions. `--law` selects wire idle fill;
it does not program the firmware's companding-law setting.

## Corrected startup ordering

Previously `connect_digital_call` enabled DS0 framing immediately upon creating
the core, while the recovered ROM was still downloading 16-bit words through
DRR. The endpoint now buffers incoming octets until the boot queue is empty
and execution has reached resident program space. It then enables the digital
frame clock. Reset clears the active PCM state and the old core's I/O cursor.

The regression executes the real ROM against a padded test resident, verifies
that no frames occur during download, and checks its transmitted codeword
after handoff. This fixes the boot/PCM boundary; it does **not** establish that
the stock resident has all overlays and interrupt targets needed for a call.
(The escape into low program addresses recorded here no longer happens; the
2026-09-17 section has the measurement.)

## The answer abort is gone; the call now stalls silent (2026-09-17)

Re-measured with the same command line above, 12M instructions, against
`artifacts/quad-server-bringup-20260911/fresh-ata.json`:

| | 2026-09-11 | 2026-09-17 |
| --- | --- | --- |
| terminal | `OK` / `NO CARRIER` | `OK`, then ATA still up at the limit |
| DSP downloads / reboots | 23 / 22 | 2 / 1 |
| `[82fe]` bit 7 | set at `f35a3` | never set; two writes, both zeroing |
| DSP exchanges | none | 7 commands sent and acked, 1 reply posted |
| PCM | inactive, 0 bytes TX | active, 49,194 G.711 bytes |
| DSP pc at the limit | low program space | `0x82eb`, in the resident, IDLE |

`ATA` still reaches `c7cfc` and `c7d3f`, but the three unserviced checks at
`c0b69` no longer happen, so nothing sets `[82fe]` bit 7 and the answer path at
`efc84` no longer exits via `efc9c`. The resident also stays in program space
instead of escaping low - the signature of the delay-slot interrupt bug fixed
in 20133c6, whose orphaned stack pushes made `RETD` pop a stale address.

Attribution is joint, not settled: four quad-side commits landed after the
baseline (`19313a0` C51 boot ROM and split SARAM, `6369173` deferring PCM to
boot completion, `c8b4195`, `df5d709`), and the old report has no
`commands_sent` / `replies_posted` fields at all, so part of the exchange is
new code rather than a freed path. Splitting it needs a run with 20133c6
reverted.

## What still blocks a connection

`runtime_bursts` is 0. No runtime overlay is requested, so no answer overlay is
selected.

**It produces no audio.** 49,166 of the 49,194 captured bytes are codeword
`0x00`, which in mu-law is full-scale negative (-8031), not silence - a stuck DC
rail for 6.15 s. `dxr_writes` is 24,606 while DXR reads back 0 and
`line_tx_nonzero` is 0: the timeslot is clocked and the same word goes out every
frame. The part is running and framed; nothing is modulating.

Next question is why the resident parks at `0x82eb` without requesting an
overlay, given the CPU exchange it now answers.

## The DSP is running the test mode, and it is a loopback (2026-09-17)

`AT&T1` is the lever, exactly as 4772fbe found on the 302: it reaches the
datapump through the test flag rather than the call gate. Against `ATA`:

| | `ATA` | `AT&T1` |
| --- | ---: | ---: |
| runtime overlay bursts | 0 | 2,547 (2,545 pulled) |
| DSP commands sent / acked | 7 / 7 | 39 / 37 |

The 39 exchanges are a datapump being programmed - six indexed `0x50` loads
(`0c1`, `145`, `211`, `310`, `40d`, `500`) plus `0x48`/`0x49`/`0x51`/`0x52`
carrying 16-bit values.

The frame handler is five instructions over circular buffer 1, which the ARAU
confirms rather than the pointer alone: `CBSR1 0bd0`, `CBER1 0bdf`,
`CBCR 00ef` - CB1 on AR7, enabled. (CB2 is `0058..005d` on AR6, the host lane
window, not audio.)

    83eb  lamm @20      ; ACC = DRR
    83ec  sacl *+       ; store it into the buffer
    83ed  lamm @6b
    83ee  or   *+       ; OR with the next cell
    83ef  samm @21      ; DXR = that

So it is a delay-line loopback - store the received word, transmit the next
cell - which for ALB is the right thing to be doing. `@6b` is 0, so the
transmitted word is the buffer cell alone.

**There are two handlers, and they are phases of one chain.** `PMST 00b0` puts
IPTR at 0, so vectors are in the mask ROM at program `0000`, and every ROM
vector is indirect: `lamm @NN` then a branch, with XINT on `@65`. This is the
same part's ROM as the 302's, and the same mechanism that
[fsk-modulation.md](fsk-modulation.md) already records there - `INTR 17`'s
vector at ROM `0x0022` is `lamm @69 ; bacc`, dispatching through the block at
data `0x60`-`0x6a` that the cold start fills. Measured on `main2205.XMF` after
its cold start, `@60`-`@6a` hold resident code addresses (`@64`/`@65` at
`81a3`, beside the `81a6` handler) while `@6b` is `0001` and `@72`/`@73` are
`0000`. **So a cell number is not a vector by position:** `@72`/`@73` are the
mark and space increments, not handlers, exactly as that document says. A
passing suggestion in this session - that the four FSK bands of 23b72eb differ
by which handlers are installed rather than by coefficients - is wrong for
`@72`/`@73`/`@6b` and holds only for `@69`. The firmware
steers by rewriting that cell - `samm @65` at `83fc` and `8404` - so `83e6` and
`8406` are consecutive phases, not rivals. The second shifts DRR right by eight
before storing; the first stores the full word.

Which phase runs tracks the mode, measured by tracing writes to `0bd4`:

| run | dominant writer | value |
| --- | --- | --- |
| idle on the default source | `83ec` x3,009 | `ffff` |
| `&T1` on the default source | `840c` x1,881 | `0000` |
| `%D1` (either test rejected) | `840c` x2,430-2,895 | `0000` |

Eliminated as causes of the zero: destructive DRR reads (the model's read is
non-destructive), the AC01 secondary frame (gated on `m_rom_codec`, which this
endpoint does not enable), the boot download (all writes occur after PCM
activation, instrumented inside the run), `bsar` (shift 8, implementation
correct) and a mid-handler entry (a PC trace shows clean entries at `8406`).

`&T3` is rejected on both the default and `%D1` sources; the `&Tn` list in the
help strings is generic Courier text, not this card's command surface.

**Method note.** `CourierMachine.run()` rebuilds the CPU and re-enters at the
image entry each call. It is not resumable, so before/after windows must be
taken from inside one run - subclass the endpoint, not chunked `run()` calls.

## How a digital call reaches the card (2026-09-17)

Not by ringing. `S62`/`S63` are ANI and DNIS *digit counts*, the strings carry
`INCOMING CALL` and `COMMAND DENIED - MODEM IN USE BY TOTAL CONTROL`, and the
`ATA` path is gated on four RAM cells rather than any line state:

    c7d06  mov al, [0xa88c] ; and al, 3
    c7d12  cmp byte [0xa895], 6
    c7d19  cmp byte [0xa897], 0
    c7d2a  cmp byte [0x878a], 0
    c7d3f  (accepted)

`[0xa895]` has 116 readers and two direct writers: a constant `4` at `c840f`,
and `f7c93`, which takes its byte from the chassis request stream -

    f7c81  lodsb                  ; from the request buffer
    f7c82  mov [0x9c2c], si       ; advance the cursor
    f7c86  cmp al,1 ; jbe f7c93   ; 0,1 stored as-is
    f7c8a  cmp al,5 ; jbe f7c91   ; 2..5 stored +2
    f7c8e  jmp f795c              ; >5 rejected

`[0x9c2c]` is the request cursor `quad-bringup-blockers.md` already identified.
`[0xa897]` is set the same way and drives hardware: `>1` sets bit `0x40` in
`[0xff64]`, `<=1` clears it. A third writer at `ee474` initialises `a895`,
`a896` and `a897` together from the profile at ~1.3M instructions, which is
where the `04 / 00 / 01` the gates read comes from; a displacement scan misses
it because it writes through a pointer.

### The frame format

    f3ba2  lodsw ; sub ax,2 ; mov [0x9c72], ax   ; +4 length word, minus 2
    f3ba9  lodsw ; mov [0x9c70], ax              ; +6 type word
    f3bad  add bx,8 ; mov [0x9c2c], bx           ; body at +8

Delivery is `f4975`: copy the bytes to `0x9bac`, length to `[0x9cbf]`, then set
`[0x9bab] = 1`, which `f43ce` polls. `f3d24` seeds the cursor from that buffer
and calls the dispatcher `f4672`, which switches on the low nibble of the type
word through a table at `cs:0xb95` (segment base `0xf3b20`).

### Why a delivered frame does nothing

A well-formed frame written to `0x9bac` with its length and ready bit is not
consumed: the flag is still set at the end of the run. The gate is one cell.

    f7b62  test byte [0x9d1e], 3   ; -> 00, so retf, every time
    f7b69  dec  word [0x9d1c]

Measured: `[0x862c] = 14` (bit 4 set), so the periodic block runs and `c0b3c`
far-calls the interpreter service **64 times** in 12M instructions. Every call
returns at once because `[0x9d1e]` is `00`, and `[0x9d1c]` still holds its
`0x2ee0` reload. This entry is a session watchdog, not the receive path: arm,
count down, tear down. The arm site `f7b13` never runs; it sits in a sparse
handler table at `f75a2` beside its disarm twin `f7b34`, with `f470e` filling
every unused slot - so arming is itself a dispatched command.

`f4975` has no near caller and no table reference anywhere in the image, so the
receive path is entered from machinery nothing here drives. And
`[0xbdea..0xbdfe]` reads `00..00 ff ff ff ff ff ff` - the config block is
erased, the card unprovisioned, the same memory family as the `0xbae1` slot
identity the controller stamps per channel.

So the chain is: provision the card, open a session (`f7b13`), deliver a frame
(`f4975` / `[0x9bab]`), seed (`f3d24`), dispatch (`f4672`), write `a895`
(`f7c93`), and `ATA`'s gate at `c7d12` takes the other branch. Every link is
decoded except the first two, and both are the chassis side rather than
anything in this image. An earlier guess here - that a chassis-presence strap
gates the interpreter - is wrong: the service is called on schedule and
declines for want of a session.
