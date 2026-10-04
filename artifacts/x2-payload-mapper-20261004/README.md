# Six-symbol PCM payload reconstruction

The larger C300 overlay in QF060003 now has a verified source-byte-to-codeword
path. The manual C lift matches the original DSP instructions, and an ideal
symbol-domain inverse recovers source bytes over continuous streams.

This is a bounded PCM core reconstruction. The supervisor edge selecting this
core during a complete x2 connection, the analogue receiver/equalizer, and the
complete peer negotiation are still unverified. The smaller C300 overlay is a
different filter implementation. Do not combine its instructions with this core.

## Payload rule

A frame consumes MD independent sign bits, then B amplitude bits, least
significant bit first. MD is 0 through 6; the configured rate table contains B
values 19 through 37. Let X be the amplitude integer and m[i] the six bank sizes.
In emission order, digit[i] = X modulo m[i], followed by X = floor(X / m[i]).
The selected bank entry supplies an octet, level index and reference sign.
A valid allocation needs product(m) >= 2^B and uniquely identifiable low-seven
codeword bits within each selected bank.

Input sign bits update a continuous XOR parity state. For MD below six,
positions rank by level index descending, with earlier positions first on ties.
The top MD positions carry independent parity toggles, assigned in emission
order. All other toggles are selected by an exhaustive minimum absolute
running-disparity search. Free-sign masks are visited descending; equal scores
retain the largest mask. The search includes eight times the signed delayed
monitor value. At MD six all toggles carry parity bits and no search is needed.

Sign toggles XOR bit seven of the reference octet. The ordinary output path
emits the octet XOR the configured final format mask (0 or 0x2A in these tests).
It also updates linear sample history, delayed disparity, energy and scaled
output samples. This lift covers local 039F bit 7 clear and FFD9 bit 12 clear,
with the builder's monitor coefficients and PM=1 for sample processing.
The alternate companding override has not yet been lifted.

## Source and inverse

B2BA calls the role-selected scrambler at 921B and appends 1 to 8 bits to the
128-bit ring. C5DF reads that same ring; C642 applies differential signs and
shaping; C544 dispatches the six sample steps and calls both stages. C544 tests
ring availability on every sample, requesting source data unless the count is
strictly greater than B+MD. Continuous tests prefill enough for this condition
to hold after the current frame has been consumed. Source callbacks and serial
queue delivery are outside the harness.

The ideal inverse reverses the final mask, finds each unique bank digit and
reference-relative sign, reconstructs X, then recovers independent bits from
successive parity values. Frame bits are assembled into bytes across boundaries
and descrambled with continuous history. This inverse assumes exact received
octets and known frame alignment; it is not a decompilation of the client DSP.

## Verification

Run `python3 tools/recover_x2_payload.py` from the repository root using the
repository Python environment. It compiles `payload_lift.c` with clang and
compares memory effects against NativeC5x executing the original stock-placed
firmware. The fixed random seed is 0xC5DF. Reports are regenerated only when all
checks pass.

| Check | Coverage |
| --- | ---: |
| Amplitude extraction and mixed-radix selection | 512 cases |
| Differential signs and disparity search | 1,024 cases |
| Source scrambling and ring append | 1,024 cases |
| Firmware banks and ideal frame inverse | 840 cases |
| Continuous original dispatcher sample steps | 1,260 samples |
| Continuous byte streams | 56 streams of 32 frames |
| Samples in those streams | 10,752 samples |
| Original bytes recovered | 8,400 bytes |

The aggregate 15,468 counts sum heterogeneous check units; it is not a count of
independent connection trials. The 30 constructed builder profiles cover rate
indices 1 through 15 with flags 0 and 1. Mode is zero for all fifteen indices. Builders execute with **SPM 1**;
prior SPM 0 constructor results are superseded. Continuous byte streams use
indices 10 and 15 and test all MD values, both source-role flags and both final
format states. Index 15 at MD=6 is the 43-bit/6-sample 57333 profile.

See `../x2-57333-profile-20261004/README.md` for the profile variants and
1792 additional exact-symbol round trips. These seeded profiles do not
establish an actual negotiated 57333 connection.

`example.json` records the first MD=3 frames of index-10 and index-15 streams.
Its source lists include prefetch beyond the first frame. `verification.json`
gives profile sizes, SPM context and the full check counts.

Source placement was independently established by all 28 full-length stock
controller overlay-copy comparisons. See the placement report in
`../x2-mapper-negotiation-20261004/placement-verification.json`.
