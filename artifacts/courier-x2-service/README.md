# Courier x2 activation test endpoint

Deployed 2026-10-07 to tower.net.cryan.nz, existing v90modem-sip container.
Isolated source/binary directory: /root/courier-x2-service.
Asterisk internal extension: 6012; endpoint-modem template, ulaw only.
MODEMEXT/6012=1 bypasses MixMonitor in the existing dialplan.
SIP 5072, RTP base 4072; auto-answer one ring; V.22 1200 mode (changed after live V.34 retraining failures).
ME_V42_T400_MS=5000 extends error-control detection for this experiment.
Service log: /root/courier-x2-service/service.log inside container.
Credentials remain on the hosts and are omitted from this artifact.

COURIER_X2_ACTIVATE=1 enables one frame per v42_restart, queued after
two seconds of transmit bits in LAPM_DATA. Frame: 01 02 0a 02 25.
This is an experimental vendor command derived from saved firmware, not
an ITU command. It attempts to set feature record 2 mask 0x10, adding x2.
No physical Courier call has been placed. Registration is verified.
Deployed library transmitter test recovered exactly one frame with valid
HDLC FCS over 100000 bits. The test forces LAPM_DATA; it does not establish
a real peer link or prove the physical Courier accepts the frame.

Dial ATDT6012, allow CONNECT and 10 seconds, disconnect, then inspect ATI7
and ATY14. Expected record change is 015 to 031 if the firmware accepts it.
The service process is running detached; automatic restart after container
restart has not been configured. Existing modem installation is untouched.

Live calls: V.34 reached MP then peer retrain; V.22 physical training
completed but detection fell back to V.14. No activation frame sent.
Restart command: docker exec -d v90modem-sip sh /root/courier-x2-service/start.sh

## Detection defect found and corrected
The live TX capture contained nine complete E/C ADP pairs per call, then
HDLC flags; RX contained repeated Courier ODP and no flags. The answerer
increments txadps before sending and its >=10 branch ended after nine.
V.42 (2002) 7.2.1.3 requires at least ten complete ADPs; Appendix III.1
recommends substantially more. The isolated service now sends 32 complete
pairs (pre-increment threshold 33), unless the existing peer-flag detection
path moves it to establishment earlier. Explicit transmitter count test:
ADP E=32 C=32. Full v42_link_test passes. Live acceptance remains to be tested.

Latest failed-call capture: courier-latest.rx.ulaw and .rx.bits/.tx.bits.
TX has 32 complete E/C pairs and 74 flags; RX has 24 even / 23 odd DC1
ODP characters and no flags. test_audio.c passes the captured TX bits through
a V.22 1200 answer datapump, G.711 mu-law quantization and a caller datapump:
32 E / 32 C / 74 flags recovered. This tests paired software datapumps;
it does not prove delivery to or compatibility with the real Courier.
Outgoing RTP-bound codeword capture added using add_tx_capture.py;
COURIER_TX_AUDIO_CAPTURE points to audio.tx.ulaw. RX capture is audio.rx.ulaw.
Their time origins must not be assumed equal (TX includes idle callback time).

Actual audio analysis (latest call): courier-live.tx.ulaw independently
replayed through a caller V.22 receiver at multiple start offsets recovers
32 E / 32 C / 74 flags. courier-live.rx.ulaw through an answer receiver
recovers 47 ODP characters, zero HDLC flags. Thus the live bit callback did
not overlook a Courier LAPM response. This does not verify the waveform at
the Courier's analog input: outgoing capture is before RTP/ATA delivery.
The underlying live interoperability issue remains unresolved. Earlier
ADP count and timer fixes are valid but did not establish the physical link.
