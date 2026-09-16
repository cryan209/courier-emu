"""The 300 bps analogue loopback, run as the part runs it.

`courier_emu.fsk` drives the datapump from the middle: it puts its own driver
in the on-chip ROM window, enters the mixer at SAMPLE_BODY, forces the PC back
once per sample and pins the buffer limit at 0x390. That skips the part's mask
ROM, its cold start, and the per-buffer service block at 0x80bb, and no baud
rate measured that way is the firmware's.

Here nothing is forced after the entry:

* the mask ROM is mapped (`courier_emu.boot_rom`), so the interrupt vector
  table exists and `intr 17` reaches its handler at 0x81a6 through B2 RAM;
* the resident's cold start at 0x8000 runs, which sets PMST, copies the
  dispatch table to data 0x60, and primes @25/@26/@27/@56/@57/@7b;
* the mixer runs its own loop, so the service block executes and the bring-up
  state machine completes to `@6f = 008c` on its own;
* the frame interrupt is raised on IDLE, which is what the loop waits in, and
  the ISR owns the buffer.

What the harness supplies is what the board supplies: the codec loop, and the
host side of the character window.

**The DSP is a datapump, not a link layer.** It carries one bit per codec
frame in each direction - `@50` shifts once per modulator call, `@20` assembles
once per call - with three bits to a window word and no framing of its own. A
300 bps symbol therefore lives on the CPU side, which sends each bit
`span // 3` times and votes on what comes back. That is what `measure` does,
and it is the only place a baud rate appears.
"""
from __future__ import annotations

import struct

from . import boot_rom
from .dsp import NativeC5x

# The four dispatch entries whose receiver sits in the transmitter's own band.
ENTRY = {'v21-answer': 0xD7FC, 'v21-originate': 0xD808,
         'bell103-answer': 0xD7D8, 'bell103-originate': 0xD7E9}

DRIVER = 0xEF00                 # past the resident's last word at 0xeea6
COLD_START, COLD_PARK = 0x8000, 0x813C
LOOP_HEAD, SAMPLE_BODY = 0x80BB, 0x80C7
FRAME_IRQ = 5                   # vector 0x000c -> @65 -> 0x8178
DELIVERY_STORE = 0x832F         # just past 8320's `sacl *+, ar1`

TX_SHIFT, RX_ASSEMBLY = 0x3D0, 0x0320    # @50 on DP 7, @20 on DP 6
DELIVERY_VECTOR, FLAGS = 0x0326, 0x006F  # @26 on DP 6, and the flag word
TX_DATA_ENABLE = 0x0004                  # @6f bit 2
STATUS_PORT = 0x56
WINDOW_POINTER = 0x3D7                   # @57 on DP 7
BITS_PER_WORD = 3                        # the frame's marker sits at bit 2


def run(rom, mode='bell103-answer', bits=None, span=48, budget=8_000_000):
    """Loop the transmitter into the receiver and return what came back.

    `span` is the CPU-side symbol in codec frames; each user bit is sent
    `span // BITS_PER_WORD` window words. Returns (transmitted, delivered),
    both bit-per-frame streams with the transmitter's gate already applied.
    """
    if mode not in ENTRY:
        raise ValueError(f'unknown mode {mode!r}')
    if span % BITS_PER_WORD:
        raise ValueError(f'span must be a multiple of {BITS_PER_WORD}')
    pattern = list(bits) if bits else [1, 1, 0, 1, 0, 0, 1, 0] * 40
    words_per_bit = span // BITS_PER_WORD

    with NativeC5x(rom) as core:
        boot_rom.install(core)
        frame = [0xBC07, 0xBF01, 0xBF0F, 0x0BC0, 0x7980, SAMPLE_BODY]
        park = DRIVER + len(frame) + 5
        driver = frame + [0xBC07, 0x7A80, ENTRY[mode], 0x7980, park] \
            + [0x7980, park]
        core.load_program(struct.pack('<%dH' % len(driver), *driver), DRIVER)

        def until(pc, limit):
            for _ in range(limit):
                core.step(1)
                if core.state()['pc'] == pc:
                    return True
            return False

        core.set_pc(COLD_START)
        if not until(COLD_PARK, 3_000_000):
            raise RuntimeError('the cold start never reached its host wait')
        # The cold start leaves @26 pointing at the delivery routine, which
        # sends the receiver's tail down the bit-assembly branch at d90b and
        # past the resume at d912, so the bring-up never advances. A datapump
        # start has to arrive with it clear. Which routine does that is NOT
        # established - d55e is the bank's only `splk @26, #0000` and its
        # caller is unaccounted for - so this stands in for the command path.
        core.set_data(DELIVERY_VECTOR, 0x0000)

        core.set_pc(DRIVER + len(frame))
        if not until(park, 200_000):
            raise RuntimeError('the dispatch entry never returned')

        core.set_pc(LOOP_HEAD)
        transmitted, delivered, echo, fed = [], [], 0, 0
        first, last = boot_rom.window_first(core), boot_rom.window_last(core)
        for _ in range(budget):
            core.step(1)
            state = core.state()
            if state['pc'] == DELIVERY_STORE:
                delivered.append((core.data(FLAGS) & TX_DATA_ENABLE,
                                  core.data(RX_ASSEMBLY)))
            if not state['idle']:
                continue
            # The board's answer to a part waiting for its frame. The window
            # pointer belongs to circular buffer 2, so it is read, never set.
            slot = core.data(WINDOW_POINTER)
            if first <= slot <= last:
                core.set_io(slot, 0xFF if pattern[(fed // words_per_bit)
                                                  % len(pattern)] else 0x00)
                fed += 1
            core.set_io(STATUS_PORT, 0xFFFF)
            core.set_io(0x57, core.io(0x57) | 0x0002)   # the CPU can take one
            core.queue_codec_rx([echo & 0xFFFF])
            core.interrupt(FRAME_IRQ)
            echo = core.serial_state()['dxr']
            transmitted.append(((core.data(TX_SHIFT) >> 8) & 1,
                                core.data(FLAGS) & TX_DATA_ENABLE))
    return ([bit for bit, gate in transmitted if gate],
            [word for gate, word in delivered if gate])


def measure(transmitted, delivered, span=48):
    """Align the two streams and vote, the way the CPU side would.

    The receiver's own delivered words carry its bit timing, so the streams
    are aligned by sequence rather than against a symbol clock the harness
    imposed. Polarity belongs to the modulation, not the harness: V.21 puts
    mark below the band centre and Bell 103 above, so the two families decode
    with opposite sign.
    """
    received = [b for word in delivered if word < (1 << BITS_PER_WORD)
                for b in (word & 1, (word >> 1) & 1, (word >> 2) & 1)]
    best = None
    for offset in range(0, 400):
        a, b = transmitted[offset:], received
        n = min(len(a), len(b))
        if n < 500:
            break
        raw = sum(x ^ y for x, y in zip(a[:n], b[:n])) / n
        score = min(raw, 1 - raw)
        if best is None or score < best['raw']:
            best = {'offset': offset, 'raw': score, 'inverted': raw > 0.5,
                    'compared': n}
    if best is None:
        raise ValueError('not enough of a stream to align')

    a, b = transmitted[best['offset']:], received
    errors = symbols = 0
    for i in range(0, min(len(a), len(b)) - span, span):
        sent = 1 if sum(a[i:i + span]) * 2 > span else 0
        votes = sum((1 ^ v) if best['inverted'] else v for v in b[i:i + span])
        errors += sent ^ (1 if votes * 2 > span else 0)
        symbols += 1
    best.update(span=span, errors=errors, symbols=symbols,
                error_rate=errors / symbols if symbols else None)
    return best
