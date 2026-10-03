# Live RasFinder overlay audit

The repeated call used native firmware and no foreground overlay assist.
At live completion, startup destinations d100 (7536 words) and 9260
(16000 words), then call overlay a000 (13912 words), all match their
transported words exactly. Destination advancement matches each transfer.
There are exactly three completed transfers and no later overlay requests.

After a000 completes, the firmware executes and changes native receive
callbacks (93f4, 9406, 941e, 9458, 97b2, 97e1, 97eb, 980a, among others).
Transmit callbacks cycle through 9e45 and 9e82 with sequence pointers
9e0c and 9e08. At 9e45 the native generator sets polarity state to one
and branches to 9e7a, which produces a fixed constellation point. At
9e82 the transmit callback returns. These states precede the later
V.34 S/PP/TRN/J generators previously examined in the offline pair.

No 0034 symbol-rate report, native retrain report 0006, or Hayes CONNECT
appears before the instruction limit. The overlay is complete and its
training logic is running; the exact unsatisfied receive detector still
needs a focused trace. An absent subsequent mailbox reply must not be
interpreted as proof that the loader stalled.
