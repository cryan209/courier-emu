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
