"""Every modulation this firmware carries, and where each one lives.

Three structures, all read out of the image rather than repeated here:

* the **carrier menu** the modem prints for `AT*C`, which is its own list of
  the modulations it can transmit - nine families, fastest last;
* the **overlay set**, four C52 images whose loader chains overlay 8 onto
  overlay 6 so the PCM downstream layer always accompanies the V.34 core;
* the **fax dispatch**, three mailbox tags in the resident bank that select a
  Class 1 modulation by the high nibble of their argument.

`fsk.mode_tables` covers the fourth, the nine-slot datapump table that the
start commands dispatch through. See `docs/datapump-slots.md`.
"""
from __future__ import annotations

import re
import struct

from .fsk import COMMAND_TABLE
from .mailbox_compare import program

# The `AT*C` help text: "(nn) <name>", one line per carrier, both sides of
# each modulation listed separately.
CARRIER_LINE = re.compile(rb'\((\d{1,2})\)\s+([\x20-\x7e]*?)\s*(?=[^\x20-\x7e])')
CARRIER_MENU_ANCHOR = b'Constant Carrier'

# The supervisor's overlay loader. It takes the requested index from 0x0d28,
# and for index 6 it loads that image and then requests 8 as well.
OVERLAY_REQUEST = 0x0D28
OVERLAY_CHAIN = bytes([0x3C, 0x06, 0x75, 0x08, 0xE8])   # cmp al,6 ; jne ; call
OVERLAY_REQUEST_WRITE = bytes([0xC6, 0x06, 0x28, 0x0D, 0x08])  # mov [0d28], 8
PAIRED_OVERLAY = 8

# The fax dispatch. Each tag's handler parks a table base in @7d and jumps to
# the shared selector, which indexes the table by the argument's high nibble.
FAX_TAGS = (0x20, 0x21, 0x22)
FAX_SELECTOR = 0xDC8E
SPLK_AT_7D, SPLK_AT_44, BRANCH, CALL = 0xAE7D, 0xAE44, 0x7980, 0x7A80
FAX_SLOTS = 6

# The transmit carrier each fax datapump installs in @44, read at 7200 Hz.
DIAL_RATE = 7200


def carrier_menu(rom):
    """The `AT*C` list: [(index, name)], in the order the modem prints it."""
    start = rom.data.find(CARRIER_MENU_ANCHOR)
    if start < 0:
        raise ValueError('no constant-carrier menu in this image')
    window = rom.data[start:start + 0x1000]
    found = []
    for match in CARRIER_LINE.finditer(window):
        index, name = int(match[1]), match[2].decode().strip()
        if name:
            found.append((index, name))
    return found


def carrier_families(rom):
    """The menu's modulation families, in menu order and without repeats.

    Each family appears twice per rate - once per side - and the faster ones
    once per rate as well, so the families are what the list is really about.
    """
    families = []
    for _, name in carrier_menu(rom):
        words = name.split(',')[0].split()
        family = ' '.join(words[:2]) if words[:1] == ['Bell'] else words[0]
        if family not in families:
            families.append(family)
    return tuple(families)


def overlay_chain(rom):
    """Which images load together, keyed by the index a caller asks for.

    Overlay 8 is never requested on its own: the loader appends it whenever
    overlay 6 is asked for, which is why the PCM layer is always beside the
    V.34 core and never beside overlay 7.
    """
    site = rom.data.find(OVERLAY_CHAIN)
    # The chain is only the chain if the requested index really becomes 8
    # immediately after the recursive call.
    chained = site >= 0 and rom.data[site + 7:site + 12] == OVERLAY_REQUEST_WRITE
    indexes = {overlay.index for overlay in rom.dsp_overlays}
    return {index: ((index, PAIRED_OVERLAY) if index == 6 and chained else (index,))
            for index in sorted(indexes)}


def _reachable(w, entry, depth=3, span=24):
    """Addresses a short run of code falls into by direct branch or call."""
    seen, entered, stack = set(), set(), [(entry, depth)]
    while stack:
        pc, left = stack.pop()
        if pc in entered or left < 0:
            continue
        entered.add(pc)
        for _ in range(span):
            seen.add(pc)
            word = w[pc]
            if word in (BRANCH, CALL):
                stack.append((w[pc + 1], left - 1))
                if word == BRANCH:
                    break
                pc += 2
                continue
            if word == 0xEF00:                  # ret
                break
            pc += 1
    return seen


def fax_dispatch(rom):
    """The three fax tags, each as a table of datapump configurations.

    Returns {tag: (entry, ...)}, one entry per slot, and `fax_carriers` reads
    what each entry installs.
    """
    w = program(rom)
    tables = {}
    for tag in FAX_TAGS:
        handler = w[0x83E9 + tag]
        base = None
        for pc in range(handler, handler + 12):
            if w[pc] == SPLK_AT_7D:
                base = w[pc + 1]
                break
        if base is None or w[base] not in (FAX_SELECTOR, 0xBE20):
            raise ValueError(f'tag {tag:#04x} is not a fax selector')
        tables[tag] = tuple(w[base:base + FAX_SLOTS])
    return tables


def fax_carriers(rom, tag=0x21):
    """The transmit carrier each of that tag's slots installs, in hertz.

    Every fax datapump writes its carrier increment to `@44`; following each
    slot's direct branches finds it. Slots that install none - the V.21 slot,
    which uses the FSK modulator's own cells, and the empty one - report None.
    """
    w = program(rom)
    found = {}
    for slot, entry in enumerate(fax_dispatch(rom)[tag]):
        increments = {w[pc + 1] for pc in _reachable(w, entry)
                      if w[pc] == SPLK_AT_44}
        found[slot] = tuple(sorted(round(i / 65536 * DIAL_RATE)
                                   for i in increments)) or None
    return found


# --- the PCM downstream schemes -------------------------------------------
#
# x2 and V.90 are two capabilities of one receiver, not two images: both ride
# overlay 8, which the loader chains onto the V.34 core. What separates them is
# an S-register bit each, and what each hands the DSP.

# The S-register file. The `ATSn` reader indexes it by the number the user
# typed, `mov al, byte ptr [bx + 0x48e]`, which is what fixes the base.
S_REGISTER_BASE = 0x048E
S_REGISTER_INDEX = bytes([0x8A, 0x87, 0x8E, 0x04])      # mov al, [bx + 0x48e]
PCM_OPTIONS, MODULATION_OPTIONS = 58, 56

# `test byte ptr [<S-register>], <bit>` - the disable tests.
def _test_byte(address, bit):
    return bytes([0xF6, 0x06, address & 0xFF, address >> 8, bit])

X2_BIT, V90_BIT = 0x01, 0x20
X2_COMMAND = 0x70                      # the capability word x2 sends the DSP
SEND_TAG = bytes([0xB8, X2_COMMAND, 0x00])              # mov ax, 0x70
EMPTY_BODY = bytes([0x75, 0x00, 0xC3])                  # jne +0 ; ret
# x2's pre-send capability edits.  Bits 4 and 16 of S58 have no recovered help
# labels, but their effect on the DSP word is explicit.
X2_CAPABILITY_BUILD = bytes([
    0x81, 0xE3, 0xFF, 0xFD,             # and bx, 0xfdff
    0xF6, 0x06, 0xC8, 0x04, 0x04,       # test [S58], 4
    0x74, 0x04, 0x81, 0xCB, 0x00, 0x02, # set bit 9 when set
    0x81, 0xCB, 0x00, 0x04,             # set bit 10
    0xF6, 0x06, 0xC8, 0x04, 0x10,       # test [S58], 16
    0x74, 0x04, 0x81, 0xE3, 0xFF, 0xFB, # clear bit 10 when set
    0x81, 0xE3, 0xFF, 0xE7,             # clear bits 11 and 12
    0x81, 0xE3, 0xFF, 0x3F,             # clear bits 14 and 15
    0xB8, X2_COMMAND, 0x00,
])

# The tag-70 DSP handler.  In addition to accepting the x2 capability word,
# it marks two shared state words as having fresh x2 parameters.
X2_DSP_SETUP = (0x097A, 0xFFF1, 0xBF09, 0xFFF1, 0x5E80, 0x3FFF,
                0x5D80, 0x0000, 0xBF09, 0xFFF4, 0xAE80, 0x8000,
                0xBF09, 0xFFF7, 0x5D80, 0x0001, 0xEF00)

# Both ladders step by 8000/6 bps: PCM downstream is 8000 symbols a second in
# six-symbol frames, so a rate is a count of bits per frame.
PCM_STEP = 8000 / 6
LADDER = re.compile(rb'([0-9]{4,5})/(x2|V90)(?![0-9A-Za-z])')


def s_register_bits(rom, number):
    """The bit meanings the modem's own help text gives for one S-register.

    Each entry is a token byte, the bit's decimal value, two more tokens, then
    the name - so the values and names come out even though the surrounding
    help text is compressed.
    """
    anchor = b'S%d' % number
    start = rom.data.find(anchor, 0x18000, 0x19000)
    if start < 0:
        raise ValueError(f'no help entry for S{number}')
    found = {}
    for chunk in rom.data[start:start + 0x120].split(b'\x00')[1:]:
        body = chunk.lstrip(b'\x7f\xff ')
        if body[:1] == b'S' and body[1:2].isdigit():
            break                                        # the next register
        match = re.match(rb'[\x80-\xff](\d{1,3})[\x80-\xff]{2} ([ -~]+?)[\s\x80-\xff]*$',
                         chunk)
        if match:
            found[int(match[1])] = match[2].decode()
    return found


def pcm_option_tests(rom):
    """Every direct supervisor test of S58, grouped by bit mask.

    This is the complete local option surface for the PCM schemes in the
    captured image: BLER once, the x2 and V.90 gates twice each, and x2's two
    otherwise-undocumented capability modifiers.
    """
    options = S_REGISTER_BASE + PCM_OPTIONS
    pattern = re.compile(rb'\xf6\x06' + bytes((options & 0xff, options >> 8)) + rb'(.)')
    found = {}
    for match in pattern.finditer(rom.data):
        found.setdefault(match[1][0], []).append(match.start())
    return {bit: tuple(sites) for bit, sites in sorted(found.items())}


def pcm_ladders(rom):
    """The rates each scheme has a result code for, from the CONNECT strings."""
    found = {'x2': set(), 'V90': set()}
    for match in LADDER.finditer(rom.data):
        found[match[2].decode()].add(int(match[1]))
    return {scheme: tuple(sorted(rates)) for scheme, rates in found.items()}


def pcm_control(rom):
    """How each scheme is enabled, and what it tells the DSP.

    The two eligibility predicates are the same routine twice over, differing
    only in which S58 bit disables them. What follows differs: x2 builds a
    capability word and sends it as command 0x70, while V.90's branch is
    present with an empty body - `jne +0 ; ret` - so it adds nothing to the
    shared PCM setup.
    """
    if S_REGISTER_INDEX not in rom.data:
        raise ValueError('the S-register file is not where this expects')
    options = S_REGISTER_BASE + PCM_OPTIONS
    found = {}
    for scheme, bit in (('x2', X2_BIT), ('V90', V90_BIT)):
        sites = [m.start() for m in
                 re.finditer(re.escape(_test_byte(options, bit)), rom.data)]
        command, empty = None, False
        for site in sites:
            tail = rom.data[site + 5:site + 5 + 3]
            if tail == EMPTY_BODY:
                empty = True
            if SEND_TAG in rom.data[site:site + 0x40]:
                command = X2_COMMAND
        found[scheme] = {'s_register': PCM_OPTIONS, 'disable_bit': bit,
                         'sites': tuple(sites), 'command': command,
                         'empty_setup': empty}
    return found


def x2_capability_builder(rom):
    """The x2-only transformation applied before tag 0x70 reaches the DSP."""
    sites = tuple(match.start() for match in
                  re.finditer(re.escape(X2_CAPABILITY_BUILD), rom.data))
    if len(sites) != 1:
        raise ValueError(f'expected one x2 capability-word builder, found {len(sites)}')
    return {'site': sites[0], 's_register': PCM_OPTIONS,
            'bit_9_from_s58': 0x04, 'bit_10_clear_from_s58': 0x10,
            'always_clear': 0xD800, 'command': X2_COMMAND}


def x2_dsp_setup(rom):
    """The complete DSP-side state update performed for host tag 0x70."""
    w = _image(rom, 5)
    sites = tuple(pc for pc in range(0x8000, 0xEEA0 - len(X2_DSP_SETUP))
                  if tuple(w[pc:pc + len(X2_DSP_SETUP)]) == X2_DSP_SETUP)
    if len(sites) != 1:
        raise ValueError(f'expected one x2 tag-70 handler, found {len(sites)}')
    return {'site': sites[0], 'capability_cell': X2_CAPABILITY,
            'capability_mask': 0x3FFF,
            'set': {0xFFF4: 0x8000, 0xFFF7: 0x0001}}


# --- the two receivers in overlay 8 ---------------------------------------
#
# Overlay 8 is not one receiver. It carries two parallel state machines with
# their own tables and callbacks, and a one-bit fork at the top chooses which
# one runs.

DATAPUMP_FLAGS = 0x039F          # @1f on page 7: which datapump is running
LAR_AR1, BIT_TEST_MASK, BCND = 0xBF09, 0xFF00, 0xE200
# The fork's bit *number*: the instruction is `bit 8, *`, and the C5x `BIT`
# shifts by `~code & 0xf`, so code 8 is bit 7.
E_FAMILY_BIT, F_FAMILY_BIT = 7, 6

# The fork: `lar ar1, #039f ; bit 8, * ; bcnd <f family>, ntc ; b <e family>`
FORK = (LAR_AR1, DATAPUMP_FLAGS, 0x4800 | 0x80)

# The three mailbox commands that set it up. Each installs a sample-path
# routine in @61 and then sets or clears the flag bit.
MODE_COMMANDS = (0x4D, 0x4E, 0x4F)
SPLK_AT_61, OPL_AT_1F, APL_AT_1F = 0xAE61, 0x5D1F, 0x5E1F
PCM_SAMPLE_PATH = 0x819D         # assembles a sample from two 8-bit codewords


def _overlay_words(rom, index):
    overlay = next(o for o in rom.dsp_overlays if o.index == index)
    raw = rom.data[overlay.offset:overlay.offset + overlay.length]
    return overlay.entry_word, list(struct.unpack('<%dH' % (len(raw) // 2), raw))


def receiver_fork(rom):
    """Where overlay 8 splits into its two receivers, and into what.

    Returns (site, bit, {bit set: entry, bit clear: entry}). The branch is
    taken when the bit is clear, so the fall-through is the set case.
    """
    org, words = _overlay_words(rom, 8)
    for i in range(len(words) - 6):
        if tuple(words[i:i + 3]) != FORK:
            continue
        if words[i + 3] & BIT_TEST_MASK != BCND or words[i + 5] != 0x7980:
            continue
        return org + i, E_FAMILY_BIT, {True: words[i + 6], False: words[i + 4]}
    raise ValueError('overlay 8 does not fork on the datapump flags')


def receiver_twins(rom, window=8, span=10):
    """Runs of code overlay 8 holds twice over, far apart - the two families.

    Two state machines built from one source share fragments verbatim while
    their tables and constants differ, so exact repeats at a consistent offset
    are what the pair leaves behind.
    """
    org, words = _overlay_words(rom, 8)
    seen = {}
    for i in range(len(words) - window):
        seen.setdefault(tuple(words[i:i + window]), []).append(org + i)
    pairs = sorted((v[0], v[1]) for v in seen.values()
                   if len(v) == 2 and abs(v[0] - v[1]) > 0x400)
    runs = []
    for first, second in pairs:
        if runs and first == runs[-1][1] + 1 and second == runs[-1][3] + 1:
            runs[-1][1], runs[-1][3] = first, second
        else:
            runs.append([first, first, second, second])
    return tuple((a, b + window - 1, c, d + window - 1)
                 for a, b, c, d in runs if b - a + window >= span)


def mode_commands(rom):
    """The commands that install a sample path and set the receiver flag."""
    w = program(rom)
    found = {}
    for tag in MODE_COMMANDS:
        pc = w[COMMAND_TABLE + tag]
        path, flag = None, None
        for _ in range(6):
            if w[pc] == SPLK_AT_61:
                path = w[pc + 1]
            elif w[pc] in (OPL_AT_1F, APL_AT_1F):
                flag = ('set' if w[pc] == OPL_AT_1F else 'clear', w[pc + 1])
            elif w[pc] == 0xEF00:
                break
            pc += 2 if w[pc] & 0xFF00 in (0xAE00, 0x5D00, 0x5E00) else 1
        found[tag] = {'sample_path': path, 'flag': flag}
    return found


# --- who arms the receiver bit --------------------------------------------
#
# The three mode commands are not sent with a literal tag in `ax`: they go
# through the packed sender, tag in `ah` and data zero, chosen by a byte of the
# stored profile. That is why they never turn up in a search for `mov ax, imm`.

RECEIVER_SETTING = 0x04ED               # active profile byte
RECEIVER_SETTING_STORED = 0x0563        # its twin in the stored profile
PROFILE_ACTIVE, PROFILE_STORED = 0x048E, 0x0504
LOAD_SETTING = bytes([0xA0, RECEIVER_SETTING & 0xFF, RECEIVER_SETTING >> 8])
PACKED_SENDER = bytes([0x9A, 0xE8, 0x01, 0x46, 0x8F])   # lcall 0x8f46:0x01e8


def receiver_selector(rom, window=0x40):
    """Where the mode commands are sent, and what chooses between them.

    Each site loads the profile byte and fans out to `mov ah, <tag>` - one per
    value - before the packed sender. Returns the sites and the value-to-tag
    map they encode.
    """
    found = []
    for match in re.finditer(re.escape(LOAD_SETTING), rom.data):
        site = match.start()
        window_bytes = rom.data[site:site + window]
        tags = {}
        for value, tag in enumerate(MODE_COMMANDS):
            where = window_bytes.find(bytes([0xB4, tag]))     # mov ah, tag
            if where >= 0:
                tags[value] = tag
        if len(tags) == len(MODE_COMMANDS) and PACKED_SENDER in window_bytes:
            found.append((site, tags))
    if not found:
        raise ValueError('no site selects a mode command from the profile')
    return tuple(found)


def receiver_setting_is_configured(rom):
    """True when the selector reads a stored setting rather than a negotiation.

    The byte is written by an AT handler that parses a number and rejects
    anything above 2, and it has a twin in the stored profile at the same
    offset - 0x5f into each of the two 118-byte blocks the S-register file
    starts. Nothing in the V.8 or INFO paths writes it.
    """
    writes_active = bytes([0xA2, RECEIVER_SETTING & 0xFF, RECEIVER_SETTING >> 8])
    writes_stored = bytes([0xA2, RECEIVER_SETTING_STORED & 0xFF,
                           RECEIVER_SETTING_STORED >> 8])
    same_offset = (RECEIVER_SETTING - PROFILE_ACTIVE
                   == RECEIVER_SETTING_STORED - PROFILE_STORED)
    return (writes_active in rom.data and writes_stored in rom.data
            and same_offset)


# The `&V` display prints each setting as a label then a number. Each label is
# a routine that calls a print-inline-string helper, the string following the
# call, so the name of a setting can be read from the display code.
DISPLAY_LOAD = bytes([0xA0, RECEIVER_SETTING & 0xFF, RECEIVER_SETTING >> 8])
NEAR_CALL = 0xE8


def _inline_string(data, site, limit=0x30):
    """The string a label routine prints: it follows that routine's own call."""
    for pc in range(site, site + limit):
        if data[pc] != NEAR_CALL:
            continue
        text = pc + 3
        end = data.find(b'\x00', text, text + 16)
        if end < 0:
            continue
        body = bytes(c for c in data[text:end] if 0x20 <= c < 0x7F)
        if body:
            return body.decode()
    return None


def receiver_setting_command(rom, limit=0x20):
    """The AT command whose value chooses the mode command, by its own label.

    The display routine prints a label and then this setting's value, so
    following its call to the label routine and reading the string that
    routine prints names the command.
    """
    for match in re.finditer(re.escape(DISPLAY_LOAD), rom.data):
        site = match.start()
        for back in range(3, limit):
            pc = site - back
            if rom.data[pc] != NEAR_CALL:
                continue
            target = pc + 3 + int.from_bytes(rom.data[pc + 1:pc + 3], 'little',
                                             signed=True)
            if not 0 <= target < len(rom.data):
                continue
            label = _inline_string(rom.data, target)
            if label and label.startswith('&'):
                return label
    raise ValueError('the setting is not labelled in the display code')


# --- what the two families differ in --------------------------------------

E_FAMILY, F_FAMILY = 0xE4C5, 0xF442
FAMILY_SPAN = {E_FAMILY: (0xE4C5, 0xEB00), F_FAMILY: (0xF442, 0xF94A)}

SPLK = 0xAE00                    # splk @dma, #imm  ->  0xAE00 | dma
FILTER_CELL, UPDATE_CELL, PHASE_CELL = 0x0A, 0x16, 0x2F
HOOK_POINTER = 0x03CD            # the phase hook every datapump installs into
LAR_AR1_ = 0xBF09
RPTZ, BIT_ = 0xBEC5, 0x4000
OVERLAY_SIX = range(0x9D00, 0xCE32)


def _image(rom, index=8):
    """The overlay's words, indexed by their own program address."""
    org, words = _overlay_words(rom, index)
    return [0] * org + words


def _splk(words, span, cell):
    """Every `splk @cell, #imm` in a span, in order."""
    first, last = span
    return tuple(words[pc + 1] for pc in range(first, last - 1)
                 if words[pc] == (SPLK | cell))


def filter_taps(rom, entry, window=8):
    """The tap count of the filter at `entry`, from its own repeat count."""
    w = _image(rom)
    for pc in range(entry, entry + window):
        if w[pc] == RPTZ:
            return w[pc + 1] + 1
    raise ValueError(f'no repeat block at {entry:#06x}')


def family_hooks(rom, span):
    """The values a span installs into the shared phase hook at 0x03cd."""
    w = _image(rom)
    first, last = span
    return tuple(w[pc + 3] for pc in range(first, last - 3)
                 if w[pc] == LAR_AR1_ and w[pc + 1] == HOOK_POINTER
                 and w[pc + 2] == 0xAE80)


def family_flag_bits(rom, span):
    """Which bits of the parameter word at 0xfff4 a span tests."""
    w = _image(rom)
    first, last = span
    bits, pointed = set(), False
    for pc in range(first, last - 1):
        if w[pc] == LAR_AR1_:
            pointed = w[pc + 1] == 0xFFF4
        elif pointed and w[pc] & 0xF080 == 0x4080:
            bits.add(15 - ((w[pc] >> 8) & 0xF))     # bit number, not bit code
    return frozenset(bits)


def family_calls_into_overlay_six(rom, span):
    """Direct calls and branches from a span into the V.34 core."""
    w = _image(rom)
    first, last = span
    return tuple(sorted({w[pc + 1] for pc in range(first, last - 1)
                         if w[pc] in (0x7A80, 0x7980, 0x7E80, 0x7D80)
                         and w[pc + 1] in OVERLAY_SIX}))


def receiver_families(rom):
    """What separates overlay 8's two receivers, read out of the image."""
    found = {}
    for entry, span in FAMILY_SPAN.items():
        words = _image(rom)
        filters = _splk(words, span, FILTER_CELL)
        updates = _splk(words, span, UPDATE_CELL)
        found[entry] = {
            'span': span,
            'filters': filters,
            'taps': tuple(filter_taps(rom, f) for f in filters),
            'updates': updates,
            'hooks': family_hooks(rom, span),
            'flag_bits': family_flag_bits(rom, span),
            'into_v34_core': family_calls_into_overlay_six(rom, span),
        }
    return found


# --- what the e-family's rate change selects -------------------------------
#
# Its phase hook walks into `call 8140`, the codec rate selector, with an index
# the routine at `adee` returns. That index is the highest V.34 symbol rate all
# four capability words agree on.

CAPABILITY_WORDS = (0xFFB0, 0xFFB1, 0xFFB2, 0xFFB3)
CAPABILITY_AND = 0xFFB4          # where their intersection is parked
RATE_CHOICE = 0xADEE             # returns the codec rate index
RATE_SELECTOR = 0x8140
SYMBOL_RATES = (2400, 2743, 2800, 3000, 3200, 3429)   # S54 bits 0..5
CODEC_RATES = (7200.0, 7578.947, 7578.947, 7578.947, 8000.0, 8000.0)


def rate_choice(rom, window=24):
    """The bit-to-index scan at `adee`, as {capability bit: codec row}.

    A run of `bit code, @7d ; lacl #index ; retc tc`, read as bit numbers:
    the C5x `BIT` shifts by `~code & 0xf`.
    """
    w = _image(rom, 5)
    found, pc = {}, RATE_CHOICE
    while pc < RATE_CHOICE + window:
        if w[pc] & 0xF080 == 0x4000 and w[pc + 1] & 0xFF00 == 0xB900:
            found[15 - ((w[pc] >> 8) & 0xF)] = w[pc + 1] & 0xFF
            pc += 3
            continue
        pc += 1
    return found


def rate_choice_selects(rom):
    """That scan as (symbol rate, codec rate) pairs, fastest first."""
    return tuple((SYMBOL_RATES[bit], CODEC_RATES[index])
                 for bit, index in sorted(rate_choice(rom).items(), reverse=True)
                 if bit < len(SYMBOL_RATES) and index < len(CODEC_RATES))


# --- which scheme a call ends up in ----------------------------------------
#
# The DSP packs one of two 16-bit capability words into a message-preparation
# path. The choice is flag bit 6 in its datapump register, which tag 1d derives
# from S29. S29 is a V.21-handshake/fallback timing control, so this proves a
# shared sequencing dependency only—not the frame carrying the word or any
# remote-x2 marker. This is also not overlay 8's family fork (bit 7), nor an
# S58 x2/V.90 selector.

X2_CAPABILITY, OTHER_CAPABILITY = 0xFFF1, 0xFFF2   # the two words it can send
MESSAGE_BUFFER = 0xFF18                            # the bit-packed message
BIT_PACKER = 0x8769                                # writes acc into it, @7f wide
CAPABILITY_FLAG_BIT, E_FAMILY_FLAG_BIT = 6, 7      # separate flag bits
BLDD_AT_7D = 0xA87D
DATAPUMP_FLAG_TRANSFER = (0x127A, 0x207A, 0xBC10, 0x901F, 0xEF00)
DATAPUMP_FLAG_S_REGISTER = 0x04AB - S_REGISTER_BASE


def capability_choice(rom):
    """Where the DSP picks which capability word goes into the message.

    `bit <code>, @1f ; bldd @7d, #fff1 ; xc 2, ntc ; bldd @7d, #fff2` chooses
    `fff1` when its bit-6 selector is set and `fff2` when clear, then pushes
    the chosen 16-bit word into the message buffer. Tag `0x70` writes `fff1`
    on the x2 setup path; tag `0x51` supplies the `fff2` counterpart. The
    S29-derived selector can be a V.21 fallback timer/state control, rather
    than an on-wire protocol selector. This proves the local setup path, not
    the message framing or individual remote capability-bit definitions.
    """
    w = _image(rom, 5)
    for pc in range(0x8000, 0xEEA0):
        if (w[pc] & 0xF000 != 0x4000 or w[pc] & 0x7F != 0x1F
                or w[pc + 1] != BLDD_AT_7D or w[pc + 2] != X2_CAPABILITY):
            continue
        if w[pc + 4] != BLDD_AT_7D or w[pc + 5] != OTHER_CAPABILITY:
            continue
        bit = 15 - ((w[pc] >> 8) & 0xF)
        width = next((w[q + 1] for q in range(pc, pc + 12)
                      if w[q] == (SPLK | 0x7F)), None)
        buffer_ = next((w[q + 1] for q in range(pc, pc + 12)
                        if w[q] == 0xBF08), None)
        return {'site': pc, 'flag_bit': bit, 'set': X2_CAPABILITY,
                'clear': OTHER_CAPABILITY, 'width': width, 'buffer': buffer_}
    raise ValueError('no capability-word choice in this image')


def datapump_flag_transfer(rom):
    """The tag-1d conversion that installs the DSP datapump flag word.

    It computes five times the mailbox argument before storing `@1f`; host
    code supplies that argument from S29 (`[4ab]`).
    """
    w = _image(rom, 5)
    sites = tuple(pc for pc in range(0x8000, 0xEEA0 - len(DATAPUMP_FLAG_TRANSFER))
                  if tuple(w[pc:pc + len(DATAPUMP_FLAG_TRANSFER)]) == DATAPUMP_FLAG_TRANSFER)
    if len(sites) != 1:
        raise ValueError(f'expected one tag-1d datapump-flag handler, found {len(sites)}')
    return {'site': sites[0], 'input_cell': 0x007A,
            'destination': DATAPUMP_FLAGS, 'multiplier': 5,
            'host_s_register': DATAPUMP_FLAG_S_REGISTER}


# --- x2 status transport ----------------------------------------------------
#
# Tag 70 initializes `fff7` bit 0 as part of x2 setup.  The resident and its
# overlays subsequently OR individual condition bits into the same word.  The
# C5x reports that *bitmap*, not a pre-rendered diagnostic enum: the delayed
# `calld 83b1` queues tag 8075 and the following call queues `fff7` as its
# argument.  The supervisor must therefore translate the bitmap to the x2
# error strings later.

X2_STATUS_TAG, X2_STATUS_WORD = 0x75, 0xFFF7
X2_STATUS_REPORT = (0x7E80, 0x83B1, 0xBF80, 0x8075,
                    0xBF09, X2_STATUS_WORD, 0x1080, 0x7A80, 0x83B1)


def x2_status_transport(rom):
    """Report sites where the DSP sends `fff7` to the host as tag 0x75."""
    sites = []
    for index in (6, 8):
        w = _image(rom, index)
        sites.extend((index, pc) for pc in range(0x8000, len(w) - len(X2_STATUS_REPORT))
                     if tuple(w[pc:pc + len(X2_STATUS_REPORT)]) == X2_STATUS_REPORT)
    if not sites:
        raise ValueError('no x2 status reports in DSP overlays')
    return {'tag': X2_STATUS_TAG, 'word': X2_STATUS_WORD, 'sites': tuple(sites)}


def x2_status_flag_masks(rom):
    """All immediate condition bits ORed into the x2 DSP status word.

    These are condition flags, not the host's textual error-number enum.
    """
    masks = {0x0001}  # tag 70 handler at resident 8d35..8d37
    for index in (5, 6, 8):
        w = _image(rom, index)
        for pc in range(0x8000, len(w) - 3):
            if w[pc:pc + 2] == [LAR_AR1_, X2_STATUS_WORD] and w[pc + 2] == 0x5E80:
                masks.add(w[pc + 3])
    return tuple(sorted(masks))


# --- V.90's INFO1a selector -----------------------------------------------
#
# This must stay distinct from `rate_choice`: V.90 Table 10 assigns integer 6
# at INFO1a bits 37:39 to mean V.90 operation, whereas V.34 uses values 0..5
# for a symbol-rate index.

INFO1A_DIGITAL_RATE_OFFSET = 0x25
V90_INFO1A_VALUE = 6
INFO1A_V90_WRITER = (0x7A80, 0x9267, 0xBF08, 0xFF1A,
                     0x7E80, BIT_PACKER, 0xAE7F, INFO1A_DIGITAL_RATE_OFFSET)


def v90_info1a_writer(rom):
    """The sole code path that writes outgoing INFO1a bits 37:39.

    The called routine computes the three-bit value; the immediately following
    bit-packer call inserts it in `ff1a` at offset 37.  A second writer would
    be an x2 candidate, but the image has no such counterpart.
    """
    w = _image(rom, 5)
    sites = tuple(pc for pc in range(0x8000, 0xEEA0 - len(INFO1A_V90_WRITER))
                  if tuple(w[pc:pc + len(INFO1A_V90_WRITER)]) == INFO1A_V90_WRITER)
    if len(sites) != 1:
        raise ValueError(f'expected one INFO1a bits-37:39 writer, found {len(sites)}')
    return {'site': sites[0], 'value_source': 0x9267,
            'buffer': 0xFF1A, 'offset': INFO1A_DIGITAL_RATE_OFFSET,
            'v90_value': V90_INFO1A_VALUE}
