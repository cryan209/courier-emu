"""Measure what each of the six QF settings-EEPROM records controls.

Sweeps one record at a time against an otherwise-zeroed part and records the
ATI7 configuration profile the firmware renders, plus the RAM cells the boot
decode at 0xc0940 fans the records into. Reproduces docs/quad-settings-eeprom.md.
"""
import json
import sys
from concurrent.futures import ProcessPoolExecutor, as_completed
from pathlib import Path

from courier_emu.machine import CourierMachine
from courier_emu.quad_image import QuadImage
from courier_emu.nvram import (CHECKSUM_BYTE, CourierNvram, IDSDL302_RECORD_ORDER,
                               IDSDL403_NVRAM, encode_idsl302_record, settings_checksum)

ROOT = Path(__file__).resolve().parents[1]
IN = ROOT / 'artifacts/quad-identify-20260910'
OUT = ROOT / 'artifacts/quad-settings-20260910'

# The six records live at EEPROM word 94, three redundant bytes each, in the
# physical order 2,3,4,5,6,1 - the same layout the 302 and 403 parts carry.
SETTINGS_BYTE = 94 * 2

# The cells the boot decode fans the records into, and the printer that reads
# each one: 0x8838/0x8839 the options list, 0x862e fax, 0x862d cellular,
# 0x81c4 the country index, 0x81d2/0x81d3 the raw settings 2 and 4.
CELLS = {'8838': 0x8838, '8839': 0x8839, '862c': 0x862C, '862d': 0x862D,
         '862e': 0x862E, '81c4': 0x81C4, '81d2': 0x81D2, '81d3': 0x81D3}

FIELDS = ('Product type', 'Options', 'ISDN Options', 'Fax Options',
          'Cellular Options', 'Clock Freq', 'Flash Rom', 'Ram')


def part(settings):
    """A 403 part with the six settings replaced and the checksum restored."""
    data = bytearray(IDSDL403_NVRAM)
    data[SETTINGS_BYTE:SETTINGS_BYTE + 18] = b''.join(
        encode_idsl302_record(settings[index]) for index in IDSDL302_RECORD_ORDER)
    data[CHECKSUM_BYTE] = settings_checksum(data)
    return data


def run(label, settings):
    image = QuadImage.modem((IN / 'flash.bin').read_bytes(), (IN / 'ram.bin').read_bytes())
    m = CourierMachine(image, quad_terminal=True, tick_ms=5,
                       nvram=CourierNvram(data=part(settings)),
                       serial_input=b'ATQ0V1\rATI7\r')
    boundary = None
    last_size = 0
    last_change = 0

    def observe(pc):
        nonlocal boundary, last_size, last_change
        if m.quad_terminal.opened == 2 and boundary is None:
            boundary = len(m.serial)
        if len(m.serial) != last_size:
            last_size = len(m.serial)
            last_change = m.instructions
        if (boundary is not None and not m.serial_rx and not m.uart.pending
                and bytes(m.uc.mem_read(0x81f8, 2)) == b'\xe6\x91'
                and m.instructions - last_change > 200_000):
            m.stop_requested = True

    m._code_observer = observe
    m.run(12_000_000)
    raw = bytes(m.serial)[boundary:] if boundary is not None else b''
    text = bytes(b & 127 for b in raw).decode('ascii', 'replace')
    fields = {}
    for line in text.splitlines():
        for key in FIELDS:
            if line.startswith(key):
                fields[key] = line[len(key):].strip()
    return dict(label=label, settings=list(settings), fields=fields,
                cells={k: m.uc.mem_read(a, 1)[0] for k, a in CELLS.items()})


def jobs():
    yield 'baseline-zero', (0, 0, 0, 0, 0, 0)
    for index in range(6):
        for bit in range(8):
            value = [0] * 6
            value[index] = 1 << bit
            yield 'S%d.bit%d' % (index + 1, bit), tuple(value)
    for country in range(24):
        yield 'S1=%d' % country, (country, 0, 0, 0, 0, 0)
    for mask in (0x01, 0x03, 0x05, 0x07, 0x0B, 0x0F, 0x10, 0x11,
                 0x18, 0x19, 0x1F, 0x3F, 0x7F, 0xFF):
        yield 'S2=%#04x' % mask, (0, mask, 0, 0, 0, 0)
    yield '403-as-shipped', (0x00, 0x1F, 0x07, 0x1E, 0x00, 0x00)


if __name__ == '__main__':
    OUT.mkdir(parents=True, exist_ok=True)
    workers = int(sys.argv[sys.argv.index('--workers') + 1]) if '--workers' in sys.argv else 4
    rows = []
    with ProcessPoolExecutor(max_workers=workers) as pool:
        futures = {pool.submit(run, label, settings): label for label, settings in jobs()}
        for future in as_completed(futures):
            rows.append(future.result())
            print(json.dumps(rows[-1]), flush=True)
    rows.sort(key=lambda r: r['label'])
    (OUT / 'results.json').write_text(json.dumps(rows, indent=1) + '\n')
