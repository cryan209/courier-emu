"""Assemble DSP 3.1.2's V.90 DIL descriptor by running its own code.

Overlay 8 is the V.PCM datapump. Near its end it builds the Ja descriptor into
a data buffer: the fixed fields are copied out of program memory, and the 197
training Ucodes are generated arithmetically rather than tabulated. This runs
that code in the C5x core and returns what it produced.

This is a component run, not a boot. It enters the assembler directly, so it
supplies the one piece of caller state that routine depends on - see ENTRY.
"""
from __future__ import annotations
import struct

from .dsp import NativeC5x

OVERLAY_ENTRY = 0xDC00
ASSEMBLER, DONE = 0xE7E8, 0xE837
BUFFER = 0x0940
FIELD_WORDS = 20            # N, LSP/LTP, 5 SP, 5 TP, 4 H, 4 REF
# The assembler reaches its build buffer through `*`, which selects whichever
# auxiliary register ARP names - not AR1, despite the `lar ar1` that precedes
# it. Its real caller arrives with ARP already 1; entering at ASSEMBLER without
# setting it sends every store through AR0, and the descriptor lands nowhere.
# The driver below selects AR1 the way the firmware's own `mar *, ar1` does.
MAR_MASK = 0x7


def overlay(rom):
    """The V.PCM overlay, identified by where it loads rather than by index."""
    for candidate in rom.dsp_overlays:
        if candidate.entry_word == OVERLAY_ENTRY:
            return candidate
    raise ValueError('this ROM has no overlay at the V.PCM entry')


def assemble(rom, *, limit=400_000):
    """Run the descriptor assembler and return the fields it wrote."""
    entry = overlay(rom)
    image = rom.data[entry.offset:entry.end]
    word = lambda pc: struct.unpack_from('<H', image, (pc - OVERLAY_ENTRY) * 2)[0]
    mar_ar1 = (word(0xE806) & ~MAR_MASK) | 1
    with NativeC5x(rom) as core:
        core.set_mpmc_pin(0)
        core.load_program(image, entry.entry_word)
        core.load_rom(struct.pack('<3H', mar_ar1, 0x7980, ASSEMBLER))
        core.set_pc(0)
        for _ in range(limit):
            core.step(1)
            if core.state()['pc'] == DONE:
                break
        else:
            raise RuntimeError(f'assembler did not finish: {core.state()}')
        buffer = [core.data(BUFFER + index) for index in range(0x80)]
        instructions = core.state()['instructions']
    n = buffer[0]
    ucodes = []
    for packed in buffer[FIELD_WORDS:]:
        ucodes += [packed & 0xFF, packed >> 8]
    return {
        'n': n,
        'lsp': (buffer[1] & 0xFF) + 1,
        'ltp': (buffer[1] >> 8) + 1,
        'sp': buffer[2:7],
        'tp': buffer[7:12],
        'h': buffer[12:16],
        'ref': buffer[16:20],
        'ucodes': ucodes[:n],
        'instructions': instructions,
    }


# --- companded levels ------------------------------------------------------
# A DIL is scored by comparing what arrives against the level each training
# Ucode stands for. A Ucode is a G.711 chord decomposition - `u >> 4` picks the
# segment, `u & 15` the position in it - and the level depends on which law the
# analog modem asked for.
#
# The A-law form is **verified against hardware**: every one of the 197 segments
# in `artifacts/dil-requested-alaw.g711`, a DIL a digital modem sent in answer
# to this Courier's own Ja, carries exactly the level below for the Ucode this
# firmware generated for that segment. The mu-law form is the standard's
# arithmetic and has no capture behind it here.
#
# The two are close but not equal, and the difference is systematic: mu-law
# carries a 132 bias that A-law does not, and A-law's first chord is a different
# slope. So Ucode 100 is 10496 in A-law and 10364 in mu-law. The law matters and
# cannot be left implicit.
MU_BIAS = 0x84    # 132: mu-law carries a bias that A-law does not


def ucode_level(ucode: int, *, law: str = 'a') -> int:
    """The linear magnitude a training Ucode stands for, in G.711's domain."""
    if not 0 <= ucode <= 127:
        raise ValueError('a training Ucode is 0..127')
    chord, step = ucode >> 4, ucode & 15
    if law == 'a':
        if chord == 0:
            return (step << 4) + 8
        return ((step << 4) + 0x108) << (chord - 1)
    if law == 'mu':
        return (((step << 3) + MU_BIAS) << chord) - MU_BIAS
    raise ValueError("law is 'a' or 'mu'")


def ladder_levels(descriptor, *, law: str = 'a') -> list[int]:
    """The descriptor's training ladder, as linear levels."""
    return [ucode_level(u, law=law) for u in descriptor['ucodes']]


def alaw_decode(byte: int) -> int:
    """One G.711 A-law octet as a signed linear sample."""
    byte ^= 0x55
    magnitude = (byte & 0x0F) << 4
    chord = (byte & 0x70) >> 4
    if chord == 0:
        magnitude += 8
    elif chord == 1:
        magnitude += 0x108
    else:
        magnitude = (magnitude + 0x108) << (chord - 1)
    return magnitude if byte & 0x80 else -magnitude


def ulaw_decode(byte: int) -> int:
    """One G.711 mu-law octet as a signed linear sample."""
    byte = ~byte & 0xFF
    magnitude = ((((byte & 0x0F) << 3) + MU_BIAS) << ((byte >> 4) & 0x07)) - MU_BIAS
    return -magnitude if byte & 0x80 else magnitude


DECODE = {'a': alaw_decode, 'mu': ulaw_decode}


def pattern(words, length: int) -> str:
    """A framed descriptor pattern back out of the words the firmware packed."""
    bits = ''.join(f'{word:016b}'[::-1] for word in words)
    return bits[:length]


def score_dil(raw: bytes, descriptor, *, law: str):
    """Compare a received DIL against the ladder this firmware asked for.

    Returns the gain the channel applied, how much of the signal survives on
    the nose, and what lands in the slots that should be silent - which is the
    comparison a DIL exists to make. It reports; it does not decide.
    """
    n = descriptor['n']
    if not n or len(raw) % n:
        raise ValueError(f'{len(raw)} symbols is not a whole number of {n} segments')
    span = len(raw) // n
    sp = pattern(descriptor['sp'], descriptor['lsp'])
    tp = pattern(descriptor['tp'], descriptor['ltp'])
    linear = [DECODE[law](byte) for byte in raw]

    signs_wrong = training = exact = 0
    ratios, reference, residual = [], [], []
    for index, sample in enumerate(linear):
        want_positive = sp[index % len(sp)] == '1'
        if sample and (sample > 0) != want_positive:
            signs_wrong += 1
        if tp[index % len(tp)] == '0':
            reference.append(abs(sample))
            continue
        expected = ucode_level(descriptor['ucodes'][index // span], law=law)
        training += 1
        if abs(sample) == expected:
            exact += 1
        if expected > 500:                  # below this, quantising dominates
            ratios.append(abs(sample) / expected)
        residual.append(abs(sample) - expected)
    ratios.sort()
    gain = ratios[len(ratios) // 2] if ratios else None
    return {
        'segments': n, 'symbols_per_segment': span,
        'signs_wrong': signs_wrong,
        'training_symbols': training, 'exact': exact,
        'gain': gain,
        'gain_db': None if not gain else 20 * __import__('math').log10(gain),
        'reference_symbols': len(reference),
        'reference_non_zero': sum(1 for value in reference if value != ucode_level(0, law=law)),
        'reference_worst': max(reference) if reference else 0,
        'residual_mean': sum(residual) / len(residual) if residual else 0.0,
    }
