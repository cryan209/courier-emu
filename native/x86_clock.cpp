#include <capstone/capstone.h>
#include <unicorn/unicorn.h>

#include <cstdint>
#include <cstdio>
#include <memory>
#include <new>

struct CourierX86Clock {
    using Service = void (*)(uint64_t, uint64_t, void *);
    uc_engine *uc = nullptr;
    uc_hook hook = 0;
    csh capstone = 0;
    uint64_t instructions = 0;
    uint64_t next_service = 0;
    uint64_t last_service = 0;
    uint64_t quantum = 0;
    Service service = nullptr;
    void *service_data = nullptr;
    std::unique_ptr<uint8_t[]> block_counts;
    std::unique_ptr<uint16_t[]> block_sizes;
};

static void clock_block(uc_engine *uc, uint64_t address, uint32_t size,
                        void *user_data) {
    auto *clock = static_cast<CourierX86Clock *>(user_data);
    uint32_t count = 1;
    const uint32_t slot = static_cast<uint32_t>(address & 0xfffff);
    if (clock->block_counts[slot] != 0 && clock->block_sizes[slot] == size) {
        count = clock->block_counts[slot];
    } else {
        uint8_t bytes[256];
        if (size <= sizeof(bytes) && uc_mem_read(uc, address, bytes, size) == UC_ERR_OK) {
            cs_insn *decoded = nullptr;
            const size_t decoded_count =
                cs_disasm(clock->capstone, bytes, size, address, 0, &decoded);
            if (decoded_count != 0) {
                count = static_cast<uint32_t>(decoded_count);
            }
            cs_free(decoded, decoded_count);
        }
        clock->block_counts[slot] = static_cast<uint8_t>(count);
        clock->block_sizes[slot] = static_cast<uint16_t>(size);
    }
    clock->instructions += count;
    if (clock->instructions >= clock->next_service) {
        const uint64_t elapsed = clock->instructions - clock->last_service;
        clock->last_service = clock->instructions;
        clock->next_service = clock->instructions + clock->quantum;
        clock->service(clock->instructions, elapsed, clock->service_data);
    }
}

extern "C" void *courier_x86_clock_create(uc_engine *uc, uint64_t initial,
                                           uint64_t quantum,
                                           CourierX86Clock::Service service,
                                           void *service_data, char *error,
                                           size_t error_size) {
    auto *clock = new (std::nothrow) CourierX86Clock;
    if (clock == nullptr) {
        std::snprintf(error, error_size, "cannot allocate x86 clock");
        return nullptr;
    }
    clock->uc = uc;
    clock->block_counts.reset(new (std::nothrow) uint8_t[1u << 20]());
    clock->block_sizes.reset(new (std::nothrow) uint16_t[1u << 20]());
    if (!clock->block_counts || !clock->block_sizes) {
        std::snprintf(error, error_size, "cannot allocate x86 block cache");
        delete clock;
        return nullptr;
    }
    clock->instructions = initial;
    clock->last_service = initial;
    clock->quantum = quantum;
    clock->next_service = initial + quantum;
    clock->service = service;
    clock->service_data = service_data;
    if (service == nullptr) {
        std::snprintf(error, error_size, "native x86 clock needs a service callback");
        delete clock;
        return nullptr;
    }
    if (cs_open(CS_ARCH_X86, CS_MODE_16, &clock->capstone) != CS_ERR_OK) {
        std::snprintf(error, error_size, "cannot initialize Capstone x86 decoder");
        delete clock;
        return nullptr;
    }
    const uc_err result = uc_hook_add(uc, &clock->hook, UC_HOOK_BLOCK,
                                      reinterpret_cast<void *>(clock_block),
                                      clock, 1, 0);
    if (result != UC_ERR_OK) {
        std::snprintf(error, error_size, "cannot install Unicorn block hook: %s",
                      uc_strerror(result));
        cs_close(&clock->capstone);
        delete clock;
        return nullptr;
    }
    return clock;
}

extern "C" uint64_t courier_x86_clock_instructions(void *handle) {
    return static_cast<CourierX86Clock *>(handle)->instructions;
}

extern "C" void courier_x86_clock_destroy(void *handle) {
    auto *clock = static_cast<CourierX86Clock *>(handle);
    if (clock == nullptr) {
        return;
    }
    uc_hook_del(clock->uc, clock->hook);
    cs_close(&clock->capstone);
    delete clock;
}
