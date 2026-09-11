# I-modem task roles from code and queue routing

Analysis of Ie030002, following the nine task entries verified in
[the startup trace](imodem-vrtx-startup.md). Roles below distinguish actual
behavior from inferred expansions of proprietary abbreviations. Selected
instruction spans and identifying strings are saved in
`artifacts/imodem-task-roles/disassembly.txt`.

## Task map

| Task / ID | Input queue | Behavior | Interpretation and confidence |
|---|---|---|---|
| TID_TOUT / 1 | 0, QID_TOUT | Woken by periodic timer service; removes an expired timer and dispatches its event. | Timeout processing, confirmed. Not terminal output. |
| TID_T3L2 / 4 | 3, QID_QIDL3L2 | Dispatches upper-layer requests to the layer-2 link state machinery at `6806:0009`. | Layer 3 → layer 2 worker; strong queue-name and code evidence. The exact spelling of the T prefix is not recovered. |
| TID_CES3 / 2 | 1, QID_CES3 | Passes requests into signaling/call-state processing at `616b:000f`. | CE → signaling layer 3; strong structural evidence. CE is the call-control executive side; its original full name is not present. |
| TID_S3CE / 3 | 2, QID_S3CE | Dispatches signaling primitives at `6b39:0002`, including forwarding selected events toward layer 4. | Signaling layer 3 → CE, confirmed direction by paired queues and the handler's `NLS_CE_PROC` diagnostic. |
| TID_L2S3 / 6 | 5, QID_L2S3 | Delivers link-layer indications/data to `5f41:0000`, with an alternate protocol path at `4546:0009` selected by channel configuration. | Layer 2 → signaling layer 3; strong evidence. Includes call-signaling packet processing. |
| TID_P3CE / 9 | 8, QID_P3CE | Accepts only event codes 4 and 7 in `6c37:0003`; forwards these through `6efe:0ab4` to queue 10. Other codes have no handler action. | P3 → CE relay, behavior confirmed. “Packet layer 3” is a plausible expansion of P3, not established by this code. |
| TID_LLL2 / 5 | 4, QID_LLL2 | Passes lower-layer messages/frames into `666c:0009`; parses frame address fields and selects a link context. | Lower/link layer → layer 2 receive worker; strong evidence. Exact LL expansion is not recovered. |
| TID_MODEM / 12 | Not one of the C queue-wait loops | Starts at `a400:0008`, initializes DSP-related state, then continues the modem firmware path. Uses callbacks into the call-control/layer-4 code. | Modem supervisor task, confirmed name/startup. No verified AT-to-OK exchange yet. |
| TID_CEML4 / 10 | 10, QID_CEML4 | Calls `7561:0009`, which dispatches connection, disconnection, release and status indications to modem/layer-4 handling. | CE → modem layer-4 interface; strong evidence, supported by the handler's own primitive names. |

Most of the short C tasks are queue consumers that call a larger protocol
handler and release the received message buffer. They are workers at protocol
boundaries, not nine independent applications.

## Why TOUT is timeout processing

The chain is explicit:

1. The periodic interrupt handler calls `46bc:0002` at `7360:1f85`.
2. `46bc:0002` reads the timer-list head through `DS:9ecc`, checks its
   32-bit countdown against `0x14`, and subtracts `0x14` while it is pending.
   This establishes countdown units, not their physical duration in milliseconds.
3. When due, `46bc:0058` posts to queue 0 through `4063:005b`.
4. `459b:0025` waits on that queue through `4063:00a5`; after wakeup,
   `459b:0056` calls `45a1:0001`.
5. That routine unlinks the timer, decrements the active-timer count at
   `DS:9eca`, clears its allocation/event word, and dispatches by event type.

The list is initialized at `6958:0005` as 50 records of 16 bytes starting at
`DS:9ed0`. `6958:0060` allocates and inserts timer records. This is timer
management, not a UART output buffer.

## Direction of the ISDN queues

The queue-creation strings are in the data copied from physical `98d50` to
segment `0ce0`. The paired queue names and consumers establish the broad flow:

```text
CE --CES3--> signaling layer 3 --T3L2--> layer 2
CE <--S3CE-- signaling layer 3 <--L2S3-- layer 2 <--LLL2-- lower layer

S3CE --selected indications--> queue 10 / CEML4 --> modem/layer-4 handling
P3CE --event 4 or 7-----------> queue 10 / CEML4
periodic interrupt ---------> queue 0 / TOUT --> expired-event handlers
```

`T3L2` works on the link context through `DS:6b8c`; its handler selects the
link using the channel/address fields from the request. `LLL2` works on that
same link-state area from received frames. At `666c:010c` onward it extracts
one address field with a shift by two and another with a shift by one,
then checks values including `3f` and `7f`, consistent with SAPI/TEI handling.
That protocol interpretation is an inference; the field extraction and
shared state are directly visible.

`L2S3` passes data to the signaling parser and state machinery. `S3CE`'s
dispatcher's default diagnostic is literally
`NLS_CE_PROC: UnSupported prim code=` at relocated data offset `12c0`.
Do not treat the letters alone as proof of the original expansion of CE.

## Modem/layer-4 bridge

The subsequent [CEML4 deep trace](imodem-ceml4.md) follows BCH_ENABLED through
bearer selection to mailbox command 005eh, with isolated execution verifying
arguments 1 and 2 for selectors 6 and 7.

`CEML4` stores its message at `DS:a48c` and passes byte `message+8` to
`7561:0009`. Its case branches reference these strings directly:

- `Prim = N_CONN_IN : `
- `Prim = N_CONN_CF : `
- `Prim = N_DISC_IN : `
- `Prim = N_DISC_CF : `
- `Prim = N_REL_IN : `

The companion modem-originated dispatcher at `7561:0272` references
`l4_SETUP : modem primitive`, `l4_DISCONN : modem primitive`,
`l4_CONNECT : modem primitive` and `l4_DIGIT : modem primitive`.
These are concrete evidence of the modem/call-control interface, rather than
an interpretation based solely on the CEML4 label.

`P3CE` is particularly small: its event filter calls `6efe:0ab4`, which calls
`46c5:000c`. That last routine copies the 24-byte message and posts it to
queue 10 at `46c5:009c`. An immediate-far-call scan found no direct caller
of the queue-8 posting wrapper at physical `46603`; indirect calls remain
possible. Thus this build retains the P3 relay, but its normal traffic source
and the exact meaning of P3 are not established. It should not be described
as a proven active X.25 subsystem.

## Scope of verification

Startup and first execution of all nine tasks were verified by the earlier
runtime trace. The queue routes and task responsibilities here were recovered
statically from actual code and referenced strings. No synthetic protocol
messages were injected to claim full state-machine coverage, and no AT parser
or terminal-output task has been positively identified by this analysis.
