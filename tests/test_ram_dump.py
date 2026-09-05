import json

import pytest

from courier_emu import flash_dump as flash, ram_dump as ram

# The fake board below answers ATI7 as 7.3.14 / 3.0.13, so its anchors are that
# build's entry in TARGETS rather than a hard-coded pair.
_FIRST, _RESET = flash.TARGETS[("7.3.14", "3.0.13")]


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


def test_settings_decoder_handles_redundancy_without_inventing_missing_values():
    # All three encodings decode to 1: ror(f3,2)+5, rol(08,1)-15, 1c^1d.
    data = bytes.fromhex("f3081c") * 6
    records = ram.decode_settings(data)
    assert all(r["value"] == 1 and r["all_copies_agree"] for r in records)
    damaged = ram.decode_settings(bytes.fromhex("f30800") + data[3:])
    assert damaged[1]["value"] == 1 and not damaged[1]["all_copies_agree"]
    invalid = ram.decode_settings(bytes(18))
    assert all(r["value"] is None for r in invalid)


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


def test_live_capture_preserves_differences_and_validates_settings(tmp_path, monkeypatch):
    monkeypatch.setattr(ram, "RAM_END", 0x800)
    output = tmp_path / "ram"
    port = FakePort()
    report = ram.collect(port, output)
    assert report["status"] == "complete" and report["anchors_rechecked"]
    assert report["pages_captured"] == 16 and report["changed_bytes"] == 1
    assert (output / "ram-pass1.bin").read_bytes()[0x200] == 1
    assert (output / "ram-pass2.bin").read_bytes()[0x200] == 2
    assert report["settings_cache"]["matches_between_passes"]
    assert all(r["value"] == 1 for r in report["settings_cache"]["passes"][0]["records"])
    assert json.loads((output / "differences.json").read_text())["physical_addresses"] == [0x200]
    assert len(list((output / "responses").glob("*.txt"))) == 20
    assert 0xFF00 not in port.calls
    with pytest.raises(FileExistsError):
        ram.collect(port, output)


def test_bad_rows_stop_without_publishing_a_pass(tmp_path, monkeypatch):
    monkeypatch.setattr(ram, "RAM_END", 0x800)
    output = tmp_path / "ram"
    with pytest.raises(RuntimeError, match="invalid RAM capture response"):
        ram.collect(FakePort(broken=True), output)
    report = json.loads((output / "manifest.json").read_text())
    assert report["status"] == "incomplete" and len(report["failed_attempts"]) == 3
    assert not (output / "ram-pass1.bin").exists()
    assert (output / "blocks" / "pass1-00000.bin").exists()


def test_upper_range_is_separate_opt_in_with_no_wrap_or_peripheral_reads():
    for address in (0x10000, 0x1FF00):
        with pytest.raises(ValueError):
            flash.command_for(address, allow_ram=True)
        assert flash.parse_page(raw_page(address, bytes(256)), address,
                                allow_upper_ram=True) == (bytes(256), "ERROR")
    assert flash.command_for(0x1FF00, allow_upper_ram=True) == "ATGLK2=1000:FF00"
    for address in (0xFF00, 0x20000, 0x10001):
        with pytest.raises(ValueError):
            flash.command_for(address, allow_ram=True, allow_upper_ram=True)


def test_upper_capture_keeps_physical_offsets_and_brackets_aliases(tmp_path):
    class UpperPort(FakePort):
        def query(self, command):
            if not command.startswith("ATGLK2="):
                return super().query(command)
            segment, offset = (int(s, 16) for s in command.split("=")[1].split(":"))
            address = segment * 16 + offset
            if address >= 0x80000:
                return super().query(command)
            self.calls[address] = self.calls.get(address, 0) + 1
            data = bytearray([(address & 0xFFFF) >> 8] * 256)
            if address == 0x10200:
                data[0] = self.calls[address]
            return raw_page(address, data)

    output = tmp_path / "upper"
    port = UpperPort()
    report = ram.collect(port, output, upper=True)
    assert report["status"] == "complete" and report["physical_start"] == 0x10000
    assert report["length_per_pass"] == 65536 and report["pages_captured"] == 512
    assert not report["failed_attempts"] and report["changed_bytes"] == 1
    assert json.loads((output / "differences.json").read_text())["physical_addresses"] == [0x10200]
    assert (output / "ram-pass1.bin").stat().st_size == 65536
    assert len(report["alias_samples"]) == 6
    assert all(r["matches_lower_before"] and r["matches_lower_after"] for r in report["alias_samples"])
    assert "settings_cache" not in report
    assert not list(output.glob("settings-cache*"))
    assert 0xFF00 not in port.calls and 0x20000 not in port.calls
    assert len(list((output / "responses").glob("*.txt"))) == 534
