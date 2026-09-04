"""Offline tests for the mailbox driver: no serial device is opened.

What matters about this tool is the exact sequence it puts on the wire and the
ports it will refuse, since both are aimed at a live modem.
"""
import pytest

from courier_emu import dsp_mailbox as mb


class FakePort:
    """Answers every command the way the monitor does, recording the order."""

    def __init__(self, *, ports: dict[int, int] | None = None) -> None:
        self.commands: list[str] = []
        self.ports = dict(ports or {})

    def query(self, command: str, timeout: float = 4.0) -> bytes:
        self.commands.append(command)
        if command == "AT":
            return b"AT\r\r\nOK\r\n"
        read = mb.re.fullmatch(r"ATGLK2I00([0-9A-F]{2})", command)
        if read:
            value = self.ports.get(int(read[1], 16), 0x00)
            return f"{command}\r\r\n{value:02X}\r\nOK\r\n".encode()
        return f"{command}\r\r\nOK\r\n".encode()


def test_the_board_latches_are_refused() -> None:
    port = mb.MailboxPort.__new__(mb.MailboxPort)
    for latch in (0x10, 0x12, 0x14):
        with pytest.raises(ValueError, match="board latches"):
            port.query(f"ATGLK2O00{latch:02X},01")
    with pytest.raises(ValueError, match="not a mailbox register"):
        port.query("ATGLK2O0018,01")


def test_a_read_of_any_port_is_still_allowed() -> None:
    """`ATGLK2B`/`ATGLK2I` sweeps are read-only and already have precedent."""
    port = mb.MailboxPort.__new__(mb.MailboxPort)
    port.fd = None
    with pytest.raises(TypeError):   # reaches the transport, not the gate
        port.query("ATGLK2I0018")


def test_a_message_is_four_data_writes_then_the_commit() -> None:
    session = mb.Session(FakePort())
    session.send(0x0BD0, 0x1234)
    assert session.port.commands == [
        "ATGLK2O0058,D0", "ATGLK2O005A,0B",     # tag word, low byte first
        "ATGLK2O005C,34", "ATGLK2O005E,12",     # value word
        "ATGLK2O001E,00",
        "ATGLK2O001C,01",                        # bit 0 back: the commit
    ]


def test_the_queue_experiment_seeds_the_ring_and_both_pointers() -> None:
    port = FakePort()
    report = mb.run(_identified(mb.Session(port)), experiment="queue",
                    target=0x1234, rounds=1)
    written = [c for c in port.commands if c.startswith("ATGLK2O0058")]
    assert written == ["ATGLK2O0058,D0", "ATGLK2O0058,79", "ATGLK2O0058,78"]
    assert [w["address"] for w in report["writes"]] == ["0BD0", "0079", "0078"]
    assert report["memory_write_commands"] is False


def test_the_queue_experiment_refuses_a_tag_the_supervisor_would_act_on() -> None:
    with pytest.raises(ValueError, match="command mode dispatches"):
        mb.run(_identified(mb.Session(FakePort())), experiment="queue",
               target=0x1283, rounds=1)


def test_the_read_experiment_converts_an_address_to_the_loop_index() -> None:
    port = FakePort()
    report = mb.run(_identified(mb.Session(port)), experiment="read",
                    target=0x0100, rounds=1)
    assert report["writes"][0] == {
        "address": "03E6", "value": "1890",
        "why": "the e732 loop's index, for program word 0100",
    }
    assert "ATGLK2O005C,90" in port.commands and "ATGLK2O005E,18" in port.commands


def test_an_unchanged_window_is_reported_as_no_reply() -> None:
    port = FakePort(ports={0x1C: 0xFD, 0x1E: 0xFF, 0x58: 0x08, 0x5C: 0x02})
    report = mb.run(_identified(mb.Session(port)), experiment="queue",
                    target=0x1234, rounds=4)
    assert report["reply"] is None
    assert report["before"] == report["after"]


def test_a_changed_window_is_decoded_as_a_tag_and_value() -> None:
    port = FakePort(ports={0x58: 0x08})
    session = _identified(mb.Session(port))
    original = session.read_port

    def once(number: int) -> int:
        # The board publishes 1234 in the inbound registers partway through.
        if len(port.commands) > 14 and number in (0x58, 0x5A, 0x5C, 0x5E):
            return {0x58: 0x34, 0x5A: 0x12, 0x5C: 0x9E, 0x5E: 0x22}[number]
        return original(number)

    session.read_port = once
    report = mb.run(session, experiment="queue", target=0x1234, rounds=6)
    assert report["reply"]["tag"] == 0x1234
    assert report["reply"]["value"] == 0x229E


def _identified(session: mb.Session) -> mb.Session:
    """Stand in for the ATI7 gate, which needs a real modem's answer."""
    session.port.query = _with_identity(session.port.query)
    return session


def _with_identity(query):
    identity = (b"ATI7\r\r\nUSRobotics Courier V.Everything\r\n"
                b"Clock Freq             20.16Mhz\r\n"
                b"Flash ROM              512k\r\n"
                b"Supervisor rev         7.3.14\r\n"
                b"DSP rev                3.0.13\r\n\r\nOK\r\n")

    def gate(command: str, timeout: float = 4.0) -> bytes:
        if command == "ATI7":
            query(command, timeout)
            return identity
        return query(command, timeout)

    return gate
