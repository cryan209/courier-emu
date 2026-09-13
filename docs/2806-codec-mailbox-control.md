# 2806 codec and audio-monitor control

Traced from the exact 25 MHz 7.3.14 / DSP 3.0.13 flash image and checked with live M/L setting probes on 2026-09-13. CPU addresses below are **ROM file offsets**; DSP addresses are program-word addresses.

## The volume-related mailbox command is 0x0f

The CPU L-command handler at 263c4 validates a value below four and stores it at RAM 05e7 (normal active-profile path). It calls both the board-latch routine at 25f4 and the mailbox routine at 0732.

The latter selects a gain from this table at 075c:

| Setting | Candidate mailbox argument |
|---|---|
| L0 | 0200 |
| L1 | 0600 |
| L2 | 0e00 |
| L3 | 3f00 |

It forces the argument to **zero** when RAM 0693 bit 08 is clear, or RAM 014b bit 01 is set. It sends tag 000f via the three-word queue thunk at 8f46:0224 (file f684). Therefore these values are conditional, not commands unconditionally issued on every board.

DSP tag 0f dispatches to 8246:

```
8246 smmr @7a, #039d   ; save host gain
8248 lamm @7a
8249 retc neq
824a lacc #8000
824c samm @50         ; silence/idle code for zero gain
824d ret
```

The receive-audio ISR at 8193 loads the codec ADC word, stores it in the receive ring, and loads TREG0 with it. At 8196 it reads data 039d (page 7, @1d). If nonzero, 8199–819d multiply by that gain, shift by 14, and write the result to DSP I/O 0050. The ordinary DAC/codec serial output follows independently at 819e onward.

This is an **audio-monitor sample-copy path through the ASIC**, not a codec register-4 write. The L-command caller is the evidence that the gain is volume-related. The electrical conversion of I/O 50 samples into an audible signal remains untraced; this analysis does not prove a DAC or PWM circuit inside the ASIC.

## M commands and the alternate volume-latch path

Live RAM snapshots establish M0/M1/M2/M3 at RAM 05e8. The exact M handler at 263f7 stores it there and calls the speaker wrappers at 2627/262b. These reach the generic latch clear/set routines with AX=1009. The port table at 27ef is 0010,0012,0014,0012, so index 1 means **CPU port 12, mask 10**. Clearing is the enable operation; setting is the disable operation. M2's immediate enable is conditional on RAM 033e bit 04. Call-state code also tests the saved M setting, so an idle M sweep is not an audible test of all modes.

The alternate volume routine at 25f8 returns immediately if RAM 0693 & 06 is nonzero. Otherwise it copies L bit 0 to port 12 mask 20 and L bit 1 to mask 40 using the same latch driver. These are CPU I/O operations, not DSP mailbox messages.

## What the live 2806 showed

The board reports serial 22AEB36ACKND and the expected 25 MHz / 7.3.14 / 3.0.13 identity. Original settings were **L2/M1**, read from RAM, and restored. RAM 0693 was **22 hex**: bit 08 clear and mask 06 nonzero. Thus the DSP-monitor gain argument is forced to zero and the direct volume-latch writer returns without writing on this board in this state.

The L sweep changed RAM 05e7 through 0,1,2,3 while monitor readback of port 12 stayed 9a. This agrees with the board-flag branch; readback alone does not establish that a writable latch equals its input readback. No call or off-hook test was made. A corrupt serial RAM reply interrupted the first volume run, whose finally block restored L2/M1 and AT response. A second run uses bounded read retries and retains the first capture.

The physical purpose of the board-type flags and the actual speaker/volume circuit on this external board still need identification. A manual volume control is a possibility, not established here.

## Mailbox commands that actually reach codec control

| Tag | DSP entry | Proven path in 3.0.13 |
|---|---|---|
| 0f | 8246 | Set gain for ADC sample copy to ASIC I/O 50; zero disables it. No codec control word. |
| 2c | 8222 | Bare RET: no-op in this firmware. |
| 55 | 8da5 | Calls codec writer 8149 with 0409 at 8dbc–8dbe, then enters mode-dependent initialization. |
| 59 | 8df9 | Reaches 8e0f/8e13: index 4 into rate selector 8151. |
| 5a | 8ddd | Reaches 8df3 then 8e13: index 4 into rate selector 8151. |

Selector 8151 writes four ASIC timing words and stages the row's codec word in data 006c with request 3 in 006b. Index 4 stages **0212**, B=18. The sender/ISR uses a secondary serial frame to transmit it directly from DSP to codec. Tag 55's branch can also reach that index. These are mode-initialization commands, not safe standalone volume controls, and were **not sent during this investigation**.

Only direct, decoded paths are claimed; this is not an exhaustive transitive call graph of every modulation overlay. Codec word 0409 and register-4 monitor bits must not be used to assert that the physical speaker is wired to MON OUT: the M/L trace establishes additional paths and that wiring was never measured.

## Reproduction and evidence

Artifacts: `artifacts/courier-2806-codec-control-20260913/`. `speaker_probe.py` records mode RAM snapshots. `volume_probe.py` records M/L values, port readback, board flags and restoration. `cpu-speaker-disassembly.txt` and `dsp-codec-disassembly.txt` record the bounded code paths. No RAM, flash, stored settings or arbitrary mailbox writes were used by these hardware probes; only volatile AT M/L settings and reads.
