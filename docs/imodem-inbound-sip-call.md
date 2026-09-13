# Inbound SIP: a real Courier calls the I-modem

This run reverses the existing live-call direction. A physical analogue
Courier originates a call through Asterisk; Asterisk sends the INVITE to the
emulator; the virtual NT presents a 3.1 kHz, mu-law Q.931 SETUP to the I-modem.
The SIP response follows what the I-modem actually does: 100 Trying on INVITE,
180 Ringing on ALERTING, and 200 OK with the emulator's PCMU SDP on CONNECT.

The SIP endpoint is deliberately registration-free. Configure the Asterisk
extension used by the physical Courier as a static contact for the host and
port below, for example `sip:courier@192.0.2.20:5062`. The `--bri-sip` address
must be the Asterisk signalling address because the UDP socket accepts the
INVITE and subsequent dialog requests from that peer.

Create an artifact directory, then run the emulator in terminal mode so it
stays available while the physical Courier originates:

```sh
mkdir -p artifacts/imodem-inbound-sip-live

.venv/bin/python -m courier_emu isdn-run Ie030002.nac --with-dsp \
    --terminal --report --no-flash-nvram \
    --bri-network --bri-establish terminal \
    --bri-sip asterisk.net.cryan.nz --bri-sip-username 6000 \
    --bri-sip-local-port 5062 \
    --bri-sip-record artifacts/imodem-inbound-sip-live/caller-to-imodem.g711 \
    --bri-tx-g711 artifacts/imodem-inbound-sip-live/imodem-to-caller.g711
```

At the I-modem terminal, enter `ATS0=1`. Once it replies `OK`, dial the
extension from the real Courier. End the run with Ctrl-]. Save the JSON report
printed on stderr as `artifacts/imodem-inbound-sip-live/run.json` (or redirect
stderr when starting the command).

Analyze both directions and make listenable WAV files:

```sh
.venv/bin/python tools/analyze_bri_sip_audio.py \
    --from-caller artifacts/imodem-inbound-sip-live/caller-to-imodem.g711 \
    --from-imodem artifacts/imodem-inbound-sip-live/imodem-to-caller.g711 \
    --output artifacts/imodem-inbound-sip-live
```

The evidence has three independent parts:

1. `bri.media_peer.sip.rtp_octets_received` says how many caller octets reached
   the RTP socket. `bri.media_peer.octets.received_from_rtp` counts how many
   were taken by the B-channel bridge. The exact bearer accounting identity is
   `received_from_rtp + silence_filled == bri.media.rx_delivered`; received RTP
   can exceed the consumed count by a final queued partial block.
2. `imodem-to-caller.g711` is captured at the DSP-facing B channel before RTP.
   A strong 2100 Hz window (and, over a sufficiently long interval, the 15 Hz
   ANSam modulation sidebands) shows that the I-modem's answer signal reached
   the bearer.
3. `caller-to-imodem.g711` contains only actual received RTP payload, never
   silence inserted for pacing. Non-idle audio with V.8 V.21 energy near
   980/1180 Hz demonstrates that the originating Courier's negotiation traffic
   reached the bridge; the delivered counter above closes the path to the DSP
   bearer.

The original outbound scenario is unchanged: supplying `--bri-sip-target` (or
letting the modem's dialled digits populate it) still makes `BearerSipLine`
call `SipSession.start_call()` and use the existing authenticated INVITE flow.
