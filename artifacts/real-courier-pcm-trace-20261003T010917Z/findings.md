# Real Courier capture: V.34 connection and outgoing media stall

The third incoming call connected at 31,200/33,600 using V.34/LAPM/V42BIS.
The physical Courier subsequently reported loss of carrier after 4:40,
21 block errors, one granted retrain, 36.7 dB SNR, and 308 ms round-trip delay.
Its V.90 status was 02F7, identifying an x2 server but no PCM connection.
The I-modem last-call report recorded 2:17, 1,728 block errors, three link
timeouts, six retransmissions, and one granted retrain.

The application RTP trace and Asterisk PCAP contain no missing, duplicate,
out-of-order packets or timestamp discontinuities in the connected call.
Before CONNECT, the largest observed outgoing packet interval was about 25 ms.
About 17 seconds after CONNECT, an outgoing packet interval reached 160.094 ms
at Asterisk. The incoming packets remained regular (largest interval about
24 ms). DSP transmit reserve dropped below its priming threshold; after the
outage its queued audio grew from roughly 60 ms to over 200 ms.

The corrected PIT time source and DSP sample clock track wall time, while
CPU instruction progress falls substantially behind. This does not ensure
that the firmware receives every timer edge: the scheduler raises only one
PIC request for multiple elapsed periods, and a PIC request bit also
coalesces edges while an earlier request remains pending.

A one-second process sample shows substantial time in native C5x execution
and in Python/FFI work. The live DSP catch-up loop could continue until its
entire absolute wall-clock target was reached, holding off the next CPU
slice during a backlog. Live DSP catch-up is now limited to a one-millisecond
host-time slice, returning at PCM-frame boundaries while retaining its cycle
deficit. The next report and trace count coalesced timer edges. This change
needs a hardware retest; it does not establish the cause of x2 fallback.

Files: analysis.json, timeline.jsonl, run.log, asterisk-next-call-rtp.pcap,
process-sample.txt, and the three raw G.711 captures in this directory.
