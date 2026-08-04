// SPDX-License-Identifier: BSD-3-Clause
#include "c5x_core.h"

#include <cerrno>
#include <cstdlib>
#include <deque>
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
        uint64_t offset = 0x2f0, byte_count = 0xebb4;
        uint64_t overlay_offset = 0xeea4, overlay_byte_count = 0x135c;
        uint64_t high_offset = 0x10200, high_byte_count = 0xb3e0;
        uint64_t limit = 1'000'000, trace_start = 0, trace_count = 0;
        std::vector<std::pair<uint16_t, uint16_t>> seeded_ports;
        for (int i = 2; i < argc; ++i) {
            std::string option = argv[i];
            if (i + 1 >= argc) throw std::runtime_error("missing value for " + option);
            const char *argument = argv[++i];
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
            uint64_t value = number(argument);
            if (option == "--offset") offset = value;
            else if (option == "--bytes") byte_count = value;
            else if (option == "--overlay-offset") overlay_offset = value;
            else if (option == "--overlay-bytes") overlay_byte_count = value;
            else if (option == "--high-offset") high_offset = value;
            else if (option == "--high-bytes") high_byte_count = value;
            else if (option == "--instructions") limit = value;
            else if (option == "--trace-start") trace_start = value;
            else if (option == "--trace") trace_count = value;
            else throw std::runtime_error("unknown option: " + option);
        }
        if ((byte_count | overlay_byte_count | high_byte_count) & 1)
            throw std::runtime_error("DSP byte count must be even");
        if (byte_count / 2 > 65536) throw std::runtime_error("DSP image exceeds 64K words");

        std::ifstream input(path, std::ios::binary);
        if (!input) throw std::runtime_error("cannot open image: " + path);
        input.seekg(0, std::ios::end);
        uint64_t size = uint64_t(input.tellg());
        if (offset + byte_count > size || overlay_offset + overlay_byte_count > size ||
            high_offset + high_byte_count > size)
            throw std::runtime_error("DSP range is outside image");
        input.seekg(std::streamoff(offset));
        std::vector<unsigned char> bytes(byte_count);
        input.read(reinterpret_cast<char *>(bytes.data()), std::streamsize(bytes.size()));
        if (!input) throw std::runtime_error("short read from image");
        std::vector<uint16_t> words(byte_count / 2);
        for (std::size_t i = 0; i < words.size(); ++i)
            words[i] = uint16_t(bytes[i * 2] | (uint16_t(bytes[i * 2 + 1]) << 8));
        input.seekg(std::streamoff(overlay_offset));
        bytes.resize(overlay_byte_count);
        input.read(reinterpret_cast<char *>(bytes.data()), std::streamsize(bytes.size()));
        if (!input) throw std::runtime_error("short read from DSP overlay segment");
        std::vector<uint16_t> overlay_words(overlay_byte_count / 2);
        for (std::size_t i = 0; i < overlay_words.size(); ++i)
            overlay_words[i] = uint16_t(bytes[i * 2] | (uint16_t(bytes[i * 2 + 1]) << 8));
        input.seekg(std::streamoff(high_offset));
        bytes.resize(high_byte_count);
        input.read(reinterpret_cast<char *>(bytes.data()), std::streamsize(bytes.size()));
        if (!input) throw std::runtime_error("short read from high DSP segment");
        std::vector<uint16_t> high_words(high_byte_count / 2);
        for (std::size_t i = 0; i < high_words.size(); ++i)
            high_words[i] = uint16_t(bytes[i * 2] | (uint16_t(bytes[i * 2 + 1]) << 8));

        courier::C5xCore core;
        core.load_program(words.data(), words.size());
        core.load_program(overlay_words.data(), overlay_words.size(), 0xde83);
        core.load_program(high_words.data(), high_words.size(), 0x8000);
        for (auto [port, value] : seeded_ports) core.set_io(port, value);
        std::deque<uint16_t> recent;
        std::string status = "instruction-limit", error;
        uint64_t executed = 0;
        for (; executed < limit; ++executed) {
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
                  << "  \"loaded_offset\": " << offset << ",\n"
                  << "  \"loaded_bytes\": " << byte_count << ",\n"
                  << "  \"loaded_words\": " << words.size() << ",\n"
                  << "  \"overlay_loaded_offset\": " << overlay_offset << ",\n"
                  << "  \"overlay_loaded_words\": " << overlay_words.size() << ",\n"
                  << "  \"high_loaded_offset\": " << high_offset << ",\n"
                  << "  \"high_loaded_words\": " << high_words.size() << ",\n"
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
