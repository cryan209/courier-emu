# 3453C streaming DSP program monitor

Revision of the installed DSP monitor, built from the verified stock 2.3.33 image.
The DSP handler and overlay relocation are identical to the first monitor build.
This revision adds CPU code at physical 8A200 and fixes ATGU to consume U.

`ATGDssssEEEE` streams the inclusive DSP program word range `ssss..EEEE`.
Both addresses must be exactly four hexadecimal digits, ordered within 0000..7FFF.
For example, `ATGD12C012C7` reads eight words. Output is:

```
DSPDUMP <four hexadecimal digits per word, with no separators>
DSPEND

OK
```

The CPU sends one 008A request per word and waits for a changed reply sequence
and tag 0072. Interrupts service the existing mailbox queue during the bounded
wait. A stalled request prints DSPTIMEOUT and returns ERROR. Invalid inputs are
rejected before any DSP request. Numeric ATG requests retain their stock path.

Capture a full program map as little-endian 16-bit words:

```
.venv/bin/python tools/3453c_monitor.py dump program 0000 7fff --fast \
  --output artifacts/3453c-dsp-memory-read-20261003/dsp-program-fast-0000-7fff.bin
```

The host checks the opening marker, exact word count, hexadecimal encoding,
closing marker, and OK before publishing the completed binary. Failures retain
an explicitly incomplete partial file and metadata. Existing captures are never
replaced. The capture reads the active program address map; it does not switch
MP/MC or guarantee that the lower region contains internal mask ROM.

Rebuild:

```
.venv/bin/python tools/build_3453c_dsp_monitor.py \
  --output artifacts/3453c-dsp-bulk-patch-20261003
```

The manifest records hashes and 12 DSP plus 17 CPU isolated executable checks.
These cover handler behavior, range parsing, ordering, sequence wrap, output,
register/stack restoration, and timeout. Hardware results belong in the flash
log and hardware verification report. Call operation, all overlay modes, and
long-term reserved-RAM ownership remain unverified.

## Hardware result

The revision was flashed successfully: all 5,888 blocks acknowledged without
retries. The modem reset, answered AT, and ATGU returned its cache followed by OK.
An eight-word test at 12C0..12C7 matched the candidate. The full 0000..7FFF capture
then completed in 69.581 seconds: 32,768 words / 65,536 bytes. Its SHA256 is
`a76f8c82a497a087af58741c395199e69f7923cd84ca9b0a73bab8ab7e1b329c`.
The full capture's dispatcher and all 68 monitor words match the candidate.
See `hardware-verification.json` and `flash-log.json` for evidence.
