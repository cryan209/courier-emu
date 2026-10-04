# The 80186/C51 download architecture

Analysis of the captured 4.03 supervisor and recovered C51 mask ROM, 2026-09-14.
Addresses in the CPU listings are offsets in the supervisor's `0x8000` code
segment; addresses in the C51 listings are DSP word addresses.

## Conclusion

The 80186 does not address the DSP program SRAM and the ASIC does not need the
DSP's full program address bus. The CPU fills four-word ASIC holding windows.
Code running on the C51 reads those words through the ASIC's DSP-side register
window and writes them to program memory with `BLDP`/`BLD(P)`, maintaining the
full destination address itself.

There are two consumers of the same physical transport:

* the mask-ROM service loader at program `0610` installs or reloads the
  resident image;
* the downloaded resident's loader at `811b..8138` installs call overlays.

Consequently, emulation must not publish a completed resident through the
serial receiver or publish an overlay with `load_program`. It should model the
shared ASIC holding registers, status, acknowledgements and C51 event, then let
the original CPU and DSP instructions perform the transfer.

## Reset line

The supervisor is an 80C186EB in the 80-lead QFP. CPU pin 58 is `P1.1`, whose
latch is bit 1 of `P1LTCH` at relocated peripheral-control address `ff56`.
That one net reaches C51 `RS` (pin 127) and the codec reset input:

```text
ff56 bit 1 -> P1.1 / CPU pin 58 -> C51 RS
                                  -> codec RESET
```

The line is active low. The routine at CPU `e3aa` clears bit 1, resets the
download/status registers, delays, and sets bit 1 again. The emulator should
therefore reset and stop both modeled devices on the falling edge and start the
C51 at program `0000` on the rising edge. Recognising the first eight payload
bytes is not a substitute for this observable signal.

## Resident transfer from the CPU

The launch routine at CPU `e3aa` first writes the requested DSP destination to
ports `40` and `42`, then pulses `ff56` bit 1. After release it waits for the
far-side state and writes `02` to port `1c`.

The checksum routine at `e447` sums the 16-bit payload words and saves the
result at CPU data `0e39`.

The transfer routine at `e47b` sends eight words per outer iteration:

1. Four little-endian words go through CPU ports `40..4e`; `out 18,1` commits
   the group and the CPU waits for acknowledgement bit 1.
2. Four little-endian words go through CPU ports `50..5e`; `out 18,2` commits
   the group and the CPU waits for acknowledgement bit 2.
3. At the end, the saved checksum goes through `40/42`; `out 18,4` submits it
   and the CPU waits for acknowledgement bit 4.

Thus ports `40..4e` and `50..5e` are two CPU-facing banks of four 16-bit
holding registers. Port `18` is their resident-download commit/status port.

## Matching mask-ROM service loader

Reset code installs the service entry in the ROM interrupt trampoline table:

```asm
0672  splk  @6a, #0610
```

The routine at `0610` initializes the service state. It obtains the requested
program destination through ASIC cell `@58`, saves it as the program-memory
pointer in `@1f`, and retains it in `@7d` as the final entry address. It polls
ASIC status cell `@56`.

For status bit/group 1 it takes four words beginning at `@58` and executes a
four-word `BLDP *+` transfer. It writes `1` to `@56` to acknowledge and advances
the program pointer by four. The indirect source pointer advances too, so group
2 consumes the second ASIC bank at `@5c..@5f`, then acknowledges with `2`.
Completion writes `4` to `@56` and branches through the entry saved in `@7d`.

This is an exact structural match for the CPU routine: four-word banks,
statuses 1 and 2, completion 4, and a destination supplied before reset. It is
not the generic `XF`/`BIO` boot loader at `072c`.

## Overlay transfer

The overlay sender uses the same eight CPU data ports but port `1e` for its
handshake. It commits words 1-2 with value 1 and words 3-4 with value 2, then
uses value 4 as the transfer boundary.

The resident C51 routine at `811b..8138` is the receiving side. It reads the
initial program address through external ASIC cell `ff62`, reads four source
words beginning at `ff58`, calls the existing wait/handshake helper at `23f0`,
writes each word to program memory with `BLDP`, increments the destination, and
writes `0300` to `ff57` as its acknowledgement.

The resident and overlay protocols therefore differ in framing and in the C51
routine consuming the words, but not in physical architecture. Both use ASIC
holding registers and make the C51 perform the program-memory writes.

## Emulator consequence

The bridge should expose one shared ASIC download device with:

* CPU-side byte lanes `40..5e` and command/status ports `18` and `1e`;
* DSP-side registers/status at `ff57`, `ff58..ff5f` and `ff62` (with the
  applicable mask-ROM direct-page aliases);
* four-word commit state and real back-pressure;
* the C51 interrupt/event associated with a committed group;
* acknowledgements generated only by the C51's writes.

For ROM-enabled boards, remove the synthesized `queue_codec_boot` table and
boot-word selection of the serial loader. For overlays, remove direct
`load_program` publication. Correct completion is the original C51 reaching
the requested program address after its own `BLDP` operations.

## I-Modem reset control

The I-Modem presents the same four-word transfer protocol to its 386EX, but
not the analog board's 80C186EB GPIO register. Its software-visible reset
transaction is `out 18,ff`: the supervisor writes the destination to `40/42`,
sends `ff` to ASIC port `18`, and subsequently uses values 1, 2 and 4 on that
port for the two four-word banks and completion. The current `ImodemDsp.write`
model already treats `18=ff` as reset, but implements it by closing the native
core and later constructing a preloaded one.

The proper model should make `18=ff` an ASIC command that asserts the C51 reset
output. Release and loader entry must follow the subsequent supervisor/ASIC
handshake, rather than recognizing destination `8000` or waiting until the
checksum. Unlike the analog board's directly measured `P1.1` net, the I-Modem
ASIC output pin and physical reset-net routing have not yet been established by
continuity, so the software command is firm while its final pin remains open.

## Service-path wake signal

The physical wake signal is the reset net already identified above: 80C186EB
`P1.1` (CPU pin 58) drives C51 `RS` (pin 127). Its falling edge resets the C51;
release starts the C51 mask ROM, whose reset setup installs and reaches the
service-loader path. This is not a separate, unidentified ASIC interrupt pin.
The CPU and C51 instruction streams independently establish the subsequent
four-word windows and 1/2/4 handshake.

## Earlier supervisors: 5/25/94 and the SDL images to 3/13/98

Measured 2026-10-04 on the Metropoli BBS SDL images (`firmware/legacy-usrobotics`),
unpacked with `tools/unpack_sdl.py`. The flash image carries no boot block, so
`courier_emu.rom.CourierRom` needs the top 16 bytes of `IDSDL302.ROM` grafted on
and its supervisor identification check bypassed before it will load one.

Every image has the same 1/2/4 holding-register transfer: two `out 0x18,1`, one
`out 0x18,2`, two `out 0x18,4`. The DSP resident is a C5x image for `0x8000` in all
of them:

| Supervisor | Payload words | Found by |
|---|---|---|
| 5/25/94 | 32329 (32312 before `ffff` padding) | the 5/94 sequence below |
| 5/15/95, 6/9/95, 7/5/95 | 25549, 25568, 25620 | `CourierRom.dsp_download` |
| 11/1/95, 1/23/96 | 26535, 26601 | `CourierRom.dsp_download` |
| 3/13/98 | 27710 | `CourierRom.dsp_download` |

`dsp_download` finds nothing in the 5/25/94 and 6/10/94 images. They launch with
the same routines but a different call shape, so the regex does not match. The
5/25/94 sequence, in the supervisor's code segment:

1. `0xc8d6f` calls `0xce220`, which sends eight words of `0x0083` to DSP
   destination `0xfff8` (`mov ax,0xfff8; call 0xce25a`, then eight word writes
   through ports `40`/`42` and `out 0x18,1`/`out 0x18,2`). The boot-mode word is
   written explicitly; later builds are not known to do this.
2. `mov ax,0x8000; call 0xce25a` writes the destination to ports `40`/`42`,
   clears bit 1 of `0xff56`, writes `0xffff` to ports `18`/`1a`/`1c`/`1e`,
   waits, and pulses bit 1 back. It then polls ports `18`/`1a` and `1c`/`1e`
   for `0xffff`.
3. `mov ax,0; mov cx,0xfc92; call 0xce323` transfers `0xfc92` bytes from
   `e3aa:0000` (physical `0xe3aa0`) through the four-word windows, then sends
   the checksum with `out 0x18,4`. The source segment is hard-coded at
   `0xce35c`.

The payload begins `bc00 ae57 ffff be41 bc00 ae2a 0010`, word for word the opening of
the 6/9/95 resident, though only 123 words match at the same index over the
whole image.

`out 0x1c,2` after the reset pulse, which this document names for the 4.03
supervisor, is not a version marker. The 5/94 code writes port `1c` with
`mov dx,0x1c; out dx,al`, which a search for `mov al,2; out 0x1c,al` does not find.

### Use of the on-chip ROM tables

Question: do the early residents lean on the DSP mask ROM's tables
([dsp-rom-content-analysis.md](dsp-rom-content-analysis.md)) where later ones carry their
own copies? On two crude tests, no:

* None of the residents, 5/94 to 3/98, contains the ROM's quarter-wave cosine table
  (`0x40..0x240`, Q14) in any of the variants searched: cosine and sine at 256 to
  4096 points, Q12 to Q15.
* Control-flow targets in the ROM table and helper range `0x40..0x615` number about
  73 in 5/25/94, 47 in 5/95 to 7/95, 58 to 59 in 11/95 and 1/96, and 102 in 3/98.
  `splk #0040` and `lar #0244` occur at about the same counts in all of them.

Both counts come from linear disassembly (`tools/c5x_disasm.py`), which reads data
as code, so the numbers are noisy. Not tested: table copies that are scaled,
interleaved or packed, and what the code reads from `0x40..0x5af`.

