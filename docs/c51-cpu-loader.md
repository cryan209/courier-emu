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

## Remaining electrical question

The exact ASIC signal used to enter the ROM service trampoline, and its C51
interrupt identity, still need to be tied to a measured pin or captured event.
That uncertainty does not change the data path: the CPU and C51 instruction
streams independently agree on the four-word windows and 1/2/4 handshake.
