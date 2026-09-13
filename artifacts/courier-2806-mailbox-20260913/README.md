# 2806 mailbox handshake, 2026-09-13

Target: 25 MHz Courier 2806, serial 22AEB36ACKND, supervisor 7.3.14, DSP 3.0.13. Probe operates through the serial monitor with the native supervisor and DSP running. Only mailbox ports 58, 5a, 5c, 5e, 1e and 1c were written. No firmware, RAM, NVRAM, board latches, dial or reset commands were used.

## Direct observations on this board

The decisive transaction is in first-results.json and first-transcript.json:

| Step | Reply tag | Reply data | CPU 1c |
|---|---|---|---|
| Baseline | 0008 | 0000 | fd |
| Stage tag 0007, data a55a across four bytes | 0008 | 0000 | fd |
| Write 1e=00 | 0008 | 0000 | fd |
| Write 1c=01 | 0031 | 0000 | fd |
| Read again | 0031 | 0000 | fd |

This establishes that staging the final data byte does not itself send this query. The additional 1e=00 write does not send it either. The 1c=01 write completes the transaction. Readback remains the prior DSP reply while the CPU writes a different outbound tag and data: the two directions have distinct storage or equivalent independent state.

The first run stopped during a later no-op snapshot because the existing parser required a particular line ending. The completed repeat, results.json/transcript.json, accepts the observed line-ending variants and runs query 07, no-op 2d, query 07 with different ignored data patterns. All readbacks remain 0031:0000, and final AT returns OK. Since the replies are identical, those repeated queries alone do not prove new replies were generated. The first 0008→0031 transition is the decisive evidence.

## Protocol reconstructed from exact 2806 firmware and prior board evidence

CPU tag low/high = ports 58/5a. CPU data low/high = ports 5c/5e. DSP tag = I/O 5e; DSP data = I/O 5f. DSP status = PA7 / 57. These identically numbered ports belong to different processors and are not interchangeable.

CPU→DSP:
1. CPU 1c bit 0 means input slot free.
2. CPU stages tag/data bytes, then writes bit 0 to 1c to publish.
3. DSP PA7 bit 0 means input pending.
4. DSP reads tag/data, then writes 0001 to PA7 to acknowledge receipt and release the input slot.

DSP→CPU:
1. DSP PA7 bit 1 means output slot free.
2. DSP writes tag/data, then writes 0002 to PA7 to publish.
3. CPU 1c bit 1 means reply pending.
4. CPU reads the reply and writes bit 1 to 1c to acknowledge and release the output slot.

The DSP receiver at 839b reads both words and acknowledges at 83b3–83b4 BEFORE command dispatch. The sender at 83d6 tests availability, writes the tag at 83eb and data at 83ee/83f6, then publishes in the delayed-return slots at 83fe–83ff. See dsp-disassembly.txt. The CPU handler at ROM file fde0–fe68 tests bits 0/1/2, stages the bytes, and writes its serviced mask to 1c at fe4a, then the high byte to 1e. See cpu-handler.txt. Thus 1c is an action/handshake interface, not a replacement value for the entire status register.

A minimal functional model has two independent tag/data holding registers and two full flags. CPU-free = NOT host_to_dsp_full; DSP-pending = host_to_dsp_full. DSP-free = NOT dsp_to_host_full; CPU-pending = dsp_to_host_full. Acknowledgement releases availability; retained reply data remains readable. This is a behavioural model, not proof of physical FIFO depth or flip-flop count.

## Limits

All serial snapshots read 1c=fd: the native supervisor services replies before the slow monitor can expose the transient pending state. Consequently this run does not directly time DSP acknowledgement, prove that the CPU acknowledgement alone clears pending, establish FIFO depth, or determine interrupt edge/level behaviour. Opposite-side status semantics are supported by the exact resident firmware and earlier 20.16 MHz kernel measurements documented in docs/dsp-mailbox-board-fix.md and docs/mailbox-from-the-rom-dump.md; they were not independently sampled on the DSP in this run.

Port 1e=00 is included in the known transaction, but necessity and the function of nonzero values remain unproven. Bit 2 (stream channel) and download-window handshakes were not exercised. A definitive transient/backpressure experiment needs a bounded CPU/DSP probe with exclusive mailbox ownership; the existing co-resident runner is guarded for 20.16 MHz 7.4.16 firmware and was not repurposed blindly for this board.
