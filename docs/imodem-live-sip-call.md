# A real call, to a real Courier

The far end of this one was not a model.  `6000@asterisk.net.cryan.nz`, dialling
`8406`, which rings a **USRobotics Courier V.Everything** on a serial port -
supervisor 7.3.14, DSP 3.0.13, `HST,V32bis,Terbo,VFC,V34+,x2,V90` - with
`ATS0=1` so it answers.

```sh
COURIER_SIP_PASSWORD=... .venv/bin/python -m courier_emu isdn-run Ie030002.nac \
    --with-dsp --bri-network --bri-establish terminal \
    --bri-sip asterisk.net.cryan.nz --bri-sip-username 6000 \
    --bri-sip-record heard.g711 --bri-tx-g711 said.g711 \
    --send 'ATDT8406' --send-after 30000000
```

## What worked, which is most of it

```
l4_SETUP : modem primitive | BCH_ENABLED Detected | Prim = N_CONN_CF :
dialled '8406' -> INVITE target '8406'
tx INVITE cseq=1 | rx 401 | tx ACK | tx INVITE cseq=2 | rx 100 | rx 183 | rx 200 | tx ACK
rtp sent 911   received 1588
octets to_rtp 145769   from_rtp 145769   silence_filled 439
```

Every joint held.  `ATD` now places a call - which it could not do before
[imodem-b-channel-silence.md](imodem-b-channel-silence.md), because the data
link gate was shut - the peer connects it, the bearer comes up, the bridge
authenticates against a real Asterisk, the call reaches a real modem across a
real network, **it rang**, it answered, and audio flowed both ways.  The
silence fill was 439 octets in 145,769: three parts in a thousand, so the
emulator was very nearly keeping up with the wire.

And `NO CARRIER` at both ends.

## Why they did not train

Not the network, and not the pacing.  The modem was never having an analogue
conversation.  Its own `ATD` SETUP says so:

```
SETUP  bearer capability 88 90          unrestricted digital, 64 kbit/s
       channel id 83                    B1
       keypad facility 38 34 30 36      '8406'
       low layer compat 88 90 28 48 76 3b c0 c2 e2    V.120
```

**It dials V.120.**  The recorded bearer agrees: `said.g711` is silence from
end to end - one sample above the noise floor in 145,769 - where an originating
analogue modem would be sending a calling tone and then answering ANSam.  The
real Courier answered, sent its answer tone into the bridge, heard an idle
digital link back, and timed out.  So did we.

This run predated reliable multi-command delivery.  The conclusion that
`AT*V2=3` did not move the bearer was a harness artifact: the setting is
accepted and persists as binary `03` at record offset `0x25f`.  With the
fixed sequencer, `AT*V2=3`, `AT&W`, `ATD8406` sends `90 90 a2` (3.1 kHz
audio, mu-law) and no LLC.  See
[imodem-dialling-analogue.md](imodem-dialling-analogue.md) for the control and
the S80 speech override.

## Two things the live call gave up for free

**The dialled digits are in the keypad facility.**  `ATDT8406` arrives as IE
`2c`, `'8406'` in ASCII, not as a called party number - which is why the peer
used to report a perfectly good dial as `the modem is calling (no number)`.
It reads both now, and `--bri-sip-target` is optional: the number the modem
dialled is the number the bridge INVITEs.

**The modem's own V.120 low layer compatibility**, which is worth more than
the call was.  [imodem-v120.md](imodem-v120.md) had to guess those octets and
the guess was refused; these are the firmware's own, and offered back to it
they are **accepted** - the call rings, `BCH_ENABLED`, the bearer carries
flags - where `1080` got `MISC_INFO` and a cleared call.  `--bri-v120-llc
48763bc0c2e2` is the value to use.  The modem still does not answer SABME, so
that question is unchanged, but it is no longer sitting behind a refused SETUP.

## The next live run

The analogue side of this board works - it answers an audio call as a modem
and puts ANSam on the bearer ([imodem-audio-bearer.md](imodem-audio-bearer.md)).
It can also originate one when `*V2=3` is selected.  The original roles no
longer have to swap merely to obtain an analogue bearer.

The existing outbound SIP bridge can now repeat this call with `*V2=3` and put
the two datapumps on an analogue bearer.  Inbound INVITE support remains useful
for reversing the roles, but it is no longer a prerequisite for trying the
original direction again.

Pacing is the question after that, not before it.  439 octets of fill in this
run says the bearer can very nearly keep pace with real time; whether *very
nearly* is good enough for a V.8 handshake is worth finding out rather than
assuming.  The mapped setting now makes that experiment possible.
