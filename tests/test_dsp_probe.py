from pathlib import Path

import pytest

from courier_emu.dsp_probe import (
    COMPLETE, CONTROL, HEADER, build_mapping_probe, build_probe, inspect_buffer,
    inspect_mapping_buffer, simulate_mapping_probe, simulate_probe, verify_download,
)

REFERENCE = Path(__file__).resolve().parents[1] / "IDSDL302.ROM"


def test_probe_reads_rom_and_distinguishes_external_mapping():
    probe = build_probe()
    mapped = simulate_probe(probe, rom_mapped=True)
    unmapped = simulate_probe(probe, rom_mapped=False)
    assert mapped["sample"] != unmapped["sample"]
    for result in (mapped, unmapped):
        assert result["status"] == "sample-captured"
        assert result["sample_matches_fixture"]
        assert result["control_before"] == result["control_after"] == list(CONTROL)
        assert result["complete"]
        assert result["io_events"] == []
        assert not result["rom_access_proven"]


def test_mapping_probe_switches_between_external_and_internal_program_zero():
    probe = build_mapping_probe()
    result = simulate_mapping_probe(probe)
    assert result["status"] == "mapping-samples-captured"
    assert result["control_before"] == result["control_after"] == list(CONTROL)
    assert result["external_matches_fixture"]
    assert result["internal_matches_fixture"]
    assert result["samples_differ"] and result["rom_readable"]
    assert not result["protection_modeled"]
    assert result["io_events"] == []


def test_mapping_probe_rejects_equal_samples_as_inconclusive():
    words = list((0xC052, 2, 0, 16, COMPLETE, 8, 16, 0))
    words += list(CONTROL) + [0xAAAA] * 16 + [0xAAAA] * 16 + list(CONTROL)
    result = inspect_mapping_buffer(words)
    assert result["status"] == "mapping-samples-captured"
    assert not result["samples_differ"] and not result["rom_readable"]


def test_mapping_probe_mailbox_form_sends_all_result_words():
    probe = build_mapping_probe(mailbox=True)
    result = simulate_mapping_probe(probe)
    writes = [event for event in result["io_events"] if event["write"]]
    assert len(probe.words) % 8 == 0
    assert result["status"] == "mapping-samples-captured"
    assert result["external_matches_fixture"] and result["internal_matches_fixture"]
    assert len([event for event in writes if event["port"] == 0x5E]) == 56
    assert len([event for event in writes if event["port"] == 0x5F]) == 56
    assert len([event for event in writes if event["port"] == 0x57]) == 56


def test_reference_cpu_transfers_every_probe_byte_and_checksum():
    pytest.importorskip("unicorn")
    if not REFERENCE.exists():
        pytest.skip("reference ROM not available")
    before = REFERENCE.read_bytes()
    probe = build_probe()
    result = verify_download(REFERENCE, probe)
    assert result["matches_kernel"] and result["checksum_matches"]
    assert bytes.fromhex(result["captured_hex"]) == probe.payload
    assert result["checksum_sent"] == sum(probe.words) & 0xFFFF
    assert REFERENCE.read_bytes() == before
    assert result["source_file_unchanged"]
    assert not result["hardware_launch_proven"] and not result["hardware_readback_proven"]
    assert all(e["size"] == 1 for e in result["writes"])


@pytest.mark.parametrize("index", [0, 4, 8, 48])
def test_bad_markers_or_controls_reject_capture(index):
    words = list(HEADER) + list(CONTROL) + [0] * 32 + list(CONTROL)
    words[4] = COMPLETE
    assert inspect_buffer(words)["status"] == "sample-captured"
    assert not inspect_buffer(words)["rom_access_proven"]  # zero-filled ROM is inconclusive
    words[index] ^= 1
    assert inspect_buffer(words)["status"] == "invalid-or-incomplete"


def test_short_capture_rejected():
    with pytest.raises(ValueError):
        inspect_buffer([0] * 55)
