# Courier MP fields and the 53333 result

5 October 2026. Profile: captured Courier 403 board ROM SHA-256
`f1c91621fbf14aad34547056feb4425e64fcf0b38ec5d57f86c9f432ca999db6`,
paired with `Ie030002.nac`. These addresses belong to that Courier profile,
not the 3453C XMF or the Quad server.

## Four-word MP and N1

The line-decoded MP has seventeen ones, a zero, four LSB-first words each
followed by zero, sixteen LSB-first CRC bits and two trailing zeros: 104 bits.
CRC starts at FFFF, uses reflected polynomial 8408, excludes separators and
has no final XOR. The body `0344 03FE 0000 0500` gives CRC `14AD`.
The earlier claim that this frame fails the V.34 CRC/layout test is superseded:
it is a four-word record, rather than the three-word standard MP layout.

The native builder first computes a local ceiling with E2DD. In the live call
that result is 12. F86E saves it in 037D, and the first F895 call packs it.
F874 saves the recovered N1 at 031C. The delayed call at F875 then executes
`SPLK @7D,#0001` in its delay slots and calls F895 again. This forces the MP
input to one while preserving the saved local ceiling.

F8A1 loads the allowed mask at FFF3. A661 computes its highest set bit,
returning a one-based ceiling. In the call FFF3 is 7FFD and its ceiling is 15.
F8AA loads W2, masks it with 7FFF and calls A661 again: 1FFE has ceiling 13.
F8B1..F8B7 takes the smaller of 037D and the FFF3 ceiling and combines it
with that W2 ceiling:

```
N1 = min(data[037D], bit_length(data[FFF3]))
N2 = bit_length(W2 & 0x7fff)
returned_fields = (N1 << 2) | (N2 << 6)
```

The second call therefore returns 0344, with N1=1 and N2=13. F87C writes it
to 0940 at DSP instruction 956242670. F58F reduces W2 from 1FFE to 03FE
five instructions later; it does not rebuild N2. This explains why the encoded
N2 exceeds the final mask ceiling. A536 later sets W1's acknowledgement bit,
producing 8344 at instruction 983920584.

`tools/verify_courier_mp_fields.py` executes the original F895 packer in 1536
controlled contexts, including empty and sparse masks, and verifies the full
returned field value and W4 byte preservation. These are local component
checks, not analogue measurement or automatic call scheduling tests.

## W4 and the rate offset

F895..F89C writes:

```
W4 = (data[0364] << 8) | (previous_W4 & 0xff)
```

The live write trace shows W4 cleared at F715 and then written as 0500 in
both F895 invocations. Its low byte is therefore zero in this MP, preserved
from the clear. Its general protocol meaning is still unassigned; this
trace does not establish that every peer or mode uses zero.

0364 is an additive bit-count parameter as well as the offset used by the
rate selector; it is not a standalone line rate. In the separate variable-length
client path, EA82..EABC selects a one-based mask index N, stores it at 031C
and passes `N - data[0364] + 20` at 037D to the continuation. E970..E97B
performs the same conversion on the five-bit local-header field and stores it
at 0351. E11C..E14B adds 0364 to 0351 and consumes that many input bits.
With 0364=5, the intermediate count is N+15, but the total is **N+20**.
Original E11C execution with a return-only per-bit callback verifies this sum
in 216 contexts: counts 20..43 and additive values 0..8. In particular 0351=35
and 0364=5 produce forty callbacks. In the six-sample allocation model,
N=20 gives K=40 and nominal rate `40*8000/6`, or 53333 bit/s. Five accounts
for five bits in that sum; assigning those specifically to independent signs
still requires the downstream mapper/receiver connection. This interpretation
must not be applied to the forced N1=1 bootstrap MP as a completed allocation.

## The bit 9 instruction

The live trace identifies F8CB (`5D80 0200`, `OPL *,#0200`, AR1=006F).
It writes 0243 at instruction 910792158. F8CD immediately adds 0800,
writing 0A43 one instruction later. Both are in F8BD's receive check:
the timer must not have failed, 034B must be zero, the two recovered words
0342 and 0343 must match, and 0343 must equal 09B0. Thus bit 9 is set in
response to the server's repeated 09B0 word, before MP construction.
The later second AEDE pass uses this bit to choose four bits per symbol.

## Does the later client record explain this 53333 result

No execution of the known variable-length client exchange was observed in
these calls. Coverage gives zero for E724 (initializer path), EA82
(selector), EAB2/EABA (selected index/header writes), EAC7 and EAD6
(body/acknowledgement preparation), and E970 (header-to-allocation conversion).
The separately enabled EA82..EABC PC trace is empty. The watched 0940..0946
buffer has no later record construction after its acknowledged MP.

The live F856 trace already obtains local index 12 before the forced-one MP;
031C retains 12, and the host reports include 006A:0A0C and later 0020:000C.
The Courier terminal prints `CONNECT 53333/ARQ/x2/LAPM/V42BIS`, while the
server prints `CONNECT 33333/ARQ/x2/LAPM/V42BIS`. Index 12 agrees with the
recovered x2 nominal-rate ladder. This supports a retained local-rate result,
not the proposed causal sequence of this MP followed by the known variable
client record. The continuation audit below establishes the Courier formatter
chain and the I-modem's live MP-to-rate selector. The complete I-modem record
receiver and payload rate remain distinct verification boundaries.

## Continuation: the DSP-to-supervisor rate chain

Three additional capped calls establish the reporting path in the actual
Courier 403 / Ie030002 pair. Evidence and original-instruction checks are in
`artifacts/x2-courier-rate-report-20261005`.

The first E2DD invocation is the F86A call. Its input is 4220, after F864
loads 4020 and F868 adds 0200. E2DD's optional FFF4 bit-12 subtraction is
inactive. The signed FFFB adjustment is FF00 (-256), taking the metric to
4120. With 039F bit 7 clear, E2EB subtracts twice 037B shifted by eight:
037B=1 subtracts 0200, giving **3F20**. The descending threshold search at
E2F3 tries 4680, 4100, 40C0, then 3EC0. The last is the first threshold no
greater than the metric; E2FC returns **12**. These are fixed-point firmware
values; their physical measurement units are not inferred here.

The fifteen-entry threshold table resides at overlay-1 program C77D and is
available at data CF2C. Its index-12 threshold is 3EC0 and its index-13
threshold is 40C0. Thus 3EC0 <= 3F20 < 40C0. Original E2DD execution verifies
both sides and equality at every threshold, including duplicate thresholds:
46 cases. Subsequent training invocations can return other indices; they do
not replace the value saved by the first F874 write in these calls.

The native reporting sequence is:

| Stage | Original instructions | Effect in the call |
| --- | --- | --- |
| Retain local ceiling | F86E, F86F, F871..F874 | Store 12 at DSP 031C |
| Force peer-facing MP N1 | F875 delay slots F877 | Set 037D=1; preserve 031C |
| Queue rate-report tag | E20A..E20C through 83B1 | Queue 806A |
| Resolve the other direction | E19C..E1A2 through A63A | Save 10 at 087A |
| Build report argument | E1A3..E1AC | Form (10<<8)+031C = 0A0C; queue through 83B1 |
| Receive tag 6A | Supervisor 93CD9..93D08 | Set x2 mode and call 94399 |
| Decode mailbox argument | 94399..943C1 | Read 5E high then 5C low; mask low with 001F; store 12 at 0A19, 0A27, 0A17 |
| Resolve result enum | 82FB9..83052 | x2 branch uses 0A27 and result/ARQ flags; return E3 |
| Select literal suffix | 89F57..89F5F | A1EB[E3] points to AC78, literal 53333/ARQ/x2 |
| Print CONNECT prefix | 89F78 -> C800:0044 -> CA811 | Emit CONNECT and continue normal result output |

E1A8..E1AB chooses 031C while FFF4 bit 1 is clear; its alternate uses 0347.
The high-byte resolver follows the peer's N2 and local mask and returns ten
in this call. It is not the Courier's x2 displayed-rate selector. The wire
N1 value one does not overwrite the saved local index twelve.

The new supervisor write trace shows 0A27 becoming 000C when tag 6A is
consumed, and being preserved by 93D77. The original result selector with
0238 bit 2 set, 04E2=3 and 022A bit 0 set returns E3; the literal is at
physical 8AC78. A later disconnect reset at 88964 changes 0A27 to one.
Consequently a final RAM peek alone misleadingly reports one even though
the connection was reported from twelve. Native supervisor memory-write
callbacks record the following instruction pointer; e.g. recorded 943AA
identifies the store at 943A7. DSP write traces name the actual writer.

The original x2 result table is not linear at its two lowest entries:

| One-based rate index | Nominal result bit/s |
| --- | --- |
| 1 | 33333 |
| 2 | 37333 |
| 3..15 | floor((index+28)*8000/6) |
| 12 | 53333 |

The DSP report builder passes 45 controlled contexts, preserving MP N1=1
while varying saved indices and masks. The original supervisor handler,
result selector and pointer lookup pass 150 contexts covering all fifteen
indices, high low-byte bits, verbosity and ARQ flags. This verifies original
firmware behavior rather than a replacement host rate calculation.

## Continuation: what the same MP does on the I-modem

Ie030002's live CFF4 selector calls ABBC with direction one. Its x2 branch
at AC07..AC26 reads W1 at 0340, extracts N1 and intersects its ceiling with
local allowed mask F6D9. For received 0344 and local mask 7FFF this returns
one. CFF8 subtracts one, CFF9 stores zero at 03A2, and CFFC reads the first
entry of table D24A into 03C0: **19**. The live PC trace records returned
one at CFF8, zero at CFF9, W4=0500 at D009 and its high byte five at D00C.
The working MP cells remain 0344/03FE, and the I-modem terminal reports
CONNECT 33333/ARQ/x2/LAPM/V42BIS.

The selector and D24A table are in Ie030002 image 6, loaded at A000, not
the overlapping image-11/image-10 pair. Fifteen original selector contexts
verify every N1 ceiling against the same full local mask. Table entries are
19,22,25,26,...,37, consistent with the shared nominal ladder's first two
special indices. The sampled 03C0 value establishes the selected allocation;
it is not a measured terminal payload throughput.

The high byte of W4 has a direct source-count effect on this receiver branch.
D00C stores it at 03ED. CC95..CC99 removes that many bits from the source
ring into 03E3; the following amplitude extraction removes 03C0 bits. Original
CC95..CCBE execution verifies the total cursor advance **B+MD** for all
fifteen amplitude entries and MD=0..6, at both zero and a wrapping cursor:
210 contexts. CE85..CE99 feeds the MD bits through the differential-sign
recurrence, while the MD-not-six branch prepares the remaining sign choices.
This locates five as the supplied sign-bit count in the I-modem branch; it
does not assign every use of Courier 0364 to the same downstream function.

In this live selected context B=19 and MD=5 give **24 source bits per bit
consumer invocation**, distinct from the nominal table's K=25 for index one.
The firmware's displayed label therefore does not itself verify the usable
payload rate. The callback cadence and full data path must be connected before
turning this local bit count into a measured throughput claim.

The reported asymmetry is therefore accounted for without the unexecuted
variable-length client exchange: **the Courier retains and displays 12;
the MP supplies N1=1 to the I-modem's transmit selector**. The later-variable
record hypothesis is unnecessary for these observed CONNECT outcomes.
This does not yet establish that the short MP alone completes every receiver
state or that 53333 is the measured usable payload rate.

## Evidence and reproduction

`artifacts/x2-courier-mp-20261005` preserves original listings, the component
verification, compact live flag and buffer write traces, and coverage results.
The raw call results and dumps were inspected before these compact extracts
were made. The record extract starts at instruction 745909000 because the
same buffer was heavily used as training scratch before it became the MP.

```
.venv/bin/python tools/verify_courier_mp_fields.py
COURIER_DSP_TRACE_LIMIT=10000 COURIER_DSP_DUMP=/private/tmp/x2-mp-flags \
.venv/bin/python tools/probe_imodem_analog_pair.py \
  --analog-settings 'X1S27=1S54=0S58=48&A3&B1Q0&U26&N39' \
  --imodem-settings 'S54=0S58=48&A3&B1Q0' \
  --imodem-nvram artifacts/imodem-pair-x2-full-rate-routed-20261002/nvram-230400-switch2.sav \
  --instructions 300000000 --analog-instructions 220000000 \
  --analog-dsp-write-watch 006f --analog-dsp-trace-range f856:f8b8 \
  --analog-dsp-peek 0364 --analog-dsp-peek 037d --analog-dsp-peek 031c \
  --output /private/tmp/x2-mp-flags-call
```

For the buffer run use `COURIER_DSP_WATCH_LAST=0946`, watch 0940, and set the
PC range to EA82:EABC. Use distinct output/dump directories. A full-length
call can reset the DSP and discard its earlier trace; the capped call preserves
it. Broad ranges containing hot signal-processing scratch can fill the trace
and slow the run; narrow field ranges retain the relevant writes efficiently.

For the continuation run add `--analog-mem-watch 0a17:0a28`, watch DSP 031C,
and use `--analog-dsp-trace-range e2dd:e307` for threshold arithmetic. In a
separate call use `--dsp-trace-range cff4:d01c` for the I-modem selector.
Run `.venv/bin/python tools/verify_courier_rate_report.py` for the component
checks. Compact live extracts retain the original writes and PC traces.

## Continuation: the upstream E boundary

The short MP is followed by a separate upstream E event. Courier script
AE83 is the triplet `AF2E,0,5`, then `AF99,0,0`. With 006F bit nine set,
AF2E does not double the five-symbol count; AF38 supplies nibble 000F to
the same AF7D scrambler/16-point transmitter used by MP. That is five
four-bit all-one source symbols, twenty decoded ones, before the data mapper
initializer AF99. This does not identify the subsequent complete B1 frame.

Ie030002 AABF clears its consecutive-one counter. A881..A889 increments
0323 for a one and clears it on a zero, then invokes the saved bit coroutine.
AAC4..AAC6 waits for seventeen ones, and AACB..AACD waits for twenty before
jumping to A891, which runs the data receiver initializer AAD3. A zero after
the seventeen-one sync returns to the record parser at A941; it is not an
E acknowledgement. `tools/verify_x2_upstream_e.py` executes the original
dispatcher and coroutine in nine contexts: sixteen through nineteen ones
wait, twenty enter A891, and an interrupted nineteen-one prefix returns to
the record path. The harness starts after record acceptance; it does not
reconstruct that acceptance or demodulate audio.

The v90modem MP receiver now detects the twenty-consecutive-one boundary on a
hypothesis that already has two matching CRC-valid MPs. Bits inside an MP
body cannot contribute to that run. The preserved PCMU fixture includes the
E boundary: detector sample 11434 within bearer samples 88640..100959,
or absolute sample **100074** (12.50925 s, detector time including filter
latency). Input blocks of 1, 17 and 160 give the identical sample. This is
a receive detection timestamp, not the unfiltered transmitted E endpoint.

Full engine replay retains INFO0=21FF, marker=4D, MP=0344/03FE/0000/0500,
and downstream startup/payload activation, and now records upstream E.
An opt-in `ME_X2_UPSTREAM_ACQUIRE=1` experiment prepares the existing V.34
T/3 receiver for 3200/high, N=10 (24000 bit/s), linear encoding and 16-state
trellis, then begins B1 acquisition on E. It fails to acquire the preserved
recording; the template fit remains below 25 percent and the engine stays
in TRAINING. E reception therefore does not establish an upstream data lock.
The next boundary is the Courier AF99/AFC9/B006 mapper reset and framing,
compared with the receiver's B1 template; no adjustment to the E threshold
or rate label is justified by this failure.

Original listings, component results and both engine replay logs are saved
in `artifacts/x2-upstream-e-20261005`. The acquisition experiment remains
off by default; no CONNECT or decoded upstream payload is claimed.

### Continuation: upstream B1 acquisition

The fresh original Courier B1A1..B1C2 trace confirms upstream rate N=10:
B1B4 holds ACC=000A before the A71B mapper builder. The built parameters
are B=60 bits per eight symbols and Q=3, hence 60*3200/8 = **24000 bit/s**.
This upstream rate is independent of downstream N1=1 and W4's five signs.

Controlled execution of B1A1, AF99 and B006 from the retained original DSP
snapshot reproduces 480 mapper symbols. Seeding received word 0340=F37C,
mask 0941=03FE, direction 039F=4060 and baud index 03DB=4 yields expanded
shaping and the 64-state trellis. Against the SpanDSP all-one reference,
minimum/16-state matches only 49 complex symbols; expanded/64-state matches
475, and all 480 amplitude norms match. Five remaining rotations require
further mapper/frame-epoch analysis; the seeded execution does not establish
a complete wire MP field decode.

The captured audio resolves the acquisition choice independently. Searching
minimum/expanded shaping for x2 alongside the existing scrambler/trellis
candidates selects GPA, expanded shaping and 64 states with **99.9% fit**.
The independent 256-symbol post-B1 check has mean lattice distance 0.252,
mean power 147.2 against template power 147.7. The 95% acceptance threshold
and post-B1 validation remain unchanged. The winning shaping and trellis
are retained for DATA decoding, and x2 acquisition now runs by default.
Recorded regressions pass at block sizes 17/160 and reject silence; all
402 V.34 data decoder cases pass. Evidence and original-instruction
reproduction are in `artifacts/x2-upstream-b1-20261005` and
`tools/verify_x2_upstream_b1.py`.

This closes the earlier B1 acquisition failure. Upstream DATA has substantial
shell/frame errors and is not a verified payload stream. The engine still
ends TRAINING and gates CONNECT/user bits. Next resolve the mapper/frame
inversion epoch and verify V.42/LAPM upstream before opening that gate.
