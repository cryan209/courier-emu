import json

import pytest

from courier_emu import flash_dump as flash, ram_dump as ram

# The fake board below answers ATI7 as 7.3.14 / 3.0.13, so its anchors are that
# build's entry in TARGETS rather than a hard-coded pair.
_FIRST, _RESET = flash.TARGETS[("7.3.14", "3.0.13", "20.16")]


def raw_page(address, data):
    command = flash.command_for(address, allow_ram=True, allow_upper_ram=True)
    segment, offset = command.split("=")[1].split(":")
    lines = [command] + [f"{segment}:{int(offset, 16)+i:04X}  {data[i:i+16].hex(' ')}"
                         for i in range(0, 256, 16)] + ["ERROR"]
    return ("\r\n".join(lines) + "\r\n").encode()


def test_ram_requires_opt_in_and_never_reads_peripheral_window():
    for address in (0, 0x700, 0xFE00):
        with pytest.raises(ValueError):
            flash.command_for(address)
        raw = raw_page(address, bytes(256))
        assert flash.parse_page(raw, address, allow_ram=True) == (bytes(256), "ERROR")
    for address in (-256, 1, 0xFF00, 0x10000, 0x7FF00, 0x100000):
        with pytest.raises(ValueError):
            flash.command_for(address, allow_ram=True)
    port = flash.SerialPort("unused", 115200, allow_ram=True)
    for command in ("ATGLK2W0000:0752=00", "ATGLK2O10,00", "ATZ", "ATGLK2=0000:FF00",
                    "ATGLK2=0010:0000"):
        with pytest.raises(ValueError):
            port.query(command)




class FakePort:
    device, baud = "fake", 115200

    def __init__(self, broken=False):
        self.calls = {}
        self.broken = broken

    def drain(self):
        return b""

    def query(self, command):
        if command == "AT":
            return b"OK\r\n"
        if command == "ATI7":
            return b"Courier\r\nClock Freq 20.16Mhz\r\nFlash ROM 512k\r\nRam 64k\r\nSupervisor rev 7.3.14\r\nDSP rev 3.0.13\r\nOK\r\n"
        segment, offset = (int(s, 16) for s in command.split("=")[1].split(":"))
        address = segment * 16 + offset
        self.calls[address] = self.calls.get(address, 0) + 1
        if self.broken and address == 0x100:
            return b"ERROR\r\n"
        data = bytearray(256)
        if address == 0x80000:
            data[:len(_FIRST)] = _FIRST
        elif address == 0xFFF00:
            data[-16:] = _RESET
        elif address == 0x700:
            data[0x52:0x64] = bytes.fromhex("f3081c") * 6
        elif address == 0x200:
            data[0] = self.calls[address]
        return raw_page(address, data)








