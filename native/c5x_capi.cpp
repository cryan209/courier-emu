// SPDX-License-Identifier: BSD-3-Clause
#include "c5x_core.h"

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <exception>

using courier::C5xCore;

namespace {
void copy_error(char *buffer, std::size_t size, const char *message)
{
    if (!buffer || !size) return;
    std::strncpy(buffer, message, size - 1);
    buffer[size - 1] = '\0';
}
}

extern "C" {

void *courier_c5x_create()
{
    try { return new C5xCore(); } catch (...) { return nullptr; }
}

void courier_c5x_destroy(void *handle) { delete static_cast<C5xCore *>(handle); }

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

void courier_c5x_set_mpmc_pin(void *handle, int level)
{
    if (handle) static_cast<C5xCore *>(handle)->set_mpmc_pin(uint16_t(level));
}

void courier_c5x_get_memory_map(void *handle, uint64_t *values, std::size_t count)
{
    if (!handle || !values || count < 18) return;
    auto map = static_cast<C5xCore *>(handle)->memory_map();
    uint64_t result[] = {
        map.mpmc_pin, map.mpmc, map.ovly, map.ram, map.cnf, map.iptr,
        map.pdwsr, map.iowsr, map.cwsr, map.rom_present ? 1u : 0u,
        map.program_rom, map.program_daram, map.program_external,
        map.data_registers, map.data_daram, map.data_reserved,
        map.data_external, map.rom_holes,
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

void courier_c5x_set_io(void *handle, uint16_t port, uint16_t value)
{
    if (handle) static_cast<C5xCore *>(handle)->set_io(port, value);
}

void courier_c5x_host_write(void *handle, uint16_t address, uint16_t value)
{
    if (handle) static_cast<C5xCore *>(handle)->host_write(address, value);
}

void courier_c5x_queue_serial_rx(void *handle, const uint16_t *samples, std::size_t count)
{
    if (handle && samples) static_cast<C5xCore *>(handle)->queue_serial_rx(samples, count);
}

void courier_c5x_queue_codec_rx(void *handle, const uint16_t *samples, std::size_t count)
{
    if (handle && samples) static_cast<C5xCore *>(handle)->queue_codec_rx(samples, count);
}

void courier_c5x_set_dtmf_digits(void *handle, const char *digits, std::size_t count)
{
    if (handle && digits) static_cast<C5xCore *>(handle)->set_dtmf_digits(digits, count);
}

void courier_c5x_set_v8_calling(void *handle, int enabled)
{
    if (handle) static_cast<C5xCore *>(handle)->set_v8_calling(enabled != 0);
}

void courier_c5x_set_v8_answering(void *handle, int enabled)
{
    if (handle) static_cast<C5xCore *>(handle)->set_v8_answering(enabled != 0);
}

void courier_c5x_set_bio_low(void *handle, int enabled)
{
    if (handle) static_cast<C5xCore *>(handle)->set_bio_low(enabled != 0);
}

uint16_t courier_c5x_get_io(void *handle, uint16_t port)
{
    return handle ? static_cast<C5xCore *>(handle)->io(port) : 0xffff;
}

uint16_t courier_c5x_get_data(void *handle, uint16_t address)
{
    return handle ? static_cast<C5xCore *>(handle)->data(address) : 0xffff;
}

void courier_c5x_set_data(void *handle, uint16_t address, uint16_t value)
{
    if (handle) static_cast<C5xCore *>(handle)->set_data(address, value);
}

void courier_c5x_interrupt(void *handle, unsigned irq)
{
    if (handle) static_cast<C5xCore *>(handle)->interrupt(irq);
}

void courier_c5x_configure_line_frame_interrupt(void *handle, unsigned irq, uint16_t vector)
{
    if (handle) static_cast<C5xCore *>(handle)->configure_line_frame_interrupt(irq, vector);
}

void courier_c5x_set_call_tdm_active(void *handle, int active)
{
    if (handle) static_cast<C5xCore *>(handle)->set_call_tdm_active(active != 0);
}

void courier_c5x_schedule_line_frame_entry(void *handle, uint16_t address)
{
    if (handle) static_cast<C5xCore *>(handle)->schedule_line_frame_entry(address);
}

void courier_c5x_set_pc(void *handle, uint16_t address)
{
    if (handle) static_cast<C5xCore *>(handle)->set_pc(address);
}

void courier_c5x_get_state(void *handle, uint64_t *values, std::size_t count)
{
    if (!handle || !values || count < 20) return;
    auto state = static_cast<C5xCore *>(handle)->state();
    uint64_t result[] = {
        state.pc, state.op, uint32_t(state.acc), uint32_t(state.accb), uint32_t(state.preg),
        state.dp, state.arp, state.flags, state.idle ? 1u : 0u,
        state.instructions, state.cycles,
        static_cast<C5xCore *>(handle)->io_events().size(),
        state.ar[0], state.ar[1], state.ar[2], state.ar[3],
        state.ar[4], state.ar[5], state.ar[6], state.ar[7],
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
    uint64_t reads = 0, writes = 0, last_read = 0, last_write = 0;
    uint64_t last_read_pc = 0, last_write_pc = 0;
    for (const auto &event : static_cast<C5xCore *>(handle)->io_events()) {
        if (event.port != port) continue;
        if (event.write) {
            ++writes; last_write = event.value; last_write_pc = event.pc;
        } else {
            ++reads; last_read = event.value; last_read_pc = event.pc;
        }
    }
    uint64_t result[] = {
        reads, writes, last_read, last_write, last_read_pc, last_write_pc,
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

uint16_t courier_c5x_get_line_tx_sample(void *handle, std::size_t index)
{
    if (!handle) return 0;
    const auto &samples = static_cast<C5xCore *>(handle)->line_tx_samples();
    return index < samples.size() ? samples[index] : 0;
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

void courier_c5x_get_pc_trace(void *handle, std::size_t index, uint64_t *values, std::size_t count)
{
    if (!handle || !values || count < 2) return;
    const auto &trace = static_cast<C5xCore *>(handle)->pc_trace();
    if (index >= trace.size()) return;
    values[0] = trace[index] >> 16;
    values[1] = trace[index] & 0xffff;
}

void courier_c5x_get_serial_state(void *handle, uint64_t *values, std::size_t count)
{
    if (!handle || !values || count < 28) return;
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
        serial.line_tx_last, serial.line_tx_last_pc, serial.imr,
    };
    std::copy(std::begin(result), std::end(result), values);
}

} // extern "C"
