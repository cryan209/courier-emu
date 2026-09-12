# Making it dial out as a modem, and what stands in the way

[imodem-live-sip-call.md](imodem-live-sip-call.md) dialled a real Courier and
found the reason the two would not train: the I-modem's own `ATD` puts out
**unrestricted digital with a V.120 low layer compatibility**.  It dials a
digital call.  For V.34 or x2 it has to dial an analogue one, and the firmware
does have the switches - this page is what is established about them and where
the attempt currently stops.

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

This wants saying plainly because it cost a detour.  `ATS80=20` answers
`NO CARRIER`, `ATS80?` still reports `016` afterwards, and the obvious
conclusion - that the write was refused - is **false**.

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
working register, and `NO CARRIER` is not this firmware's way of refusing a
command - note that a bare `AT` draws no answer at all, so the absence of `OK`
says nothing either way.  The general lesson is the one
[imodem-config-sector.md](imodem-config-sector.md) already learned about
`AT*V1`: a response is not necessarily an answer to the command before it.

## What the setting does, and does not, do

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

## The blocker, which is ours

The experiment that would settle it in one run - set the register over the AT
interface, then dial - **cannot currently be run**, and the reason is in this
harness rather than in the firmware:

> After any preceding AT command, a dial produces no SETUP at all.  The trace
> shows it reaching layer 3 as `l4_CONNECT` rather than `l4_SETUP`, and the
> DTE gets `NO CARRIER`.

A bare `AT` before the dial is enough to do it, so it is not the register
write.  A dial on its own works perfectly - that is how the live call was
placed.  Chained *queries* sometimes work and sometimes do not, which points
at the serial line discipline or the command buffer rather than at anything
the modem is refusing.

That is the next thing to fix, and it is worth fixing beyond this question:
every configuration experiment on this board is currently limited to one
command per run, and that limit has been silently shaping what gets tried.

## What is not blocked

The answering direction.  The board already answers a 3.1 kHz audio call as a
modem and puts ANSam on the bearer
([imodem-audio-bearer.md](imodem-audio-bearer.md)), which needs no setting
changed and no dial.  Two Couriers can therefore be made to train the other
way round - the real one originating, this one answering - and what that needs
is an inbound INVITE in `sip.py`, which
[imodem-live-sip-call.md](imodem-live-sip-call.md) already names.  On an
answered call this board is the *digital* end, which is where x2 and V.90 put
the server anyway.
