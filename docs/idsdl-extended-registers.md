# ID_SDL's `AT+S` registers, and the post-flash step this board never had

Source: `docs/New Folder With Items/ID20C403/IDSDL403.TXT`, the ID_SDL v4.03
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

## It was DIP switch 10, not a checksum

A separate anomaly turned up on the way: the running configuration after a power
cycle was the factory-default set, while `ATI5` displayed a configured NVRAM
profile. An earlier version of this document concluded that the NVRAM image must
be readable but *invalid* - a bad checksum that the firmware displayed on
request while ignoring at boot - and that `AT&W` had fixed it by rewriting the
image. **That was wrong.**

**The operator had been toggling DIP switch 10**, which on a Courier selects
whether power-on loads the NVRAM profile or the `&F0` factory defaults. The
switch, not `AT&W`, is why the board started coming up with the stored profile.

The correction matters because it changes what the fault was:

* with DIP 10 in the **factory-defaults** position the ID_SDL `+S` block is
  never loaded from NVRAM at power-on, so it sits at zero - which is why
  `+S24` and `+S26` read `00` and DTMF was silent;
* with DIP 10 in the **NVRAM** position the block loads and DTMF works.

Note the boot path and the command are **not** the same thing. `AT&F0` issued
from the command line does *not* zero the extended registers - measured, they
stay at `13000`/`3080` across `AT&F0` and a following `ATZ`. Only the DIP-10
power-on path leaves them unloaded.

After `AT&W`, an `ATZ!` hardware reset does carry the registers through:

```
AT+S24? -> 13000    AT+S1?  -> 70
AT+S26? -> 3080     AT+S22? -> 525
```

but that is `&W` having stored them, not evidence about any checksum.

**One piece of evidence was destroyed on the way.** Whether NVRAM already held
correct `+S` values before the `AT&W` cannot now be established - the write
overwrote them. If it did, the whole DTMF fault was the DIP switch alone and
`AT+SF` was never needed.

Two caveats. `ATZ!` is the firmware's hardware reset and does not remove power
from the NVRAM, ASIC or DSP, so a true power cycle is still worth confirming.
And `DIAL=HUNT` appears in the running config once `S27=048` is set, where the
stored dial mode is `TONE` - a display artifact rather than a fault, but not
chased down.

**Operationally**: putting DIP 10 back to the factory-defaults position should
make DTMF stop working again, for the reason above. That is the test that would
confirm this reading, and it costs one switch flip.

## Doing this on another unit

`AT&F1`, `AT+SF`, `AT&W`, in that order, as the manual says - **but not blindly
on a unit whose NVRAM profile you want to keep.** `AT&W` stores the *current*
running config, so `AT&F1` first means writing factory defaults over whatever
was stored. On this board the profile was rebuilt in RAM from an `ATI5` capture
before writing, and the DTE rate set to match `&B1`, because `&W` stores that
too.
