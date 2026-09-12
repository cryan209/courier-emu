import json

import pytest
import courier_emu.flash_dump as fd

from courier_emu import flash_dump as dump


def response(address, data, terminal="ERROR"):
    command = dump.command_for(address)
    segment = (address & 0xF0000) >> 4
    offset = address & 0xFFFF
    lines = [command.lower()] + [
        f"  {segment:04X}:{offset+i:04X}    {data[i:i+16].hex(' ').upper()}"
        for i in range(0, 256, 16)
    ] + [terminal]
    return ("\r\n".join(lines) + "\r\n").encode()






def test_address_sequence_covers_flash_without_offset_wrap():
    commands = [dump.command_for(a) for a in range(0x80000, 0x100000, 256)]
    assert len(set(commands)) == 2048
    assert commands[0] == "ATGLK2=8000:0000"
    assert commands[255:257] == ["ATGLK2=8000:FF00", "ATGLK2=9000:0000"]
    assert commands[-1] == "ATGLK2=F000:FF00"
    for address in (0xFF00, 0x7FF00, 0x100000, 0x80001):
        with pytest.raises(ValueError):
            dump.command_for(address)


class FakePort:
    device = "test-port"
    baud = 115200

    def __init__(self, unstable=False):
        self.commands = []
        self.unstable = unstable
        first, reset = dump.TARGETS[("7.3.14", "3.0.13", "20.16")]
        self.pages = {
            0x80000: first + bytes(256 - len(first)),
            0x80100: bytes(240) + reset,
        }

    def drain(self):
        return b""

    def query(self, command):
        self.commands.append(command)
        if command == "AT":
            return b"AT\r\nOK\r\n"
        if command == "ATI7":
            return b"Courier\r\nClock Freq 20.16Mhz\r\nFlash ROM 512k\r\nSupervisor rev 7.3.14\r\nDSP rev 3.0.13\r\nOK\r\n"
        segment, offset = (int(v, 16) for v in command.split("=")[1].split(":"))
        address = segment * 16 + offset
        data = self.pages[address]
        if self.unstable and self.commands.count(command) % 2 == 0:
            data = data[:128] + bytes([data[128] ^ 1]) + data[129:]
        return response(address, data)








def test_known_firmware_targets_are_selected_by_revision():
    stock = (b"Courier\r\nClock Freq 20.16Mhz\r\nFlash ROM 512k\r\n"
             b"Supervisor rev 7.3.14\r\nDSP rev 3.0.13\r\nOK\r\n")
    idsdl = (b"Courier\r\nClock Freq 20.16Mhz\r\nFlash ROM 512k\r\n"
             b"Supervisor rev 7.4.16\r\nDSP rev 3.1.2\r\nOK\r\n")
    assert dump.validate_identity(stock)[1] == ("7.3.14", "3.0.13", "20.16")
    assert dump.validate_identity(idsdl)[1] == ("7.4.16", "3.1.2", "20.16")
    # The two builds end with different reset vectors, so the anchor check
    # cannot pass for a board running firmware it was not selected for.
    assert dump.TARGETS[("7.3.14", "3.0.13", "20.16")] != dump.TARGETS[("7.4.16", "3.1.2", "20.16")]





# The tick probe's commands, and everything it must never send.











