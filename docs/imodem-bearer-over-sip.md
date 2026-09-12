# The B channel as a SIP call

[imodem-audio-bearer.md](imodem-audio-bearer.md) ends with the I-modem
answering an audio call as a modem, putting ANSam on the bearer, and finding
nothing at the other end of it.  `--bri-sip` puts a SIP call there.

```sh
.venv/bin/python tools/sip_answer_sink.py answer.g711 150 &

.venv/bin/python -m courier_emu isdn-run Ie030002.nac --with-dsp \
    --bri-network --bri-establish terminal --bri-call-at 20000000 \
    --bri-call-to 7349195 --bri-bearer audio \
    --bri-sip 127.0.0.1:5060 --bri-sip-target 5551234 \
    --send ATA --send-after 30000000
```

and the modem's answer tone comes out of the far end of an RTP stream:

```
bri.media_peer   INVITE to 5551234
                 tx INVITE cseq=1 | rx 200 | tx ACK cseq=1
                 state connected, 588 RTP packets sent
94,080 octets recorded, 2100 Hz throughout
```

## Why this join needs nothing in the middle

A B channel carries 8000 octets a second of G.711.  RTP's PCMU payload *is*
8000 octets a second of G.711.  They are the same octets, so the bridge
converts nothing:

* **no resampling** - both sides are 8 kHz.  `ata.py`, which puts the analogue
  board on a SIP line, has to run a polyphase filter because that board's codec
  path is not;
* **no companding conversion** - mu-law in, mu-law out.

The second one is not tidiness.  `SipSession`'s linear path decodes each
codeword to a sample and re-encodes it on the way out, and that round trip is
identity for 255 of the 256 codewords and **not for `7f`**.  One in 256 would
be inaudible in speech and is a defect here: V.90 and x2 are built on exact
codewords - the whole idea is that the digital end of the call places them on
the wire itself - and this board is that end.  So `send_pcmu` and
`receive_pcmu` were added beside `send_audio`, and the analogue path is left
exactly as it was.

`tests/test_bearer_sip.py` puts all 256 codewords through a real socket pair
and checks they arrive unchanged, and checks the linear path against the same
256 so the reason stays written down.

## What it does not pretend

The emulator runs on an instruction budget and RTP runs on a clock, and the two
disagree about how long a second is.  The bridge does not paper over that: it
returns exactly as many octets as it was handed, fills what has not arrived
with mu-law silence, and **counts every octet of the fill**.  A run says so
plainly:

```
octets  to_rtp 94096  from_rtp 94096  silence_filled 94096
```

- everything the modem said went out, and nothing came back, because the sink
above sends no audio.  A far end that does send audio will show the fill
falling, and how far it falls is the honest measure of how close to real time
that run was.  Nothing here tries to make the two clocks agree; a run that
needs them to is a different piece of work, and it should be a deliberate one.

## Where it goes

The obvious far end is the other Courier.  This tree already models the
analogue board and its datapump, and
[ata-sip-line.md](ata-sip-line.md) already puts that board on a SIP line
through `LineExchange`.  Both ends now speak PCMU to a SIP server, which means
the ISDN Courier and the analogue Courier can be pointed at each other through
one - the digital end placing codewords directly on the bearer, the analogue
end hearing them through a codec.  That is the shape of an x2 or V.90
connection, and it is the first time this repository has had both halves of it
able to reach the same wire.
