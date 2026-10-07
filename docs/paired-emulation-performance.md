# Paired I-modem / analogue Courier: where the time goes

Measured on the documented x2 call (53333, both payloads), 120 s of line time:

| Build | Wall time | Versus real time |
|---|---|---|
| Original | 485 s | 4.0x |
| After the first round of changes | 372 s | 3.1x |
| Native lanes, cheap DSP probes | 250 s | 2.1x |
| Native I-modem port model | 216 s | 1.8x |
| Batched PCM exchange | 209 s | 1.7x |

The I-modem process is the limiter (about 199 s of CPU against 165 s for the
analogue worker), roughly a third of it in the C5x interpreter and the rest in
Python: the 8 kHz PCM exchange with the DSC (about 960k frames), the per-chunk
service pass, and the port accesses that still leave the native engine.

## Switches

- `COURIER_NATIVE_IO=0` runs the I-modem's lane ports and DSP advance through
  the Python handlers instead of the native port model. The I-modem's complete
  state is bit-identical either way; use it to bisect a behaviour change.
- `COURIER_LINE_WINDOW=N` (with a smaller `COURIER_LINE_FRAME_MS`) lets each
  modem run N-1 line frames ahead of the other. It did not help here, because
  neither process waits long, and it shifts the negotiated rate (52000), so it
  is off by default.

## The PCM exchange

Each 8 kHz frame the I-modem's DSP finishes is exchanged with the DSC model
in Python. The DSP now runs on through several frames between visits:

- The network side of upcoming frames comes from the DSC's B-channel queues
  alone (for an ordinary call), so it is settled ahead of time and fed to the
  core (`Am79C30.bearer_take_ahead`), only past octets that are really queued
  on the call's channel. Anything else - an empty queue, a line that is down,
  a route that loops one peripheral slot to another - falls back to the
  frame-at-a-time path.
- The native advance stops for a reply, a transmit backlog or an empty
  receive queue, not for each frame, and the finished frames are exchanged in
  bulk (`bearer_finish_batch`).
- Frames are still exchanged at the start of every poll, before the bearer
  reads what the modem sent, and around any write to the DSC, because the
  bearer's stall logic and the MUX registers need that. That is why the gain
  is small: there is no later point to defer the work to without shifting the
  line's timing. (Deferring it did save more CPU, but moved the negotiated
  rate to 49333-52000.)

The I-modem's state matches the one-frame-at-a-time path bit for bit apart
from the receive octets held ahead. `COURIER_PCM_BATCH=0` turns it off;
`COURIER_PCM_BATCH=1` runs the lookahead with a flush after every frame.

## What did not help

- A cache for repeated status reads: only about 10% repeat an unchanged answer.
- Servicing the BRI every other poll: no change in CPU.
- A 1024-instruction timer poll or a 128-instruction read quantum: both change
  the negotiated rate or the run length.

## What would

Serving the mailbox's `0x1c`/`0x1e` ports natively on both modems, and a
faster C5x interpreter (its cost is spread over fetch, addressing and cycle
accounting rather than any one hot spot).
