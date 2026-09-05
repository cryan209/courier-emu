import json

import pytest

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


@pytest.mark.parametrize("terminal", ["OK", "ERROR"])
def test_full_page_is_valid_even_with_error_status(terminal):
    data = bytes(range(256))
    assert dump.parse_page(response(0xFFF00, data, terminal), 0xFFF00) == (data, terminal)


@pytest.mark.parametrize("mutation", [
    lambda r: r.replace(b"8000:0010", b"8000:0000"),
    lambda r: r.replace(b"8000:0010", b"9000:0010"),
    lambda r: r.replace(b"10 11 12", b"10 12"),
    lambda r: r.replace(b"ERROR\r\n", b""),
    lambda r: r + r,
    lambda r: r + b"\xff",
])
def test_bad_or_stale_reply_is_rejected(mutation):
    with pytest.raises(ValueError):
        dump.parse_page(mutation(response(0x80000, bytes(range(256)))), 0x80000)


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
        first, reset = dump.TARGETS[("7.3.14", "3.0.13")]
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


def test_collection_preserves_copies_and_checks_before_publishing(tmp_path, monkeypatch):
    monkeypatch.setattr(dump, "LENGTH", 512)
    port = FakePort()
    output = tmp_path / "capture"
    report = dump.collect(port, output)
    assert report["status"] == "complete"
    assert (output / "courier-board.rom").read_bytes() == b"".join(port.pages.values())
    assert report["pages_verified"] == 2 and report["anchors_rechecked"]
    assert len(list((output / "responses").glob("*.txt"))) == 8
    assert report["terminal_status_counts"] == {"ERROR": 8}
    assert port.commands[:2] == ["AT", "ATI7"]
    assert all(c.startswith("ATGLK2=") for c in port.commands[2:])
    with pytest.raises(FileExistsError):
        dump.collect(port, output)


def test_disagreeing_reads_never_publish_a_complete_image(tmp_path, monkeypatch):
    monkeypatch.setattr(dump, "LENGTH", 512)
    output = tmp_path / "capture"
    with pytest.raises(RuntimeError, match="could not verify"):
        dump.collect(FakePort(unstable=True), output)
    report = json.loads((output / "manifest.json").read_text())
    assert report["status"] == "incomplete"
    assert len(report["failed_attempts"]) == 3
    assert not (output / "courier-board.rom").exists()


def test_wrong_target_identity_rejected():
    with pytest.raises(ValueError, match="ATI7 does not match"):
        dump.validate_identity(b"Courier\r\nClock Freq 25Mhz\r\nOK\r\n")


def test_known_firmware_targets_are_selected_by_revision():
    stock = (b"Courier\r\nClock Freq 20.16Mhz\r\nFlash ROM 512k\r\n"
             b"Supervisor rev 7.3.14\r\nDSP rev 3.0.13\r\nOK\r\n")
    idsdl = (b"Courier\r\nClock Freq 20.16Mhz\r\nFlash ROM 512k\r\n"
             b"Supervisor rev 7.4.16\r\nDSP rev 3.1.2\r\nOK\r\n")
    assert dump.validate_identity(stock)[1] == ("7.3.14", "3.0.13")
    assert dump.validate_identity(idsdl)[1] == ("7.4.16", "3.1.2")
    # The two builds end with different reset vectors, so the anchor check
    # cannot pass for a board running firmware it was not selected for.
    assert dump.TARGETS[("7.3.14", "3.0.13")] != dump.TARGETS[("7.4.16", "3.1.2")]


def test_unknown_firmware_is_refused_rather_than_guessed():
    other = (b"Courier\r\nClock Freq 20.16Mhz\r\nFlash ROM 512k\r\n"
             b"Supervisor rev 9.9.9\r\nDSP rev 1.2.3\r\nOK\r\n")
    with pytest.raises(ValueError, match="unknown firmware"):
        dump.validate_identity(other)



# The tick probe's commands, and everything it must never send.

def test_timing_commands_are_settings_and_local_tests():
    for command in ("ATE0", "ATQ0", "ATV1", "ATX3", "AT&T1", "AT&T0",
                    "ATS18?", "ATS18=5", "ATS6=2", "ATS7=30", "ATS18=255"):
        assert dump.TIMING_COMMAND.fullmatch(command), command


def test_nvram_writes_and_dialling_are_not_timing_commands():
    for command in ("AT&W", "AT&W0", "ATZ", "ATDT5551212", "ATD5551212",
                    "ATS18=256", "ATS0=1", "AT&F"):
        assert dump.TIMING_COMMAND.fullmatch(command) is None, command


def test_the_off_hook_list_carries_no_digits():
    for command in ("ATD", "ATH", "ATH0"):
        assert dump.OFF_HOOK_COMMAND.fullmatch(command), command
    for command in ("ATDT5551212", "ATD1", "ATDP9", "ATD,"):
        assert dump.OFF_HOOK_COMMAND.fullmatch(command) is None, command


def test_call_results_terminate_a_dial_wait():
    for reply in (b"\r\nNO DIAL TONE\r\n", b"\r\nNO CARRIER\r\n",
                  b"\r\nBUSY\r\n", b"\r\nOK\r\n"):
        assert dump.CALL_TERMINAL.search(reply), reply
    assert dump.CALL_TERMINAL.search(b"\r\nCONNECT 33600\r\n") is None
