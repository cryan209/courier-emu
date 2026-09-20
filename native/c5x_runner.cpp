// SPDX-License-Identifier: BSD-3-Clause
#include "c5x_core.h"

#include <cerrno>
#include <cstdlib>
#include <deque>
#include <array>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <set>
#include <sstream>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

namespace {

uint64_t number(const char *text)
{
    char *end = nullptr;
    errno = 0;
    auto value = std::strtoull(text, &end, 0);
    if (errno || !end || *end) throw std::runtime_error(std::string("invalid number: ") + text);
    return value;
}

std::string hex16(uint16_t value)
{
    std::ostringstream out;
    out << std::hex << std::setfill('0') << std::setw(4) << value;
    return out.str();
}

std::string escape_json(const std::string &input)
{
    std::ostringstream out;
    for (unsigned char ch : input) {
        switch (ch) {
        case '\\': out << "\\\\"; break; case '"': out << "\\\""; break;
        case '\n': out << "\\n"; break; case '\r': out << "\\r"; break;
        case '\t': out << "\\t"; break;
        default: if (ch >= 0x20) out << ch;
        }
    }
    return out.str();
}

} // namespace

int main(int argc, char **argv)
{
    try {
        if (argc < 2) throw std::runtime_error(
            "usage: c5x_runner IMAGE [--offset N] [--bytes N] [--instructions N] [--trace N]");
        std::string path = argv[1];
        auto model = courier::C5xCore::Model::C51;
        // The image's own supervisor names every segment, so the caller
        // passes them in as --segment OFFSET:BYTES:ORIGIN. Nothing here knows
        // a layout: 2.1/2.2 load at 8000 and up, 2.3 at 0000..7fff, and a
        // default recovered from either one mislocates the other.
        std::vector<std::array<uint64_t, 3>> segments;
        uint64_t limit = 1'000'000, trace_start = 0, trace_count = 0;
        uint64_t force_pc_after = UINT64_MAX;
        uint16_t force_pc = 0;
        std::vector<std::pair<uint16_t, uint16_t>> seeded_ports;
        for (int i = 2; i < argc; ++i) {
            std::string option = argv[i];
            if (i + 1 >= argc) throw std::runtime_error("missing value for " + option);
            const char *argument = argv[++i];
            if (option == "--model") {
                const std::string name = argument;
                if (name == "c51") model = courier::C5xCore::Model::C51;
                else if (name == "c53") model = courier::C5xCore::Model::C53;
                else throw std::runtime_error("unsupported DSP model: " + name);
                continue;
            }
            if (option == "--port") {
                std::string assignment = argument;
                auto separator = assignment.find('=');
                if (separator == std::string::npos) throw std::runtime_error("port must be PORT=VALUE");
                auto port = number(assignment.substr(0, separator).c_str());
                auto port_value = number(assignment.substr(separator + 1).c_str());
                if (port > 0xffff || port_value > 0xffff) throw std::runtime_error("port assignment exceeds 16 bits");
                seeded_ports.emplace_back(uint16_t(port), uint16_t(port_value));
                continue;
            }
            if (option == "--segment") {
                std::string field = argument;
                auto first = field.find(':');
                auto second = field.find(':', first == std::string::npos ? first : first + 1);
                if (first == std::string::npos || second == std::string::npos)
                    throw std::runtime_error("segment must be OFFSET:BYTES:ORIGIN");
                auto segment_offset = number(field.substr(0, first).c_str());
                auto segment_bytes = number(field.substr(first + 1, second - first - 1).c_str());
                auto segment_origin = number(field.substr(second + 1).c_str());
                if (segment_bytes & 1) throw std::runtime_error("DSP byte count must be even");
                if (segment_bytes / 2 > 65536) throw std::runtime_error("DSP image exceeds 64K words");
                if (segment_origin > 0xffff) throw std::runtime_error("segment origin exceeds 16 bits");
                segments.push_back({segment_offset, segment_bytes, segment_origin});
                continue;
            }
            uint64_t value = number(argument);
            if (option == "--instructions") limit = value;
            else if (option == "--trace-start") trace_start = value;
            else if (option == "--trace") trace_count = value;
            else if (option == "--force-pc") {
                if (value > 0xffff) throw std::runtime_error("forced PC exceeds 16 bits");
                force_pc = uint16_t(value);
            }
            else if (option == "--force-pc-after") force_pc_after = value;
            else throw std::runtime_error("unknown option: " + option);
        }
        if (segments.empty()) throw std::runtime_error("no --segment given");

        std::ifstream input(path, std::ios::binary);
        if (!input) throw std::runtime_error("cannot open image: " + path);
        input.seekg(0, std::ios::end);
        uint64_t size = uint64_t(input.tellg());

        courier::C5xCore core(model);
        // Segments are loaded in the order given and the part enters the
        // first. Overlays land over the top of resident code, so pass one only
        // when that is the state being probed: at reset the board has
        // downloaded the resident and nothing else.
        for (const auto &segment : segments) {
            auto [segment_offset, segment_bytes, segment_origin] = segment;
            if (segment_offset + segment_bytes > size)
                throw std::runtime_error("DSP range is outside image");
            input.seekg(std::streamoff(segment_offset));
            std::vector<unsigned char> bytes(segment_bytes);
            input.read(reinterpret_cast<char *>(bytes.data()), std::streamsize(bytes.size()));
            if (!input) throw std::runtime_error("short read from image");
            std::vector<uint16_t> words(segment_bytes / 2);
            for (std::size_t i = 0; i < words.size(); ++i)
                words[i] = uint16_t(bytes[i * 2] | (uint16_t(bytes[i * 2 + 1]) << 8));
            core.load_program(words.data(), words.size(), uint16_t(segment_origin));
        }
        core.set_pc(uint16_t(segments.front()[2]));
        for (auto [port, value] : seeded_ports) core.set_io(port, value);
        std::deque<uint16_t> recent;
        std::string status = "instruction-limit", error;
        uint64_t executed = 0;
        for (; executed < limit; ++executed) {
            if (executed == force_pc_after) core.set_pc(force_pc);
            auto before = core.state();
            if (executed >= trace_start && executed < trace_start + trace_count)
                std::cerr << std::dec << executed << " pc=" << hex16(before.pc)
                          << " op=" << hex16(core.program(before.pc))
                          << " acc=" << std::hex << uint32_t(before.acc) << '\n';
            try { core.step(); }
            catch (const std::exception &exception) { status = "unsupported-opcode"; error = exception.what(); break; }
            auto after = core.state();
            recent.push_back(after.pc);
            if (recent.size() > 4096) recent.pop_front();
            if (after.idle) { status = "idle"; ++executed; break; }
            if (recent.size() == 4096 && executed > 10'000 && (executed & 0xff) == 0) {
                std::set<uint16_t> unique(recent.begin(), recent.end());
                if (unique.size() <= 256) { status = "stable-loop"; ++executed; break; }
            }
        }
        auto state = core.state();
        std::set<uint16_t> loop_pcs(recent.begin(), recent.end());
        std::cout << "{\n"
                  << "  \"status\": \"" << status << "\",\n"
                  << "  \"error\": \"" << escape_json(error) << "\",\n"
                  << "  \"resident_offset\": " << segments.front()[0] << ",\n"
                  << "  \"resident_bytes\": " << segments.front()[1] << ",\n"
                  << "  \"resident_origin\": \"" << hex16(uint16_t(segments.front()[2])) << "\",\n"
                  << "  \"segments\": " << segments.size() << ",\n"
                  << "  \"instructions\": " << state.instructions << ",\n"
                  << "  \"cycles\": " << state.cycles << ",\n"
                  << "  \"pc\": \"" << hex16(state.pc) << "\",\n"
                  << "  \"op\": \"" << hex16(state.op) << "\",\n"
                  << "  \"acc\": " << state.acc << ",\n"
                  << "  \"accb\": " << state.accb << ",\n"
                  << "  \"preg\": " << state.preg << ",\n"
                  << "  \"dp\": " << state.dp << ",\n"
                  << "  \"arp\": " << state.arp << ",\n"
                  << "  \"flags\": " << state.flags << ",\n"
                  << "  \"io_events\": " << core.io_events().size() << ",\n"
                  << "  \"recent_unique_pcs\": " << loop_pcs.size() << ",\n"
                  << "  \"loop_pcs\": [";
        bool first = true;
        if (loop_pcs.size() <= 32)
            for (uint16_t pc : loop_pcs) { if (!first) std::cout << ", "; first = false; std::cout << '"' << hex16(pc) << '"'; }
        std::cout << "]\n}\n";
        return 0;
    } catch (const std::exception &exception) {
        std::cerr << "c5x_runner: " << exception.what() << '\n';
        return 2;
    }
}
