# Making it dial out as a modem, and what stands in the way

[imodem-live-sip-call.md](imodem-live-sip-call.md) dialled a real Courier and
found the reason the two would not train: the I-modem's own `ATD` puts out
**unrestricted digital with a V.120 low layer compatibility**.  It dials a
digital call.  For V.34 or x2 it has to dial an analogue one, and the firmware
does have the switches - this page establishes which one selects it and how
S80 modifies the resulting SETUP.

## The switches, in the firmware's own words

`tools/imodem_help.py` decodes the built-in help table, and the relevant
registers name themselves:

```
S58   1 = Disable x2          2 = Disable server mode    4 = Force x2 A-law mode
      8 = Disable symmetric mode   16 = Enable -6dbm constellation
     32 = Disable V.90
S67   8 = Route 3.1K Audio Calls / Route Analog Telephony Calls
S68   1 = Disallow Analogue Connects
     16 = Route Speech Calls to / Route ISDN 3.1kHz Telephony
S80   4 = Force Modem Calls as Speech / Force Modem Calls as ISDN
```

S58 is the x2 register outright, and it is worth noting what it says about
roles: **server mode and symmetric mode are both on by default** (the bits
disable them), which is the arrangement x2 needs with a digitally attached
modem.  S68 bit 1 says analogue connects are *allowed* unless disallowed.

## S-register writes work, and an earlier reading here was wrong

This wants saying plainly because it cost a detour.  An older mistimed run
attributed `NO CARRIER` to `ATS80=20` and `ATS80?` still reported `016`
afterwards.  With result-code-gated sequencing the setter itself answers
`OK`; in either case, the conclusion that the write was refused is **false**.

Reading the live register file settles it.  The file is at `2600:d17b`, one
byte per register, and the write routine at `0xcc471` indexes it directly
(`add ax, 0xd17b`, register number bounds-checked against `0x53`).  Watching
those bytes across a run:

| command | S80 in the register file | S0 |
|---|---|---|
| `ATS80?` | 16 | 0 |
| `ATS80=20` | **20** | 0 |
| `ATS0=7` | 16 | **7** |

The write lands.  `ATSn?` is reading the **saved profile** rather than the
working register.  The general lesson is the one
[imodem-config-sector.md](imodem-config-sector.md) already learned about
`AT*V1`: a response is not necessarily an answer to the command before it.

## S80 alone is not enough

Setting S80 bit 4 in the live register file and then dialling - `ATD` as the
only AT command of the run - changes nothing about the call:

```
SETUP  bearer capability 88 90
       low layer compat  88 90 28 48 76 3b c0 c2 e2
```

Still unrestricted digital, still V.120.  So "Force Modem Calls as Speech" on
its own is not the switch, or not the whole of it.  The help text has *two*
lines against bit 4 - "as Speech" and "as ISDN" - which suggests its meaning
depends on another setting, and the obvious candidate is the `*V2` data bearer
(Auto Detect, V.120, V.110, Modem/Fax Emulation, Clear Channel, PPP, X.75)
that [imodem-config-sector.md](imodem-config-sector.md) puts in the record
rather than in ATI12's table.

## `*V2=3` is the analogue-origination switch

The command sequencer now waits for a complete final-result line before
offering the next command.  That removes the harness blocker and makes this
single run reliable:

```sh
.venv/bin/python -m courier_emu isdn-run Ie030002.nac \
    --instructions 30000000 --send-every 0 --no-flash-nvram \
    --bri-network --bri-establish terminal \
    --send 'AT*V2=3' --send 'AT&W' --send 'ATD8406'
```

The modem sends SETUP and the peer records:

```text
bearer capability       90 90 a2   3.1 kHz audio, 64 kbit/s, G.711 mu-law
low layer compatibility absent
```

The default-profile control is `88 90` plus LLC
`88 90 28 48 76 3b c0 c2 e2`: unrestricted digital with V.120.  Thus
`*V2=3` really does switch outbound calls to an analogue modem bearer.

S80 bit 4 is a second-stage override.  In the same sequence, inserting
`ATS80=20` before the dial changes the bearer to `80 90 a2`: Speech, 64
kbit/s, G.711 mu-law, still with no LLC.  Leave S80 at its default 16 for the
3.1 kHz bearer; set the bit only when Speech is specifically wanted.
