// SPDX-License-Identifier: BSD-3-Clause
// The I-modem's B-channel path between its C5x and the line: the Am79C30's
// MUX queues (bearer_rx / bearer_tx in am79c30.py), the frames settled ahead
// of the DSP, and the exchange of a batch of transmitted frames. The Python
// containers it replaces are proxies onto this state (native_bearer.py), and
// the Python methods remain the reference: every operation here does what
// `Am79C30.bearer_take_ahead`, `bearer_finish_batch`, `bearer_return_ahead`
// and `ImodemDsp._sync_pcm`/`prefeed`/`cancel_lookahead` do.
#pragma once

#include <cstddef>
#include <cstdint>
#include <deque>
#include <vector>

#include "c5x_core.h"

namespace courier {

constexpr unsigned BEARER_SLOTS = 2;       // eight-bit slots per peripheral-port frame
constexpr uint8_t BEARER_IDLE = 0xff;

struct Bearer {
    // One frame settled ahead: what each B channel contributed, which of them
    // came out of the queue, and what the modem will have heard.
    struct Entry {
        uint8_t in[2];
        uint8_t taken;      // bit per channel popped from its queue
        uint8_t heard;      // bit per channel whose input is logged as heard
    };

    std::deque<uint8_t> rx[2];
    std::vector<uint8_t> tx[2], heard[2], pcm_tx;
    uint64_t routed[2] = {0, 0};
    uint64_t frames = 0;
    bool fed[2] = {false, false};
    bool partial_valid = false;
    uint8_t partial = 0;

    // Configuration the harness publishes whenever the routing changes.
    bool activated = false;
    unsigned route_count = 0;
    uint8_t routes[3][2] = {};
    uint8_t slot[BEARER_SLOTS] = {0, 0};   // logical port in each slot, 0: none
    uint64_t generation = 0;
    uint32_t channels = 0;                 // bit 0: B1 carries the call, bit 1: B2
    bool frame_service = false;            // a per-frame callback forbids batching
    unsigned lookahead_frames = 8;

    std::deque<Entry> ahead;
    uint64_t ahead_generation = 0;
    uint32_t ahead_channels = 0;

    bool channel_in(unsigned channel) const { return channels & (1u << (channel - 1)); }

    bool lookahead_valid() const
    {
        return ahead.empty()
            || (ahead_generation == generation && ahead_channels == channels);
    }

    // Bearer_take_ahead for up to `count` frames; the receive octets go to the
    // C5x's queue. Returns how many frames were taken.
    unsigned take_ahead(C5xCore *core, unsigned count)
    {
        if (!activated || !channels) return 0;
        for (unsigned index = 0; index < route_count; ++index) {
            const uint8_t left = routes[index][0], right = routes[index][1];
            if (left > 2 && right > 2) return 0;
        }
        std::vector<uint8_t> octets;
        unsigned taken_frames = 0;
        for (unsigned frame = 0; frame < count; ++frame) {
            bool stop = false;
            for (unsigned channel = 1; channel <= 2; ++channel)
                if (channel_in(channel) && rx[channel - 1].empty()) stop = true;
            if (stop) break;
            for (unsigned channel = 1; channel <= 2; ++channel)
                if (!channel_in(channel) && rx[channel - 1].empty() && fed[channel - 1])
                    stop = true;
            if (stop) break;
            Entry entry{{BEARER_IDLE, BEARER_IDLE}, 0, 0};
            for (unsigned channel = 1; channel <= 2; ++channel) {
                auto &queue = rx[channel - 1];
                if (!queue.empty()) {
                    entry.in[channel - 1] = queue.front();
                    queue.pop_front();
                    entry.taken |= uint8_t(1u << (channel - 1));
                }
                if (fed[channel - 1]) entry.heard |= uint8_t(1u << (channel - 1));
            }
            uint8_t outputs[9];
            for (auto &value : outputs) value = BEARER_IDLE;
            for (unsigned index = 0; index < route_count; ++index) {
                const uint8_t left = routes[index][0], right = routes[index][1];
                const uint8_t from_right = right <= 2 ? entry.in[right - 1] : BEARER_IDLE;
                const uint8_t from_left = left <= 2 ? entry.in[left - 1] : BEARER_IDLE;
                outputs[left] = from_right;
                outputs[right] = from_left;
            }
            for (unsigned position = 0; position < BEARER_SLOTS; ++position)
                octets.push_back(slot[position] ? outputs[slot[position]] : BEARER_IDLE);
            ahead.push_back(entry);
            ++taken_frames;
        }
        if (taken_frames) {
            ahead_generation = generation;
            ahead_channels = channels;
            core->queue_g711_rx(octets.data(), octets.size());
        }
        return taken_frames;
    }

    // ImodemDsp.cancel_lookahead: give back what was fed ahead.
    void cancel_lookahead(C5xCore *core)
    {
        if (ahead.empty()) return;
        if (core) core->drop_g711_rx_tail(BEARER_SLOTS * ahead.size());
        for (auto entry = ahead.rbegin(); entry != ahead.rend(); ++entry)
            for (unsigned channel = 1; channel <= 2; ++channel)
                if (entry->taken & (1u << (channel - 1)))
                    rx[channel - 1].push_front(entry->in[channel - 1]);
        ahead.clear();
    }

    // ImodemDsp.prefeed.
    void prefeed(C5xCore *core)
    {
        if (!core || !lookahead_frames) return;
        if (!ahead.empty() && !lookahead_valid()) cancel_lookahead(core);
        if (ahead.size() >= lookahead_frames) return;
        const unsigned want = lookahead_frames - unsigned(ahead.size());
        if (want * 2 < lookahead_frames) return;
        take_ahead(core, want);
    }

    // bearer_finish_batch for the first `count` entries of `ahead`, whose
    // transmitted octets are `octets` (BEARER_SLOTS per frame). False, with
    // nothing done, unless every route joins one B channel to one port.
    bool finish_batch(unsigned count, const uint8_t *octets)
    {
        if (!activated) return false;
        int carried[2] = {0, 0};
        bool ports[9] = {};
        for (unsigned index = 0; index < route_count; ++index) {
            uint8_t left = routes[index][0], right = routes[index][1];
            const uint8_t channel = left <= 2 ? left : right;
            const uint8_t port = left <= 2 ? right : left;
            if (channel > 2 || port <= 2 || carried[channel - 1] || ports[port]) return false;
            carried[channel - 1] = port;
            ports[port] = true;
        }
        for (unsigned channel = 1; channel <= 2; ++channel) {
            const int port = carried[channel - 1];
            int position = -1;
            if (port)
                for (unsigned index = 0; index < BEARER_SLOTS; ++index)
                    if (slot[index] == port) { position = int(index); break; }
            auto &stream = tx[channel - 1];
            if (position >= 0) {
                for (unsigned frame = 0; frame < count; ++frame)
                    stream.push_back(octets[frame * BEARER_SLOTS + unsigned(position)]);
                routed[channel - 1] += count;
            } else {
                stream.insert(stream.end(), count, BEARER_IDLE);
            }
        }
        for (unsigned channel = 1; channel <= 2; ++channel)
            for (unsigned frame = 0; frame < count; ++frame)
                if (ahead[frame].heard & (1u << (channel - 1)))
                    heard[channel - 1].push_back(ahead[frame].in[channel - 1]);
        frames += count;
        return true;
    }

    // `_route_bearer`: the MUX's outputs for one frame, and what B1/B2 sent.
    // `have[port]` says an input exists for that port; `peripheral[port]`
    // that the port is one of the slots carrying the modem's octets.
    void route_frame(const uint8_t *input, const bool *have, const bool *peripheral,
                     uint8_t *outputs)
    {
        for (unsigned port = 0; port < 9; ++port) outputs[port] = BEARER_IDLE;
        for (unsigned index = 0; index < route_count; ++index) {
            const uint8_t left = routes[index][0], right = routes[index][1];
            if (!activated && (left <= 2 || right <= 2)) continue;
            outputs[left] = have[right] ? input[right] : BEARER_IDLE;
            outputs[right] = have[left] ? input[left] : BEARER_IDLE;
            if (left <= 2 && peripheral[right]) ++routed[left - 1];
            if (right <= 2 && peripheral[left]) ++routed[right - 1];
        }
        tx[0].push_back(outputs[1]);
        tx[1].push_back(outputs[2]);
        ++frames;
    }

    bool channel_routed(unsigned channel) const
    {
        for (unsigned index = 0; index < route_count; ++index)
            if (routes[index][0] == channel || routes[index][1] == channel) return true;
        return false;
    }

    // `bearer_finish_frame`.
    void finish_frame(const Entry &entry, const uint8_t *sent)
    {
        for (unsigned channel = 1; channel <= 2; ++channel)
            if (entry.heard & (1u << (channel - 1)))
                heard[channel - 1].push_back(entry.in[channel - 1]);
        uint8_t input[9] = {};
        bool have[9] = {}, peripheral[9] = {};
        for (unsigned position = 0; position < BEARER_SLOTS; ++position)
            if (slot[position]) {
                input[slot[position]] = sent[position];
                have[slot[position]] = peripheral[slot[position]] = true;
            }
        input[1] = entry.in[0];
        input[2] = entry.in[1];
        have[1] = have[2] = true;
        uint8_t outputs[9];
        route_frame(input, have, peripheral, outputs);
    }

    // `clock_bearer` for one frame, queueing what the modem receives. False,
    // with nothing done, for a frame that would be an underrun: the Python
    // method keeps that count.
    bool clock_frame(const uint8_t *sent, std::vector<uint8_t> &incoming)
    {
        if (activated)
            for (unsigned channel = 1; channel <= 2; ++channel)
                if (rx[channel - 1].empty() && fed[channel - 1] && channel_routed(channel))
                    return false;
        uint8_t input[9] = {};
        bool have[9] = {}, peripheral[9] = {};
        for (unsigned position = 0; position < BEARER_SLOTS; ++position)
            if (slot[position]) {
                input[slot[position]] = sent[position];
                have[slot[position]] = peripheral[slot[position]] = true;
            }
        for (unsigned channel = 1; channel <= 2; ++channel) {
            auto &queue = rx[channel - 1];
            if (!queue.empty() && activated) {
                input[channel] = queue.front();
                queue.pop_front();
            } else {
                input[channel] = BEARER_IDLE;
            }
            have[channel] = true;
            if (activated && fed[channel - 1]) heard[channel - 1].push_back(input[channel]);
        }
        uint8_t outputs[9];
        route_frame(input, have, peripheral, outputs);
        for (unsigned position = 0; position < BEARER_SLOTS; ++position)
            incoming.push_back(slot[position] ? outputs[slot[position]] : BEARER_IDLE);
        return true;
    }

    // ImodemDsp._sync_pcm's exchange of what the C5x transmitted. Every frame
    // it can settle is settled here; it stops, leaving the rest to Python, at
    // a frame whose bookkeeping Python keeps (an underrun) or at once when a
    // per-frame callback has to run between frames. Returns how many octets
    // it left in `remainder` (0: everything done, any odd octet held over).
    std::size_t exchange(C5xCore *core, const uint8_t *octets, std::size_t count,
                         uint8_t *remainder)
    {
        pcm_tx.insert(pcm_tx.end(), octets, octets + count);
        std::vector<uint8_t> pending;
        if (partial_valid) pending.push_back(partial);
        pending.insert(pending.end(), octets, octets + count);
        partial_valid = false;
        const std::size_t frame_count = pending.size() / BEARER_SLOTS;
        std::size_t done = 0;
        if (!frame_service) {
            if (frame_count && ahead.size() >= frame_count
                && finish_batch(unsigned(frame_count), pending.data())) {
                for (; done < frame_count; ++done) ahead.pop_front();
            } else {
                std::vector<uint8_t> incoming;
                for (; done < frame_count; ++done) {
                    const uint8_t *sent = pending.data() + done * BEARER_SLOTS;
                    if (!ahead.empty()) {
                        finish_frame(ahead.front(), sent);
                        ahead.pop_front();
                    } else if (!clock_frame(sent, incoming)) {
                        break;
                    }
                }
                if (!incoming.empty()) core->queue_g711_rx(incoming.data(), incoming.size());
            }
        }
        const std::size_t used = done * BEARER_SLOTS;
        if (done == frame_count) {
            partial_valid = pending.size() > used;
            if (partial_valid) partial = pending.back();
            return 0;
        }
        std::copy(pending.begin() + used, pending.end(), remainder);
        return pending.size() - used;
    }
};

}  // namespace courier
