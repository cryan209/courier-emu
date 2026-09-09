# x2 Symmetric and V.90 All-Digital: where 64000 comes from

The Courier's result-code table carries `64000`, `64000/ARQ`, `64000/x2`,
`64000/ARQ/x2` and `64000/V90`, `64000/ARQ/V90` in every image from 2.1.1
through 2.3.33 ([pcm-x2-v90.md](pcm-x2-v90.md)).  64000 is not an analog PCM
rate - the client can never train to it over a subscriber loop - and the
supervisor cannot ask for it either: the rate mask at `8fc9` is 15 bits over
the x2 ladder's 15 analog rates (33333 … 57333), and 64000 sits outside it.
It is the rate of a **digital-to-digital** connection, and the mode that
reaches it is not in this firmware.  It is in the server.

## The server has three x2 roles, not two

The Total Control HDM MIB (`TCM/BIN/SNMPMIBS/ALLMIBS/HDM.MIB` in
`docs/x2/tcmw551.zip`) and the Network Management Card's object table
(`docs/x2/3Com Software.zip`) give the x2 mode bits as S76:

| bit | object | help text |
|---|---|---|
| S76.0 | `hdmScX2DisableClient` | "The modem can receive information at x2 speeds." |
| S76.1 | `hdmScX2DisableServer` | "The modem can distribute information at x2 speeds." |
| **S76.2** | `hdmScX2DIsableSymmetric` / `mdmScX2Symmetric` | **"requires both the server and client modem to send and receive information at the same x2 speed"** |
| S76.3 | - | x2 fallback to V.34 |
| S76.7 | `hdmScHighPowerConst` | x2 high-power constellation, legal only in some countries |

So **x2 Symmetric is real, it is a distinct third x2 role, and it is a server
S-register bit (S76.2), enabled by default.**  It is PCM in *both* directions
at the same rate - up to the 64000 the speed enums carry - which is only
reachable when neither end has an analog local loop.

## V.90 has the same three, and names them

The same MIB continues at S81:

| object | S-bit | description in the MIB |
|---|---|---|
| `hdmScV90Analogue` | S81.4 | "the V.90 client (**APCM**) modulation" |
| `hdmScV90Digital` | S81.5 | "the V.90 server (**DPCM**) modulation" |
| `hdmScV90AllDigital` | **S81.6** | "the V.90 **symmetric** modulation (**DDPCM**)" |

The NMC table labels the last one "V.90 All Digital Mode (S81.6)".  So the
user's hunch is right on both counts: x2's symmetric mode and V.90's
all-digital mode are the same idea, and USR shipped both as server options
with their own S-register bits.

## The RADIUS dictionary counts them as separate modulations

`dictnary` in `docs/x2/ne050303.zip` (NETServer) reports the trained
modulation per call:

```
x2                23      v90Analogue     33
x2client          29      v90Digital      34
x2symmetric       30      v90AllDigital   35
piafs             31      v92             36
```

and `Initial-Connect-Speed` value 39 is `64000-BPS`.  The HiPer ARC MIB keeps
a per-rate call counter `usrCipSpeedStatisticsSpeed64000`, "the number of
calls with speed of 64000" - a rate that would never increment if 64000 were
only a string.

## Where V.91 fits

ITU-T **V.91** (approved May 1999, still in force) is
"a digital modem operating at data signalling rates of up to 64 000 bit/s for
use on a 4-wire circuit switched connection and on leased point-to-point
4-wire digital circuits".  That is the standardised form of the same
symmetric-64k idea, but it is a *4-wire / leased-circuit* recommendation, not
a mode of V.90 - V.90 itself defines only the analog client and digital
server halves.  DDPCM as USR shipped it is a vendor extension over the V.90
PCM machinery, not V.91, and the name V.91 appears nowhere in this firmware
or in any of the server archives.

## What this means for the Courier

Nothing in the client image implements either mode:

* `symmetric`, `all digital`, `DDPCM` and `V.91` appear in **no** Courier
  image (2.1.1, 2.2.05, 2.3.12/15/31/33, IDSDL302).
* The Courier's PCM option register is S58 - bit 1 x2, bit 32 V.90
  ([pcm-x2-v90.md](pcm-x2-v90.md)) - and it has no S76.2 or S81.6 equivalent.
  Its x2 setup builds one capability word and sends it as tag `70`; there is
  no second, digital-side capability path.
* The 64000 result codes are there because the **result-code table is shared
  across the product line**, not because a V.Everything can reach 64000.  A
  Courier on an analog loop cannot: it has a DAA and a codec, which is the one
  analog conversion the rate forbids.

The emulator should therefore keep 64000 as a reportable code and out of the
negotiable rate mask, which is what the firmware itself does.
