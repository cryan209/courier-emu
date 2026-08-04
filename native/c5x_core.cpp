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
    m_st0.intm = 1;
    m_st1.c = 1; m_st1.hm = 1; m_st1.sxm = 1; m_st1.xf = 1;
    m_ifr = m_imr = 0;
    std::fill(std::begin(m_pcstack), std::end(m_pcstack), 0);
    m_pcstack_ptr = 0;
    m_rpt_start = m_rpt_end = 0;
    m_cbcr = m_cbsr1 = m_cber1 = m_cbsr2 = m_cber2 = 0;
    m_timer = {}; m_serial = {}; m_tdm = {}; m_shadow = {};
    m_codec_rx.clear();
    m_line_rx.clear();
    m_line_tx.clear();
    m_line_rx_consumed = m_line_tx_nonzero = 0;
    m_line_tx_last_pc = 0;
    m_dtmf_digits.clear();
    m_dtmf_frame = 0;
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

void C5xCore::load_data(const uint16_t *words, std::size_t count, uint16_t origin)
{
    if (count > 65536u - origin) throw std::out_of_range("data image exceeds C5x address space");
    std::copy_n(words, count, m_data.begin() + origin);
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
    for (std::size_t index = 0; index < count; ++index) m_codec_rx.push_back(samples[index]);
}
void C5xCore::set_dtmf_digits(const char *digits, std::size_t count)
{
    m_dtmf_digits.assign(digits, count);
    m_dtmf_frame = 0;
}
uint16_t C5xCore::io(uint16_t port) const { return m_io[port]; }
uint16_t C5xCore::program(uint16_t address) const { return m_program[address]; }
uint16_t C5xCore::data(uint16_t address) const { return m_data[address]; }
void C5xCore::set_data(uint16_t address, uint16_t value) { m_data[address] = value; }

void C5xCore::consume_cycles(unsigned cycles)
{
    m_step_cycles += cycles;
    m_cycles += cycles;
}

uint16_t C5xCore::ROPCODE() { return m_program[m_pc++]; }
void C5xCore::CHANGE_PC(uint16_t new_pc) { m_pc = new_pc; }
uint16_t C5xCore::PM_READ16(uint16_t address) { return m_program[address]; }
void C5xCore::PM_WRITE16(uint16_t address, uint16_t value) { m_program[address] = value; }
uint16_t C5xCore::DM_READ16(uint16_t address)
{
    return address < 0x60 ? cpuregs_r(address) : m_data[address];
}
void C5xCore::DM_WRITE16(uint16_t address, uint16_t value)
{
    if (m_trace_data_writes)
        m_data_events.push_back({address, value, static_cast<uint16_t>(m_pc - 1), m_instructions});
    if (address < 0x60) cpuregs_w(address, value); else m_data[address] = value;
}

uint16_t C5xCore::IO_READ16(uint16_t port)
{
    // The Courier ASIC exposes the line ADC at external I/O port 0x54.
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
    if (port == 0xb2e5 && !m_dtmf_digits.empty()) value = dtmf_sample();
    m_io[port] = value;
    m_io_events.push_back({true, port, value, static_cast<uint16_t>(m_pc - 1), m_instructions});
    // The complementary ASIC line-DAC sink is written once per service frame.
    if (port == 0xb2e5) {
        m_line_tx.push_back(value);
        if (value) ++m_line_tx_nonzero;
        m_line_tx_last_pc = uint16_t(m_pc - 1);
    }
    if (m_io_write) m_io_write(port, value);
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
    if (index >= m_dtmf_digits.size() || within >= tone) return 0;

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
    case 0x22: return m_serial.spc;
    case 0x24: return m_timer.tim; case 0x25: return m_timer.prd;
    case 0x26: return uint16_t(((m_timer.psc & 0xf) << 6) | (m_timer.tddr & 0xf));
    case 0x28: case 0x37: return 0;
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
    case 0x00: case 0x05: case 0x28: case 0x29: case 0x2a: return;
    case 0x04: m_imr = value; return;
    case 0x06: m_ifr &= ~value; return;
    case 0x07:
        m_pmst.iptr = (value >> 11) & 0x1f; m_pmst.avis = (value >> 7) & 1;
        m_pmst.ovly = (value >> 5) & 1; m_pmst.ram = (value >> 4) & 1;
        m_pmst.mpmc = (value >> 3) & 1; m_pmst.ndx = (value >> 2) & 1;
        m_pmst.trm = (value >> 1) & 1; m_pmst.braf = value & 1; return;
    case 0x09: m_brcr = value; return;
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
        m_pc = uint16_t((m_pmst.iptr << 11) | ((irq + 1) << 1));
        m_ifr &= ~(1u << irq); m_idle = false; save_interrupt_context(); return;
    }
}
void C5xCore::interrupt(unsigned irq)
{
    if (irq >= 16) throw std::out_of_range("C5x interrupt number");
    if (m_imr & (1u << irq)) m_ifr |= uint16_t(1u << irq);
    check_interrupts();
}

void C5xCore::step()
{
    m_step_cycles = 0;
    if (m_idle) consume_cycles(1);
    else {
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
        m_serial.last_drr_pc, m_serial.last_dxr_pc, m_serial.last_spc_pc,
        m_tdm.trcv, m_tdm.tdxr, m_tdm.tspc,
        m_tdm.trcv_reads, m_tdm.tdxr_writes, m_tdm.tspc_writes,
        m_tdm.last_trcv_pc, m_tdm.last_tdxr_pc, m_tdm.last_tspc_pc,
        m_line_tx.size(), m_line_tx_nonzero,
        m_line_tx.empty() ? uint16_t(0) : m_line_tx.back(), m_line_tx_last_pc};
}

} // namespace courier
