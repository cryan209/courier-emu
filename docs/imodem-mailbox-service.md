# I-modem supervisor/DSP mailbox service

The immediate supervisor blocker was missing **IRQ13 service plus runtime
mailbox status**, not VRTX task startup. The original Ie030002 firmware now
drains its command ring without guest patches. This is a transport fix:
`IsdnMachine` still captures DSP downloads and does not execute the C52.
Its default mailbox endpoint explicitly reports `capture-only`.

## Recovered path

- IRQ13 maps through the programmed PICs to INT 2dh.
- INT 2dh contains `4030:0316` (physical `40616`). That wrapper saves
  registers, sets DS/ES to 2600h, pushes flags, and far-calls `[c893]`.
- The booted service pointer becomes `b3d9:0000` (physical `b3d90`).
  Its `iret` returns through the wrapper's synthetic interrupt frame.
- The handler reads ports 1eh/1ch, masks to the low two bits, and tests
  bit 0 for permission to transmit and bit 1 for a pending receive word.
- The queue lives at `2600:c9b2..c9f1`; read/write pointers are c9ae/c9b0.
  An ff00 marker selects a full command/argument pair. Compact words encode
  the command in their high byte and argument in their low byte.
- CPU writes 58h/5ah hold the command's low/high bytes; 5ch/5eh hold the
  argument. Writing bit 0 to 1ch commits the pair. The following zero write
  is not another command.
- Receive uses separate latches at those same addresses. Reading does not
  acknowledge; writing bit 1 to 1ch releases the pending reply. This permits
  simultaneous transmit and receive without corrupting either window.

The alternative handler at `b3d9:3f91` (`b7d21`) uses the same mailbox
windows and status bits. It is not the handler executed in this startup run.
The earlier CEML4 probe's `b7c8b` consumer is valid isolated code, but is not
proof that the live IRQ takes that particular consumer.

## Implementation and limits

`imodem_mailbox.py` implements directional latches, commit, receive
acknowledgment, transmit backpressure and a bounded command history.
`offer_reply` refuses to overwrite a reply awaiting acknowledgment.
An optional command callback provides an attachment point for a DSP endpoint;
no successful DSP response is fabricated by the default capture endpoint.
Writes during startup/reset are also recorded; not every recorded commit is
a runtime command.

`isdn.py` raises IRQ13 every 2048 supervisor instructions through the PIC,
respecting its masks and the CPU interrupt-enable flag. This is a **modeled
cadence**, not a measurement of the I-modem's physical interrupt clock.
The service handler also performs timer work, so recovering the real rate
matters before claiming accurate call timing. `mailbox_service=False`
disables this source for comparisons. The existing IRQ10 tick is retained.
Ports 18h and 1eh retain the existing download-handshake model; runtime
mailbox acknowledgment is distinct from acknowledgment of DSP execution.

## Unpatched firmware comparison

Reproduce with Unicorn (on macOS the JIT may need execution outside the sandbox):

```sh
.venv/bin/python tools/imodem_mailbox_probe.py \
  --output artifacts/imodem-mailbox-service/probe.json
```

Both cases run Ie030002 for 5,000,000 instructions with transmit-ready status;
only IRQ13 service differs. Image hash and full summaries are in the artifact.

| Observation | Service disabled | Service enabled |
|---|---:|---:|
| Runtime handler entries at b3d90 | 0 | 1,234 |
| Ring-wait visits at a543b | 509,590 | 1 |
| Ring-drain timeout visits at a5446 | 15 | 0 |
| Final read pointer | c9b2 | c9c2 |
| Final write pointer | c9de | c9c2 |

The enabled run emits four runtime pairs: `0002:d100`, `0002:9260`,
`0001:003f`, `005b:0000`. Five earlier commits belong to startup/reset
traffic. There are no injected DSP replies. These results establish that
MODEM gets past the blocked send queue; they do not establish DSP command
completion or a working modem call. An AT-to-OK exchange is no longer
outstanding - see [the AT interface](imodem-at-interface.md) - but it runs
over SIO0 and says nothing about this path.

The next DSP integration must consume these committed pairs, drive
transmit-ready from actual endpoint availability, publish DSP-produced
replies into the receive latch, and propagate CPU acknowledgment back to
the DSP. Simply returning ready forever is only the capture endpoint's
behavior, not evidence that the C52 processed a command.

## Native C50/C52 connection

The transport-only limitation above is now optional. Run the native endpoint:

```sh
./courier isdn-run Ie030002.xmp --with-dsp --instructions 5000000
```

`IsdnMachine(..., with_dsp=True)` connects `ImodemDsp` to `NativeC5x`.
Without the flag the earlier capture-only mode remains available. Library
callers should call `machine.mailbox.close()` after inspecting the native
results; the CLI closes it automatically.

The connection includes:

1. **Bootstrap capture:** the CPU's alternating 40h/50h windows contain four
   16-bit words each, committed by port 18h bits 0/1. Both ready bits remain
   available; merely echoing the last strobe made the firmware's final
   two-bit wait fail. The 8000h destination comes from the reset transaction.
   The checksum-completion strobe installs the captured resident (4,672 words,
   including two padding words) in the native core. The core executes resident
   initialization to its first IDLE before exposing completion. This retains
   a modeled bootstrap transfer/completion, not execution of the mask ROM's
   reset loader or validation of the wire checksum. The recovered mask ROM
   is loaded and hash-checked for the resident's interrupt vectors.
2. **Runtime commands:** CPU bit-0 commit writes DSP input ports 5eh/5fh and
   sets PA7 bit 0. The resident dispatcher at 85c6 reads the pair at
   85cah/85cch and clears bit 0 at 85ceh. Transmit-ready stays low until that
   acknowledgment. The endpoint does not choose a command handler.
3. **Overlays:** command 2 supplies the destination to the DSP's own handler
   at 840fh. CPU port 1eh bits 0/1 publish two-word halves at DSP 58h/59h
   and 5ah/5bh; PA7 bits 8/9 represent pending halves. The native resident's
   BLDP at 82bfh writes four program words and clears those pending bits.
   CPU ready status is the inverse of PA7 bits 8..10. Overlay bytes are not
   directly installed by Python or read from a second copy of the image.
4. **Replies:** the native sender at 8603 emits tag/value to its output
   latches and clears PA7 bit 1. CPU bit-1 acknowledgment grants DSP room
   to send again. A native-core bug in `io_output` exposed the input latch
   in mailbox-only mode even though writes used a separate output latch;
   that accessor now honors both mailbox-only and analog-codec modes.

The coupled scheduler advances four DSP instructions per supervisor
instruction, at I/O boundaries as well as timer polls. Waiting until the
512-instruction timer poll artificially stalled each overlay block long
enough to trigger the supervisor's download timeout. The scheduling ratio
and the digital serial clock (the existing model's 20.16 MHz / 8 kHz setup,
idle octet ffh, DSP interrupt 5) are model choices, not recovered I-modem
board-clock measurements. The Am79C30 bearer routing is still unconnected.

### Native verification

```sh
.venv/bin/python tools/imodem_dsp_probe.py \
  --output artifacts/imodem-native-dsp/probe.json
```

In 5,000,000 unpatched supervisor instructions:

- All four startup commands (`0002:d100`, `0002:9260`, `0001:003f`,
  `005b:0000`) are read and acknowledged by the native DSP.
- Image 10 at d100h matches all **15,072 bytes** of its source.
- Image 11 at 9260h matches all **31,994 bytes** of its source.
- The supervisor command ring is empty, with **zero queue-drain timeouts**.
- No spontaneous DSP replies are observed during that startup interval.

A separately labeled diagnostic then seeds `8074,beef` in the DSP firmware's
outgoing ring and runs another 50,000 supervisor instructions. The real DSP
sender emits `0074:beef`; the real supervisor ISR stores status bytes `74,80`,
acknowledges the reply, and restores DSP room-to-send. Neither CPU nor DSP
code is patched, and Python does not populate the receive latch directly.
This proves the bidirectional service path using synthetic queue input;
it does not claim that a real call generated that report.

The native regression tests also send command 19h and verify the original
handler updates DSP data 03adh, and exercise reply retention until CPU
acknowledgment. Full AT command handling and a working modem call are still
outside what these runs demonstrate.
