# No, the I-modem does not need an ISDN carrier

The B channel is 8000 octets per second and nothing says they have to be data.
Offer the call as audio and the I-modem answers it **as a modem** - its own
datapump, straight onto the bearer, with no rate adaption on top and no ISDN
protocol to establish.  That is the interesting case for x2 and V.90, because
it puts this board on the *digital* side of an analogue connection with direct
access to the codewords.

```sh
.venv/bin/python -m courier_emu isdn-run Ie030002.nac --with-dsp \
    --bri-network --bri-establish terminal --bri-call-at 20000000 \
    --bri-call-to 7349195 --bri-bearer audio \
    --bri-tx-g711 answer.g711 --send ATA --send-after 30000000
```

## What comes back

49,006 octets of it, and it is not framing:

```
t=  0.00s  level   405.6  dominant 2100 Hz
t=  0.62s  level   434.9  dominant 2100 Hz
t=  1.25s  level   428.1  dominant 2105 Hz     <- a reversal inside the window
t=  1.88s  level   437.2  dominant 2100 Hz
```

with the phase of a 2100 Hz reference turning over at **0.47, 0.92, 1.37, 1.82,
2.27, 2.72 and 3.17 seconds** - 450 ms apart, six times running.  2100 Hz with
phase reversals every 450 ms is **ANSam**, V.8's answer tone, which is the one
a modem sends when it is willing to talk about V.90 rather than just V.34.  It
runs for about three seconds, stops, and starts again seven seconds later:
the modem answering twice, because nothing answered it back.

So the whole chain works, and it is a short chain:

```
SETUP (3.1 kHz audio, mu-law) -> RING -> ATA -> l4_CONNECT -> BCH_ENABLED
-> MCR1 = 16h -> the datapump -> ANSam on B1
```

No V.120, no X.75, no LLI, no SABME.  `courier_emu/v120.py` and
[imodem-v120.md](imodem-v120.md) are for the other kind of call - the digital
one - and nothing on this page needs them.

## The one thing that has to be right

**mu-law.**  The bearer capability's layer-1 protocol octet is `A2` for mu-law
and `A3` for A-law, and this modem takes the first and refuses the second:

| bearer capability | offered as | verdict |
|---|---|---|
| `90 90 a2` | 3.1 kHz audio, mu-law | ALERTING - it rings |
| `80 90 a2` | speech, mu-law | ALERTING - it rings |
| `90 90 a3` | 3.1 kHz audio, A-law | `SETUP with result= FFFE`, cause 88 |
| `80 90 a3` | speech, A-law | `SETUP with result= FFFE`, cause 88 |

Both directory numbers behave the same way, so it is the law and not the
number.  This is worth being blunt about because it produced a wrong reading
earlier in this work: `--bri-bearer speech` was refused, the refusal was read
as *the bearer class being wrong*, and the analogue call was written off.  It
was `A3`.  The peer now sends `A2` by default and `--bri-law a` asks for the
refusal on purpose.

## Where this goes

The bearer is an audio path with a datapump on it, and the far end of it is a
recording.  What it wants is a modem: something that answers ANSam with a V.8
call menu, negotiates, and trains.  The repository already knows a great deal
about what should be on that wire - [pcm-x2-v90.md](pcm-x2-v90.md),
[x2-v90-protocol-selection.md](x2-v90-protocol-selection.md),
[v34-arming.md](v34-arming.md), [answer-tone.md](answer-tone.md) - and the
analogue Courier's own datapump is in this tree to be pointed at it.

The useful shape of the next piece of work is therefore not more ISDN.  It is
connecting this bearer to the analogue side already modelled here, so the two
Couriers can answer each other.
