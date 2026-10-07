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

## C5x interpreter

The per-instruction diagnostic probes (V.8 dispatch capture, negotiation-loop
snapshot, ISR trace) are now off by default; set `COURIER_DSP_PROBES=1` to turn
them back on. `COURIER_C5X_LIBRARY` names a prebuilt library, for A/B runs.

The interpreter itself was then restructured, each step checked for identical
results from both processes: `step()` takes a short path unless a vector, IDLE,
the overlay entry, block repeat or a diagnostic is pending; the timer is brought
up to date only when an expiry is due or its registers are touched, and the
frame-rate events share one deadline; program and data space are classified by
byte tables (cached per CNF/OVLY/RAM/MP-MC/GREG combination, since some firmware
flips CNF in a tight loop); opcodes dispatch through plain function pointers;
and the common indirect addressing modes and on-chip RAM accesses are inlined.
On the filter-loop microbenchmark that is 26.4 -> 13.5 ns per DSP instruction
(247 -> about 145 host instructions each). On the full call the interpreter is
now only about a fifth of the I-modem process (Python is two thirds), so wall
time stayed at about 214 s: the call is Python-bound, not interpreter-bound.

Tried and dropped, because alternating A/B runs showed no gain (the fast build
was 3-5% slower in wall time): a circular-buffer mask for indirect addressing,
an inline timer fast path in `step()`, and raising the compiler's inline limits.
At about 250 host instructions per DSP instruction the cost is spread across
`step()`, addressing, dispatch and memory access, so a worthwhile gain needs a
structural rewrite of the dispatch/fetch/memory path rather than local tweaks.

## Python glue

A sampling profile of the full call (every 5 ms of CPU, both processes) puts
the I-modem at about a third native (C5x 20%, 386 engine 14%) and two thirds
Python, and the worker at about 27% native and 58% Python. The Python is a long
flat tail: no function above 4%, a few dozen between 0.7% and 3%.

Trimmed, with results bit-identical to before: one native call collects what a
DSP service pass reads (status, reply registers, transmitted octets) instead of
five; PIT counters are skipped until a wrap is due; the console pumps frame and
slice only when there is something to do; the T200 walk is skipped when no
timer has expired. That is 13% fewer Python calls and the full call went from
214 s to 206 s.

What the profile says is left, for whoever goes after real time next:

* In an active call about 80% of polls have a PCM batch to exchange, so
  skipping idle polls would save little. The exchange itself (flush, prefeed,
  bearer routing, the line clock) is about a quarter of the I-modem's time.
* Ports 0x1c/0x1e (the DSP host-port status and strobe) cause about half of
  the Python exits in both processes (roughly 550k of 1.0M in the I-modem,
  600k of 770k in the worker, per 250M instructions). Serving them in the
  native port models would remove those stops, but the models would then have
  to keep the mailbox's diagnostic logs (`overlay_recent` and friends) exactly.
* Reaching 120 s means the I-modem's Python going from about 125 s to about
  55 s; trimming alone will not do that.

### Host-port status and strobes, served natively

Both native port models now answer the DSP host-port registers 0x1c/0x1e for
the accesses that need nothing from the harness, which were about half of all
exits from the x86 engine:

* I-modem (`ImodemHostIo`): IN 0x1c (the mailbox status word, with the same
  host-pending/transmit-ready bookkeeping `_sync` does), IN 0x1e, OUT 0x1e
  (publishing the staged window words and raising the status bits) and OUT 0x1c
  with neither bit 0 nor bit 1 set. Commits, acknowledgements and replies to
  offer still go to Python. The 0x1e accesses are logged natively and replayed
  into the mailbox's `overlay_*` logs, in order, before anything else touches
  them (`ImodemDsp._drain_overlay`).
* Analog worker (`LaneHostIo`): IN 0x1c in the ROM protocol's runtime mode
  (from the DSP status latch plus two flags the harness publishes: a host
  message staged, a DSP message queued), IN 0x1e (the overlay status byte),
  and the writes of 0 to either port, which do nothing.

Python calls fell by 29% in the I-modem and 25% in the worker, and the full
call went from 206 s to 186 s with both processes' results bit-identical.

### The PCM bearer path, native

The I-modem's B-channel path is now native (`native/bearer.hpp`): the Am79C30's
bearer queues, the frames settled ahead of the DSP, and the exchange of
transmitted frames. `native_bearer.py` holds the Python views of that state
(the proxies `Am79C30` and `ImodemDsp` use in place of the old containers); the
Python methods are still the reference and take the frames the native path
leaves (underruns). `tests/test_native_bearer.py` runs both on random scripts
and compares everything.

On top of it the x86 engine can run the harness's poll itself
(`ImodemHostIo::poll`, called from the engine at each poll boundary). With a
call up on the bearer line it flushes and feeds PCM frames, advances the DSP and
settles what that finishes, and it calls Python only when something else in
`poll_timers` has work: a timer or service falls due (`elide_until`), a device
was touched (`poll_dirty`, set by every Python port handler except the
read-backs of the PIT, PIC and UART status registers), or the line clock has a
frame to send. `IsdnMachine._update_elision` decides, after each full poll,
whether the next ones may be skipped and until when; the engine hands back to
Python, partway if need be (`resume_service`), for anything it cannot do alone.
Interrupt sources that stay asserted (UART B's THRE) are raised by the skipped
polls too, so `_catch_up` does that to the controller before anything looks at
it. Serial pumps opt in by offering `next_due`. `COURIER_POLL_ELISION=0` and
`COURIER_NATIVE_BEARER=0` turn the two off.

Full call: 186 s -> 169 s (I-modem 148 s of CPU, worker 134 s), results
bit-identical. In a call about half the polls are now skipped. What still sends
the engine back to Python is mostly the timers: the mailbox service
(every ~2000 instructions), the three PIT counters and the RTOS tick each fall
due every few polls, and each one is a full poll and an interrupt delivery in
Python. Serving the PIC and those timers natively is the next step.

## Native PIC and timers

The interrupt controllers, the 8254's wrap bookkeeping and the service
deadlines now live in one ctypes structure (`courier_emu/poll_state.py`, mirrored
by `PollState` in `c5x_capi.cpp`). `Pic8259`, `Counter` and `IsdnMachine` read
and write its fields as ordinary attributes, so Python and the native model
share the same memory and never copy. The PIC ports (0xF020/1, 0xF0A0/1) are
served by the host-port model, and the native poll takes the timer wraps, the
RTOS and mailbox deadlines and the asserted interrupt lines itself, then enters
the interrupt in the engine (`enter_interrupt`). Python's dispatch charges one
retired instruction per injected interrupt, so the engine does the same
(poll code 4) to stay bit-identical.
`tests/test_native_port_models.py` checks the native PIC ports against the
Python controllers.

Full call: 169 s -> 155 s (I-modem 112.6 s of CPU, worker 140.6 s), results
bit-identical; about 208k of 244k in-call polls run natively. The I-modem is
now under the 120 s of line time; the analog worker is the limiter and needs
the same treatment (native poll, PIC and timers).

## The analog worker

The worker (one Courier board: 80186, C5x, codec model) is the longer pole once
the I-modem is native: its C5x runs the whole V.34/V.90 data pump, and its
80186 harness serviced every 1,024 instructions in Python. What was done, in
the order of what it cost, each step compared with the previous run's full
results (`tools/probe_imodem_analog_pair.py`, bit for bit):

- **Glue that built more than it needed.** Reading one serial counter built a
  70-key dictionary, a port-write count went through a six-field array, the
  resampler recomputed its Kaiser window for every kernel, and the overlay and
  ROM loaders single-stepped the C5x through ctypes. They are single calls now
  (`serial_backlog`, `io_port_writes`, `step_until_data`, a shared window).
- **MMIO and port reads served by the engine.** The 80186's end-of-interrupt
  write (142k a window) is logged by the native x86 engine (guard bit 64) and
  replayed in order before Python next runs; the panel latch at port 0x14 (103k
  reads a window, a polling loop) is worked out by the harness and served by the
  native port model until a panel port is written. Both only once the first
  events have been recorded verbatim, as for the lane ports.
- **A fast path for the service.** `service_chunk` is split into head, clock,
  tail and the interrupt sources, and `fast_service` makes the tests of the
  common service in one place and in the same order: nothing for the call state
  machines to start, the codec frame not due, the line not ready for a frame,
  the DSP silent. It declines before changing anything when a test says there is
  work and hands what is left of a service to the original code when a later one
  does. The DSP step is one call that also returns what is read next
  (`service_step`), and the DSP's frame interrupt (a quarter of a million
  entries per call) is entered in the callback instead of leaving the engine for
  the run loop and re-entering it (`redirect_is_free` keeps the dispatch edge
  uncharged, as the run loop's own path does). `COURIER_FAST_SERVICE=0` turns it
  off.
- **The resampler.** Its retuned path runs for the rest of a call once the codec
  clock moves, and was a quarter of the glue. The per-sample loop, including the
  samples at a clock edge, is native (`native/resample.hpp`); the dot products
  are CPython's `math.sumprod` (a triple-length accumulation, ported and checked
  against it on 200k random vectors), the Kaiser series uses libm's `pow` as
  `float ** int` does. `tests/test_resample_rate_changes.py` runs both on random
  streams with rate changes and compares every sample.
- **The C5x step.** A third of the worker's DSP steps are inside RPTB bodies and
  went through the rare path for the block-repeat edge; that edge is on the fast
  path now, and XC's condition sample is one register.

Full call, same machine, same results: worker CPU 140.6 s -> 109 s, I-modem
97-105 s (noise from the shared host is +-5%), wall 155 s -> 127-133 s for 120 s
of line time. Where the worker's time goes now (250M window): the C5x about 47%
(533M instructions at ~45 ns, dominated by a handful of filter loops and cold
once-per-frame code), the native x86 engine 13%, the harness the rest.

What is left, in the order it looks worth doing: the I-modem's call set-up (the
first ~35 s, where the poll elision cannot yet run because no call is up and the
worker waits for it), the C5x interpreter itself (a predecoded handler per
program address would cut the dispatch), and the remaining per-service reads of
the timers and the panel latch.
