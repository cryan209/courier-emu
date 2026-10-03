/* QF060003.NAC shared x2/V.90 server PCM helpers, separate from IM020104.
 * These are table/parameter helpers, not the complete downstream mapper.
 * Program and data address spaces are explicitly distinct.
 */
#include <stdint.h>

void quad_pcm_parameters(uint16_t d[65536]) /* c7ad..c7bf, DP=7 */
{
    unsigned flag = d[0xffd9] & 1u;
    d[0x03a3] = flag ? 0x002a : 0;
    d[0x03eb] = flag ? 0x0042 : 0;
    d[0x03ec] = flag ? 0 : 0x0108;
    d[0x03ea] = 0x007f;
}

void quad_pcm_codewords(const uint16_t program[65536], uint16_t d[65536],
                        uint16_t destination) /* c9bf..c9ca */
{
    uint16_t source = (d[0xffd9] & 4u) ? 0xc9d7 : 0xc9ce;
    for (unsigned i = 0; i < 9; ++i)
        d[(uint16_t)(destination+i)] = program[source+i];
}

uint16_t quad_pcm_selector(const uint16_t program[65536],
                            const uint16_t d[65536], unsigned kind)
{
    if (kind == 2) /* c9b6..c9be */
        return (d[0xffd9] & 4u) ? 0xcb00 : 0xcc2b;
    /* c994 or c9a5; tested submodes 0..2. Program-table addresses,
     * not callable mapper function pointers. */
    uint16_t base = kind ? 0xc9b0 : 0xc99f;
    uint16_t index = (uint16_t)(d[0x03e4]*2u + ((d[0xffd9] & 4u) ? 1u : 0u));
    return program[(uint16_t)(base+index)];
}
