# PCM received record to rate banks and payload source

4 October 2026. This executes the QF060003 server PCM handoff from decoded
input bits through record acceptance, rate selection, bank construction,
mapped output and payload-source activation. The larger C300 PCM overlay
is used with 039F=8040 (bit 7 clear), SPM 1 and constant-one cell 03FB=1.
It is shared PCM firmware evidence. This is not yet an established x2 call,
a demodulator test or proof that the client negotiates every seeded record.

## What the original instructions now establish

| Stage | Original entry or cells | Executed effect |
| --- | --- | --- |
| Receive bit dispatch | A9EA, 0320, 0322, 0343 | Dispatch decoded bits through the saved receiver continuation |
| Framed record receiver | AAA4 through AAF8 | Collect four words and check CRC before committing parameters |
| Commit accepted record | AB06, AB24 | FF48/FF49 to 0340/0341; FF4A/FF4B to E8F1/E8F2 |
| Schedule handoff | AA45, 03CD | Select program script C7E7 for the tested local mode |
| Startup samples | B096, C7E7, C4AB/C4AD | Six sample callbacks; then select C52A |
| Select rate and construct banks | C52A, C85E, AC34, C862 | Select rate from peer limit and local mask, then construct all six banks |
| Mapped sample phase | C544, C5DF, C642 | Group scrambled bits and emit six codewords per frame |
| Payload source activation | C52E after 0FF0 samples | Set 006F bit 2 and FFD9 bit 1; queue 0003; install source 84FB |

No preselected rate is passed to C862 in these integrated tests. No working
record or mapping bank is written by the harness after record reception.
Local call state, the allowed-rate mask, synthetic decoded input bits and
source octets are supplied by the harness. C840 initializes the original
startup banks before AA45 selects the handoff script.

## Tested record framing and CRC

In the tested receiver branch the framing is at least seventeen one bits,
then zero, then four LSB-first 16-bit words, each followed by a zero separator,
then sixteen LSB-first CRC bits. The CRC starts FFFF and updates as follows:

```
v = crc XOR incoming_bit
crc = (v >> 1) XOR (0x8408 if v & 1 else 0)
```

There is no final XOR in the tested comparison. Separators are excluded from
the CRC. AAA4 initializes the receiver continuation; the harness then calls
the original A9EA bit dispatcher rather than injecting decoded words. AAF8
compares computed and received CRCs. Only the matching branch reaches AB06
and copies the staging record to the working parameters. Corrupt packets
can overwrite the staging buffer but do not commit the working record.

This four-word PCM record receiver is distinct from the still-unidentified
receiver for the short proprietary seven-bit directional announcement.
It must not be presented as a recovery of that announcement's framing.

## Rate selection

For the tested PCM transmit direction, C85E supplies direction selector one
to AC34. The peer ceiling occupies bits 2 through 5 of received word zero.
AC34 masks local allowed-rate word FF39 with a ceiling mask and finds its
highest surviving bit:

```
peer_limit = (received_word_0 >> 2) & 15
eligible = local_mask_FF39 & ((1 << peer_limit) - 1)
selected_local_index = eligible.bit_length()
builder_table_index = selected_local_index - 1
```

Bit zero permits local index one; bit fourteen permits local index fifteen.
This chooses the highest allowed index below the peer ceiling, including
sparse local masks. With peer limit fifteen and local mask 3FFF the result
is index fourteen (B=36); with mask 0081 it is index eight (B=30). With mask
7FFF it is index fifteen (B=37). These correspond to 56000, 48000 and
57333⅓ bit/s when the record independently supplies MD=6.

The peer ceiling, local index, B and MD are distinct. The received record
also carries mode and position controls, which select the bank descriptor
row and contents. The handoff does not search all possible constellations
for the channel: it consumes the selected record.

A zero eligible mask returns index zero in the resolver tests. The harness
does not pass that sentinel into C862; the upstream refusal/fallback path
remains outside the integrated success cases. Other AC34 directions and
039F bit-7 branches are outside this formula's verified scope.

## Later source activation

Program C7E7 holds callback/parameter/count triplets:

```
C4AB, 01FF, 0006
C52A, 0000, 0FF0
C52E, 0000, 0000
0000
```

B096 loads the first triplet. The sample-output tail decrements the count
and advances the script. C52A resolves the rate, constructs banks, sets an
eight-bit source width/mask and replaces its callback with C544. The 0FF0
sample countdown continues through that replacement. After 4080 mapped
samples it advances to C52E. C52E enables the source gate, sets FFD9 bit one,
queues word 0003 through original 86CD, initializes source state and installs
84FB before continuing at C544. The host interpretation of 0003 and complete
external byte-queue delivery are not established by this test.

The harness keeps the bit ring supplied through original B2BA calls. This
allows uninterrupted scheduler execution and isolates the transition from
unreconstructed external source queues. It does not establish that the
4080 earlier mapped samples carry terminal payload in an actual call.

## Verification and remaining boundary

Run `.venv/bin/python tools/trace_x2_rate_handoff.py`.

- 1249 rate-mask/peer-limit comparisons, including all one-hot bits against
  all fifteen nonzero ceilings, random sparse masks and zero masks.
- 128 accepted four-word records and 256 corrupted-record rejections.
- 40 integrated record-to-rate/bank/data contexts, covering all fifteen local
  indices, both output states, additional rate-15 bank variants and reductions
  imposed by sparse local masks.
- 1280 exact-symbol frame inverses across 7680 continuously dispatched samples.
- One complete 57333 scheduler countdown through payload-source activation,
  including the queued notification and installed source callback.

Evidence is in `../artifacts/x2-rate-handoff-20261004/verification.json`,
`57333-trace.json` and `handoff.asm`.

The client side now has execution-checked rate-mask selection, position
classification and variable-length body construction in both pre-V.90
3453B 2.1.1 and later 3453C 2.3.33. Their original serializers also execute;
64 four-word bodies from the later client pass this server receiver. See
[x2 client measurement records](x2-client-record-production.md).

The 5EC3..5F11 bitmap summarizer is a host diagnostic report, not the peer
record producer. The variable-length client body preserves five header words,
then packs position controls and representative bitmaps; it has 15..103 words.
It is not yet connected to this four-word branch. Analogue measurements,
automatic exchange scheduling, complete call-state selection, peer alignment,
the short announcement and analogue payload decoding still require tracing.
