# SV25.XMD recovery-loader harness

Run the focused 80188 experiment with:

```sh
./courier recovery-run SV25.XMD > /tmp/sv25-recovery.json
```

With the existing execution extra installed, the equivalent is
`python -m courier_emu recovery-run SV25.XMD`. The command launches an isolated
Unicorn worker and prints a JSON report. Exit status is zero only when the
complete SDL prompt has passed through the firmware's serial transmit store.
`--instructions N` sets a positive instruction budget (default 6,000,000);
`--no-serial-stimulus` stops at the foreground command wait without supplying
input. A custom native library can be selected with `--libunicorn DIRECTORY`.
Unicorn's native JIT needs an environment that permits executable memory; a
worker killed by a native signal produces `native-error` through the public CLI.

The module opens the input with `Path.read_bytes()` and provides no image-save,
flash-programming, transfer, or physical serial-device interface. The command
`AT~X!\r` is delivered only to the emulated CPU. No `Y` or `T` response is sent.
Use a separate path for redirected JSON output, as in the example above.

## Observed result

For the checked-in source image, SHA-256
`43503d82caae5377d67c61f4f44d73e6a19e15c61b2cb706a70c6f1b88ef413f`,
Unicorn 2.1.4 reaches:

```text
status: sdl-xmodem-prompt
instructions: 5051290
setup_word_writes: 36
setup_byte_writes: 9
relocation_verified: true
flash_array_unchanged: true
source_file_unchanged: true
serial_text: "\r\n\r\nSDL Xmodem file transfer - (Y)es (N)o (T)est >"
stop: 0000:12bb (MOV [0xff6a], AX), AL=0x3e ('>')
```

The stop is driven by bytes written to the serial data register, not discovery
of a string in the image, a print-routine shortcut, or a forced jump to the
prompt. The CPU executes the setup loops, RAM copy, software interrupt, CRC,
autobaud interrupt handler, AT/token parser and serial-output loop. The count
is Unicorn instruction-hook steps, including REP iterations and interrupted
foreground dispatches; it is not a cycle or bus timing measurement.

Under this decoded map, the CPU computes application CRC `0x1735` over flash
`0x40000..0x77ffd`, compared with `0xffff` at flash `0x77ffe`. That mismatch
naturally selects recovery. This does **not** establish that a modem programmed
by the original downloader has a corrupt application: the downloadable image,
programming process and installed checksum may differ. The harness does not
patch the checksum or force the conditional branch.

## XMD decode, not a speculative bank transition

Strip the 128-byte header. For each 128-byte payload block:

1. XOR each byte with the current key, initially `0x55`.
2. Use the last **decoded** byte as the next block's key.

This is an empirically recovered file transform. It does not imply that the
80188 or its flash bus performs XOR at runtime. Both raw and decoded bytes are
immutable Python `bytes` objects; only the decoded view is mapped for execution.
The report includes both digests and all recovery-region block keys.

Independent checks supporting the transform include the initial application
stub and copyright text, valid low-RAM interrupt vectors, continuous prompt
strings, all setup table entries, the relocation instruction crossing a block
boundary, and the reset stub. In particular:

| Flash block | XOR key | Consequence |
|---|---:|---|
| `0x7db00` | `0xa1` | Decodes the first 27 setup records into peripheral register writes. |
| `0x7db80` | `0x00` | Nine remaining word records, byte table and bootstrap already look plain. |
| `0x7dc00` | `0xf3` | Restores the second byte of `REP MOVSW`, then `XOR AX,AX; MOV DS,AX; INT 13h`. |

The preceding static analysis's partial XOR strings and apparent post-setup
bank break are explained by this block transform. No runtime bank flip is
needed on the executed recovery path. This result does not solve the normal
supervisor's full resident/overlay map.

## Address map and assumptions

Offsets called “flash” refer to the decoded payload, excluding the header;
file offsets add `0x80`. Thus the requested bootstrap at flash `0x7dbc0` is
file `0x7dc40`, logical `fc00:1bc0`, physical `0xfdbc0`.

| Region or action | Model and evidence |
|---|---|
| Flash `0x80000..0xfffff` | Read/execute mapping. Decoded reset stub programs `OUT 0xffa4,0x8000` and jumps to `fc00:1bbf`. That target begins with `CLD`; the requested harness entry is the following instruction at `1bc0`, so DF starts clear. IF also starts clear. |
| RAM `0..0x1ffff` | Zero-filled 128 KiB allocation, chosen from LCS start `0x0000` and stop `0x200a`. The recovery path uses low memory. This does not resolve the earlier board-spec claim of 64 KiB RAM. |
| Peripheral block `0xff00..0xffff` | Available as memory and I/O aliases for bootstrap access. The firmware first writes memory `0xffa8=0x00ff`, later outputs `0xffa8=0x10ff`. These are recorded; alias availability is simplified rather than enforcing every relocation decode gate. |
| Loader copy | The CPU copies `0x1b14` bytes from physical `0xfc000` to zero using `REP MOVSW`. The harness verifies every byte before dispatching `INT 13h` through the newly copied IVT to `0000:043e`. |
| Other addresses | Unmapped; an access stops with its address and PC. There is no broad identity alias or guessed flash-to-RAM mirror. |
| Chip selects and board latches | Every write is recorded, including word width and provenance. Candidate address fields are decoded as `(value & 0xffc0) << 4`. Wait states, upper-stop granularity and overlapping selects are not simulated. Board-latch writes do not remap memory. |

The CPU core is Unicorn's 16-bit x86 engine, not an instruction-set-restricted,
cycle-accurate Intel 80188. The model covers the recovered instruction path and
small peripheral subset. It does not execute DSP firmware, normal supervisor
bank dispatch, XMODEM reception, programming or erase routines.

## Peripheral stimuli

- `IN 0x10` returns `0x08`: the startup readiness bit is asserted and EEPROM
  data samples are zero. Firmware bit-bangs its own startup sequence; no
  persistent EEPROM is loaded or written.
- `IN 0x12` returns `0x40`, selecting the recovery combination if the CRC passes.
  Other input ports return all ones. Output latches are logged independently
  from input responses.
- Serial status at `0xff66` returns `0x0008` (transmit ready); writes to
  `0xff6a` supply captured bytes. Other peripheral registers are retained
  register values unless a listed stimulus updates them.
- At foreground wait `0000:0875`, once the firmware installs vector `0x0d`
  and unmasks INT1, the harness supplies one edge with timer-1 count `0x0050`.
  The firmware's autobaud handler chooses its short-count path and installs
  the serial handler itself. The count is a deterministic stimulus, not a
  measured baud rate or a general timer model.
- At subsequent visits to that wait, with interrupts enabled and serial RX
  unmasked, the harness provides `AT~X!\r` through register `0xff68` and vector
  `0x14`, one byte at a time. Real ISR and parser instructions consume it;
  parser flags, buffers, return values and PCs are not preseeded to skip them.
- The flash-ID probe's two known word stores at `0000:0733` and `0000:0743`
  issue `0x90` and `0xff` to physical `0xffff0`. These non-programming device
  commands select an ephemeral Intel ID read view (`0x0089`, `0x4470`) and
  restore array reads. This chip identity is an assumption to satisfy the
  firmware's supported-device branch, not a part identified from a board.
  Protected-write faults emulate just those MOVs outside the callback. All
  other CPU flash stores stop as `blocked-flash-write`; the array never gains
  CPU write permission. The ID view is restored even if the budget expires.

No timer ticks or asynchronous interrupts beyond those stimuli are generated.
`--no-serial-stimulus` leaves the loader at `serial-input-wait`, making the
input dependency directly observable.

## Report and validation

`events` is chronological and contains every I/O access, every peripheral
memory write, setup provenance, mapping-register interpretations, board latch
writes, verified RAM relocation, subsequent IVT changes, CS transitions,
interrupt deliveries, the CRC comparison, flash commands, and each RX/TX byte.
Addresses, values and PCs are numeric JSON fields. No setup events are truncated.
`memory_write_counts` aggregates all guest RAM writes by starting address,
including copy, stack and CRC state writes; repeated RAM writes do not flood
the event log. Host device-view updates and interrupt stack construction are
represented by their device/interrupt events rather than guest-write counts.
The final registers, recent PCs, hot PCs and stop reason support incomplete runs.

Tests use the real image to verify the entire output path and compare all 45
executed table writes, plus an independent reflected CRC calculation. Small RAM
programs exercise protected flash stores, budget expiry during the identifier
view, and unmapped accesses. Budget and no-input runs must not claim a prompt.
The CLI also tests containment of native worker signals.

```sh
python -m pytest tests/test_recovery.py tests/test_cli.py -q
```
