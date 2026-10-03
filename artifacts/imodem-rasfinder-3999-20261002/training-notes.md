# RasFinder 3999 native I-modem call

Account 2903 placed one SIP dialog to 3999; hunt-group member 8416 answered.
The 49.23-second bearer had 390354 actual RTP octets and 3486 silence-fill
samples (0.89%). No SIP BYE, new INVITE, or second call appears in the run
report. The observed tonal restarts therefore occurred within one telephone
call, rather than being new SIP calls. The run ended at its instruction limit,
without CONNECT or NO CARRIER, and cleanup hung up the call.

The DSP's retained timeline reaches V.8 image request `0047:0006` at 9.8835
seconds and supervisor command `0002:a000` at 9.8870. There are no subsequent
retained replies, including no symbol-rate report `0034` or retrain report
`0006`. This does not yet prove the exact location of the stall: a live
program-transfer audit and state snapshots are needed to distinguish overlay
handoff from execution after the transfer. Audio continues in both directions.
The existing offline pair's verified later J wait must not automatically be
assigned to this live originate call.
