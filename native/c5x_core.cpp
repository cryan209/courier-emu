// SPDX-License-Identifier: BSD-3-Clause
// Opcode helpers and execution behavior adapted from MAME's BSD-3-Clause
// TMS320C5x implementation, copyright Ville Linde.
#include "c5x_core.h"

#include <algorithm>
#include <cmath>
#include <cstdarg>
#include <cstdio>
#include <cstring>
#include <stdexcept>

namespace courier {

// Serial port control register bits. The firmware writes 0x40c8 at program
// 0x00c0: receiver and transmitter out of reset, burst frame sync, and both
// TXM and MCM clear, which makes the C52 a slave to an externally supplied
// clock and frame sync. That is the arrangement the DAA chipset's own
// documentation describes, with the board clocking the bus.
//
// The status bits below are the half this core did not model. Without them a
// transmit handshake never completes: the firmware writes DXR twice at
// program 0x00c2 and then waits forever for a readiness it is never told
// about, which is exactly what the access counts showed.
// FO, the word format, is SPC bit 2 - C5x user's guide table 9-13, and the bit
// docs/quad-dsp-pcm-path.md separates the two products on. The Quad writes
// 40cc, FO = 1, eight-bit bytes; the I-modem and the 302 write 40c8, FO = 0,
// sixteen-bit words. At 8 kHz that second case is two eight-bit
// peripheral-port time slots per frame, MSB first, which puts the frame's
// first slot in the high byte at both ends.
static constexpr uint16_t SPC_FO   = 1u << 2;   // word format: 1 = byte
static constexpr uint16_t SPC_XRST = 1u << 6;   // transmitter out of reset
static constexpr uint16_t SPC_RRST = 1u << 7;   // receiver out of reset
static constexpr uint16_t SPC_RRDY = 1u << 10;  // a received word is waiting
static constexpr uint16_t SPC_XRDY = 1u << 11;  // DXR can take another word

[[noreturn]] static void fatalerror(const char *format, ...)
{
    char buffer[512];
    va_list arguments;
    va_start(arguments, format);
    std::vsnprintf(buffer, sizeof(buffer), format, arguments);
    va_end(arguments);
    throw std::runtime_error(buffer);
}

C5xCore::C5xCore() { reset(); }

void C5xCore::reset()
{
    m_pc = m_op = 0;
    m_acc = m_accb = m_preg = 0;
    m_treg0 = m_treg1 = m_treg2 = 0;
    std::fill(std::begin(m_ar), std::end(m_ar), 0);
    m_rptc = -1;
    m_bmar = 0; m_brcr = 0; m_paer = m_pasr = 0;
    m_indx = m_dbmr = m_arcr = 0;
    m_st0 = {}; m_st1 = {}; m_pmst = {};
    // MP/MC comes out of reset at the pin's level. This firmware's reset code
    // preserves it - `APL #0x07f8, @07` keeps bit 3 and clears IPTR - so the
    // pin decides what program 0x0000 is for the whole run.
    m_pmst.mpmc = m_mpmc_pin;
    m_map = {};
    m_st0.intm = 1;
    m_st1.c = 1; m_st1.hm = 1; m_st1.sxm = 1; m_st1.xf = 1;
    m_xf_falling_edges = 0;
    m_ifr = m_imr = 0;
    m_interrupt_vectors.fill(0xffff);
    m_line_frame_irq = -1;
    m_line_frame_interrupts = 0;
    m_line_frame_next_cycle = 0;
    m_line_frame_phase = 0;
    m_line_sample_phase = 0;
    m_line_sample_due = false;
    m_line_dac_sum = 0;
    m_line_dac_count = 0;
    m_call_tdm_active = false;
    for (auto &phase : m_line_phase_tx) phase.clear();
    m_line_frame_entry = -1;
    m_pending_overlay.clear();
    std::fill(std::begin(m_pcstack), std::end(m_pcstack), 0);
    m_pcstack_ptr = 0;
    m_rpt_start = m_rpt_end = 0;
    m_cbcr = m_cbsr1 = m_cber1 = m_cbsr2 = m_cber2 = 0;
    m_timer = {}; m_serial = {}; m_tdm = {}; m_shadow = {};
    // Both wait-state registers come out of reset at maximum.
    m_pdwsr = m_iowsr = 0xffff; m_cwsr = 0x000e;
    m_codec_rx.clear();
    m_codec_boot.clear();
    m_line_rx.clear();
    m_line_tx.clear();
    m_line_rx_consumed = m_line_tx_nonzero = 0;
    m_line_tx_last_pc = 0;
    m_v8_mode = V8Mode::Off;
    m_tdm_rx_ready = false;
    m_v8_callback_ready = false;
    m_negotiation_loop_active = false; m_negotiation_loop_entries = 0;
    m_negotiation_loop_pc = m_negotiation_source = m_negotiation_pair = 0;
    m_negotiation_source_value = m_negotiation_pair_value = 0; m_negotiation_acc = 0;
    m_v8_dispatches = 0; m_v8_record = m_v8_handler = 0;
    m_v8_countdown = m_v8_flags = 0;
    m_negotiation_d76 = m_negotiation_d77 = 0;
    m_negotiation_d78 = m_negotiation_d79 = 0;
    m_negotiation_d26 = m_negotiation_indx = 0;
    m_negotiation_arp = m_negotiation_pm = 0;
    m_idle = false;
    m_instructions = m_cycles = 0;
    m_step_cycles = 0;
    m_io.fill(0xffff);
    m_mailbox_output.fill(0);
    m_io_events.clear();
    m_data_events.clear();
    m_data_write_counts.fill(0);
    m_pc_trace.clear();
    m_trace_data_writes = false;
}

void C5xCore::load_program(const uint16_t *words, std::size_t count, uint16_t origin)
{
    if (count > 65536u - origin) throw std::out_of_range("program image exceeds C5x address space");
    std::copy_n(words, count, m_program.begin() + origin);
}

void C5xCore::schedule_call_overlay(uint16_t origin, const uint16_t *words,
    std::size_t count, uint16_t entry, const uint16_t *registers,
    uint16_t selector)
{
    if (count > 65536u - origin)
        throw std::out_of_range("program overlay exceeds C5x address space");
    m_pending_overlay_origin = origin;
    m_pending_overlay.assign(words, words + count);
    std::copy_n(registers, m_pending_call_registers.size(),
        m_pending_call_registers.begin());
    m_pending_call_selector = selector;
    m_line_frame_entry = entry;
}

void C5xCore::load_data(const uint16_t *words, std::size_t count, uint16_t origin)
{
    if (count > 65536u - origin) throw std::out_of_range("data image exceeds C5x address space");
    std::copy_n(words, count, m_data.begin() + origin);
}

void C5xCore::load_rom(const uint16_t *words, std::size_t count, uint16_t origin)
{
    if (count > C5X_ROM_WORDS - origin)
        throw std::out_of_range("boot ROM image exceeds the C52's on-chip ROM");
    std::copy_n(words, count, m_rom.begin() + origin);
    m_rom_present = true;
}

void C5xCore::set_shared_window(uint16_t first, uint16_t last)
{
    m_shared_first = first;
    m_shared_last = last;
}

void C5xCore::set_mpmc_pin(uint16_t level)
{
    m_mpmc_pin = level ? 1 : 0;
    m_pmst.mpmc = m_mpmc_pin;
}

void C5xCore::set_io_callbacks(IoRead read, IoWrite write)
{
    m_io_read = std::move(read); m_io_write = std::move(write);
}

// The C5x's own cycle clock, which is what m_line_frame_period counts in.
// 3472 cycles is 7200 Hz here, which is the figure this core shipped with.
static constexpr uint64_t C5X_CLOCK_HZ = 25'000'000;

void C5xCore::configure_digital_pcm(bool enabled, uint16_t idle_codeword,
    uint32_t clock_hz)
{
    m_digital_pcm = enabled;
    m_g711_idle = idle_codeword & 0xff;
    // A DS0 presents exactly one octet every 125 us. The Quad clocks both its
    // 80186 and C50 at 20.16 MHz; this is intentionally not the 25 MHz clock
    // used by the analog Courier's codec model.
    m_line_frame_period = enabled ? unsigned(clock_hz / 8'000) : 258;
    m_codec.tx_ready = true;
}

void C5xCore::queue_g711_rx(const uint8_t *codewords, std::size_t count)
{
    for (std::size_t index = 0; index < count; ++index)
        m_g711_rx.push_back(codewords[index]);
}

void C5xCore::configure_rom_codec(bool enabled)
{
    m_rom_codec = enabled;
    m_codec = Ac01{};
    // Until the firmware programs the A and B registers the harness keeps the
    // period it has always used. The datasheet's power-up A = B = 18 would put
    // the part at 4444 Hz, which is a rate this board never runs at; nothing
    // here knows what the ASIC clocks the port at before programming, so this
    // stands in for it rather than claiming to model it.
    m_line_frame_period = enabled ? 3472 : 258;
}

void C5xCore::set_codec_mclk(uint32_t hz)
{
    m_codec.mclk_hz = hz;
    if (m_codec.rate_programmed) codec_recompute_rate();
}

// fs = MCLK / (2 x A x B), datasheet equations 11 and 20.
void C5xCore::codec_recompute_rate()
{
    const uint64_t a = m_codec.registers[1], b = m_codec.registers[2];
    if (!a || !b) return;  // an unusable divider leaves the last good rate
    const uint64_t divisor = 2 * a * b;
    m_codec.sample_rate_millihz = uint64_t(m_codec.mclk_hz) * 1000 / divisor;
    m_codec.rate_programmed = true;
    if (!m_rom_codec) return;
    // Frame period in C5x cycles. With A = 10 and B = 20 this is 3472, the
    // constant it replaces.
    const unsigned period = unsigned(C5X_CLOCK_HZ * divisor / m_codec.mclk_hz);
    if (period) m_line_frame_period = period;
}

// One secondary word: [DS15:14 control][DS13 R/W][DS12:8 address][DS7:0 data].
void C5xCore::codec_apply_register(uint16_t word)
{
    m_codec.last_control_word = word;
    ++m_codec.secondary_frames;
    const unsigned address = (word >> 8) & 0x1f;
    const bool read = (word >> 13) & 1;
    if (address == 0 || address > 8) return;  // register 0 is the no-op
    if (read) {
        // Read mode returns the register in the low byte and writes nothing.
        m_codec.readback = m_codec.registers[address] & 0xff;
        m_codec.readback_armed = true;
        ++m_codec.register_reads;
        return;
    }
    m_codec.registers[address] = word & 0xff;
    ++m_codec.register_writes;
    if (address == 1 || address == 2) codec_recompute_rate();
    if (address == 6 && (word & 0x02)) {
        // Software reset returns every register to its power-up value and
        // clears itself.
        const uint32_t mclk = m_codec.mclk_hz;
        m_codec = Ac01{};
        m_codec.mclk_hz = mclk;
    }
}

// A word the DSP wrote to DXR. Which kind of frame it is was decided by the
// previous frame's two control bits, not by where the write came from.
void C5xCore::codec_transmit(uint16_t word)
{
    const bool secondary = m_codec.secondary_now
        || (m_codec.registers[6] & 0x04);  // register 6 DS02 forces every frame
    m_codec.secondary_now = false;
    if (secondary) {
        codec_apply_register(word);
        // DS15:DS14 carry the same request encoding as a primary word.
        m_codec.secondary_now = (word >> 14) == 3;
        return;
    }
    ++m_codec.primary_frames;
    switch (word & 3) {
    case 3:
        m_codec.secondary_now = true;
        // Half a frame period after this one - (B/2) FCLK periods, which is
        // B/2 divided by FCLK = fs/2. Scheduled from now rather than from the
        // frame boundary, since the DSP writes DXR from inside the ISR.
        m_codec.secondary_due = true;
        m_codec.secondary_cycle = m_cycles + m_line_frame_period / 2;
        break;
    case 1: case 2: ++m_codec.phase_shifts; break;
    default: break;
    }
    if (!m_rom_codec) return;
    // The sample is the top 14 bits; the low two were never data.
    const uint16_t sample = uint16_t(word & 0xfffc);
    m_line_tx.push_back(sample);
    if (sample) ++m_line_tx_nonzero;
    m_line_tx_last_pc = uint16_t(m_pc - 1);
}

// One frame sync: the codec clocks a word each way, whether or not the DSP has
// anything to say. This is the part of the model the harness did without - DRR
// used to be filled lazily when the firmware happened to read it, so a run
// whose receive queue was empty returned the same stale word every frame.
void C5xCore::codec_frame(bool secondary)
{
    if (secondary) {
        // Datasheet 2.4: during secondary communications DOUT carries the
        // addressed register when a read was requested, and is otherwise zero.
        // Either way no conversion result is delivered, so the ADC stream is
        // one word per *primary* frame.
        m_serial.drr = m_codec.readback_armed ? m_codec.readback : 0;
        m_codec.readback_armed = false;
        m_codec.rx_ready = true;
        m_codec.tx_ready = true;
        return;
    }
    // The ADC converts whether or not the line is doing anything. An empty
    // queue is silence on the line, which is a delivered zero, not a repeat.
    uint16_t sample = 0;
    if (!m_codec_rx.empty()) {
        sample = m_codec_rx.front();
        m_codec_rx.pop_front();
        ++m_serial.rx_consumed;
        m_codec_rx_peak = std::max<uint16_t>(m_codec_rx_peak,
            uint16_t(std::abs(int(int16_t(sample)))));
    }
    ++m_codec.frames_clocked;
    m_codec.tx_ready = true;   // DXR has gone to the shift register
    m_serial.drr = sample;
    m_codec.rx_ready = true;
    // Feed the same word to the V.8 tone detector the harness runs alongside
    // the firmware, which previously only saw samples on the legacy TDM path.
    m_v8_rx_window.push_back(int16_t(sample));
    if (m_v8_rx_window.size() > 960) m_v8_rx_window.pop_front();
}

C5xCore::CodecState C5xCore::codec_state() const
{
    CodecState out{};
    for (unsigned index = 0; index < 9; ++index)
        out.registers[index] = m_codec.registers[index];
    out.codec_rx_size = m_codec_rx.size();
    out.line_frame_next_cycle = m_line_frame_next_cycle;
    out.cycles = m_cycles;
    out.line_frame_irq = m_line_frame_irq;
    out.mclk_hz = m_codec.mclk_hz;
    out.sample_rate_millihz = m_codec.sample_rate_millihz;
    out.frame_period = m_line_frame_period;
    out.secondary_frames = m_codec.secondary_frames;
    out.register_writes = m_codec.register_writes;
    out.register_reads = m_codec.register_reads;
    out.phase_shifts = m_codec.phase_shifts;
    out.primary_frames = m_codec.primary_frames;
    out.frames_clocked = m_codec.frames_clocked;
    out.last_control_word = m_codec.last_control_word;
    out.rate_programmed = m_codec.rate_programmed;
    out.secondary_pending = m_codec.secondary_now;
    out.force_secondary = (m_codec.registers[6] & 0x04) != 0;
    out.free_run = (m_codec.registers[6] & 0x20) != 0;
    out.sixteen_bit = (m_codec.registers[6] & 0x08) != 0;
    out.high_pass_enabled = (m_codec.registers[5] & 0x04) == 0;
    out.loopback = (m_codec.registers[5] & 0x03) == 0;
    out.input_select = uint8_t(m_codec.registers[5] & 0x03);
    out.monitor_gain = uint8_t((m_codec.registers[4] >> 4) & 3);
    out.input_gain = uint8_t((m_codec.registers[4] >> 2) & 3);
    out.output_gain = uint8_t(m_codec.registers[4] & 3);
    return out;
}

void C5xCore::set_io(uint16_t port, uint16_t value) { m_io[port] = value; }
void C5xCore::host_write(uint16_t address, uint16_t value)
{
    // NOT the board's protocol.  A real mailbox tag is a command index into
    // the jump table at program word 8401, bounded at 7f, and only 27 of its
    // handlers store the host's word - each at one fixed address.  See
    // docs/dsp-rom-probe.md, "A repeatable host write".  This entry point is
    // kept as a direct way to seed modelled state, and callers must not read
    // it as evidence that a host can write an arbitrary data cell.
    DM_WRITE16(address, value);
}
void C5xCore::queue_serial_rx(const uint16_t *samples, std::size_t count)
{
    for (std::size_t index = 0; index < count; ++index) m_line_rx.push_back(samples[index]);
}
void C5xCore::queue_codec_rx(const uint16_t *samples, std::size_t count)
{
    for (std::size_t index = 0; index < count; ++index) {
        m_codec_rx.push_back(samples[index]);
        m_codec_rx_peak = std::max<uint16_t>(m_codec_rx_peak,
            uint16_t(std::abs(int16_t(samples[index]))));
    }
}
void C5xCore::queue_codec_boot(const uint16_t *words, std::size_t count)
{
    for (std::size_t index = 0; index < count; ++index)
        m_codec_boot.push_back(words[index]);
}
void C5xCore::set_v8_calling(bool enabled)
{
    m_v8_mode = enabled ? V8Mode::Calling : V8Mode::Off;
}
void C5xCore::set_v8_answering(bool enabled)
{
    m_v8_mode = enabled ? V8Mode::Answering : V8Mode::Off;
}
uint16_t C5xCore::io(uint16_t port) const { return m_io[port]; }
uint16_t C5xCore::io_output(uint16_t port) const
{
    return (m_rom_codec || m_host_mailbox) && port >= 0x5e && port <= 0x60
        ? m_mailbox_output[port - 0x5e] : m_io[port];
}
uint16_t C5xCore::program(uint16_t address) const { return m_program[address]; }
// These reach the same storage the running program does, so a cell staged
// from the harness lands where the firmware's own read will find it. Without
// the region check, a value seeded into the shared window would go to the data
// array while the DSP read the program one - two arrays for one RAM.
uint16_t C5xCore::data(uint16_t address) const
{
    return data_region(address) == Region::Shared ? m_program[address]
                                                  : m_data[address];
}
void C5xCore::set_data(uint16_t address, uint16_t value)
{
    if (data_region(address) == Region::Shared) m_program[address] = value;
    else m_data[address] = value;
}

C5xCore::MemoryMap C5xCore::memory_map() const
{
    m_map.mpmc_pin = m_mpmc_pin;
    m_map.mpmc = m_pmst.mpmc;
    m_map.ovly = m_pmst.ovly;
    m_map.ram = m_pmst.ram;
    m_map.cnf = m_st1.cnf;
    m_map.iptr = m_pmst.iptr;
    m_map.pdwsr = m_pdwsr;
    m_map.iowsr = m_iowsr;
    m_map.cwsr = m_cwsr;
    m_map.rom_present = m_rom_present;
    return m_map;
}

void C5xCore::consume_cycles(unsigned cycles)
{
    m_step_cycles += cycles;
    m_cycles += cycles;
}

C5xCore::Region C5xCore::program_region(uint16_t address) const
{
    // Microcomputer mode puts the 4K boot ROM at the bottom of program space;
    // microprocessor mode leaves the whole space off-chip. CNF brings B0 in
    // at the top. The C52 has no SARAM, so PMST.RAM does nothing here.
    if (!m_pmst.mpmc && address < C5X_ROM_WORDS) return Region::Rom;
    if (m_st1.cnf && address >= C5X_B0_PROGRAM_FIRST) return Region::Daram;
    if (m_pmst.ram && address >= C5X_SARAM_FIRST && address <= C5X_SARAM_LAST)
        return Region::Saram;
    return Region::External;
}

C5xCore::Region C5xCore::data_region(uint16_t address) const
{
    if (address < 0x60) return Region::Registers;
    if (address >= C5X_B2_FIRST && address < C5X_B2_FIRST + C5X_B2_WORDS)
        return Region::Daram;
    // B0 leaves data space for the top of program space when CNF is set, and
    // what it leaves behind is reserved rather than off-chip. B1 stays put.
    if (address >= C5X_B0_FIRST && address < C5X_B0_FIRST + C5X_B0_WORDS)
        return m_st1.cnf ? Region::Reserved : Region::Daram;
    if (address >= C5X_B1_FIRST && address < C5X_B1_FIRST + C5X_B1_WORDS)
        return Region::Daram;
    if (m_pmst.ovly && address >= C5X_SARAM_FIRST && address <= C5X_SARAM_LAST)
        return Region::Saram;
    // The board's external RAM answers both spaces. See the shared-window
    // constants in c5x_core.h.
    if (address >= m_shared_first && address <= m_shared_last)
        return Region::Shared;
    // Without SARAM mapped, everything from 0x0800 up is off-chip and the two
    // gaps below it are reserved.
    if (address >= C5X_DATA_EXTERNAL_FIRST) return Region::External;
    return Region::Reserved;
}

uint16_t C5xCore::fetch(uint16_t address)
{
    switch (program_region(address)) {
    case Region::Rom:
        ++m_map.program_rom;
        // An XMF carries the program the supervisor downloads and nothing
        // else, so with no ROM supplied this window has no contents. Falling
        // back to the downloaded image is what this harness has always done;
        // counting the fetches is what says how much of a run rests on it.
        if (!m_rom_present) { ++m_map.rom_holes; break; }
        return m_rom[address];
    case Region::Daram: ++m_map.program_daram; return m_data[C5X_B0_FIRST + (address - C5X_B0_PROGRAM_FIRST)];
    // SARAM is one memory in both spaces, so a fetch reads what data stores
    // put there - which is how the firmware's own block moves get executed.
    case Region::Saram: ++m_map.program_saram; return m_data[address];
    default: ++m_map.program_external; break;
    }
    return m_program[address];
}

uint16_t C5xCore::ROPCODE() { return fetch(m_pc++); }
void C5xCore::CHANGE_PC(uint16_t new_pc) { m_pc = new_pc; }
uint16_t C5xCore::PM_READ16(uint16_t address) { return fetch(address); }
void C5xCore::PM_WRITE16(uint16_t address, uint16_t value)
{
    switch (program_region(address)) {
    case Region::Rom:
        if (m_rom_present) m_rom[address] = value;
        return;
    case Region::Saram: m_data[address] = value; return;
    default: break;
    }
    m_program[address] = value;
}
uint16_t C5xCore::DM_READ16(uint16_t address)
{
    const Region region = data_region(address);
    switch (region) {
    case Region::Registers: ++m_map.data_registers; break;
    case Region::Daram: ++m_map.data_daram; break;
    case Region::Saram: ++m_map.data_saram; break;
    case Region::Reserved: ++m_map.data_reserved; break;
    case Region::Shared: ++m_map.data_shared; break;
    default: ++m_map.data_external; break;
    }
    uint16_t value = address < 0x60 ? cpuregs_r(address)
                   : region == Region::Shared ? m_program[address]
                   : m_data[address];
    // The read side traces a fixed set of cells. A caller watching one cell
    // wants only that cell, and these reads otherwise flood the buffer.
    if (m_trace_data_writes && !m_trace_filtered &&
        (address == 0x006f || address == 0x035c || address == 0x069c ||
         address == 0x0b49 || address == 0x039f || address == 0x03c8 || address == 0x03ca)) {
        if (m_data_events.size() >= 4096) m_data_events.erase(m_data_events.begin());
        m_data_events.push_back({address, value, static_cast<uint16_t>(m_pc - 1), m_instructions});
    }
    return value;
}
void C5xCore::DM_WRITE16(uint16_t address, uint16_t value)
{
    ++m_data_write_counts[address];
    if (m_trace_data_writes && (!m_trace_filtered || address == m_trace_filter)) {
        if (m_data_events.size() >= 4096) m_data_events.erase(m_data_events.begin());
        m_data_events.push_back({address, value, static_cast<uint16_t>(m_pc - 1), m_instructions});
    }
    if (address < 0x60) cpuregs_w(address, value);
    else if (data_region(address) == Region::Shared) m_program[address] = value;
    else m_data[address] = value;
    // Which ASIC slot the line datapump's output word lands in. The ISR at
    // 0x0228 keeps a 32-bit phase accumulator in @7c/@7d - 0xfffc/0xfffd at
    // DP 0x1ff - and reading 0xfffd gives that phase, which is a linear ramp
    // rather than a waveform. The word it computes from it goes out through
    // @7a to 0xffff. Which of the two the board sinks is the question this
    // makes measurable.
    if (m_call_tdm_active && address == m_line_dac_slot) {
        m_line_dac_sum += int16_t(value);
        ++m_line_dac_count;
        std::vector<uint16_t> &phase = m_line_phase_tx[m_io[0x52] & 3];
        if (phase.size() < 400000) phase.push_back(value);
    }
}

uint16_t C5xCore::IO_READ16(uint16_t port)
{
    // The resident idle path exposes its line ADC at external I/O port 0x54.
    // main211 reads a frame at 0xb300 and rereads the held word at 0xb304.
    if (port == 0x54 && uint16_t(m_pc - 1) == 0xb300 && !m_line_rx.empty()) {
        m_io[port] = m_line_rx.front();
        m_line_rx.pop_front();
        ++m_line_rx_consumed;
    }
    uint16_t value = m_io_read ? m_io_read(port) : m_io[port];
    m_io_events.push_back({false, port, value, static_cast<uint16_t>(m_pc - 1), m_instructions});
    return value;
}

void C5xCore::IO_WRITE16(uint16_t port, uint16_t value)
{
    if ((m_rom_codec || m_host_mailbox) && port == 0x57)
        // PA7 is an acknowledgement register, not ordinary port storage.
        // The board leaves 0002 unchanged after writes of 0200, 0300 and 0000
        // (artifacts/dsp-status-03). Assigning FFFF during resident init used
        // to invent download-ready bit 9; with NDX working the firmware then
        // consumed nonexistent download words indefinitely.
        m_io[port] &= uint16_t(~value);
    else if ((m_rom_codec || m_host_mailbox) && port >= 0x5e && port <= 0x60)
        // The CPU and DSP each own a holding register. A DSP reply must not
        // overwrite an incoming CPU word, or vice versa.
        m_mailbox_output[port - 0x5e] = value;
    else m_io[port] = value;
    m_io_events.push_back({true, port, value, static_cast<uint16_t>(m_pc - 1), m_instructions});
    // The C52 firmware writes its ASIC line-DAC sink at b2e5. The older C51
    // resident image uses external port 006a at high program addresses. The
    // C52's low-bank TDM ISR also writes 006a, but that is its control slot and
    // must not be interleaved with line PCM.
    uint16_t write_pc = uint16_t(m_pc - 1);
    if (port == 0x006a && write_pc >= 0x8000) {
        m_line_tx.push_back(value);
        if (value) ++m_line_tx_nonzero;
        m_line_tx_last_pc = write_pc;
    }
    if (m_io_write) m_io_write(port, value);
}

static uint16_t detect_v8_tones(const std::deque<int16_t> &samples)
{
    if (samples.size() < 960) return 0;
    constexpr double pi = 3.14159265358979323846;
    double c1300 = 0.0, s1300 = 0.0, c2100 = 0.0, s2100 = 0.0;
    double total = 0.0;
    int n = 0;
    for (int16_t sample : samples) {
        double x = sample;
        double phase1300 = 2.0 * pi * 1300.0 * double(n) / 9600.0;
        double phase2100 = 2.0 * pi * 2100.0 * double(n) / 9600.0;
        c1300 += x * std::cos(phase1300);
        s1300 += x * std::sin(phase1300);
        c2100 += x * std::cos(phase2100);
        s2100 += x * std::sin(phase2100);
        total += x * x;
        ++n;
    }
    if (total < 1.0) return 0;
    // A single real-bin correlation is deliberately conservative: this is a
    // DSP-side observation of V.8, not a supervisor/carrier shortcut.
    uint16_t state = 0;
    double limit = total * double(samples.size()) * 0.02;
    if ((c1300 * c1300 + s1300 * s1300) > limit) state |= 1; // CI
    if ((c2100 * c2100 + s2100 * s2100) > limit) state |= 2; // ANSam
    return state;
}

uint16_t C5xCore::cpuregs_r(uint16_t offset)
{
    switch (offset) {
    case 0x04: return m_imr;
    case 0x06: return m_ifr;
    case 0x07: return uint16_t((m_pmst.iptr << 11) | (m_pmst.avis << 7) |
        (m_pmst.ovly << 5) | (m_pmst.ram << 4) | (m_pmst.mpmc << 3) |
        (m_pmst.ndx << 2) | (m_pmst.trm << 1) | m_pmst.braf);
    case 0x09: return uint16_t(m_brcr);
    // TREG0 is memory-mapped at 0x0c, next to TREG1 and TREG2. Leaving it out
    // splits it in two: LT and its relatives write the register while a read
    // through the data space sees a cell nothing keeps up to date.
    //
    // TREG1, TREG2 and DBMR were exactly that split until this line: the write
    // side below binds all four, the read side bound only TREG0. A bit pump
    // that keeps its bit number in TREG2 and steps it with
    // `lamm @0e / sub #01 / samm @0e` then reads zero every time, writes ffff
    // back, and never reaches the count it is watching for - which is how the
    // I-modem's HDLC receiver came to sit in one loop for a whole call.
    case 0x0c: return m_treg0;
    case 0x0d: return m_treg1;
    case 0x0e: return m_treg2;
    case 0x0f: return m_dbmr;
    case 0x10: case 0x11: case 0x12: case 0x13:
    case 0x14: case 0x15: case 0x16: case 0x17: return m_ar[offset - 0x10];
    case 0x18: return m_indx; case 0x19: return m_arcr;
    case 0x1a: return m_cbsr1; case 0x1b: return m_cber1;
    case 0x1c: return m_cbsr2; case 0x1d: return m_cber2;
    case 0x1e: return m_cbcr; case 0x1f: return m_bmar;
    case 0x20:
        ++m_serial.drr_reads; m_serial.last_drr_pc = uint16_t(m_pc - 1);
        if (m_rom_codec) {
            if (!m_codec_boot.empty()) {
                // The ROM boot loader polling its table. This is the ASIC
                // clocking words in, not a conversion result.
                m_serial.drr = m_codec_boot.front();
                m_codec_boot.pop_front();
                ++m_serial.rx_consumed;
                return m_serial.drr;
            }
            // The frame clock loaded this; reading it only clears RRDY.
            m_codec.rx_ready = false;
            return m_serial.drr;
        }
        if (m_codec.readback_armed) {
            m_codec.readback_armed = false;
            m_serial.drr = m_codec.readback;
            return m_serial.drr;
        }
        if (!m_codec_rx.empty()) {
            m_serial.drr = m_codec_rx.front(); m_codec_rx.pop_front();
            ++m_serial.rx_consumed;
        }
        return m_serial.drr;
    case 0x21: return m_serial.dxr;
    case 0x22: {
        // The control bits read back as written; the two status bits are
        // answered from the port's actual state. A slave transmitter whose
        // clock comes from the board is ready again as soon as the shifter
        // has taken the word, so readiness follows XRST rather than a frame
        // this core does not run.
        uint16_t value = m_serial.spc & uint16_t(~(SPC_XRDY | SPC_RRDY));
        // XRDY says DXR can accept another word, which becomes true when a
        // frame sync moves the last one into the transmit shift register. It
        // therefore follows the codec's frame clock rather than merely the
        // transmitter being out of reset, which is what the reset handshake at
        // program 0x8097 spins on.
        // Only the AC01 path has a frame clock to set it. The legacy TDM path
        // models no framing on this port, so nothing there would ever set XRDY
        // again after a write and a firmware spin would never end; it keeps the
        // optimistic answer it always had. That is a scoping decision about
        // this model, not something the hardware does.
        if (m_serial.spc & SPC_XRST) {
            if (!m_rom_codec || m_codec.tx_ready) value |= SPC_XRDY;
        }
        // On the AC01 path a word is receivable once a frame sync has clocked
        // one in, not merely because the harness has audio queued.
        const bool ready = m_digital_pcm
            ? m_codec.rx_ready
            : m_rom_codec
            ? (m_codec.rx_ready || !m_codec_boot.empty())
            : !m_codec_rx.empty();
        if ((m_serial.spc & SPC_RRST) && ready) value |= SPC_RRDY;
        return value;
    }
    case 0x24: return m_timer.tim; case 0x25: return m_timer.prd;
    case 0x26: return uint16_t(((m_timer.psc & 0xf) << 6) | (m_timer.tddr & 0xf));
    case 0x28: return m_pdwsr;
    case 0x29: return m_iowsr;
    case 0x2a: return m_cwsr;
    case 0x37: return 0;
    case 0x30:
        ++m_tdm.trcv_reads; m_tdm.last_trcv_pc = uint16_t(m_pc - 1);
        m_tdm_rx_ready = false;
        return m_tdm.trcv;
    case 0x31: return m_tdm.tdxr;
    case 0x32: return m_tdm.tspc;
    case 0x33: return m_tdm.tcsr;
    case 0x34: return m_tdm.trta;
    case 0x35: return m_tdm.trad;
    default:
        if (offset >= 0x50 && offset <= 0x5f) return IO_READ16(offset);
        return m_data[offset];
    }
}

void C5xCore::cpuregs_w(uint16_t offset, uint16_t value)
{
    switch (offset) {
    case 0x00: case 0x05: return;
    // The wait-state registers say which regions the firmware expects to be
    // off-chip, which is worth recording even though this core runs every
    // access in one cycle.
    case 0x28: m_pdwsr = value; return;
    case 0x29: m_iowsr = value; return;
    case 0x2a: m_cwsr = value; return;
    case 0x04: m_imr = value; return;
    case 0x06: m_ifr &= ~value; return;
    case 0x07:
        // SPRU056D Figure 4-3: IPTR is bits 15-11 (2K-word pages),
        // AVIS is bit 7; bits 10-8 and 6 are reserved and read as zero.
        m_pmst.iptr = (value >> 11) & 0x1f; m_pmst.avis = (value >> 7) & 1;
        m_pmst.ovly = (value >> 5) & 1; m_pmst.ram = (value >> 4) & 1;
        m_pmst.mpmc = (value >> 3) & 1; m_pmst.ndx = (value >> 2) & 1;
        m_pmst.trm = (value >> 1) & 1; m_pmst.braf = value & 1; return;
    case 0x09: m_brcr = value; return;
    case 0x0c: m_treg0 = value; return;
    case 0x0d: m_treg1 = value; return; case 0x0e: m_treg2 = value; return;
    case 0x0f: m_dbmr = value; return;
    case 0x10: case 0x11: case 0x12: case 0x13:
    case 0x14: case 0x15: case 0x16: case 0x17: m_ar[offset - 0x10] = value; return;
    case 0x18: m_indx = value; return; case 0x19: m_arcr = value; return;
    case 0x1a: m_cbsr1 = value; return; case 0x1b: m_cber1 = value; return;
    case 0x1c: m_cbsr2 = value; return; case 0x1d: m_cber2 = value; return;
    case 0x1e: m_cbcr = value; return; case 0x1f: m_bmar = value; return;
    case 0x20: m_serial.drr = value; return;
    case 0x21:
        m_serial.dxr = value; ++m_serial.dxr_writes;
        m_serial.last_dxr_pc = uint16_t(m_pc - 1);
        m_codec.tx_ready = false;
        // Whether this word is a sample or a control register is the codec's
        // business, not the caller's: the previous frame's control bits decided
        // it. This used to be two hardcoded ISR addresses, which recognised the
        // samples of two known builds and no others.
        codec_transmit(value);
        return;
    case 0x22:
        // A 0 -> 1 edge on XRST releases the transmitter with DXR empty.
        if (!(m_serial.spc & SPC_XRST) && (value & SPC_XRST)) m_codec.tx_ready = true;
        m_serial.spc = value; ++m_serial.spc_writes;
        m_serial.last_spc_pc = uint16_t(m_pc - 1); return;
    case 0x24: m_timer.tim = value; return; case 0x25: m_timer.prd = value; return;
    case 0x26:
        m_timer.tddr = value & 0xf; m_timer.psc = (value >> 6) & 0xf;
        if (value & 0x20) { m_timer.tim = m_timer.prd; m_timer.psc = m_timer.tddr; }
        return;
    case 0x30: m_tdm.trcv = value; return;
    case 0x31:
        m_tdm.tdxr = value; ++m_tdm.tdxr_writes;
        m_tdm.last_tdxr_pc = uint16_t(m_pc - 1); return;
    case 0x32:
        m_tdm.tspc = value; ++m_tdm.tspc_writes;
        m_tdm.last_tspc_pc = uint16_t(m_pc - 1); return;
    case 0x33: m_tdm.tcsr = value; return;
    case 0x34: m_tdm.trta = value; return;
    case 0x35: m_tdm.trad = value; return;
    default:
        if (offset >= 0x50 && offset <= 0x5f) { IO_WRITE16(offset, value); return; }
        m_data[offset] = value; return;
    }
}

#define CYCLES(x) consume_cycles(x)

#include "c5x_ops.ipp"

#undef CYCLES

void C5xCore::op_group_be() { (this->*s_opcode_table_be[m_op & 0xff])(); }
void C5xCore::op_group_bf() { (this->*s_opcode_table_bf[m_op & 0xff])(); }

void C5xCore::delay_slot(uint16_t startpc)
{
    m_op = ROPCODE(); (this->*s_opcode_table[m_op >> 8])();
    while (uint16_t(m_pc - startpc) < 2) { m_op = ROPCODE(); (this->*s_opcode_table[m_op >> 8])(); }
}

void C5xCore::save_interrupt_context()
{
    m_shadow = {m_acc, m_accb, m_arcr, m_indx, m_pmst, m_preg, m_st0, m_st1,
        m_treg0, m_treg1, m_treg2};
}
void C5xCore::restore_interrupt_context()
{
    m_acc = m_shadow.acc; m_accb = m_shadow.accb; m_arcr = m_shadow.arcr;
    m_indx = m_shadow.indx; m_pmst = m_shadow.pmst; m_preg = m_shadow.preg;
    m_st0 = m_shadow.st0; m_st1 = m_shadow.st1;
    m_treg0 = m_shadow.treg0; m_treg1 = m_shadow.treg1; m_treg2 = m_shadow.treg2;
}
void C5xCore::check_interrupts()
{
    if (m_st0.intm || !m_ifr) return;
    for (unsigned irq = 0; irq < 16; ++irq) if (m_ifr & (1u << irq)) {
        m_st0.intm = 1; PUSH_STACK(m_pc);
        uint16_t vector = m_interrupt_vectors[irq];
        m_pc = vector != 0xffff
            ? vector
            : uint16_t((m_pmst.iptr << 11) | ((irq + 1) << 1));
        m_ifr &= ~(1u << irq); m_idle = false; save_interrupt_context(); return;
    }
}
void C5xCore::interrupt(unsigned irq)
{
    if (irq >= 16) throw std::out_of_range("C5x interrupt number");
    if (m_imr & (1u << irq)) {
        m_ifr |= uint16_t(1u << irq);
        // SPRU056D 4.10.1: an enabled interrupt wakes IDLE even with
        // INTM set; in that case execution resumes after IDLE, without ISR.
        m_idle = false;
    }
    check_interrupts();
}

void C5xCore::configure_line_frame_interrupt(unsigned irq, uint16_t vector)
{
    if (irq >= 16) throw std::out_of_range("C5x line-frame interrupt number");
    m_line_frame_irq = int(irq);
    m_interrupt_vectors[irq] = vector;
    m_line_frame_next_cycle = m_cycles + m_line_frame_period;
}

void C5xCore::step()
{
    m_step_cycles = 0;
    if (m_idle) consume_cycles(1);
    else {
        // The customer-ROM dispatcher publishes call state at the boundary
        // immediately before the idle frame's ADC block. Waiting for this PC
        // preserves the calling convention that overlapping entry 0x2295
        // expects; entering on an arbitrary cycle corrupts IMR and stalls TDM.
        if (
            m_line_frame_entry >= 0 && !m_st0.intm && m_pc == 0xb2f6
            && !(m_io[0x52] & 3)
            && m_line_frame_next_cycle > m_cycles
            && m_line_frame_next_cycle - m_cycles >= 128
            && m_line_frame_next_cycle - m_cycles <= 192
        ) {
            if (!m_pending_overlay.empty()) {
                std::copy(m_pending_overlay.begin(), m_pending_overlay.end(),
                    m_program.begin() + m_pending_overlay_origin);
                m_pending_overlay.clear();
                std::fill(m_io.begin() + 0x50, m_io.begin() + 0x60, 0);
                static constexpr uint16_t call_registers[] = {
                    0x13, 0x15, 0x16, 0x19, 0x1a, 0x1b, 0x1f,
                };
                for (std::size_t index = 0; index < std::size(call_registers); ++index)
                    DM_WRITE16(call_registers[index], m_pending_call_registers[index]);
                m_data[0x006f] = m_pending_call_selector;
                m_v8_callback_ready = false;
                m_call_tdm_active = true;
            }
            CHANGE_PC(uint16_t(m_line_frame_entry));
            m_line_frame_entry = -1;
        }
        if (m_pmst.braf && m_pc == m_paer) {
            if (m_brcr > 0) CHANGE_PC(m_pasr);
            if (--m_brcr <= 0) m_pmst.braf = 0;
        }
        uint16_t previous_pc = m_pc;
        if (previous_pc == 0xc418) {
            ++m_v8_dispatches;
            m_v8_record = uint16_t(m_acc);
            m_v8_handler = m_data[0x48];
            m_v8_countdown = m_data[0x4a];
            m_v8_flags = m_data[0x4d];
        }
        bool negotiation_loop = previous_pc == 0xc7f7 || previous_pc == 0xc81a ||
            previous_pc == 0xc853;
        if (negotiation_loop && !m_negotiation_loop_active) {
            m_negotiation_loop_active = true;
            ++m_negotiation_loop_entries;
            m_negotiation_loop_pc = previous_pc;
            m_negotiation_source = m_ar[m_st0.arp];
            m_negotiation_pair = m_ar[2];
            m_negotiation_source_value = m_data[m_negotiation_source];
            m_negotiation_pair_value = m_data[m_negotiation_pair];
            m_negotiation_acc = m_acc;
            m_negotiation_d76 = m_data[0x76]; m_negotiation_d77 = m_data[0x77];
            m_negotiation_d78 = m_data[0x78]; m_negotiation_d79 = m_data[0x79];
            m_negotiation_d26 = cpuregs_r(0x26); m_negotiation_indx = m_indx;
            m_negotiation_arp = m_st0.arp; m_negotiation_pm = m_st1.pm;
        }
        m_op = ROPCODE();
        if ((previous_pc >= 0xc700 && previous_pc < 0xca00) ||
            (previous_pc >= 0x0200 && previous_pc < 0x0300) ||
            (previous_pc >= m_trace_first && previous_pc <= m_trace_last)) {
            if (m_pc_trace.size() >= 512) m_pc_trace.pop_front();
            m_pc_trace.push_back((uint32_t(previous_pc) << 16) | m_op);
        }
        (this->*s_opcode_table[m_op >> 8])();
        if (negotiation_loop && m_pc != previous_pc) m_negotiation_loop_active = false;
        if (m_rptc > 0 && previous_pc == m_rpt_end) { CHANGE_PC(m_rpt_start); --m_rptc; }
        else if (m_rptc <= 0) m_rptc = 0;
    }
    ++m_instructions;
    if (--m_timer.psc <= 0) {
        m_timer.psc = m_timer.tddr;
        if (--m_timer.tim == 0) { m_timer.tim = m_timer.prd; interrupt(3); }
    }
    // The ASIC is the TDM clock master. Its edge continues while the DSP is
    // inside an overlay and no longer executing the idle DAC loop, so cadence
    // must come from elapsed C5x cycles rather than from observing an OUT.
    // The AC01's own frame sequence. A secondary frame sync arrives (B/2) FCLK
    // periods after the primary that requested it (datasheet Figure 2-1, note),
    // and since fs = FCLK/B that is exactly half a frame - so it is serviced
    // ahead of the next primary rather than replacing it.
    if (m_rom_codec && m_line_frame_irq >= 0 && m_codec.secondary_due
        && m_cycles >= m_codec.secondary_cycle) {
        m_codec.secondary_due = false;
        codec_frame(true);
        if (!m_st0.intm && (m_imr & (1u << m_line_frame_irq))) ++m_line_frame_interrupts;
        interrupt(unsigned(m_line_frame_irq));
        return;
    }
    if (m_line_frame_irq >= 0 && m_cycles >= m_line_frame_next_cycle) {
        do m_line_frame_next_cycle += m_line_frame_period;
        while (m_cycles >= m_line_frame_next_cycle);
        if (m_digital_pcm) {
            // No linearisation or companding-law conversion belongs here: the
            // octets are the time slots as they sit on the wire. How many of
            // them a frame carries is SPC's to say, not this code's.
            auto next_octet = [&]() -> uint16_t {
                if (m_g711_rx.empty()) return m_g711_idle;
                const uint16_t octet = m_g711_rx.front();
                m_g711_rx.pop_front();
                return octet;
            };
            if (m_serial.spc & SPC_FO) {
                m_serial.drr = next_octet();
                m_g711_tx.push_back(uint8_t(m_serial.dxr & 0xff));
            } else {
                // Sixteen-bit words, MSB first: the frame's first time slot
                // is the high byte at both ends.
                const uint16_t first = next_octet();
                m_serial.drr = uint16_t((first << 8) | next_octet());
                m_g711_tx.push_back(uint8_t(m_serial.dxr >> 8));
                m_g711_tx.push_back(uint8_t(m_serial.dxr & 0xff));
            }
            m_codec.rx_ready = true;
            m_codec.tx_ready = true;
            if (!m_st0.intm && (m_imr & (1u << m_line_frame_irq)))
                ++m_line_frame_interrupts;
            interrupt(unsigned(m_line_frame_irq));
            return;
        }
        if (m_rom_codec) {
            codec_frame(false);
            if (!m_st0.intm && (m_imr & (1u << m_line_frame_irq))) ++m_line_frame_interrupts;
            interrupt(unsigned(m_line_frame_irq));
            return;
        }
        // LAMM @52 at the ISR entry masks this ASIC word to two bits and
        // indexes its four phase descriptors. Preserve any board status bits
        // while advancing the slot number supplied by the frame master.
        m_io[0x52] = uint16_t((m_io[0x52] & ~3u) | m_line_frame_phase);
        m_line_frame_phase = uint16_t((m_line_frame_phase + 1) & 3);
        // Convert the 25 MHz/258-cycle TDM slot stream to the 9.6 kHz line
        // codec. The two most recent ADC words are held between boundaries.
        m_line_sample_phase += m_line_frame_period * 9600u;
        m_line_sample_due = m_line_sample_phase >= 25000000u;
        if (m_line_sample_due) {
            m_line_sample_phase -= 25000000u;
            if (m_call_tdm_active) {
                // The customer-ROM scheduler withholds the V.8 callback
                // until the opposite bootstrap indicator has qualified. Once
                // qualified it republishes the ready bit each codec slot.
                if (m_v8_callback_ready) {
                    m_data[0x039f] |= 0x0100;
                } else {
                    m_data[0x039f] &= uint16_t(~0x0100);
                }
                if (!m_codec_rx.empty()) {
                    // The ASIC's polyphase input holds the newest and previous
                    // 9.6 kHz ADC words in the delay cells at 0xfff8/0xfff9.
                    // Through DM_WRITE16 so the ADC pair is visible to the
                    // same instrumentation as everything else the datapump
                    // touches; whether the firmware's own reads track it is
                    // the question, and it cannot be asked otherwise.
                    DM_WRITE16(0xfff9, m_data[0xfff8]);
                    DM_WRITE16(0xfff8, m_codec_rx.front());
                    // The TDM receive register and the polyphase ADC latch
                    // are two views of the same ASIC slot. Populate TRCV
                    // before the frame ISR reads it; previously only the
                    // native detector saw this sample.
                    m_tdm.trcv = m_codec_rx.front();
                    m_tdm_rx_ready = true;
                    int16_t input = int16_t(m_codec_rx.front());
                    m_codec_rx.pop_front();
                    m_v8_rx_peak = std::max<uint16_t>(m_v8_rx_peak,
                        uint16_t(std::abs(int(input))));
                    ++m_serial.rx_consumed;
                    m_v8_rx_window.push_back(input);
                    if (m_v8_rx_window.size() > 960) m_v8_rx_window.pop_front();
                    uint16_t detected = detect_v8_tones(m_v8_rx_window);
                    if (detected) {
                        m_v8_rx_state |= detected;
                        m_data[0x0306] = m_v8_rx_state;
                        // Stop the native V.8 bootstrap tone once the peer's
                        // opposite indicator is present. From this edge on,
                        // the downloaded C52 overlay owns CM/JM and later
                        // negotiation; keeping the bootstrap generator active
                        // would mask the firmware's own DAC output.
                        if ((m_v8_mode == V8Mode::Calling && (detected & 2)) ||
                            (m_v8_mode == V8Mode::Answering && (detected & 1))) {
                            m_v8_callback_ready = true;
                            m_data[0x039f] |= 0x0100;
                            m_v8_mode = V8Mode::Off;
                            // BIO remains high during the call overlay. The
                            // ISR's BIO-low conditional skips its NMI trap;
                            // asserting it here strands the answer path.
                        }
                    }
                }
                // The line slot carries the datapump's own DAC accumulation
                // and nothing else. Whatever V.8 the call needs is the C52
                // overlay's to emit.
                if (m_line_dac_count) {
                    int16_t sample = int16_t(
                        m_line_dac_sum / int64_t(m_line_dac_count));
                    m_line_tx.push_back(uint16_t(sample));
                    if (sample) ++m_line_tx_nonzero;
                    m_line_tx_last_pc = 0x0238;
                    m_line_dac_sum = 0;
                    m_line_dac_count = 0;
                }
            } else {
                uint16_t sample = m_io[0xb2e5];
                m_line_tx.push_back(sample);
                if (sample) ++m_line_tx_nonzero;
                m_line_tx_last_pc = 0x8c25;
            }
        }
        unsigned irq = unsigned(m_line_frame_irq);
        if (!m_st0.intm && (m_imr & (1u << irq))) ++m_line_frame_interrupts;
        interrupt(irq);
    }
}

void C5xCore::run(uint64_t instruction_limit)
{
    for (uint64_t i = 0; i < instruction_limit; ++i) step();
}

C5xCore::State C5xCore::state() const
{
    State result{m_pc, m_op, m_acc, m_accb, m_preg, m_treg0, m_treg1, m_treg2, {},
        m_st0.dp, m_st0.arp, m_arcr, m_indx,
        uint16_t((m_st0.intm << 7) | (m_st0.ovm << 6) | (m_st0.ov << 5) |
                 (m_st1.sxm << 4) | (m_st1.c << 3) | (m_st1.tc << 2) |
                 (m_st1.xf << 1) | m_st1.cnf),
        m_idle, m_instructions, m_cycles};
    std::copy(std::begin(m_ar), std::end(m_ar), result.ar.begin());
    return result;
}

C5xCore::SerialState C5xCore::serial_state() const
{
    return {m_serial.drr, m_serial.dxr, m_serial.spc,
        m_serial.drr_reads, m_serial.dxr_writes, m_serial.spc_writes,
        m_line_rx_consumed, m_line_rx.size(),
        m_serial.rx_consumed, m_serial.rx_consumed + m_codec_rx.size(),
        m_serial.last_drr_pc, m_serial.last_dxr_pc, m_serial.last_spc_pc,
        m_tdm.trcv, m_tdm.tdxr, m_tdm.tspc,
        m_tdm.trcv_reads, m_tdm.tdxr_writes, m_tdm.tspc_writes,
        m_tdm.last_trcv_pc, m_tdm.last_tdxr_pc, m_tdm.last_tspc_pc,
        m_line_tx.size(), m_line_tx_nonzero, m_line_frame_interrupts,
        m_line_tx.empty() ? uint16_t(0) : m_line_tx.back(), m_line_tx_last_pc, m_imr,
        m_v8_rx_state, m_v8_rx_peak, m_codec_rx_peak,
        m_negotiation_loop_entries, m_negotiation_loop_pc, m_negotiation_source, m_negotiation_pair,
        m_negotiation_source_value, m_negotiation_pair_value, m_negotiation_acc,
        m_v8_dispatches, m_v8_record, m_v8_handler, m_v8_countdown, m_v8_flags,
        m_negotiation_d76, m_negotiation_d77, m_negotiation_d78, m_negotiation_d79,
        m_negotiation_d26, m_negotiation_indx, m_negotiation_arp, m_negotiation_pm};
}

} // namespace courier
