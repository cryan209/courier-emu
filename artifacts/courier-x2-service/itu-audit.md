# ITU audit of the failed Courier call

Sources inspected locally: ITU-T V.42 (03/2002), V.22 (11/1988), and
V.22bis (11/1988), in /Users/scottcryan/v90modem/ITU Docs.

| Requirement | Implementation / captured result |
|---|---|
| V.42 7.2.1.2: ODP is DC1 with alternating parity and 8–16 mark bits | RX audio recovers the expected alternating DC1 patterns, spaced 19 bits per character (10 character bits plus 9 mark bits). |
| V.42 7.2.1.3: recognize at least four alternating DC1 characters | Receiver requires two complete ODP repetitions. |
| V.42 Table 3: ADP is E/C, each followed by 8–16 mark bits | Actual TX audio recovers E/C characters at 18-bit intervals: 10 character bits plus 8 mark bits. |
| V.42 7.2.1.3: at least ten ADPs | Old implementation emitted nine. Corrected isolated service emits 32; audio confirms count. |
| V.42 7.2.1.2: originator recognizes two adjacent ADPs before establishing LAPM | Courier never sends flags after our ADP. |
| V.42 9.1.1: default T400 is 750 ms | Courier ODP burst contains about 23 pairs, roughly 728 ms. This suggests, but does not prove, expiration of its default detection timer. |
| V.42 7.2.1: use carrier-clock bits, without async speed matching | LAPM/detection is connected directly to datapump bit callbacks, bypassing V.14 character framing. |
| V.22bis 5: scrambler polynomial 1+x^-14+x^-17 | TX taps at zero-based positions 13 and 16 match. Output-run-of-64 inversion rule also matches V.22bis. |
| V.22bis Table 1 and 2.5.2.2: 00=90°, 01=0°, 10=180°, 11=270°; use constellation position 01 at 1200 | phase_steps={1,0,2,3}; 1200 selects constellation index 01. |
| V.22bis 6.3.1.2.2: answer sends scrambled marks, waits 765±10 ms before data | TX uses 756 ms, within permitted tolerance. RX/TX readiness sequencing still needs a full independent audit. |

The latest TX waveform independently demodulates to 32 E/C pairs and 74 flags.
The RX waveform independently demodulates to 47 ODP characters, no flags.
Independent here means a separate decoder invocation; it still uses the same
SpanDSP implementation and does not validate a waveform at the Courier input.

Timing risk: service receive jitter buffer is fixed at 200 ms. This consumes
200 ms of the originator's response budget before ODP reaches our detector.
ATA buffering, packetization, TX delivery and receiver qualification add more.
Do not subtract positions in TX/RX files as if their origins were calibrated.
A controlled endpoint-only experiment reduces fixed buffering to 40 ms;
it preserves fixed playout and disables discarding as before. This is a
hypothesis test, not a confirmed connection fix. No user data is required
before protocol establishment; no activation has been sent.
