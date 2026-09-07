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

## The second fault was the same fault

A separate anomaly turned up on the way: the running configuration after a power
cycle was the factory-default set, while `ATI5` displayed a configured NVRAM
profile with `DIAL=TONE`, `X7`, `115200` - and `ATZ` would not move the running
config toward it. The stored profile was not being applied at reset.

Completing the manual's sequence fixed that too. After `AT&W`, an `ATZ!`
hardware reset brings the board up with **`&A3 &B1 &G2 &H1`** - the stored
profile - and the extended registers survive it:

```
AT+S24? -> 13000
AT+S26? -> 3080
AT+S1?  -> 70
AT+S22? -> 525
```

The likely reading is that the NVRAM image was **readable but not valid** - a
bad or never-initialised checksum. The firmware would display it on request
while ignoring it at boot, falling back to defaults, and leaving the extended
registers at zero for the same reason. `AT&W` rewrote NVRAM with a valid
checksum. So the zeroed `+S24`/`+S26` and the unapplied profile are **one root
cause, not two**, and both are exactly what the post-flash sequence exists to
prevent.

Two caveats. `ATZ!` is the firmware's hardware reset and does not remove power
from the NVRAM, ASIC or DSP, so a true power cycle is still worth confirming.
And `DIAL=HUNT` appears in the running config once `S27=048` is set, where the
stored dial mode is `TONE` - a display artifact rather than a fault, but not
chased down.

## Doing this on another unit

`AT&F1`, `AT+SF`, `AT&W`, in that order, as the manual says - **but not blindly
on a unit whose NVRAM profile you want to keep.** `AT&W` stores the *current*
running config, so `AT&F1` first means writing factory defaults over whatever
was stored. On this board the profile was rebuilt in RAM from an `ATI5` capture
before writing, and the DTE rate set to match `&B1`, because `&W` stores that
too.
