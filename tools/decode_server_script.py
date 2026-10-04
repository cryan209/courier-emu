#!/usr/bin/env python3
"""Print the Ie030002 downstream training script from a saved DSP program dump.

Usage: decode_server_script.py dsp-program.bin [START_HEX]

The I-modem's post-marker output is driven by a table of (state, parameter, duration)
words in program memory (default start c915).  The interpreter at cc85-cc96 reads
three words per entry: the state routine address into @48, a parameter into @49 and a
symbol count into @4a; a zero state word halts the script.  The dump is the
dsp-program.bin that tools/probe_imodem_analog_pair.py writes next to its results.
"""
from __future__ import annotations

import json
import struct
import sys

STATES = {
    0xC9A4: "digital zero: octet 7f",
    0xC9C8: "pattern A: Barker-11 signs, two levels (ab/bd), 11-symbol cycles",
    0xC9DD: "pattern A, last cycle with every sign inverted",
    0xCA2E: "scrambled ones as two PCMU levels (level octet b1)",
    0xCAEB: "12-bit register, six bits per six-symbol frame, rotated by six",
    0xCA22: "scrambled ones as two PCMU levels (level octet from d237)",
    0xCB0C: "six-octet rotation, table at cb06",
    0xCB3D: "constellation training through d229/d0af, size 0013 at start",
}


def main(path, start=0xC915):
    raw = open(path, "rb").read()
    w = struct.unpack("<65536H", raw)
    entries, a = [], start
    while a < start + 40:
        state = w[a]
        if state == 0:
            entries.append({"address": f"{a:04x}", "state": "0000", "meaning": "halt marker (one word)"})
            a += 1
            if a > start + 24 and w[a] == 0:
                break
            continue
        param, duration = w[a + 1], w[a + 2]
        entries.append({"address": f"{a:04x}", "state": f"{state:04x}", "parameter": f"{param:04x}",
                        "duration_symbols": duration, "seconds_at_8000": round(duration / 8000, 4),
                        "meaning": STATES.get(state, "")})
        a += 3
    tables = {"d235_d239_octets": [f"{x:02x}" for x in w[0xD235:0xD23A]],
              "cb06_cb0b_octets": [f"{x:02x}" for x in w[0xCB06:0xCB0C]],
              "quad_B_table_c9e0": None}
    return {"dump": path, "script_start": f"{start:04x}", "entries": entries, "tables": tables}


if __name__ == "__main__":
    if len(sys.argv) < 2:
        raise SystemExit(__doc__)
    print(json.dumps(main(sys.argv[1], int(sys.argv[2], 16) if len(sys.argv) > 2 else 0xC915), indent=1))
