"""Locate the resident ROM's DTE entry points without borrowing another build's RAM.

These signatures describe the 302/403 resident supervisor. Unknown layouts
return None so the CPU-only terminal adapter cannot scribble into their state.
"""
from dataclasses import dataclass
import re


@dataclass(frozen=True)
class RomSerialLayout:
    callbacks: int
    receive_isr: int
    attention: int
    command_idle: int
    command_collecting: int
    mode: int
    output_flags: int


def locate_rom_serial(data: bytes, callbacks: int) -> RomSerialLayout | None:
    resident = data[:0x10000]
    patterns = {
        "isr": rb"\xfc\x60\xa1\x68\xff\xff\x16" + re.escape(callbacks.to_bytes(2, "little")),
        "attention": rb"\xc6\x06..\x00\x3c\x61\x74.\x3c\x41",
        "mode": rb"\xc6\x06(..)\x02\x33\xc0\xa3",
        "output": rb"\xf6\x06(..)\x01\xf9\x74.\x80\x3e",
        # Find the routine that installs the command-mode dispatcher.
        # Require its indexed event-table prologue as well.
        "command": rb"\x33\xc0\xe8..\xc7\x06" + re.escape((callbacks + 4).to_bytes(2, "little")) + rb"(..)\xe8..\xf8\xc3",
    }
    matches = {name: list(re.finditer(pattern, resident, re.S))
               for name, pattern in patterns.items()}
    commands = [m for m in matches["command"]
                if resident[int.from_bytes(m[1], "little"):][:8] == b"\x32\xe4\x93\xd1\xe3\x2e\xff\xa7"]
    matches["command"] = commands
    if any(len(found) != 1 for found in matches.values()):
        return None
    m = {name: found[0] for name, found in matches.items()}
    idle = int.from_bytes(m["command"][1], "little")
    table = int.from_bytes(resident[idle + 8:idle + 10], "little")
    event_one = int.from_bytes(resident[table + 2:table + 4], "little")
    handler = resident[event_one:event_one + 9]
    if (handler[:5] != b"\x93\xc7\x06" + (callbacks + 4).to_bytes(2, "little")
            or handler[7:] != b"\xf8\xc3"):
        return None
    collecting = int.from_bytes(handler[5:7], "little")
    return RomSerialLayout(callbacks, m["isr"].start(), m["attention"].start(),
                           idle, collecting,
                           int.from_bytes(m["mode"][1], "little"),
                           int.from_bytes(m["output"][1], "little"))
