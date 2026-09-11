# CEML4: call-control events to modem/DSP setup

Ie030002 `TID_CEML4` consumes queue 10 at `46dd:000a`, stores the message
pointer at `0ce0:a48c`, and calls `7561:0009` with byte `message+8`.
This trace reaches the modem/DSP mailbox from the `BCH_ENABLED` event.
It establishes control-plane setup, not the continuing PCM sample path.

## Primitive dispatch

| Message byte +08 | Meaning from the referenced diagnostic | Main handler / action |
|---|---|---|
| 00 | N_CONN_IN | `7561:00bc`; classifies incoming connection, calls `7561:0eb7`. |
| 01 | N_CONN_CF | `7561:0130`; resolves connection, calls `1ffe` and `2eea(slot,1)`. |
| 02 | N_DISC_IN | `7561:0167`; propagates cause information and calls `3b60(2,cause)`. |
| 03 | N_DISC_CF | `7561:01ef`; calls `3b60(3,cause)`. |
| 07 | N_STAT_IN | `7561:14bf`; dispatches status subtype at message +10. |
| 0a | N_REL_IN | `7561:0210`; calls `3b60(0a,cause)`. |
| 40 | Special connection event, name unconfirmed | `7561:006d`; acts on special slot 80h, updates state/digit buffers. |

Observed message fields: +0b is the connection identifier used by lookup;
+10 is a status subtype or cause depending on the primitive; +12 is used for
channel information; +14/+16 form a far pointer to additional information.
This is an internal message layout, not a raw Q.931 packet format.

`7561:3b2a` compares the identifier with `DS:a634`, `DS:a64c`, `DS:a640`,
returning slot 0, special slot 80h, slot 1 respectively, or ffff on failure.
Slots 0/1 are call-record indices, not proof that they always correspond to
physical B1/B2. Ordinary records have a 12-byte stride starting at DS:a630.

## BCH_ENABLED path

Primitive 07, subtype **60h** selects `7561:17ae`, whose diagnostic is
`BCH_ENABLED Detected`.

1. Resolve the connection with `3b2a`; abandon an unknown identifier.
2. Update its bearer-related record via `4290(slot, connection_id)`.
3. Call `1ecf(slot)`, which derives a selector from the bearer state and
   sends **command 005eh** with selector minus five (normally 1 or 2).
4. Depending on call state and configuration, invoke `3f36(slot,2)` and the
   link setup helper `8f6f:08af`. These later calls are conditional, not an
   unconditional action of every BCH_ENABLED indication.

`4290` compares the identifier against `DS:8eea` and `DS:8eee`, consults the
associated selectors at `DS:8ee9`/`DS:8eed`, and sets the per-record byte at
`a63a + 12*slot` to 6 or 7. It also sets the adjacent flag at `a639 + 12*slot`.
`1ecf` selects the corresponding bearer state and subtracts five to obtain
the command argument. The natural B1/B2 interpretation is strongly supported
by the two-channel structure; the isolated execution below proves the
numeric mapping without assuming board wiring.

## Exact command transport

```text
7561:1ecf -> 7561:431e(command=005e, argument=1 or 2)
  writes 2600:c982 = command, 2600:c984 = argument
  -> a400:1709 loads AX/BX
  -> b3d9:049a -> b3d9:04d8
  enqueues [ff00, command, argument]
  -> interrupt-side consumer b3d9:3efb
  outputs command via ports 58/5a, argument via 5c/5e
```

The ring's read/write pointers are at `2600:c9ae`/`2600:c9b0`; its data span
is `c9b2..c9f1`, 32 words. The ff00 marker is staged internally before the
command/argument pair is sent. It is not output as a third payload word.
The consumer's surrounding code uses ports 1c/1e for handshake/status.
These are the mailbox windows also identified in `mailbox_tap.py`.

## Additional bearer/mode commands

`7561:3f36(slot,mode)` builds an argument with:

- bit 7 from `(record_selector - 6) << 7`, distinguishing selectors 6/7;
- bit 6 set;
- low bits adjusted from modem configuration at `2600:d1be`, `2600:d1c0`,
  and `2600:e4ef`.

It emits **005ch** when mode is 1 and **005dh** otherwise. It then emits
command **000ah** with `(record_selector - 6) << 3 | 3` (3 or 11), and saves
that value at `2600:c986`. The DSP-side interpretation of these bits is not
yet decoded. In particular, do not label them A-law/mu-law or PCM enable bits
without following the DSP handlers.

The link helper at `8f6f:08af` logs PRIMARY CHAN/SECONDARY CHAN and sets a
rate field to 56000 or 64000 according to an argument. That is evidence of
separate data-link configuration; it is not evidence that the helper moves
G.711 samples.

## Executed verification

`tools/imodem_ceml4_probe.py` runs the original unpatched x86 routines
`4290`, `1ecf`, their command adapters, and the mailbox consumer with synthetic
call state. It does not run the whole CEML4 queue or synthesize a complete call.

| Input bearer selector | Queued words | Port writes (port:value, hexadecimal) |
|---|---|---|
| 6 | ff00, 005e, 0001 | 58:5e, 5a:00, 5c:01, 5e:00 |
| 7 | ff00, 005e, 0002 | 58:5e, 5a:00, 5c:02, 5e:00 |

Both cases passed assertions. Reproduce from the repository root:

```sh
.venv/bin/python tools/imodem_ceml4_probe.py \
  --output artifacts/imodem-ceml4/probe.json
```

The probe uses a synthetic far-call frame and configured RAM, then runs the
real interrupt-side staging and output instructions. It stops before the rest
of the interrupt handler. Results and image hash are in `probe.json`; selected
instruction spans are in `artifacts/imodem-ceml4/disassembly.txt`.

## What is still open

CEML4 clearly connects call/bearer events to modem/DSP control commands. The
evidence does not yet establish the DSP implementation of 5ch/5dh/5eh, the
Am79C30 multiplexer connection selected for a modem call, or the physical
path that transfers B-channel PCM. No AT-to-OK exchange or end-to-end modem
call has been demonstrated by this probe.
