"""The real image is the execution fixture; small RAM programs test write guards."""
from hashlib import sha256
from pathlib import Path
import importlib.util
import json
from unittest.mock import patch

import pytest

from courier_emu.cli import main
from courier_emu.recovery import (
    BANK_OFFSET, BOOTSTRAP, COPY_SIZE, ENTRY_OFFSET, FLASH_BASE, FLASH_SIZE,
    PROMPT, RecoveryImage, RecoveryMachine, decode_payload,
)

IMAGE = Path(__file__).resolve().parents[1] / "SV25.XMD"


@pytest.fixture(scope="module")
def image():
    if not IMAGE.exists():
        pytest.skip("SV25.XMD is not available")
    return RecoveryImage.load(IMAGE)


@pytest.fixture(scope="module")
def execution(image):
    if importlib.util.find_spec("unicorn") is None:
        pytest.skip("Unicorn execute extra is not installed")
    return RecoveryMachine(image).run()


def test_decode_resolves_independent_anchors(image):
    assert sha256(image.source).hexdigest() == "43503d82caae5377d67c61f4f44d73e6a19e15c61b2cb706a70c6f1b88ef413f"
    assert image.payload.startswith(bytes.fromhex("bd0b00e9930f0d0a") + b"Copyright")
    assert image.payload[BANK_OFFSET:BANK_OFFSET + 4] == bytes.fromhex("05030000")
    assert image.payload[BANK_OFFSET + ENTRY_OFFSET:][:len(BOOTSTRAP)] == BOOTSTRAP
    assert image.payload[0x7DB14:0x7DB18] == bytes.fromhex("32ff007e")
    assert image.block_keys[0x7DB00 // 128:0x7DC80 // 128] == (0xA1, 0, 0xF3)
    assert image.payload[0x7DBFF:0x7DC07] == bytes.fromhex("f3a533c08ed8cd13")
    # Decoding changes only the in-memory view; the file and raw source agree.
    assert IMAGE.read_bytes() == image.source
    assert image.source[0x7DC80:0x7DC87] == bytes.fromhex("56c0337d2b3ee0")


def test_invalid_images_are_rejected(tmp_path, image):
    path = tmp_path / "bad.xmd"
    for data in (b"", image.source[:-1], bytes(len(image.source)),
                 image.source[:128] + bytes(FLASH_SIZE)):
        path.write_bytes(data)
        with pytest.raises(ValueError):
            RecoveryImage.load(path)
    with pytest.raises(ValueError):
        decode_payload(b"short")


def test_boot_executes_setup_relocation_and_serial_path(execution, image):
    result = execution
    assert result["status"] == "sdl-xmodem-prompt", result["error"]
    assert result["serial_text"].encode() == b"\r\n\r\n" + PROMPT
    assert result["registers"]["cs"] == 0
    assert result["registers"]["ip"] == 0x12BB  # actual TX store, not a string scan
    assert result["relocation_verified"]
    assert result["flash_array_unchanged"] and result["source_file_unchanged"]
    events = result["events"]
    writes = [e for e in events if e["kind"] == "io-write" and e["setup"]]
    assert [e["size"] for e in writes] == [2] * 36 + [1] * 9
    assert (result["setup_word_writes"], result["setup_byte_writes"]) == (36, 9)
    # Compare every executed table entry to the independently parsed table.
    bank = image.payload[BANK_OFFSET:]
    expected = [(int.from_bytes(bank[n:n + 2], "little"),
                 int.from_bytes(bank[n + 2:n + 4], "little"))
                for n in range(0x1B14, 0x1BA4, 4)]
    expected += [(int.from_bytes(bank[n:n + 2], "little"), bank[n + 2])
                 for n in range(0x1BA4, 0x1BBF, 3)]
    assert [(e["port"], e["value"]) for e in writes] == expected
    copy = next(e for e in events if e["kind"] == "ram-relocation")
    assert copy["size"] == COPY_SIZE and copy["verified"]
    assert bytes(e["value"] for e in events if e["kind"] == "serial-rx") == b"AT~X!\r"
    assert bytes(e["value"] for e in events if e["kind"] == "serial-tx") == b"\r\n\r\n" + PROMPT
    assert [e["value"] for e in events if e["kind"] == "flash-command"] == [0x90, 0xFF]
    assert not any(e["kind"] == "blocked-flash-write" for e in events)
    # No CRC shortcut: compare the CPU's result to a separate reflected update.
    crc = 0xFFFF
    for byte in image.payload[0x40000:0x77FFE]:
        crc ^= byte
        for _ in range(8):
            crc = (crc >> 1) ^ (0x8408 if crc & 1 else 0)
    crc_event = next(e for e in events if e["kind"] == "application-crc")
    assert crc_event["computed"] == crc
    assert crc_event["stored"] == 0xFFFF
    assert not crc_event["matches"]


def new_machine(image, **kwargs):
    pytest.importorskip("unicorn")
    return RecoveryMachine(image, **kwargs)


def test_instruction_budget_does_not_claim_prompt(image):
    result = new_machine(image).run(20)
    assert result["status"] == "instruction-limit"
    assert result["instructions"] == 20
    assert result["serial_text"] == ""
    assert result["setup_word_writes"] < 36
    assert result["flash_array_unchanged"]


def test_without_serial_stimulus_stops_at_real_input_wait(image):
    result = new_machine(image, serial_stimulus=False).run()
    assert result["status"] == "serial-input-wait"
    assert result["registers"]["ip"] == 0x875
    assert result["relocation_verified"]
    assert result["serial_text"] == ""
    assert not any(e["kind"] == "serial-rx" for e in result["events"])


@pytest.mark.parametrize("value", [0x40, 0x20, 0x1234, 0x90])
def test_cpu_flash_stores_cannot_change_array(image, value):
    machine = new_machine(image)
    # A real CPU store from RAM to the protected flash mapping must trap. Even
    # an ID opcode is rejected outside the identified firmware probe.
    machine.cpu.mem_write(0x200, b"\x26\xc7\x06\0\0" + value.to_bytes(2, "little"))
    machine._set("cs", 0)
    machine._set("ip", 0x200)
    machine._set("es", 0x8000)
    result = machine.run(10)
    assert result["status"] == "blocked-flash-write"
    assert result["flash_array_unchanged"] and result["source_file_unchanged"]
    assert result["events"][-1]["address"] == FLASH_BASE


def test_budget_during_id_probe_restores_array_view(image):
    machine = new_machine(image)
    machine.cpu.mem_write(0x733, image.payload[BANK_OFFSET + 0x733:BANK_OFFSET + 0x73A])
    machine._set("cs", 0)
    machine._set("ip", 0x733)
    machine._set("es", 0xFFFF)
    result = machine.run(1)
    assert result["status"] == "instruction-limit"
    assert result["flash_array_unchanged"]
    assert any(e["kind"] == "flash-command" for e in result["events"])


def test_unmapped_memory_is_a_reported_stop(image):
    machine = new_machine(image)
    machine.cpu.mem_write(0x200, bytes.fromhex("26a10000"))
    machine._set("cs", 0)
    machine._set("ip", 0x200)
    machine._set("es", 0x4000)
    result = machine.run(10)
    assert result["status"] == "unmapped-access"
    assert result["events"][-1]["address"] == 0x40000


def test_cli_isolates_native_failure(capsys):
    with patch("courier_emu.cli.subprocess.run") as run:
        run.return_value.returncode = -4
        assert main(["recovery-run", str(IMAGE), "--instructions", "0x100"]) == 1
    assert json.loads(capsys.readouterr().out)["status"] == "native-error"
    assert run.call_args.args[0][-1] == "256"


def test_cli_refuses_unbounded_instruction_limit():
    with pytest.raises(SystemExit):
        main(["recovery-run", str(IMAGE), "--instructions", "0"])
