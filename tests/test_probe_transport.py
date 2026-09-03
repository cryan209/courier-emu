from pathlib import Path

import pytest

from courier_emu.dsp import NativeC5x
from courier_emu.probe_transport import (
    ENTRY, KERNEL, REFERENCE_START, REFERENCE_END, ROUTINES,
    TransportMachine, build_diagnostic, parse_capture,
)

REFERENCE = Path(__file__).resolve().parents[1] / "IDSDL302.ROM"


@pytest.fixture(scope="module")
def diagnostic():
    pytest.importorskip("unicorn")
    if not REFERENCE.exists():
        pytest.skip("reference ROM not available")
    return build_diagnostic(REFERENCE)


@pytest.mark.parametrize("mapped", [True, False])
def test_download_mailbox_and_uart_carry_actual_dsp_sample(diagnostic, monkeypatch, mapped):
    # An emulator memory peek must never substitute for hardware readback.
    def forbid_peek(*args):
        raise AssertionError("DSP data memory bypassed the mailbox")
    monkeypatch.setattr(NativeC5x, "data", forbid_peek)
    result = TransportMachine(diagnostic, rom_mapped=mapped).run()
    assert result["status"] == "complete"
    assert result["sample_matches_fixture"]
    assert result["download_matches_kernel"] and result["download_checksum_matches"]
    assert result["packets"] == result["acks"] == 56
    assert result["source_file_unchanged"] and result["flash_array_unchanged"]
    assert not result["hardware_tested"] and not result["uploadable_sdl_image"]
    assert not result["capture"]["rom_access_proven"]
    resets = [e["requested_origin"] for e in result["events"] if e["kind"] == "dsp-reset"]
    assert resets == [0xFFF8, 0x8000]
    writes = [e for e in result["events"] if e["kind"] == "io-write"]
    assert all(e["size"] == 1 for e in writes)
    strobes = [e["value"] for e in writes if e["port"] == 0x18 and e["value"] in (1, 2)]
    assert strobes == [1, 2] * (1 + len(diagnostic.probe.payload) // 16)


@pytest.mark.parametrize("fault,status", [
    ("reset", "reset-timeout"), ("checksum", "download-timeout"),
    ("no-dsp", "mailbox-timeout"), ("tag", "mailbox-tag-error"),
    ("stale", "mailbox-tag-error"), ("uart", "uart-timeout"),
])
def test_transport_failures_cannot_report_a_dump(diagnostic, fault, status):
    result = TransportMachine(diagnostic, fault=fault).run()
    assert result["status"] == status
    assert result["capture"] is None
    assert "CDRP1 DONE" not in result["serial_text"]
    assert result["source_file_unchanged"] and result["flash_array_unchanged"]
    with pytest.raises(ValueError):
        parse_capture(result["serial_text"].encode())


def test_capture_rejects_missing_duplicate_corrupt_and_failed_records(diagnostic):
    capture = TransportMachine(diagnostic).run()["serial_text"].encode()
    assert parse_capture(capture)["status"] == "sample-captured"
    variants = [capture[:-14], capture + capture,
                capture.replace(b"0009:2468", b"0008:2468"),
                capture.replace(b"0010:1234", b"0010:1235"),
                capture.replace(b"SUM:5350", b"SUM:0000"),
                capture.replace(b"CDRP1 DONE", b"CDRP1 ERR TAG"),
                capture + b"\xff"]
    for data in variants:
        with pytest.raises(ValueError):
            parse_capture(data)


def test_relocation_only_changes_two_source_segment_immediates(diagnostic):
    original = diagnostic.reference.data[REFERENCE_START:REFERENCE_END]
    actual = diagnostic.ram[ROUTINES - ENTRY:ROUTINES - ENTRY + len(original)]
    assert actual == original.replace(bytes.fromhex("b808a9"), bytes.fromhex("b80003"))
    assert diagnostic.ram[KERNEL - ENTRY:] == diagnostic.probe.payload


def test_wrong_reference_is_rejected(tmp_path, diagnostic):
    path = tmp_path / "wrong.ROM"
    changed = bytearray(diagnostic.reference.data)
    changed[0x30000] ^= 1
    path.write_bytes(changed)
    with pytest.raises(ValueError, match="unsupported reference"):
        build_diagnostic(path)


def test_instruction_budget_does_not_pass(diagnostic):
    result = TransportMachine(diagnostic).run(10)
    assert result["status"] == "instruction-limit"
    assert result["capture"] is None


def test_dsp_sender_waits_for_mailbox_ack(diagnostic):
    core = NativeC5x(diagnostic.probe)
    try:
        core.set_pc(0x8000)
        core.set_io(0x57, 0)
        core.step(200)
        writes = lambda: [(e["port"], e["value"]) for e in core.io_events() if e["write"]]
        assert writes() == []
        for tag, data in ((0x5200, 0xC051), (0x5201, 1)):
            before = len(writes())
            core.set_io(0x57, 2)
            for _ in range(50):
                core.step(1)
                if len(writes()) == before + 3:
                    break
            assert writes()[before:] == [(0x5E, tag), (0x5F, data), (0x57, 2)]
            core.set_io(0x57, 0)
            core.step(100)
            assert len(writes()) == before + 3
    finally:
        core.close()
