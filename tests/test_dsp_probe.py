from pathlib import Path

import pytest

from courier_emu.dsp_probe import (
    COMPLETE, CONTROL, HEADER, build_probe, inspect_buffer, simulate_probe, verify_download,
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
