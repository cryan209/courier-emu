# Six-position PCM preparation under conditional Quad alignment

QF060003's larger PCM overlay, as previously extracted at flat 5c1f0,
starts with ffff. Internal targets consistently refer one word before the
previously identified routine bodies. Omitting that first word makes calls,
branches, and table references coherent. This is a **conditional placement**:
the stock supervisor/DSP transfer has not yet proven that the first word is
omitted. Production overlay constants remain unchanged.

Under this placement, original instructions and manual C match in 8,384 cases:

- C6E5 counts nonzero entries in six two-bit position fields (4,096 cases).
- C6F4 distributes two byte-sized candidate sizes to six positions; zero
  fields choose the high-byte size and nonzero fields choose the low byte
  (4,096 cases).
- C92A expands six working banks from source 0A60 (zero field) or 0880
  (nonzero field), consuming two control bits per bank. An odd field ORs
  0100 into each entry. The banks start at E8F4 and advance by 0080 words.
  Copy counts are last indices, so a count of 3 copies 4 words (192 cases).

Under this same placement C9BF copies the paired nine-word tables:

A5 A7 AD AF B7 BD C5 CF E5
95 97 9D 9F A7 AD B5 BF D5

This supersedes the interpretation of the old raw helper outputs as valid
constellation tables: those outputs included one preceding value and omitted
one final value. The existing raw helper tests show isolated equivalence,
not correctness of the full load map. The EF00 selector result from the old
placement likewise must not be taken as a real mapper pointer.

The six-position preparation is consistent with the existing six-symbol
rate analysis. No alignment waveform, complete payload mapper, PCM law,
flag meaning, or receiver inverse is inferred solely from these routines.

Run `.venv/bin/python tools/recover_x2_mapper.py` to regenerate the conditional
listing and comparison report. This test does not use hardware or patch the
original program instructions. It only changes which extracted word is
placed at the stated overlay origin in its component runner.

Negotiation documentation now includes the seven-bit body layout and the
41-bit transmit script (39 framed bits plus two lead-in ones). The shared
seven-bit detector is an INFO preamble detector from pre-x2 firmware, not a
verified receiver for that proprietary body. See the correction in
`docs/x2-v90-protocol-selection.md`.
