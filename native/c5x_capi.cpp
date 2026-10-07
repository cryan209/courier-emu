// SPDX-License-Identifier: BSD-3-Clause
#include "c5x_core.h"
#include "bearer.hpp"

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <exception>
#include <stdexcept>

using courier::C5xCore;

namespace {
void copy_error(char *buffer, std::size_t size, const char *message)
{
    if (!buffer || !size) return;
    std::strncpy(buffer, message, size - 1);
    buffer[size - 1] = '\0';
}
}

namespace {
// Port-level model of the analogue board's live data lanes, run inside the
// x86 engine so the CPU's polling of them does not leave native code. Only
// the lane regime lives here: it is a pure function of the DSP's I/O cells
// and the supervisor's window bytes, so it answers exactly what the harness's
// Python handlers answer. Everything else is declined and goes to Python.
struct LaneHostIo {
    C5xCore *core = nullptr;
    bool live = false;
    uint16_t command_port = 0x18, ack_port = 0x1a;
    uint16_t lane_first = 0x40, banks = 6, dsp_first = 0x58, dsp_status = 0x56;
    // Window bytes behind ports lane_first + 2 * index, index < 2 * banks.
    uint8_t *lane[16] = {};
    // Accesses served here, to be folded into the harness's I/O tallies.
    uint32_t in_count[256] = {}, out_count[256] = {};
    uint16_t out_last[256] = {};
    uint8_t out_seen[256] = {};
    // The host-port status (0x1c) and overlay-strobe (0x1e) registers, for the
    // accesses that are a pure function of the DSP's status latch and of the
    // few bridge flags the harness publishes here (courier_laneio_configure_
    // mailbox). Whatever else they do - commits, window strobes - is declined.
    bool mb_runtime = false;     // ROM protocol, runtime mode: 0x1c answers from the latch
    bool mb_pending = false;     // a host message is staged for delivery
    bool mb_inbound = false;     // a DSP-to-host message is queued
    bool mb_overlay = false;     // 0x1e reads answer the overlay status byte
    bool mb_zero_ok = false;     // a 0 written to 0x1e is not a strobe
    uint8_t mb_overlay_status = 0;
    uint16_t mb_status_cell = 0x57;

    // direction 1 = IN, 2 = OUT; true when served.
    bool serve_mailbox(int direction, uint16_t port, uint16_t value, uint16_t *out)
    {
        if (direction == 1) {
            uint16_t answer;
            if (port == 0x1c) {
                if (!mb_runtime) return false;
                const uint16_t status = core->io(mb_status_cell);
                answer = (status & 0x0001) || mb_pending ? 0 : 1;
                if (mb_inbound || ((status ^ 0x0006) & 0x02)) answer |= 2;
            } else {
                if (!mb_overlay) return false;
                answer = mb_overlay_status;
            }
            ++in_count[port];
            *out = answer & 0xff;
            return true;
        }
        if (value & 0xff) return false;
        if (port == 0x1c ? !mb_runtime : !mb_zero_ok) return false;
        ++out_count[port];
        out_last[port] = 0;
        out_seen[port] = 1;
        return true;
    }

    uint16_t lane_word(unsigned bank) const
    {
        uint16_t word = 0;
        for (unsigned half = 0; half < 2; ++half) {
            const uint8_t *byte = lane[2 * bank + half];
            word |= uint16_t((byte ? *byte : 0xff) << (8 * half));
        }
        return word;
    }
};
}

namespace {
// The interrupt controllers' registers, the 8254's wrap bookkeeping and the
// counters the poll keeps: the layout of PollState in poll_state.py.
struct PicChip {
    uint8_t vector_base, mask, irr, isr, auto_eoi, read_isr, expect_icw4, single, init_words;
};
struct PitSlot {
    uint64_t next_due, origin, reported;
    uint32_t initial;
    uint8_t programmed;
};
constexpr uint64_t PIT_INFINITE = ~uint64_t(0);

// The engine's registers and memory, lent to the poll for an interrupt entry
// (x86_interpreter.cpp's Core, in the order its register array has them).
struct PollCpu {
    uint32_t *regs;
    uint8_t *memory;
    std::size_t memory_size;
};
enum { REG_SP = 4, REG_CS = 9, REG_SS = 10, REG_IP = 12, REG_FLAGS = 13 };
struct PollState {
    PicChip pic[2];
    uint64_t delivered;
    PitSlot pit[3];
    uint64_t timer_ticks;
    uint64_t coalesced[3];
    int8_t counter_irq[12];
    uint64_t pit_clock_hz, ips;
    int64_t clock_origin;
    uint64_t next_rtos, next_mailbox, rtos_interval, mailbox_interval;
    uint8_t rtos_on, mailbox_on;
    uint8_t asserted_count, asserted[8];
    uint64_t hardware_interrupts;
    uint64_t last_poll;
    uint64_t pic_in[4], pic_out[4];
};

// pic.py, line for line.
namespace pic {
constexpr unsigned CASCADE = 2;
inline void command(PicChip &c, uint8_t value)
{
    if (value & 0x10) {
        c.expect_icw4 = value & 1;
        c.single = (value & 2) != 0;
        c.init_words = 1;
        c.isr = 0;
        c.irr = 0;
        return;
    }
    if (value & 0x08) {
        if (value == 0x0B) c.read_isr = 1;
        else if (value == 0x0A) c.read_isr = 0;
        return;
    }
    if (value & 0x20) {
        if (value & 0x40) {
            c.isr &= uint8_t(~(1u << (value & 7)));
        } else {
            for (unsigned line = 0; line < 8; ++line)
                if (c.isr & (1u << line)) { c.isr &= uint8_t(~(1u << line)); break; }
        }
    }
}
inline void data(PicChip &c, uint8_t value)
{
    if (c.init_words == 1) {
        c.vector_base = value & 0xF8;
        if (!c.single) c.init_words = 2;
        else c.init_words = c.expect_icw4 ? 3 : 0;
        return;
    }
    if (c.init_words == 2) { c.init_words = c.expect_icw4 ? 3 : 0; return; }
    if (c.init_words == 3) { c.auto_eoi = (value & 2) != 0; c.init_words = 0; return; }
    c.mask = value;
}
inline int pending(const PicChip &c, uint8_t irr)
{
    const uint8_t ready = irr & uint8_t(~c.mask);
    if (!ready) return -1;
    for (unsigned line = 0; line < 8; ++line) {
        const uint8_t bit = uint8_t(1u << line);
        if (c.isr & bit) return -1;
        if (ready & bit) return int(line);
    }
    return -1;
}
inline void acknowledge(PicChip &c, unsigned line)
{
    c.irr &= uint8_t(~(1u << line));
    if (!c.auto_eoi) c.isr |= uint8_t(1u << line);
}
inline void raise(PollState &s, unsigned irq)
{
    if (irq < 8) {
        s.pic[0].irr |= uint8_t(1u << irq);
    } else {
        s.pic[1].irr |= uint8_t(1u << (irq - 8));
        s.pic[0].irr |= uint8_t(1u << CASCADE);
    }
}
// InterruptControllers.pending_vector: -1 when nothing is ready.
inline int pending_vector(PollState &s)
{
    PicChip &master = s.pic[0], &slave = s.pic[1];
    const int line = pending(master, master.irr);
    if (line < 0) return -1;
    if (line == int(CASCADE)) {
        const int slave_line = pending(slave, slave.irr);
        if (slave_line < 0) {
            master.irr &= uint8_t(~(1u << CASCADE));
            return -1;
        }
        acknowledge(master, CASCADE);
        acknowledge(slave, unsigned(slave_line));
        ++s.delivered;
        return slave.vector_base + slave_line;
    }
    acknowledge(master, unsigned(line));
    ++s.delivered;
    return master.vector_base + line;
}
}  // namespace pic
}

namespace {
constexpr std::size_t OV_LOG_CAPACITY = 8192;
// State the I-modem's mailbox endpoint shares with its native port model.
// Python reads and writes these fields in place through a ctypes mirror of
// this layout (dsp.py ImodemShared), so neither side marshals anything.
struct ImodemShared {
    uint64_t dsp_instructions;   // 386 instruction count the C5x has been run to
    double cycle_debt;           // C5x cycles owed and not yet run
    uint64_t pcm_cursor;         // PCM octets already exchanged with the DSC
    uint64_t consumed;
    uint64_t reply_writes;
    uint64_t latch_writes;
    uint64_t lane_writes;        // lane stores served natively
    uint8_t host_pending;
    uint8_t tx_ready;
    uint8_t rx_present;
    uint8_t needs_service;       // 1: the harness has work after a native advance
    // Stop for the harness once this many transmitted PCM octets are waiting
    // (0: at every finished frame, which is the unbatched behaviour).
    uint32_t flush_octets;
    uint8_t lanes[0x60];         // window bytes by port, 0x40..0x5e
    uint32_t tx_pending;         // transmitted octets the harness has not taken
    uint32_t rx_pending;         // receive octets queued ahead in the core
    // Host-port 0x1e accesses served natively, in order, for the mailbox's
    // diagnostic logs: (kind << 3) | value, kind 0 an IN's answer, kind 1 an
    // OUT's low three bits. The harness replays them (ImodemDsp._drain_overlay)
    // before it touches those logs itself; the model declines when this is full.
    uint32_t ov_len;
    uint8_t ov_log[OV_LOG_CAPACITY];
    // What the harness publishes so the engine can skip its poll (poll()):
    // until which 386 instruction count nothing in the harness is due, whether
    // anything it depends on was touched since it last looked, and where the
    // line clock stands (octets of B1 it has taken, octets waiting to go out,
    // and the line frame that sends them).
    uint64_t elide_until;
    uint64_t clock_seen;
    uint64_t clock_pending;
    uint32_t clock_frame;
    uint8_t poll_dirty;
    uint8_t elide_on;
    uint64_t polls_native, polls_resumed;
    uint8_t elided_if, elided_any;
    uint64_t poll_why[8];
};

// Port model for the I-modem's live data lanes and their DSP advance. It does
// what ImodemDsp.read/write and IsdnMachine._advance_dsp do for these ports,
// and stops, leaving `needs_service` set, whenever the harness has to act
// (a finished PCM frame, a reply to offer) so that work happens in Python in
// the same order it would have.
struct ImodemHostIo {
    ImodemShared *shared = nullptr;
    C5xCore *core = nullptr;
    bool live = false;
    double cycles_per_instruction = 0;
    uint32_t read_quantum = 0;
    uint32_t in_count[256] = {}, out_count[256] = {};
    courier::Bearer *bearer = nullptr;
    PollState *ps = nullptr;

    // The 8259 registers at 0xf020/0xf021 and 0xf0a0/0xf0a1.
    bool serve_pic(int direction, uint16_t port, uint16_t value, uint16_t *out)
    {
        unsigned slot;
        switch (port) {
        case 0xF020: slot = 0; break;
        case 0xF021: slot = 1; break;
        case 0xF0A0: slot = 2; break;
        case 0xF0A1: slot = 3; break;
        default: return false;
        }
        PicChip &chip = ps->pic[slot >> 1];
        if (direction == 1) {
            *out = (slot & 1) ? chip.mask : (chip.read_isr ? chip.isr : chip.irr);
            ++ps->pic_in[slot];
        } else {
            if (slot & 1) pic::data(chip, uint8_t(value));
            else pic::command(chip, uint8_t(value));
            ++ps->pic_out[slot];
        }
        return true;
    }

    uint16_t word(uint16_t port) const
    {
        return uint16_t(shared->lanes[port] | (shared->lanes[port + 2] << 8));
    }

    // The host-port status (0x1c) and strobe (0x1e) registers, for the cases
    // that need nothing from the harness: ImodemDsp.read/write do the same.
    // Anything else - a command commit, a reply acknowledgement, a reply to
    // offer, a full log - is declined and left to them.
    int serve_host_port(int direction, uint16_t port, uint16_t value,
                        uint64_t now, uint16_t *out)
    {
        ImodemShared *sh = shared;
        if (direction == 1) {
            if (port == 0x1e && sh->ov_len >= OV_LOG_CAPACITY) return 0;
            if (!advance(now, read_quantum)) return 0;
            uint16_t answer;
            if (port == 0x1e) {
                answer = uint16_t(~(core->io(0x57) >> 8)) & 7;
                sh->ov_log[sh->ov_len++] = uint8_t(answer);
            } else {
                // ImodemDsp._sync, then the mailbox's status word.
                const uint16_t status = core->io(0x57);
                if (sh->host_pending && !(status & 1)) {
                    ++sh->consumed;
                    sh->host_pending = 0;
                }
                sh->tx_ready = !(status & 1);
                if (!(status & 2) && !sh->rx_present
                    && core->io_port_stat(0x5f).writes > sh->reply_writes)
                    return 0;
                answer = uint16_t(sh->tx_ready | (sh->rx_present ? 2 : 0));
            }
            ++in_count[port];
            *out = answer;
            return 1;
        }
        value &= 0xff;
        if (port == 0x1c) {
            // Bit 0 commits a command and bit 1 acknowledges a reply; with
            // neither the write does nothing at all.
            if (value & 3) return 0;
            if (!advance(now, 0)) return 0;
        } else {
            if (sh->ov_len >= OV_LOG_CAPACITY) return 0;
            if (!advance(now, 0)) return 0;
            const unsigned masked = value & 7;
            sh->ov_log[sh->ov_len++] = uint8_t(8 | masked);
            if (value & 3) {
                const uint16_t base = (value & 1) ? 0x40 : 0x48;
                const uint16_t dsp_base = (value & 1) ? 0x58 : 0x5a;
                for (unsigned i = 0; i < 2; ++i)
                    core->set_io(uint16_t(dsp_base + i), word(uint16_t(base + 4 * i)));
            }
            core->set_io(0x57, uint16_t(core->io(0x57) | (masked << 8)));
        }
        ++out_count[port];
        return 1;
    }

    // The octets the C5x has transmitted that nobody has exchanged: `waiting`
    // of them when it is the native model's own count that is there, else all.
    std::size_t untaken(std::size_t waiting) const
    {
        const auto &tx = core->g711_tx();
        const std::size_t cursor = std::min<std::size_t>(shared->pcm_cursor, tx.size());
        const std::size_t available = tx.size() - cursor;
        return waiting && available >= waiting ? waiting : available;
    }

    // The part of ImodemDsp._sync_values the native path may do: a reply to
    // offer is Python's.
    bool reply_due(uint16_t status, uint64_t writes) const
    {
        return !(status & 2) && !shared->rx_present && writes > shared->reply_writes;
    }

    void sync_values(uint16_t status)
    {
        ImodemShared *sh = shared;
        if (sh->host_pending && !(status & 1)) {
            ++sh->consumed;
            sh->host_pending = 0;
        }
        sh->tx_ready = !(status & 1);
    }

    // Exchange `count` octets from the C5x's transmit buffer, which must be
    // settled entirely from frames fed ahead (the caller has checked).
    void exchange_taken(std::size_t count)
    {
        ImodemShared *sh = shared;
        const auto &tx = core->g711_tx();
        std::vector<uint8_t> octets(tx.begin() + sh->pcm_cursor,
                                    tx.begin() + sh->pcm_cursor + count);
        sh->pcm_cursor += count;
        uint8_t remainder[2 * courier::BEARER_SLOTS + 2];
        bearer->exchange(core, octets.data(), octets.size(), remainder);
    }

    bool settles(std::size_t count) const
    {
        const std::size_t frames = ((bearer->partial_valid ? 1 : 0) + count) / courier::BEARER_SLOTS;
        return bearer->ahead.size() >= frames;
    }

    // ImodemDsp.service_pending, for what the native path can do alone.
    // 0: done. 2: nothing was changed and Python must do it. 3: the C5x ran on
    // and the harness has to carry on from there (ImodemDsp.resume_service).
    int service()
    {
        ImodemShared *sh = shared;
        if (bearer->frame_service) return 2;
        const uint16_t status = core->io(0x57);
        const uint64_t writes = core->io_port_stat(0x5f).writes;
        if (reply_due(status, writes)) return 2;
        const std::size_t count = untaken(sh->tx_pending);
        if (count && (!settles(count)
                      || (!bearer->ahead.empty() && !bearer->lookahead_valid()))) return 2;
        sh->needs_service = 0;
        sh->tx_pending = 0;
        sync_values(status);
        if (count) exchange_taken(count);
        bearer->prefeed(core);
        // step_cycles(0): run what is still owed, one finished frame at a time.
        if (sh->cycle_debt < 1) return 0;
        int64_t remaining = int64_t(sh->cycle_debt);
        int64_t elapsed = 0;
        while (remaining > 0) {
            const uint64_t before = core->cycle_count();
            core->run_cycles(uint64_t(remaining), true);
            const int64_t spent = int64_t(core->cycle_count() - before);
            elapsed += spent;
            const uint16_t now_status = core->io(0x57);
            const std::size_t taken = untaken(0);
            if (reply_due(now_status, core->io_port_stat(0x5f).writes)
                || (taken && !settles(taken))) {
                sh->cycle_debt -= double(elapsed);
                return 3;
            }
            sync_values(now_status);
            if (taken) exchange_taken(taken);
            remaining -= spent;
        }
        sh->cycle_debt -= double(elapsed);
        return 0;
    }

    // The engine's poll hook: ImodemDsp's share of IsdnMachine.poll_timers
    // (flush, prefeed, advance), when everything else in that poll is known to
    // do nothing. 1: done; 0: run the whole poll in Python; 2/3: the poll was
    // begun here and Python finishes it.
    // IsdnMachine.push_far: take `vector` through the vector table. False for
    // a null vector, with nothing changed.
    static bool enter_interrupt(const PollCpu &cpu, unsigned vector)
    {
        uint32_t *r = cpu.regs;
        uint8_t *mem = cpu.memory;
        const std::size_t length = cpu.memory_size;
        const uint32_t table = vector * 4;
        const uint16_t offset = uint16_t(mem[table] | uint16_t(mem[table + 1]) << 8);
        const uint16_t segment = uint16_t(mem[table + 2] | uint16_t(mem[table + 3]) << 8);
        if (!offset && !segment) return false;
        uint16_t sp = uint16_t(r[REG_SP]);
        const uint16_t values[] = {uint16_t(r[REG_FLAGS]), uint16_t(r[REG_CS]), uint16_t(r[REG_IP])};
        for (uint16_t value : values) {
            sp = uint16_t(sp - 2);
            const uint32_t address = uint32_t(((r[REG_SS] & 65535) * 16 + sp) % length);
            mem[address] = uint8_t(value);
            mem[(address + 1) % length] = uint8_t(value >> 8);
        }
        r[REG_SP] = sp;
        r[REG_FLAGS] = uint16_t(r[REG_FLAGS]) & ~uint32_t(0x0200 | 0x0100);
        r[REG_CS] = segment;
        r[REG_IP] = offset;
        return true;
    }

    // What is left of IsdnMachine.poll_timers once the DSP has been dealt with,
    // and of its caller's tail: the services that raise a line when due, the
    // sources that stay asserted, the 8254 wraps, and the interrupt the
    // controller hands over if IF allows one.
    bool tail(uint64_t now, uint32_t flags, const PollCpu &cpu)
    {
        PollState &s = *ps;
        const uint64_t value = uint64_t(int64_t(now) - s.clock_origin);
        if (s.rtos_on && value >= s.next_rtos) {
            s.next_rtos = value + s.rtos_interval;
            pic::raise(s, 11);
        }
        for (unsigned index = 0; index < s.asserted_count; ++index) pic::raise(s, s.asserted[index]);
        if (s.mailbox_on && value >= s.next_mailbox) {
            s.next_mailbox = value + s.mailbox_interval;
            pic::raise(s, 13);
        }
        const uint64_t ticks = value * s.pit_clock_hz / s.ips;
        for (unsigned index = 0; index < 3; ++index) {
            PitSlot &slot = s.pit[index];
            if (ticks < slot.next_due) continue;
            const uint64_t period = slot.initial ? slot.initial : 65536;
            const uint64_t elapsed = ticks > slot.origin ? ticks - slot.origin : 0;
            const uint64_t total = slot.programmed ? elapsed / period : 0;
            const uint64_t fresh = total > slot.reported ? total - slot.reported : 0;
            slot.reported = total;
            slot.next_due = slot.programmed ? slot.origin + (total + 1) * period : PIT_INFINITE;
            if (!fresh) continue;
            s.timer_ticks += fresh;
            for (unsigned entry = 0; entry < 4 && s.counter_irq[4 * index + entry] >= 0; ++entry) {
                const unsigned line = unsigned(s.counter_irq[4 * index + entry]);
                const PicChip &chip = s.pic[line >= 8 ? 1 : 0];
                const bool already = (chip.irr >> (line % 8)) & 1;
                s.coalesced[index] += fresh - (already ? 0 : 1);
                pic::raise(s, line);
            }
        }
        s.last_poll = now;
        bool delivered = false;
        if (flags & 0x200) {
            const int vector = pic::pending_vector(s);
            if (vector >= 0 && enter_interrupt(cpu, unsigned(vector))) {
                ++s.hardware_interrupts;
                delivered = true;
            }
        }
        return delivered;
    }

    int poll(uint64_t now, uint32_t flags, const PollCpu &cpu)
    {
        ImodemShared *sh = shared;
        if (!sh || !core || !live || !bearer || !sh->elide_on) return 0;
        if (sh->poll_dirty) { ++sh->poll_why[1]; return 0; }
        if (sh->needs_service) { ++sh->poll_why[2]; return 0; }
        if (now >= sh->elide_until) { ++sh->poll_why[3]; return 0; }
        courier::Bearer &b = *bearer;
        if (!b.activated || b.frame_service || !b.channels || !b.lookahead_valid()) {
            ++sh->poll_why[4];
            return 0;
        }
        std::size_t flush = 0;
        if (sh->tx_pending) {
            flush = untaken(sh->tx_pending);
            if (!settles(flush)) { ++sh->poll_why[5]; return 0; }
        }
        const std::size_t frames = ((b.partial_valid ? 1 : 0) + flush) / courier::BEARER_SLOTS;
        // The line clock sends a frame when enough B1 octets have gathered.
        if (b.tx[0].size() + frames + sh->clock_pending
            >= sh->clock_seen + sh->clock_frame) { ++sh->poll_why[6]; return 0; }
        if (sh->tx_pending) {
            sh->tx_pending = 0;
            if (flush) exchange_taken(flush);
            b.prefeed(core);
        }
        if (b.ahead.size() * 2 <= b.lookahead_frames) b.prefeed(core);
        int result = 0;
        if (!advance(now, 0)) result = service();
        if (result) {
            ++sh->polls_resumed;
            return result;
        }
        const bool delivered = tail(now, flags, cpu);
        ++sh->polls_native;
        // An interrupt taken costs the dispatch edge one retired instruction
        // that executes nothing (see Core::poll_fn).
        return delivered ? 4 : 1;
    }

    // true: the C5x is where the harness would have put it; false: the
    // harness has to take over from here.
    bool advance(uint64_t now, uint32_t quantum)
    {
        ImodemShared *sh = shared;
        if (sh->needs_service) return false;
        const int64_t elapsed = int64_t(now) - int64_t(sh->dsp_instructions);
        if (elapsed < int64_t(quantum)) return true;
        sh->dsp_instructions = now;
        if (!elapsed) return true;
        sh->cycle_debt += double(elapsed) * cycles_per_instruction;
        if (sh->cycle_debt < 1) return true;
        int64_t remaining = int64_t(sh->cycle_debt);
        uint64_t spent_total = 0;
        bool stop = false;
        try {
            while (remaining > 0) {
                const uint64_t before = core->cycle_count();
                core->run_cycles(uint64_t(remaining), true);
                const uint64_t spent = core->cycle_count() - before;
                const auto &octets = core->g711_tx();
                const std::size_t cursor = std::min<std::size_t>(
                    sh->pcm_cursor, octets.size());
                const std::size_t waiting = octets.size() - cursor;
                const std::size_t queued = core->g711_rx_pending();
                sh->tx_pending = uint32_t(waiting);
                sh->rx_pending = uint32_t(queued);
                // A finished frame is the harness's to exchange. With receive
                // octets queued ahead the C5x can run on through several, up
                // to flush_octets of transmit, and must stop before one that
                // would find the queue empty.
                const bool frame = waiting > 0
                    && (sh->flush_octets == 0 || waiting >= sh->flush_octets
                        || queued < 2);
                const uint16_t status = core->io(0x57);
                const uint64_t writes = core->io_port_stat(0x5f).writes;
                if (sh->host_pending && !(status & 1)) {
                    ++sh->consumed;
                    sh->host_pending = 0;
                }
                sh->tx_ready = !(status & 1);
                const bool reply = !(status & 2) && !sh->rx_present
                    && writes > sh->reply_writes;
                spent_total += spent;
                remaining -= int64_t(spent);
                if (frame || reply) { stop = true; break; }
            }
        } catch (const std::exception &) {
            stop = true;
        }
        sh->cycle_debt -= double(spent_total);
        if (stop) sh->needs_service = 1;
        return !stop;
    }
};
}

extern "C" {

void *courier_laneio_create() { return new LaneHostIo(); }

void courier_laneio_destroy(void *context)
{
    delete static_cast<LaneHostIo *>(context);
}

// `core` may be null, which declines every access.
void courier_laneio_configure(void *context, void *core, int live,
    uint16_t command_port, uint16_t ack_port, uint16_t lane_first,
    uint16_t banks, uint16_t dsp_first, uint16_t dsp_status)
{
    auto *io = static_cast<LaneHostIo *>(context);
    io->core = static_cast<C5xCore *>(core);
    io->live = live != 0;
    io->command_port = command_port;
    io->ack_port = ack_port;
    io->lane_first = lane_first;
    io->banks = banks > 8 ? 8 : banks;
    io->dsp_first = dsp_first;
    io->dsp_status = dsp_status;
}

// What the harness knows about the mailbox ports that the model cannot read
// off the DSP's latch: see LaneHostIo::serve_mailbox.
void courier_laneio_configure_mailbox(void *context, int runtime, int pending,
    int inbound, int overlay, unsigned overlay_status, int zero_ok,
    unsigned status_cell)
{
    auto *io = static_cast<LaneHostIo *>(context);
    io->mb_runtime = runtime != 0;
    io->mb_pending = pending != 0;
    io->mb_inbound = inbound != 0;
    io->mb_overlay = overlay != 0;
    io->mb_overlay_status = uint8_t(overlay_status);
    io->mb_zero_ok = zero_ok != 0;
    io->mb_status_cell = uint16_t(status_cell);
}

void courier_laneio_set_lane(void *context, unsigned index, uint8_t *byte)
{
    if (index < 16) static_cast<LaneHostIo *>(context)->lane[index] = byte;
}

// direction 1 = IN, 2 = OUT. Returns 1 when served; the answer to an IN is in
// *out. Byte accesses only.
int courier_laneio_access(void *context, int direction, uint16_t port,
    int size, uint16_t value, uint64_t, uint16_t *out)
{
    auto *io = static_cast<LaneHostIo *>(context);
    if (!io->core || size != 1 || port >= 256) return 0;
    if ((port == 0x1c || port == 0x1e) && io->serve_mailbox(direction, port, value, out))
        return 1;
    const uint16_t mask = uint16_t((1u << io->banks) - 1);
    const uint16_t lane_last = uint16_t(io->lane_first + 4 * io->banks);
    if (direction == 1) {
        if (!io->live) return 0;
        uint16_t answer;
        if (port == io->command_port || port == io->ack_port) {
            const uint16_t status = io->core->io(io->dsp_status);
            answer = port == io->command_port
                ? uint16_t(0xC0 | (~status & mask))
                : uint16_t(0xC0 | (~(status >> 8) & mask));
        } else if (port >= io->lane_first && port < lane_last) {
            const unsigned offset = port - io->lane_first;
            const uint16_t word = io->core->io_output(
                uint16_t(io->dsp_first + offset / 4));
            answer = (word >> ((offset & 2) ? 8 : 0)) & 0xff;
        } else {
            return 0;
        }
        ++io->in_count[port];
        *out = answer & 0xff;
        return 1;
    }
    value &= 0xff;
    if (port == io->command_port || port == io->ack_port) {
        if (!io->live) return 0;
        uint16_t bits = value & mask;
        if (port == io->command_port) {
            for (unsigned bank = 0; bank < io->banks; ++bank)
                if (bits & (1u << bank))
                    io->core->set_io(uint16_t(io->dsp_first + bank),
                        io->lane_word(bank));
        } else {
            bits = uint16_t(bits << 8);
        }
        io->core->set_io(io->dsp_status,
            uint16_t(io->core->io(io->dsp_status) | bits));
    } else if (port >= io->lane_first && port < lane_last
               && !((port - io->lane_first) & 1)) {
        uint8_t *byte = io->lane[(port - io->lane_first) / 2];
        if (!byte) return 0;
        *byte = uint8_t(value);
    } else {
        return 0;
    }
    ++io->out_count[port];
    io->out_last[port] = value;
    io->out_seen[port] = 1;
    return 1;
}

void *courier_imodemio_create() { return new ImodemHostIo(); }

void courier_imodemio_destroy(void *context)
{
    delete static_cast<ImodemHostIo *>(context);
}

// `core` may be null, which declines everything but lane stores.
void courier_imodemio_configure(void *context, void *shared, void *core,
    int live, double cycles_per_instruction, unsigned read_quantum)
{
    auto *io = static_cast<ImodemHostIo *>(context);
    io->shared = static_cast<ImodemShared *>(shared);
    io->core = static_cast<C5xCore *>(core);
    io->live = live != 0;
    io->cycles_per_instruction = cycles_per_instruction;
    io->read_quantum = read_quantum;
}

// The harness's own advance, for passes that are not port accesses: 1 when the
// C5x is where the harness would have put it, 0 when it must call
// service_pending (needs_service is then set).
int courier_imodemio_advance(void *context, uint64_t now, unsigned quantum)
{
    auto *io = static_cast<ImodemHostIo *>(context);
    if (!io->shared || !io->core || !io->live) return 0;
    return io->advance(now, quantum) ? 1 : 0;
}

void courier_imodemio_set_poll_state(void *context, void *state)
{
    static_cast<ImodemHostIo *>(context)->ps = static_cast<PollState *>(state);
}

void courier_imodemio_set_bearer(void *context, void *bearer)
{
    static_cast<ImodemHostIo *>(context)->bearer = static_cast<courier::Bearer *>(bearer);
}

int courier_imodemio_poll(void *context, uint64_t now, uint32_t flags, void *cpu)
{
    return static_cast<ImodemHostIo *>(context)->poll(now, flags, *static_cast<PollCpu *>(cpu));
}

int courier_imodemio_access(void *context, int direction, uint16_t port,
    int size, uint16_t value, uint64_t now, uint16_t *out)
{
    auto *io = static_cast<ImodemHostIo *>(context);
    ImodemShared *sh = io->shared;
    if (io->ps && port >= 0xF020 && io->serve_pic(direction, port, value, out)) return 1;
    if (!sh || size != 1 || port >= 0x60) return 0;
    const bool lane = port >= 0x40 && port < 0x58 && !(port & 1);
    if (direction == 2 && lane) {
        sh->lanes[port] = uint8_t(value);
        ++sh->lane_writes;
        ++io->out_count[port];
        return 1;
    }
    if (!io->core || !io->live) return 0;
    if (port == 0x1c || port == 0x1e) return io->serve_host_port(direction, port, value, now, out);
    if (direction == 1) {
        if (port != 0x18 && port != 0x1a && !lane) return 0;
        if (!io->advance(now, io->read_quantum)) return 0;
        uint16_t answer;
        if (port == 0x18 || port == 0x1a) {
            const uint16_t status = io->core->io(0x56);
            answer = port == 0x18 ? uint16_t(0xc0 | (~status & 0x3f))
                                  : uint16_t(0xc0 | (~(status >> 8) & 0x3f));
        } else {
            const unsigned offset = port - 0x40;
            const uint16_t word = io->core->io_output(uint16_t(0x58 + offset / 4));
            answer = (word >> ((offset & 2) ? 8 : 0)) & 0xff;
        }
        ++io->in_count[port];
        *out = answer & 0xff;
        return 1;
    }
    // The ack/command latches: 0xff on 0x18 is the loader's reset request.
    if ((port != 0x18 && port != 0x1a) || (port == 0x18 && (value & 0xff) == 0xff))
        return 0;
    if (!io->advance(now, 0)) return 0;
    uint16_t bits = value & 0x3f;
    if (port == 0x18) {
        for (unsigned bank = 0; bank < 6; ++bank)
            if (bits & (1u << bank))
                io->core->set_io(uint16_t(0x58 + bank),
                    io->word(uint16_t(0x40 + 4 * bank)));
    } else {
        bits = uint16_t(bits << 8);
    }
    io->core->set_io(0x56, uint16_t(io->core->io(0x56) | bits));
    ++sh->latch_writes;
    ++io->out_count[port];
    return 1;
}

void courier_imodemio_take_counts(void *context, uint32_t *in_counts,
    uint32_t *out_counts)
{
    auto *io = static_cast<ImodemHostIo *>(context);
    std::memcpy(in_counts, io->in_count, sizeof io->in_count);
    std::memcpy(out_counts, io->out_count, sizeof io->out_count);
    std::memset(io->in_count, 0, sizeof io->in_count);
    std::memset(io->out_count, 0, sizeof io->out_count);
}

// A write the harness handled itself supersedes the last one served here.
void courier_laneio_clear_seen(void *context, uint16_t port)
{
    if (port < 256) static_cast<LaneHostIo *>(context)->out_seen[port] = 0;
}

// Copy out and clear the tallies of accesses served so far.
void courier_laneio_take_counts(void *context, uint32_t *in_counts,
    uint32_t *out_counts, uint16_t *last, uint8_t *seen)
{
    auto *io = static_cast<LaneHostIo *>(context);
    std::memcpy(in_counts, io->in_count, sizeof io->in_count);
    std::memcpy(out_counts, io->out_count, sizeof io->out_count);
    std::memcpy(last, io->out_last, sizeof io->out_last);
    std::memcpy(seen, io->out_seen, sizeof io->out_seen);
    std::memset(io->in_count, 0, sizeof io->in_count);
    std::memset(io->out_count, 0, sizeof io->out_count);
    std::memset(io->out_seen, 0, sizeof io->out_seen);
}

void *courier_c5x_create()
{
    try { return new C5xCore(); } catch (...) { return nullptr; }
}

// Keep the original constructor ABI for existing Courier clients.
void *courier_c5x_create_model(int model)
{
    if (model != 51 && model != 52 && model != 53) return nullptr;
    try { return new C5xCore(model == 53 ? C5xCore::Model::C53 : model == 52 ? C5xCore::Model::C52 : C5xCore::Model::C51); }
    catch (...) { return nullptr; }
}

void courier_c5x_set_separate_global_memory(void *handle, int enabled)
{
    if (handle) static_cast<C5xCore *>(handle)->set_separate_global_memory(enabled != 0);
}

void courier_c5x_destroy(void *handle) { delete static_cast<C5xCore *>(handle); }

void courier_c5x_reset(void *handle)
{
    if (handle) static_cast<C5xCore *>(handle)->reset();
}

void courier_c5x_get_delay_move_state(void *handle, uint64_t *values)
{
    if (!handle || !values) return;
    const auto state = static_cast<C5xCore *>(handle)->delay_move_state();
    std::copy(state.begin(), state.end(), values);
}

int courier_c5x_load_program(
    void *handle, uint16_t origin, const uint8_t *bytes, std::size_t byte_count,
    char *error, std::size_t error_size)
{
    try {
        if (!handle || !bytes || (byte_count & 1)) throw std::runtime_error("invalid C5x program segment");
        std::vector<uint16_t> words(byte_count / 2);
        for (std::size_t i = 0; i < words.size(); ++i)
            words[i] = uint16_t(bytes[i * 2] | (uint16_t(bytes[i * 2 + 1]) << 8));
        static_cast<C5xCore *>(handle)->load_program(words.data(), words.size(), origin);
        return 0;
    } catch (const std::exception &exception) {
        copy_error(error, error_size, exception.what());
        return -1;
    }
}

int courier_c5x_schedule_call_overlay(
    void *handle, uint16_t origin, const uint8_t *bytes, std::size_t byte_count,
    uint16_t entry, const uint16_t *registers, uint16_t selector,
    char *error, std::size_t error_size)
{
    try {
        if (!handle || !bytes || !registers || (byte_count & 1))
            throw std::runtime_error("invalid C5x call overlay");
        std::vector<uint16_t> words(byte_count / 2);
        for (std::size_t i = 0; i < words.size(); ++i)
            words[i] = uint16_t(bytes[i * 2] | (uint16_t(bytes[i * 2 + 1]) << 8));
        static_cast<C5xCore *>(handle)->schedule_call_overlay(
            origin, words.data(), words.size(), entry, registers, selector);
        return 0;
    } catch (const std::exception &exception) {
        copy_error(error, error_size, exception.what());
        return -1;
    }
}

int courier_c5x_load_rom(
    void *handle, uint16_t origin, const uint8_t *bytes, std::size_t byte_count,
    char *error, std::size_t error_size)
{
    try {
        if (!handle || !bytes || (byte_count & 1)) throw std::runtime_error("invalid C5x ROM image");
        std::vector<uint16_t> words(byte_count / 2);
        for (std::size_t i = 0; i < words.size(); ++i)
            words[i] = uint16_t(bytes[i * 2] | (uint16_t(bytes[i * 2 + 1]) << 8));
        static_cast<C5xCore *>(handle)->load_rom(words.data(), words.size(), origin);
        return 0;
    } catch (const std::exception &exception) {
        copy_error(error, error_size, exception.what());
        return -1;
    }
}

void courier_c5x_set_host_io_base(void *handle, uint16_t base)
{
    if (handle) static_cast<C5xCore *>(handle)->set_host_io_base(base);
}

void courier_c5x_set_mpmc_pin(void *handle, int level)
{
    if (handle) static_cast<C5xCore *>(handle)->set_mpmc_pin(uint16_t(level));
}

void courier_c5x_set_shared_window(void *handle, uint16_t first, uint16_t last)
{
    if (handle) static_cast<C5xCore *>(handle)->set_shared_window(first, last);
}

// The core has always carried I/O callbacks; only the C entry point was
// missing, so a harness outside C++ could not install a device. The MICA board
// needs one: its host port is at forced MMRs 0x50..0x52, which this core
// already routes into the I/O space, and what answers there is a window onto
// i960 memory rather than anything the Courier has.
//
// A null callback restores the default, which is the core's own port storage.
// The read callback is asked about every port, so a device that claims only
// some of them should return the stored value for the rest -
// courier_c5x_get_io answers that.
void courier_c5x_set_io_hooks(
    void *handle, uint16_t (*read)(void *user, uint16_t port),
    void (*write)(void *user, uint16_t port, uint16_t value), void *user)
{
    if (!handle) return;
    C5xCore *core = static_cast<C5xCore *>(handle);
    C5xCore::IoRead on_read;
    C5xCore::IoWrite on_write;
    if (read)
        on_read = [read, user](uint16_t port) { return read(user, port); };
    if (write)
        on_write = [write, user](uint16_t port, uint16_t value) { write(user, port, value); };
    core->set_io_callbacks(std::move(on_read), std::move(on_write));
}

void courier_c5x_get_memory_map(void *handle, uint64_t *values, std::size_t count)
{
    if (!handle || !values || count < 21) return;
    auto map = static_cast<C5xCore *>(handle)->memory_map();
    uint64_t result[] = {
        map.mpmc_pin, map.mpmc, map.ovly, map.ram, map.cnf, map.iptr,
        map.pdwsr, map.iowsr, map.cwsr, map.rom_present ? 1u : 0u,
        map.program_rom, map.program_daram, map.program_saram,
        map.program_external,
        map.data_registers, map.data_daram, map.data_saram,
        map.data_reserved, map.data_shared, map.data_external, map.rom_holes,
    };
    std::copy(std::begin(result), std::end(result), values);
}

int courier_c5x_step(void *handle, uint64_t count, char *error, std::size_t error_size)
{
    try {
        if (!handle) throw std::runtime_error("null C5x handle");
        static_cast<C5xCore *>(handle)->run(count);
        return 0;
    } catch (const std::exception &exception) {
        copy_error(error, error_size, exception.what());
        return -1;
    }
}

int courier_c5x_step_cycles(void *handle, uint64_t count,
    uint64_t *instructions, uint64_t *cycles,
    char *error, std::size_t error_size)
{
    try {
        if (!handle) throw std::runtime_error("null C5x handle");
        C5xCore *core = static_cast<C5xCore *>(handle);
        const uint64_t before_instructions = core->instruction_count();
        const uint64_t before_cycles = core->cycle_count();
        core->run_cycles(count);
        if (instructions)
            *instructions = core->instruction_count() - before_instructions;
        if (cycles) *cycles = core->cycle_count() - before_cycles;
        return 0;
    } catch (const std::exception &exception) {
        copy_error(error, error_size, exception.what());
        return -1;
    }
}

std::size_t courier_c5x_advance_imodem(void *handle, uint64_t count,
    std::size_t tx_start, uint8_t *tx, std::size_t tx_capacity,
    uint64_t *values, std::size_t value_count,
    char *error, std::size_t error_size)
{
    try {
        if (!handle || !values || value_count < 6)
            throw std::runtime_error("invalid I-modem advance arguments");
        C5xCore *core = static_cast<C5xCore *>(handle);
        const uint64_t before_instructions = core->instruction_count();
        const uint64_t before_cycles = core->cycle_count();
        core->run_cycles(count, true);
        const auto &words = core->g711_tx();
        tx_start = std::min(tx_start, words.size());
        const std::size_t available = words.size() - tx_start;
        if (tx)
            std::copy_n(words.begin() + tx_start,
                std::min(available, tx_capacity), tx);
        const auto &port = core->io_port_stat(0x5f);
        values[0] = core->instruction_count() - before_instructions;
        values[1] = core->cycle_count() - before_cycles;
        values[2] = core->io(0x57);
        values[3] = core->io_output(0x5e);
        values[4] = core->io_output(0x5f);
        values[5] = port.writes;
        return available;
    } catch (const std::exception &exception) {
        copy_error(error, error_size, exception.what());
        return std::size_t(-1);
    }
}

uint16_t courier_c5x_get_io_output(void *handle, uint16_t port)
{
    return handle ? static_cast<C5xCore *>(handle)->io_output(port) : 0;
}

void courier_c5x_set_io(void *handle, uint16_t port, uint16_t value)
{
    if (handle) static_cast<C5xCore *>(handle)->set_io(port, value);
}

void courier_c5x_queue_io_rx(
    void *handle, uint16_t port, const uint16_t *words, std::size_t count)
{
    if (handle && words) static_cast<C5xCore *>(handle)->queue_io_rx(port, words, count);
}

void courier_c5x_configure_host_mailbox(void *handle, int enabled)
{
    if (handle) static_cast<C5xCore *>(handle)->configure_host_mailbox(enabled != 0);
}

uint64_t courier_c5x_get_xf_falling_edges(void *handle)
{
    return handle ? static_cast<C5xCore *>(handle)->xf_falling_edges() : 0;
}

void courier_c5x_host_write(void *handle, uint16_t address, uint16_t value)
{
    if (handle) static_cast<C5xCore *>(handle)->host_write(address, value);
}

void courier_c5x_queue_serial_rx(void *handle, const uint16_t *samples, std::size_t count)
{
    if (handle && samples) static_cast<C5xCore *>(handle)->queue_serial_rx(samples, count);
}

void courier_c5x_queue_codec_boot(void *handle, const uint16_t *words, std::size_t count)
{
    if (handle && words) static_cast<C5xCore *>(handle)->queue_codec_boot(words, count);
}

void courier_c5x_queue_codec_rx(void *handle, const uint16_t *samples, std::size_t count)
{
    if (handle && samples) static_cast<C5xCore *>(handle)->queue_codec_rx(samples, count);
}

void courier_c5x_queue_line_rx(void *handle, const uint16_t *samples, std::size_t count)
{
    if (handle && samples) static_cast<C5xCore *>(handle)->queue_line_rx(samples, count);
}

void courier_c5x_set_hybrid_return(void *handle, uint32_t return_scale,
    uint32_t delay)
{
    if (handle) static_cast<C5xCore *>(handle)->set_hybrid_return(
        return_scale, delay);
}

void courier_c5x_configure_digital_pcm(void *handle, int enabled,
    uint16_t idle_codeword, uint32_t clock_hz)
{
    if (handle) static_cast<C5xCore *>(handle)->configure_digital_pcm(
        enabled != 0, idle_codeword, clock_hz);
}

uint64_t courier_c5x_get_g711_rx_underruns(void *handle)
{
    return handle ? static_cast<C5xCore *>(handle)->g711_rx_underruns() : 0;
}

std::size_t courier_c5x_get_g711_rx_pending(void *handle)
{
    return handle ? static_cast<C5xCore *>(handle)->g711_rx_pending() : 0;
}

std::size_t courier_c5x_drop_g711_rx_tail(void *handle, std::size_t count)
{
    return handle ? static_cast<C5xCore *>(handle)->drop_g711_rx_tail(count) : 0;
}

void courier_c5x_queue_g711_rx(void *handle, const uint8_t *codewords, std::size_t count)
{
    if (handle && codewords) static_cast<C5xCore *>(handle)->queue_g711_rx(codewords, count);
}

std::size_t courier_c5x_get_g711_tx(void *handle, uint8_t *out, std::size_t capacity)
{
    if (!handle) return 0;
    const auto &codewords = static_cast<C5xCore *>(handle)->g711_tx();
    const std::size_t count = std::min(codewords.size(), capacity);
    if (out) std::copy(codewords.begin(), codewords.begin() + count, out);
    return codewords.size();
}

std::size_t courier_c5x_get_g711_tx_since(void *handle, std::size_t start,
    uint8_t *out, std::size_t capacity)
{
    if (!handle) return 0;
    const auto &words = static_cast<C5xCore *>(handle)->g711_tx();
    start = std::min(start, words.size());
    const auto available = words.size() - start;
    if (out) std::copy_n(words.begin() + start, std::min(available, capacity), out);
    return available;
}

// What the I-modem harness reads from the core each time it services the DSP:
// the host-port status word, the reply registers and the count of writes to
// the reply strobe, and the transmitted G.711 octets since `tx_start`. With a
// non-zero `waiting` that is `waiting` octets when that many are there (the
// native port model's own count), otherwise everything since `tx_start`.
// Returns the number of octets copied, or SIZE_MAX when they did not fit.
std::size_t courier_c5x_imodem_collect(void *handle, std::size_t tx_start,
    std::size_t waiting, uint8_t *out, std::size_t capacity, uint64_t *values)
{
    if (!handle) return 0;
    C5xCore *core = static_cast<C5xCore *>(handle);
    values[0] = core->io(0x57);
    values[1] = core->io_output(0x5e);
    values[2] = core->io_output(0x5f);
    values[3] = core->io_port_stat(0x5f).writes;
    const auto &words = core->g711_tx();
    tx_start = std::min(tx_start, words.size());
    const std::size_t available = words.size() - tx_start;
    const std::size_t count = waiting && available >= waiting ? waiting : available;
    if (count > capacity) return SIZE_MAX;
    std::copy_n(words.begin() + tx_start, count, out);
    return count;
}

void courier_c5x_set_data_trace_filter(void *handle, unsigned address, int enabled)
{
    if (handle) static_cast<C5xCore *>(handle)->set_data_trace_filter(
        static_cast<uint16_t>(address), enabled != 0);
}

void courier_c5x_set_data_event_limit(void *handle, std::size_t limit)
{
    if (handle) static_cast<C5xCore *>(handle)->set_data_event_limit(limit);
}

void courier_c5x_set_data_trace_range(void *handle, unsigned first, unsigned last, int enabled)
{
    if (handle) static_cast<C5xCore *>(handle)->set_data_trace_range(first, last, enabled != 0);
}

void courier_c5x_set_step_probes(void *handle, int enabled)
{
    if (handle) static_cast<C5xCore *>(handle)->set_step_probes(enabled != 0);
}

void courier_c5x_set_coverage(void *handle, int enabled)
{
    if (handle) static_cast<C5xCore *>(handle)->set_coverage(enabled != 0);
}

uint64_t courier_c5x_get_first_exec(void *handle, unsigned pc)
{
    return handle ? static_cast<C5xCore *>(handle)->first_exec(uint16_t(pc)) : 0;
}

void courier_c5x_set_pc_trace_range(void *handle, unsigned first, unsigned last)
{
    if (handle) static_cast<C5xCore *>(handle)->set_pc_trace_range(
        static_cast<uint16_t>(first), static_cast<uint16_t>(last));
}

void courier_c5x_set_v8_dispatch_pcs(void *handle, const uint16_t *pcs,
    std::size_t count)
{
    if (handle) static_cast<C5xCore *>(handle)->set_v8_dispatch_pcs(pcs, count);
}

void courier_c5x_set_v8_calling(void *handle, int enabled)
{
    if (handle) static_cast<C5xCore *>(handle)->set_v8_calling(enabled != 0);
}

void courier_c5x_set_v8_answering(void *handle, int enabled)
{
    if (handle) static_cast<C5xCore *>(handle)->set_v8_answering(enabled != 0);
}

std::size_t courier_c5x_get_line_phase_samples(void *handle, unsigned phase,
    uint16_t *out, std::size_t capacity)
{
    if (!handle) return 0;
    const auto &samples = static_cast<C5xCore *>(handle)->line_phase_samples(phase);
    std::size_t count = samples.size() < capacity ? samples.size() : capacity;
    if (out) std::copy(samples.begin(), samples.begin() + count, out);
    return samples.size();
}

void courier_c5x_set_line_dac_slot(void *handle, uint16_t slot)
{
    if (handle) static_cast<C5xCore *>(handle)->set_line_dac_slot(slot);
}

void courier_c5x_set_bio_low(void *handle, int enabled)
{
    if (handle) static_cast<C5xCore *>(handle)->set_bio_low(enabled != 0);
}

uint16_t courier_c5x_get_io(void *handle, uint16_t port)
{
    return handle ? static_cast<C5xCore *>(handle)->io(port) : 0xffff;
}

uint16_t courier_c5x_get_program(void *handle, uint16_t address)
{
    return handle ? static_cast<C5xCore *>(handle)->program(address) : 0xffff;
}

uint16_t courier_c5x_get_data(void *handle, uint16_t address)
{
    return handle ? static_cast<C5xCore *>(handle)->data(address) : 0xffff;
}

uint16_t courier_c5x_get_stack(void *handle, unsigned index)
{
    return handle ? static_cast<C5xCore *>(handle)->stack_entry(index) : 0xffff;
}

uint16_t courier_c5x_get_register(void *handle, uint16_t offset)
{
    return handle ? static_cast<C5xCore *>(handle)->register_value(offset) : 0xffff;
}

void courier_c5x_set_data(void *handle, uint16_t address, uint16_t value)
{
    if (handle) static_cast<C5xCore *>(handle)->set_data(address, value);
}

uint64_t courier_c5x_get_data_write_count(void *handle, uint16_t address)
{
    return handle ? static_cast<C5xCore *>(handle)->data_write_count(address) : 0;
}

void courier_c5x_interrupt(void *handle, unsigned irq)
{
    if (handle) static_cast<C5xCore *>(handle)->interrupt(irq);
}

void courier_c5x_nmi(void *handle)
{
    if (handle) static_cast<C5xCore *>(handle)->nmi();
}

void courier_c5x_configure_line_frame_interrupt(void *handle, unsigned irq, uint16_t vector)
{
    if (handle) static_cast<C5xCore *>(handle)->configure_line_frame_interrupt(irq, vector);
}

void courier_c5x_set_call_tdm_active(void *handle, int active)
{
    if (handle) static_cast<C5xCore *>(handle)->set_call_tdm_active(active != 0);
}

int courier_c5x_call_tdm_active(void *handle)
{
    return handle && static_cast<C5xCore *>(handle)->call_tdm_active() ? 1 : 0;
}

void courier_c5x_schedule_line_frame_entry(void *handle, uint16_t address)
{
    if (handle) static_cast<C5xCore *>(handle)->schedule_line_frame_entry(address);
}

void courier_c5x_set_pc(void *handle, uint16_t address)
{
    if (handle) static_cast<C5xCore *>(handle)->set_pc(address);
}

uint64_t courier_c5x_get_io_port_writes(void *handle, uint16_t port)
{
    return handle ? static_cast<C5xCore *>(handle)->io_port_stat(port).writes : 0;
}

uint16_t courier_c5x_get_pc(void *handle)
{
    return handle ? static_cast<C5xCore *>(handle)->program_counter() : 0;
}

void courier_c5x_get_state(void *handle, uint64_t *values, std::size_t count)
{
    if (!handle || !values || count < 22) return;
    auto state = static_cast<C5xCore *>(handle)->state();
    uint64_t result[] = {
        state.pc, state.op, uint32_t(state.acc), uint32_t(state.accb), uint32_t(state.preg),
        state.dp, state.arp, state.flags, state.idle ? 1u : 0u,
        state.instructions, state.cycles,
        static_cast<C5xCore *>(handle)->io_events().size(),
        state.ar[0], state.ar[1], state.ar[2], state.ar[3],
        state.ar[4], state.ar[5], state.ar[6], state.ar[7],
        state.arcr, state.indx,
    };
    std::copy(std::begin(result), std::end(result), values);
}

void courier_c5x_set_data_trace(void *handle, int enabled)
{
    if (handle) static_cast<C5xCore *>(handle)->set_data_trace(enabled != 0);
}

void courier_c5x_clear_data_events(void *handle)
{
    if (handle) static_cast<C5xCore *>(handle)->clear_data_events();
}

std::size_t courier_c5x_get_data_event_count(void *handle)
{
    return handle ? static_cast<C5xCore *>(handle)->data_events().size() : 0;
}

std::size_t courier_c5x_get_io_event_count(void *handle)
{
    return handle ? static_cast<C5xCore *>(handle)->io_events().size() : 0;
}

void courier_c5x_get_io_port_stats(
    void *handle, uint16_t port, uint64_t *values, std::size_t count)
{
    if (!handle || !values || count < 6) return;
    const auto &stat = static_cast<C5xCore *>(handle)->io_port_stat(port);
    uint64_t result[] = {
        stat.reads, stat.writes, stat.last_read, stat.last_write,
        stat.last_read_pc, stat.last_write_pc,
    };
    std::copy(std::begin(result), std::end(result), values);
}

void courier_c5x_get_io_event(void *handle, std::size_t index, uint64_t *values, std::size_t count)
{
    if (!handle || !values || count < 5) return;
    const auto &events = static_cast<C5xCore *>(handle)->io_events();
    if (index >= events.size()) return;
    const auto &event = events[index];
    uint64_t result[] = {event.write ? 1u : 0u, event.port, event.value, event.pc, event.instruction};
    std::copy(std::begin(result), std::end(result), values);
}

std::size_t courier_c5x_get_mailbox_event_count(void *handle)
{
    return handle ? static_cast<C5xCore *>(handle)->mailbox_events().size() : 0;
}

void courier_c5x_get_mailbox_event(
    void *handle, std::size_t index, uint64_t *values, std::size_t count)
{
    if (!handle || !values || count < 5) return;
    const auto &events = static_cast<C5xCore *>(handle)->mailbox_events();
    if (index >= events.size()) return;
    const auto &event = events[index];
    uint64_t result[] = {event.write ? 1u : 0u, event.port, event.value, event.pc, event.instruction};
    std::copy(std::begin(result), std::end(result), values);
}

uint16_t courier_c5x_get_line_tx_sample(void *handle, std::size_t index)
{
    if (!handle) return 0;
    const auto &samples = static_cast<C5xCore *>(handle)->line_tx_samples();
    return index < samples.size() ? samples[index] : 0;
}

uint64_t courier_c5x_get_line_tx_writes(void *handle)
{
    return handle ? static_cast<C5xCore *>(handle)->serial_state().line_tx_writes : 0;
}

std::size_t courier_c5x_get_line_tx_samples(void *handle, std::size_t first,
    uint16_t *values, std::size_t capacity)
{
    if (!handle) return 0;
    const auto &samples = static_cast<C5xCore *>(handle)->line_tx_samples();
    if (first >= samples.size()) return 0;
    const std::size_t count = std::min(capacity, samples.size() - first);
    std::copy_n(samples.begin() + first, count, values);
    return count;
}

std::size_t courier_c5x_get_line_tx_clock_events(void *handle, uint64_t *values, std::size_t count)
{
    if (!handle) return 0;
    const auto &events = static_cast<C5xCore *>(handle)->line_tx_clock_events();
    if (values)
        for (std::size_t i = 0; i < std::min(count, events.size()); ++i) {
            values[2*i] = events[i][0];
            values[2*i+1] = events[i][1];
        }
    return events.size();
}

void courier_c5x_get_data_event(void *handle, std::size_t index, uint64_t *values, std::size_t count)
{
    if (!handle || !values || count < 4) return;
    const auto &events = static_cast<C5xCore *>(handle)->data_events();
    if (index >= events.size()) return;
    const auto &event = events[index];
    uint64_t result[] = {event.address, event.value, event.pc, event.instruction};
    std::copy(std::begin(result), std::end(result), values);
}

std::size_t courier_c5x_get_pc_trace_count(void *handle)
{
    return handle ? static_cast<C5xCore *>(handle)->pc_trace().size() : 0;
}

void courier_c5x_set_pc_capture(void *handle, uint16_t pc, const uint16_t *addresses, std::size_t count)
{
    if (!handle || count > 256 || (count && !addresses)) return;
    std::vector<uint16_t> selected;
    if (count) selected.assign(addresses, addresses + count);
    static_cast<C5xCore *>(handle)->set_pc_capture(pc, selected);
}

std::size_t courier_c5x_get_pc_capture_count(void *handle)
{
    return handle ? static_cast<C5xCore *>(handle)->pc_captures().size() : 0;
}

std::size_t courier_c5x_get_pc_capture(void *handle, std::size_t index, uint64_t *values, std::size_t count)
{
    if (!handle || !values) return 0;
    const auto &captures = static_cast<C5xCore *>(handle)->pc_captures();
    if (index >= captures.size()) return 0;
    const auto &capture = captures[index];
    const auto copied = std::min(count, capture.size());
    std::copy_n(capture.begin(), copied, values);
    return copied;
}

void courier_c5x_clear_pc_captures(void *handle)
{
    if (handle) static_cast<C5xCore *>(handle)->clear_pc_captures();
}

void courier_c5x_clear_pc_trace(void *handle)
{
    if (handle) static_cast<C5xCore *>(handle)->clear_pc_trace();
}

void courier_c5x_get_pc_trace(void *handle, std::size_t index, uint64_t *values, std::size_t count)
{
    if (!handle || !values || count < 2) return;
    const auto &trace = static_cast<C5xCore *>(handle)->pc_trace();
    if (index >= trace.size()) return;
    values[0] = trace[index] >> 48;
    values[1] = (trace[index] >> 32) & 0xffff;
    if (count >= 3) values[2] = trace[index] & 0xffffffff;
}

void courier_c5x_get_serial_state(void *handle, uint64_t *values, std::size_t count)
{
    if (!handle || !values || count < 65) return;
    auto serial = static_cast<C5xCore *>(handle)->serial_state();
    uint64_t result[] = {
        serial.drr, serial.dxr, serial.spc,
        serial.drr_reads, serial.dxr_writes, serial.spc_writes,
        serial.rx_consumed, serial.rx_queued,
        serial.codec_rx_consumed, serial.codec_rx_queued,
        serial.last_drr_pc, serial.last_dxr_pc, serial.last_spc_pc,
        serial.trcv, serial.tdxr, serial.tspc,
        serial.trcv_reads, serial.tdxr_writes, serial.tspc_writes,
        serial.last_trcv_pc, serial.last_tdxr_pc, serial.last_tspc_pc,
        serial.line_tx_writes, serial.line_tx_nonzero, serial.line_frame_interrupts,
        serial.serial_frame_suppressed,
        serial.shadow_dp,
        serial.last_dp_pc, serial.last_dp_value, serial.last_dp_source,
        serial.stray_cala_pc, serial.stray_cala_target, serial.stray_cala_dp,
        serial.line_dac_writes, serial.line_dac_frames,
        serial.line_tx_last, serial.line_tx_last_pc, serial.imr,
        serial.v8_rx_state, serial.v8_rx_peak, serial.codec_rx_peak,
        serial.negotiation_loop_entries, serial.negotiation_loop_pc, serial.negotiation_source, serial.negotiation_pair,
        serial.negotiation_source_value, serial.negotiation_pair_value,
        uint32_t(serial.negotiation_acc),
        serial.v8_dispatches, serial.v8_record, serial.v8_handler,
        serial.v8_countdown, serial.v8_flags, serial.v8_dispatch_pc,
        serial.v8_dispatch_dp,
        serial.negotiation_d76, serial.negotiation_d77,
        serial.negotiation_d78, serial.negotiation_d79,
        serial.negotiation_d26, serial.negotiation_indx,
        serial.negotiation_arp, serial.negotiation_pm,
        serial.hybrid_frames, serial.hybrid_peak,
    };
    std::copy(std::begin(result), std::end(result), values);
}

} // extern "C"

extern "C" void courier_c5x_configure_rom_codec(void *handle, int enabled)
{
    if (handle) static_cast<C5xCore *>(handle)->configure_rom_codec(enabled != 0);
}

extern "C" void courier_c5x_configure_si3034_codec(void *handle)
{
    if (handle) static_cast<C5xCore *>(handle)->configure_si3034_codec();
}

extern "C" void courier_c5x_set_si3034_line(void *handle, int connected, int off_hook, int ringing)
{
    if (handle) static_cast<C5xCore *>(handle)->set_si3034_line(connected != 0, off_hook != 0, ringing != 0);
}

extern "C" void courier_c5x_get_codec_registers(void *handle, uint16_t *values, std::size_t count)
{
    if (!handle || !values) return;
    for (std::size_t index = 0; index < std::min(count, std::size_t(32)); ++index)
        values[index] = static_cast<C5xCore *>(handle)->codec_register(unsigned(index));
}

extern "C" void courier_c5x_set_codec_mclk(void *handle, uint32_t hz)
{
    if (handle) static_cast<C5xCore *>(handle)->set_codec_mclk(hz);
}

extern "C" void courier_c5x_get_codec_state(void *handle, uint64_t *values, std::size_t count)
{
    if (!handle || !values || count < 36) return;
    auto codec = static_cast<C5xCore *>(handle)->codec_state();
    uint64_t result[] = {
        codec.registers[0], codec.registers[1], codec.registers[2],
        codec.registers[3], codec.registers[4], codec.registers[5],
        codec.registers[6], codec.registers[7], codec.registers[8],
        codec.mclk_hz, codec.sample_rate_millihz, codec.frame_period,
        codec.secondary_frames, codec.register_writes, codec.register_reads,
        codec.phase_shifts, codec.primary_frames, codec.frames_clocked,
        codec.last_control_word,
        codec.rate_programmed, codec.secondary_pending, codec.force_secondary,
        codec.free_run, codec.high_pass_enabled, codec.loopback,
        codec.sixteen_bit, codec.input_gain, codec.output_gain,
        codec.monitor_gain, codec.input_select,
        codec.codec_rx_size, codec.line_frame_next_cycle, codec.cycles,
        uint64_t(int64_t(codec.line_frame_irq)), codec.rx_empty_frames,
    };
    std::copy(std::begin(result), std::end(result), values);
}

// ---- the B-channel path (bearer.hpp); see native_bearer.py for the Python side ----

using courier::Bearer;

extern "C" {

void *courier_bearer_create() { return new Bearer(); }
void courier_bearer_destroy(void *handle) { delete static_cast<Bearer *>(handle); }

// Streams: kind 0 = rx queue (channel 0/1), 1 = tx, 2 = heard, 3 = pcm_tx (channel ignored).
std::size_t courier_bearer_length(void *handle, int kind, int channel)
{
    auto *b = static_cast<Bearer *>(handle);
    switch (kind) {
    case 0: return b->rx[channel].size();
    case 1: return b->tx[channel].size();
    case 2: return b->heard[channel].size();
    default: return b->pcm_tx.size();
    }
}

// Copy [start, stop) of a tx/heard/pcm stream, or of the rx queue, to `out`.
std::size_t courier_bearer_read(void *handle, int kind, int channel,
    std::size_t start, std::size_t stop, uint8_t *out)
{
    auto *b = static_cast<Bearer *>(handle);
    if (kind == 0) {
        const auto &queue = b->rx[channel];
        stop = std::min(stop, queue.size());
        for (std::size_t index = start; index < stop; ++index) *out++ = queue[index];
        return stop > start ? stop - start : 0;
    }
    const std::vector<uint8_t> &stream =
        kind == 1 ? b->tx[channel] : kind == 2 ? b->heard[channel] : b->pcm_tx;
    stop = std::min(stop, stream.size());
    if (start >= stop) return 0;
    std::memcpy(out, stream.data() + start, stop - start);
    return stop - start;
}

// The stream's length, and a copy of everything from `start` on (up to `capacity`).
std::size_t courier_bearer_tail(void *handle, int kind, int channel,
    std::size_t start, uint8_t *out, std::size_t capacity)
{
    auto *b = static_cast<Bearer *>(handle);
    const std::vector<uint8_t> &stream =
        kind == 1 ? b->tx[channel] : kind == 2 ? b->heard[channel] : b->pcm_tx;
    const std::size_t total = stream.size();
    if (start < total)
        std::memcpy(out, stream.data() + start, std::min(total - start, capacity));
    return total;
}

void courier_bearer_append(void *handle, int kind, int channel,
    const uint8_t *data, std::size_t count)
{
    auto *b = static_cast<Bearer *>(handle);
    switch (kind) {
    case 0: b->rx[channel].insert(b->rx[channel].end(), data, data + count); break;
    case 1: b->tx[channel].insert(b->tx[channel].end(), data, data + count); break;
    case 2: b->heard[channel].insert(b->heard[channel].end(), data, data + count); break;
    default: b->pcm_tx.insert(b->pcm_tx.end(), data, data + count); break;
    }
}

// rx queue: pop the front (returns -1 when empty) or push to the front.
int courier_bearer_rx_popleft(void *handle, int channel)
{
    auto &queue = static_cast<Bearer *>(handle)->rx[channel];
    if (queue.empty()) return -1;
    const int value = queue.front();
    queue.pop_front();
    return value;
}
void courier_bearer_rx_appendleft(void *handle, int channel, int value)
{
    static_cast<Bearer *>(handle)->rx[channel].push_front(uint8_t(value));
}
void courier_bearer_rx_clear(void *handle, int channel)
{
    static_cast<Bearer *>(handle)->rx[channel].clear();
}

// Scalars: 0 routed[0], 1 routed[1], 2 frames, 3 fed[0], 4 fed[1].
uint64_t courier_bearer_get(void *handle, int which)
{
    auto *b = static_cast<Bearer *>(handle);
    switch (which) {
    case 0: return b->routed[0];
    case 1: return b->routed[1];
    case 2: return b->frames;
    case 3: return b->fed[0];
    default: return b->fed[1];
    }
}
void courier_bearer_set(void *handle, int which, uint64_t value)
{
    auto *b = static_cast<Bearer *>(handle);
    switch (which) {
    case 0: b->routed[0] = value; break;
    case 1: b->routed[1] = value; break;
    case 2: b->frames = value; break;
    case 3: b->fed[0] = value != 0; break;
    default: b->fed[1] = value != 0; break;
    }
}

void courier_bearer_configure(void *handle, int activated, unsigned route_count,
    const uint8_t *routes, const uint8_t *slots, uint64_t generation)
{
    auto *b = static_cast<Bearer *>(handle);
    b->activated = activated != 0;
    b->route_count = std::min(route_count, 3u);
    for (unsigned index = 0; index < b->route_count; ++index) {
        b->routes[index][0] = routes[2 * index];
        b->routes[index][1] = routes[2 * index + 1];
    }
    for (unsigned index = 0; index < courier::BEARER_SLOTS; ++index) b->slot[index] = slots[index];
    b->generation = generation;
}

void courier_bearer_set_mode(void *handle, uint32_t channels, int frame_service,
    unsigned lookahead_frames)
{
    auto *b = static_cast<Bearer *>(handle);
    b->channels = channels;
    b->frame_service = frame_service != 0;
    b->lookahead_frames = lookahead_frames;
}

std::size_t courier_bearer_ahead_count(void *handle)
{
    return static_cast<Bearer *>(handle)->ahead.size();
}
int courier_bearer_lookahead_valid(void *handle)
{
    return static_cast<Bearer *>(handle)->lookahead_valid() ? 1 : 0;
}
// Pop the oldest settled frame: in1, in2, taken, heard packed in a word.
// Returns -1 when none.
int64_t courier_bearer_ahead_popleft(void *handle)
{
    auto *b = static_cast<Bearer *>(handle);
    if (b->ahead.empty()) return -1;
    const auto entry = b->ahead.front();
    b->ahead.pop_front();
    return int64_t(entry.in[0]) | int64_t(entry.in[1]) << 8
        | int64_t(entry.taken) << 16 | int64_t(entry.heard) << 24;
}
void courier_bearer_ahead_clear(void *handle)
{
    static_cast<Bearer *>(handle)->ahead.clear();
}
void courier_bearer_cancel(void *handle, void *core)
{
    static_cast<Bearer *>(handle)->cancel_lookahead(static_cast<C5xCore *>(core));
}
void courier_bearer_prefeed(void *handle, void *core)
{
    static_cast<Bearer *>(handle)->prefeed(static_cast<C5xCore *>(core));
}
// Settle what the C5x transmitted; returns how many octets are left in
// `remainder` for the harness (0: all done).
std::size_t courier_bearer_exchange(void *handle, void *core, const uint8_t *octets,
    std::size_t count, uint8_t *remainder)
{
    return static_cast<Bearer *>(handle)->exchange(
        static_cast<C5xCore *>(core), octets, count, remainder);
}
std::size_t courier_bearer_partial(void *handle, uint8_t *out)
{
    auto *b = static_cast<Bearer *>(handle);
    if (!b->partial_valid) return 0;
    *out = b->partial;
    return 1;
}
void courier_bearer_set_partial(void *handle, const uint8_t *data, std::size_t count)
{
    auto *b = static_cast<Bearer *>(handle);
    b->partial_valid = count != 0;
    if (count) b->partial = data[count - 1];
}

}  // extern "C"
