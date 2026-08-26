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
    m_line_rx.clear();
    m_line_tx.clear();
    m_line_rx_consumed = m_line_tx_nonzero = 0;
    m_line_tx_last_pc = 0;
    m_dtmf_digits.clear();
    m_dtmf_frame = 0;
    m_v8_mode = V8Mode::Off;
    m_idle = false;
    m_instructions = m_cycles = 0;
    m_step_cycles = 0;
    m_io.fill(0xffff);
    m_io_events.clear();
    m_data_events.clear();
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

void C5xCore::set_mpmc_pin(uint16_t level)
{
    m_mpmc_pin = level ? 1 : 0;
    m_pmst.mpmc = m_mpmc_pin;
}

void C5xCore::set_io_callbacks(IoRead read, IoWrite write)
{
    m_io_read = std::move(read); m_io_write = std::move(write);
}

void C5xCore::set_io(uint16_t port, uint16_t value) { m_io[port] = value; }
void C5xCore::host_write(uint16_t address, uint16_t value)
{
    // The board runtime mailbox presents a C52 data-space address followed by
    // the value to place there.  Use the normal data-memory decoder because
    // low addresses are memory-mapped CPU registers on the C52.
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
void C5xCore::set_dtmf_digits(const char *digits, std::size_t count)
{
    m_dtmf_digits.assign(digits, count);
    m_dtmf_frame = 0;
}
void C5xCore::set_v8_calling(bool enabled)
{
    m_v8_mode = enabled ? V8Mode::Calling : V8Mode::Off;
}
void C5xCore::set_v8_answering(bool enabled)
{
    m_v8_mode = enabled ? V8Mode::Answering : V8Mode::Off;
    if (enabled) m_dtmf_frame = 960;
}
uint16_t C5xCore::io(uint16_t port) const { return m_io[port]; }
uint16_t C5xCore::program(uint16_t address) const { return m_program[address]; }
uint16_t C5xCore::data(uint16_t address) const { return m_data[address]; }
void C5xCore::set_data(uint16_t address, uint16_t value) { m_data[address] = value; }

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
    // The C52 has no SARAM, so everything from 0x0800 up is off-chip and the
    // two gaps below it are reserved. PMST.OVLY is a don't-care on this part.
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
    default: ++m_map.program_external; break;
    }
    return m_program[address];
}

uint16_t C5xCore::ROPCODE() { return fetch(m_pc++); }
void C5xCore::CHANGE_PC(uint16_t new_pc) { m_pc = new_pc; }
uint16_t C5xCore::PM_READ16(uint16_t address) { return fetch(address); }
void C5xCore::PM_WRITE16(uint16_t address, uint16_t value)
{
    if (program_region(address) == Region::Rom) {
        if (m_rom_present) m_rom[address] = value;
        return;
    }
    m_program[address] = value;
}
uint16_t C5xCore::DM_READ16(uint16_t address)
{
    switch (data_region(address)) {
    case Region::Registers: ++m_map.data_registers; break;
    case Region::Daram: ++m_map.data_daram; break;
    case Region::Reserved: ++m_map.data_reserved; break;
    default: ++m_map.data_external; break;
    }
    return address < 0x60 ? cpuregs_r(address) : m_data[address];
}
void C5xCore::DM_WRITE16(uint16_t address, uint16_t value)
{
    if (m_trace_data_writes)
        m_data_events.push_back({address, value, static_cast<uint16_t>(m_pc - 1), m_instructions});
    if (address < 0x60) cpuregs_w(address, value); else m_data[address] = value;
    // The polyphase ISR's 0xfffd result is the oversampled DAC word. Slot
    // 0xffff is control; 0xfff8/0xfff9 hold the ADC delay pair.
    if (m_call_tdm_active && address == 0xfffd
        && uint16_t(m_pc - 1) == 0x0238) {
        m_line_dac_sum += int16_t(value);
        ++m_line_dac_count;
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
    if (port == 0xb2e5 && (!m_dtmf_digits.empty() || m_v8_mode != V8Mode::Off))
        value = m_io[port];
    m_io[port] = value;
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

uint16_t C5xCore::dtmf_sample()
{
    // The Courier's frame service cadence is 9.6 kHz. A dial sequence starts
    // with 100 ms of silence, then uses 100 ms tones and 50 ms interdigit gaps.
    constexpr uint64_t sample_rate = 9600, lead = 960, tone = 960, gap = 480;
    uint64_t frame = m_dtmf_frame++;
    if (frame < lead) return 0;
    frame -= lead;
    std::size_t index = std::size_t(frame / (tone + gap));
    uint64_t within = frame % (tone + gap);
    if (index >= m_dtmf_digits.size()) {
        if (m_v8_mode == V8Mode::Off) {
            // The board-side dialer owns only the digit interval. Relinquish
            // the DAC afterwards so the downloaded datapump, not this assist,
            // supplies V.8 and all later modulation.
            m_dtmf_digits.clear();
            return 0;
        }
        uint64_t v8_frame = frame - m_dtmf_digits.size() * (tone + gap);
        constexpr double v8_pi = 3.14159265358979323846;
        double phase = double(v8_frame) / double(sample_rate);
        if (m_v8_mode == V8Mode::Calling) {
            // V.8 calling indicator: 1300 Hz, 500 ms on / 500 ms off.
            if (v8_frame % sample_rate >= sample_rate / 2) return 0;
            return uint16_t(int16_t(std::lround(
                9000.0 * std::sin(2.0 * v8_pi * 1300.0 * phase))));
        }
        // V.8 ANSam approximation: 2100 Hz answer tone, 15 Hz amplitude
        // modulation, and the standard 450 ms phase reversals.
        double reversal = ((v8_frame / 4320) & 1) ? -1.0 : 1.0;
        double envelope = 0.8 + 0.2 * std::sin(2.0 * v8_pi * 15.0 * phase);
        return uint16_t(int16_t(std::lround(
            9000.0 * envelope * reversal * std::sin(2.0 * v8_pi * 2100.0 * phase))));
    }
    if (within >= tone) return 0;

    int low = 0, high = 0;
    switch (m_dtmf_digits[index]) {
    case '1': low = 697; high = 1209; break;
    case '2': low = 697; high = 1336; break;
    case '3': low = 697; high = 1477; break;
    case 'A': low = 697; high = 1633; break;
    case '4': low = 770; high = 1209; break;
    case '5': low = 770; high = 1336; break;
    case '6': low = 770; high = 1477; break;
    case 'B': low = 770; high = 1633; break;
    case '7': low = 852; high = 1209; break;
    case '8': low = 852; high = 1336; break;
    case '9': low = 852; high = 1477; break;
    case 'C': low = 852; high = 1633; break;
    case '*': low = 941; high = 1209; break;
    case '0': low = 941; high = 1336; break;
    case '#': low = 941; high = 1477; break;
    case 'D': low = 941; high = 1633; break;
    default: return 0;
    }
    constexpr double pi = 3.14159265358979323846;
    double phase = double(within) / double(sample_rate);
    int sample = int(std::lround(6500.0 * (
        std::sin(2.0 * pi * low * phase) + std::sin(2.0 * pi * high * phase))));
    return uint16_t(int16_t(sample));
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
    case 0x0c: return m_treg0;
    case 0x10: case 0x11: case 0x12: case 0x13:
    case 0x14: case 0x15: case 0x16: case 0x17: return m_ar[offset - 0x10];
    case 0x18: return m_indx; case 0x19: return m_arcr;
    case 0x1a: return m_cbsr1; case 0x1b: return m_cber1;
    case 0x1c: return m_cbsr2; case 0x1d: return m_cber2;
    case 0x1e: return m_cbcr; case 0x1f: return m_bmar;
    case 0x20:
        ++m_serial.drr_reads; m_serial.last_drr_pc = uint16_t(m_pc - 1);
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
        if (m_serial.spc & SPC_XRST) value |= SPC_XRDY;
        if ((m_serial.spc & SPC_RRST) && !m_codec_rx.empty()) value |= SPC_RRDY;
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
        m_serial.last_dxr_pc = uint16_t(m_pc - 1); return;
    case 0x22:
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
    if (m_imr & (1u << irq)) m_ifr |= uint16_t(1u << irq);
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
        m_op = ROPCODE();
        (this->*s_opcode_table[m_op >> 8])();
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
    if (m_line_frame_irq >= 0 && m_cycles >= m_line_frame_next_cycle) {
        do m_line_frame_next_cycle += m_line_frame_period;
        while (m_cycles >= m_line_frame_next_cycle);
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
                // The customer-ROM scheduler publishes the V.8 callback
                // ready bit once per codec slot.  The downloaded image tests
                // data cell 0x039f bit 8 before resuming that callback; the
                // ASIC/TDM edge is the only producer of this bit.
                m_data[0x039f] |= 0x0100;
                if (!m_codec_rx.empty()) {
                    // The ASIC's polyphase input holds the newest and previous
                    // 9.6 kHz ADC words in the delay cells at 0xfff8/0xfff9.
                    m_data[0xfff9] = m_data[0xfff8];
                    m_data[0xfff8] = m_codec_rx.front();
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
                            m_v8_mode = V8Mode::Off;
                            // The ASIC asserts BIO-low at the V.8 handoff;
                            // this releases conditional CM/JM service code.
                            m_bio_low = true;
                        }
                    }
                }
                if (m_v8_mode != V8Mode::Off) {
                    // The ASIC owns the V.8 line slot for both roles. Calling
                    // emits CI; answering emits ANSam. Previously only the
                    // answer branch drove this slot, leaving the caller silent
                    // once the real call overlay became active.
                    uint16_t sample = dtmf_sample();
                    m_line_tx.push_back(sample);
                    if (sample) ++m_line_tx_nonzero;
                    m_line_tx_last_pc = 0x0238;
                    m_line_dac_sum = 0;
                    m_line_dac_count = 0;
                } else if (m_line_dac_count) {
                    int16_t sample = int16_t(
                        m_line_dac_sum / int64_t(m_line_dac_count));
                    m_line_tx.push_back(uint16_t(sample));
                    if (sample) ++m_line_tx_nonzero;
                    m_line_tx_last_pc = 0x0238;
                    m_line_dac_sum = 0;
                    m_line_dac_count = 0;
                }
            } else {
                if (!m_dtmf_digits.empty() || m_v8_mode != V8Mode::Off)
                    m_io[0xb2e5] = dtmf_sample();
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
        m_st0.dp, m_st0.arp,
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
        m_v8_rx_state, m_v8_rx_peak, m_codec_rx_peak};
}

} // namespace courier
