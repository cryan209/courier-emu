/* Manual semantic lift of selected 3453C 2.3.33 DSP routines.
 * Not recovered source and not a complete standalone modem implementation.
 * Program PCs are word addresses. Overlay identity is part of each address.
 * d[] models DSP data memory; program memory is a separate address space.
 * Names describe observed effects unless explicitly marked as inferred.
 */
#include <stdint.h>
#include <stdbool.h>

enum {
    PCM_FLAGS = 0x7fe8, PCM_FLAGS_2 = 0x7fe9,
    PCM_RATE_MASK = 0x7fea, X2_CAPABILITY = 0x7feb,
    BASE_CAPABILITY = 0x7fec, PCM_STATUS = 0x7fee
};

/* Low overlay 7, 08f8..090a. Entry: DP=0, ARP=1, value at d[007a].
 * Flags are assigned, whereas status bit 0 is ORed into existing status.
 */
void x2_tag70(uint16_t d[65536], uint16_t value)
{
    d[X2_CAPABILITY] = (value | 0x4000u) & 0x7fffu;
    d[PCM_FLAGS] = 0x8000u;
    d[PCM_STATUS] |= 1u;
}

/* Low overlay 7, 090b..0911; role/rate interpretation comes from older code. */
void pcm_tag71(uint16_t d[65536], uint16_t value)
{
    d[PCM_RATE_MASK] = value & 0x7fffu;
}

/* Adjacent shared handlers: keep raw addresses where semantics are unknown. */
void pcm_tag72(uint16_t d[65536], uint16_t value) /* 0921..0923 */
{
    d[0x7fbc] = value;
}
void pcm_tag74(uint16_t d[65536]) /* 091c..0920; overwrites mailbox scratch */
{
    d[0x007a] = 1;
    d[0x77c9] = 1;
}
void pcm_tag76(uint16_t d[65536], uint16_t value) /* 0912..0918 */
{
    d[0x77c7] = value & 0x003fu;
}
void pcm_tag77(uint16_t d[65536], uint16_t value) /* 0919..091b */
{
    d[0x77c8] = value;
}

/* Resident 12c0..12c7. Signed guard models SUB #87 / RETC GT.
 * Intended inputs are mailbox tags 00..87; other words are not valid tags.
 * Caller must load the overlay containing the returned handler before use.
 */
bool mailbox_target(const uint16_t program[65536], uint16_t tag,
                    uint16_t *target)
{
    if ((int16_t)(tag - 0x87u) > 0)
        return false;
    *target = program[(uint16_t)(0x1394u + tag - 0x87u)];
    return true;
}

/* Resident 5b17..5b20. The conditional block tests another bit, but ADD #02
 * itself is unconditional inside that block. No second test gates the add.
 * Returns the value passed to resident 112b; meaning of that value is open.
 */
uint16_t pcm_state_selector(const uint16_t d[65536])
{
    return (d[PCM_FLAGS] & 0x4000u) ? 0x0d02u : 0x0d00u;
}

/* Low overlay 7, 09a0..09a7: shared negotiation cleanup fragment. */
void pcm_clear_negotiation_bits(uint16_t d[65536])
{
    d[PCM_FLAGS_2] &= 0xffbfu;
    d[PCM_FLAGS] &= 0xfffdu;
}

/* Low overlay 7, 0e4f..0e68: shared peer/rate qualification fragment.
 * No protocol name is inferred for the raw peer capability bits.
 * BIT's printed operand is the actual bit index (no second inversion).
 */
void pcm_peer_qualification(uint16_t d[65536])
{
    uint16_t peer = d[0x7f00];
    if (!(peer & 0x1000u)) d[PCM_FLAGS] |= 0x0100u;
    int32_t margin = 0x4a00 - (((uint32_t)peer << 5) & 0x0f00u)
                           - (int16_t)d[0x7f26];
    d[PCM_FLAGS] &= 0xbfffu;
    if (margin > 0) d[PCM_FLAGS] |= 0x4000u;
}

/* Overlay 6, 1dc9..1dd8: observed initial capability operations.
 * A980 BLDD reads FROM the indirect address TO immediate address 7f00.
 * This entry uses BASE_CAPABILITY rather than X2_CAPABILITY.
 * This does not establish what a complete x2 call ultimately transmits.
 */
void pcm_initial_capability(uint16_t d[65536])
{
    d[0x006f] = 0x4042u;
    d[0x7f18] = d[BASE_CAPABILITY] >> 1;
    d[0x7f00] = d[0x7f18];
    d[0x7efb] = 0;
    d[0x7efc] = 0;
}

/* Equivalent bit-at-a-time lift of low overlay 7 scrambler 0890..08af
 * and descrambler 08b0..08cb. These are shared V.34/PCM routines.
 * Original implementation batches 1..9 LSB-first bits with shift/XOR ops.
 * Polynomial taps: 1+x^-18+x^-23 (GPC), 1+x^-5+x^-23 (GPA).
 */
uint16_t pcm_scrambler_bits(uint32_t *history, uint16_t value,
                            unsigned count, unsigned tap, bool receive)
{
    uint32_t state = *history & 0x7fffffu;
    uint16_t result = 0;
    for (unsigned bit = 0; bit < count; ++bit) {
        unsigned incoming = (value >> bit) & 1u;
        unsigned output = incoming ^ ((state >> (23u - tap)) & 1u)
                                   ^ (state & 1u);
        result |= (uint16_t)(output << bit);
        state = (state >> 1) | ((receive ? incoming : output) << 22);
    }
    *history = state;
    return result;
}

/* Entry precondition: DP=6; widths must be 1..9 and mask=(1<<width)-1.
 * GPA/GPC role selection is by absolute d[006f], not a DP-relative cell.
 */
void pcm_scramble_batch(uint16_t d[65536]) /* low overlay 7, 0890 */
{
    uint32_t state = ((uint32_t)d[0x0358] << 16) | d[0x0359];
    unsigned tap = (d[0x006f] & 1u) ? 5u : 18u;
    d[0x0350] = pcm_scrambler_bits(&state, d[0x0350], d[0x0352], tap, false);
    d[0x0358] = (uint16_t)(state >> 16);
    d[0x0359] = (uint16_t)state;
}
void pcm_descramble_batch(uint16_t d[65536]) /* low overlay 7, 08b0 */
{
    uint32_t state = ((uint32_t)d[0x031e] << 16) | d[0x031f];
    unsigned tap = (d[0x006f] & 2u) ? 18u : 5u;
    d[0x0320] = pcm_scrambler_bits(&state, d[0x0320], d[0x0322], tap, true);
    d[0x031e] = (uint16_t)(state >> 16);
    d[0x031f] = (uint16_t)state;
}

/* Overlay 8, 6421..6432, called at 63fa with width 6 and mask 003f.
 * Byte-identical to x2-only ED2E..ED3F and Courier 4.03 F938..F949.
 * Generates GPC-scrambled binary ones; the named wire sequence is unknown.
 * Entry DP=6; equivalent recurrence, not a register-by-register translation.
 */
void pcm_training_ones(uint16_t d[65536])
{
    uint32_t state = ((uint32_t)d[0x0379] << 16) | d[0x037a];
    unsigned count = d[0x037e];
    d[0x037d] = pcm_scrambler_bits(&state, (uint16_t)((1u << count) - 1u),
                                  count, 18u, false);
    d[0x0379] = (uint16_t)(state >> 16);
    d[0x037a] = (uint16_t)state;
}
