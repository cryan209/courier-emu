# ID_SDL's `AT+S` registers, and the post-flash step this board never had

Source: `firmware/legacy-usrobotics/ID20C403/IDSDL403.TXT`, the ID_SDL v4.03
manual, 62 KB of CP866 Russian dated 24/01/00 - the same date as the banner
`ATI7` prints. It documents a command set that appears in **no help screen on
the modem**: `AT$`, `AT&$`, `AT%$` and `ATD$` all print the stock USRobotics
Courier reference and say nothing about any of this.

## The line that matters

> `!! Внимание, после заливки этой пpошивки набеpите команды AT&F1,AT+SF,AT&W. !!`
> `иначе ловля Dialtone,Busy будет не возможна.`

"After flashing this firmware, enter the commands `AT&F1`, `AT+SF`, `AT&W` -
otherwise catching Dialtone and Busy will not be possible."

**That step was never performed on this unit**, and it is the explanation for a
fault that had survived a power cycle and resisted every other theory.

## The register set

`AT+S?` lists them, `AT+S$` prints their help, `AT+Sn?` reads one, `AT+Sn=m`
writes one, and **`AT+SF` loads the documented defaults**.

| register | meaning | documented default |
|---|---|---|
| `+S1` | delay in ms between adjacent digits when dialling | 70 |
| `+S2` | break/make duration per dialled digit | 0 |
| `+S3` | Busy/Dialtone recognition **before** dialling starts | - |
| `+S4` | Busy/Dialtone recognition **after** dialling starts | - |
| `+S22` | DTMF **detection** sensitivity | 525 |
| **`+S24`** | **DTMF transmit level, first frequency** | **13000** |
| **`+S26`** | **DTMF transmit level, second frequency** | **3080** |

## What was actually wrong

Read off the live board before anything was changed:

```
AT+S1?  -> 00      (documented 70)
AT+S24? -> 00      (documented 13000)
AT+S26? -> 00      (documented 3080)
```

**Both DTMF transmit levels were zero.** The modem was generating its dial
tones at zero amplitude - so it went off hook, held the line, and emitted
nothing, while pulse dialling kept working because it uses the hook relay and
never touches the tone generator. Every symptom follows from that:

* dial tone audible, no DTMF audible - the operator listening on the line;
* `ATDT` returning no result code until the `S7` timeout, because no digits
  were ever sent;
* `ATDP` producing audible relay clicks;
* the fault surviving a power cycle, because the registers are zero in NVRAM
  too and nothing was ever loading defaults into them.

`AT+SF` restores all four to the documented values, confirmed by re-reading
them afterwards.

## What this rules back in

Several things were suspected and cleared along the way, and they stay cleared:

* **Flash is intact** - all 2048 pages byte-identical to the earlier capture,
  `artifacts/flash-verify-01/`.
* **NVRAM is intact** and holds an operator-configured profile.
* The board's `ATI2` RAM test passes and the S-registers are all at their
  documented defaults.

## Two separate things, established by flipping the switch back

This section has been wrong twice, so here is the measurement that settles it.

With **DIP 10 returned to the factory-defaults position** and an `ATZ!` reset:

```
running config : &A1 &B0 &G0 &H0 ... , DIAL=PULSE     <- defaults, as the switch selects
+S24           : 13000
+S26           : 3080
```

The switch plainly takes effect - the standard USR profile comes up as `&F0`
defaults rather than the stored one - and **the extended registers are
untouched by it**. So `+S` is not part of what DIP 10 selects.

That separates the two faults cleanly, and it also recovers evidence that
looked lost:

1. **The DTMF fault was an uninitialised `+S` block in NVRAM.** Before the
   `AT&W`, `+S24`/`+S26` read `00` at power-on; after it they read
   `13000`/`3080` at power-on, with the DIP switch in the *same* position both
   times. The only thing that changed is the NVRAM contents. So the block held
   zeros - the post-flash `AT+SF`/`AT&W` had never been run on this unit - and
   `AT+SF` followed by `AT&W` was the necessary fix, not an unnecessary one.
2. **The profile not being applied at power-on was DIP switch 10**, and is
   unrelated to the above.

Two faults, not one, and neither is the NVRAM-checksum story an earlier draft
of this document told.

For the record, what was claimed and withdrawn along the way: first that `AT&W`
had repaired an invalid NVRAM checksum, folding both symptoms into one cause -
wrong, DIP 10 explained the profile symptom; then that the DIP switch explained
*both*, making `AT+SF` unnecessary - also wrong, since the switch demonstrably
does not touch `+S`. `AT&F0` as a command does not zero the registers either,
measured.

After `AT&W` the registers survive a hardware reset in either switch position:

```
AT+S24? -> 13000    AT+S1?  -> 70
AT+S26? -> 3080     AT+S22? -> 525
```

## Doing this on another unit

`AT&F1`, `AT+SF`, `AT&W`, in that order, as the manual says - **but not blindly
on a unit whose NVRAM profile you want to keep.** `AT&W` stores the *current*
running config, so `AT&F1` first means writing factory defaults over whatever
was stored. On this board the profile was rebuilt in RAM from an `ATI5` capture
before writing, and the DTE rate set to match `&B1`, because `&W` stores that
too.

## Where the block lives in NVRAM, and the emulator fixture

Measured in the emulator on the 302 image with a persistent `--nvram` file:
`AT&W` alone programs the standard USR profile at EEPROM words `0x00`-`0x22`;
`AT+SF` followed by `AT&W` additionally programs words `0xc1`-`0xf4`. That
block is a byte stream starting on the high byte of word `0xc1`, and it is
byte-identical to the defaults table at CPU `0xc8891` - `+S1` = 70 first, then
`+S22` = 525, `+S24` = 13000 and `+S26` = 3080 at words `0xcc`-`0xce`, ending
in the `3.02` version tag.

Those three are what the dial path sends beside each digit on mailbox tags
`0x19`, `0x1a` and `0x1b`. With the block erased the lanes carry `0xffff` and
the DSP's own tone generator produces nothing the modeled exchange can decode;
after `AT+SF` they carry `020d`/`32c8`/`0c08` and the exchange decodes every
digit. The `--nvram-fixture idsdl302` image now seeds this block alongside the
settings cache, so a cold boot in the emulator dials audibly.
