/* Manual C semantic reconstruction: first-x2 I-modem IM020104.NAC.
 * Not vendor source or a complete modem. DSP PCs are word addresses.
 * These server/symmetric routines also implement digital bearer modes;
 * a 7-bit DS0 word is not the analogue x2 six-symbol PCM rate ladder.
 */
#include <stdint.h>
#include <stdbool.h>

void server_tag70(uint16_t d[65536], uint16_t value) /* 91a1..91ad */
{
    d[0xffdb] = value & 0x3fffu;
    d[0xffd9] |= 0x8000u;
}
void server_tag71(uint16_t d[65536], uint16_t value) /* 91ae..91b0 */
{
    d[0xffda] = value;
}

/* e7e7..e7f1: reverse the low octet, discarding bits above bit 7. */
uint16_t server_reverse_octet(uint16_t value)
{
    uint16_t result = 0;
    for (unsigned bit = 0; bit < 8; ++bit)
        result |= ((value >> bit) & 1u) << (7 - bit);
    return result;
}

/* 927f..928b: choose the advertised capability and zero its work area.
 * Original then tail-calls the bitfield writer 9617 at offset 16.
 * Separate selection from that writer so its unresolved ABI stays visible.
 */
uint16_t server_select_capability(uint16_t d[65536])
{
    uint16_t value = d[(d[0x039f] & 0x1000u) ? 0xffdb : 0xffdc];
    d[0xfef0] = 0;
    d[0xfef1] = 0;
    return value;
}

/* 927f through tail-call 9617: actual two-word capability packing.
 * Entry DP=7, d[03fb]=1 (writer's unit mask); writes field at offset 16.
 * The word straddles the 17-bit INFO0 work buffer: low bit in fef1 bit 15,
 * remaining bits in fef0. With SXM=1, ADDT sign-extends the source; a base
 * capability with bit 15 set also sets the unused high bit of fef0.
 * This models data effects, not scratch registers.
 */
void server_pack_info0_capability(uint16_t d[65536])
{
    uint16_t value = server_select_capability(d);
    d[0xfef1] = (uint16_t)(value << 15);
    d[0xfef0] = (uint16_t)((int16_t)value >> 1);
}

/* e172..e179: actual control-flow destinations, not guessed protocol names.
 * A call to e822 is followed by e61d on return.
 */
uint16_t server_mode_family_target(uint16_t mode)
{
    if (mode & 4u) return 0xe60bu;
    if (mode & 2u) return 0xe822u;
    return 0xe61du;
}

/* e1d2..e202: asymmetric startup probe source. The state identifier is
 * the original function pointer at page+75; this preserves delayed RETD
 * writes. No claim is made about the receiver's interpretation or timing.
 */
uint16_t server_probe_word(uint16_t d[65536], uint16_t page)
{
    uint16_t old;
    switch (d[page+0x75]) {
    case 0xe1d2:
        if (--d[page+0x74] == 0) {
            d[page+0x74] = 7; d[page+0x75] = 0xe1dd;
        }
        return 0x7e;
    case 0xe1dd:
        if (--d[page+0x74] == 0) {
            d[page+0x73] = 0; d[page+0x74] = 0xff;
            d[page+0x75] = 0xe1ea;
        }
        return 0;
    case 0xe1ea:
        old = d[page+0x73]++;
        d[page+0x75] = 0xe1f2;
        return old;
    case 0xe1f2:
        old = d[page+0x74];
        if (--d[page+0x74] == 0x7f) {
            d[page+0x74] = 0x6d3; d[page+0x75] = 0xe1d2;
        } else d[page+0x75] = 0xe1ea;
        return old;
    default: return 0; /* outside the recovered four-state source */
    }
}

/* Equivalent recurrence of 8faa (GPC TX) and direct entry 8fe1 (GPC RX).
 * Each operates on its caller's DP page, not a fixed absolute state address.
 * Width 1..9; count determines a contiguous low-bit mask in these tests.
 */
static uint16_t shift_bits(uint32_t *history, uint16_t value,
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
void server_scramble(uint16_t d[65536], uint16_t page) /* 8faa */
{
    uint32_t state = ((uint32_t)d[page+0x58] << 16) | d[page+0x59];
    d[page] = shift_bits(&state, d[page], d[page+2], 18, false);
    d[page+0x58] = (uint16_t)(state >> 16);
    d[page+0x59] = (uint16_t)state;
}
void server_descramble(uint16_t d[65536], uint16_t page) /* 8fe1 */
{
    uint32_t state = ((uint32_t)d[page+0x1e] << 16) | d[page+0x1f];
    d[page+0x20] = shift_bits(&state, d[page+0x20], d[page+0x22], 18, true);
    d[page+0x1e] = (uint16_t)(state >> 16);
    d[page+0x1f] = (uint16_t)state;
}

/* e5e7..e60a: TX/RX width setup. Original LST restores two saved ST0
 * contexts; pass their DP bases explicitly (normal TX=0380, RX=0300).
 * Caller guarantees the saved pages and ARP context are valid.
 */
void server_width_setup(uint16_t d[65536], uint16_t tx, uint16_t rx)
{
    bool seven = (d[tx+0x60] & 1u) != 0;
    uint16_t width = seven ? 7 : 8;
    uint16_t mask = seven ? 0x7f : 0xff;
    d[tx+3] = 5;
    d[tx+4] = d[tx+5] = d[tx+0x58] = d[tx+0x59] = 0;
    d[tx+6] = 0x83c9;
    d[tx+1] = mask;
    d[tx+2] = width;
    d[rx+0x22] = width;
    d[rx+0x25] = d[rx+0x24] = d[rx+0x1e] = d[rx+0x1f] = 0;
    d[rx+0x71] = 0;
    d[rx+0x21] = mask;
    d[rx+0x26] = 0x84af;
}

/* e4d1..e4ef: fixed 7e training source with an LSB-first bit reservoir.
 * Valid states have width 7/8, buffered count <16 and reservoir consistent
 * with that count. Output includes upper reservoir bits, as the firmware
 * does; the transmit callback is responsible for masking the word.
 */
void server_training_word(uint16_t d[65536], uint16_t page)
{
    unsigned count = d[page+4];
    uint32_t reservoir = d[page+5];
    unsigned width = d[page+2];
    while (count < width) {
        reservoir |= 0x7eu << count;
        count += 8;
    }
    d[page+4] = (uint16_t)(count - width);
    d[page] = (uint16_t)reservoir;
    d[page+5] = (uint16_t)(reservoir >> width);
}

/* e65f..e67a: TX callback with the payload-source gate at [006f].2 CLOSED.
 * This makes 83c4 return immediately: the caller supplies d[0380] instead
 * of asking the supervisor's source state machine for new payload bits.
 * The following transform/write portion is original callback behavior.
 */
void server_transmit_preloaded(uint16_t d[65536], uint16_t sample_cell)
{
    uint16_t tx = 0x0380;
    d[tx] &= d[tx+1];
    if (d[tx+0x60] & 0x0200u) server_scramble(d, tx);
    if (d[0xffd9] & 0x8000u) d[tx] = server_reverse_octet(d[tx]);
    d[0xff01] = d[tx];
    d[0xff0c] = d[tx+2];
    d[sample_cell] = d[tx];
}

/* e67b..e691: RX callback with [006f].3 CLOSED so 847e does not dispatch
 * into the supervisor's byte-output buffer. Mask/reversal/descrambling are
 * verified here; delivery through the buffer state machine is separate.
 */
void server_receive_preloaded(uint16_t d[65536], uint16_t sample_cell)
{
    uint16_t value = d[sample_cell];
    d[0xff00] = value;
    if (d[0xffd9] & 0x8000u) value = server_reverse_octet(value);
    d[0x0320] = value & d[0x0321];
    if (d[0x03e0] & 0x0200u) server_descramble(d, 0x0300);
}
