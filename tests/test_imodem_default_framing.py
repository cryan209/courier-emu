from courier_emu.imodem_config import (
    CONFIGURATION_PAGES, DTE_FORMAT_OFFSET, PAGE_SIZE, default_nvram,
    load_nvram, page_is_sealed, set_dte_framing,
)
from courier_emu.isdn import IsdnMachine
from courier_emu.nac import NacImage


def test_default_profile_boots_original_firmware_in_8n1():
    nvram = default_nvram()
    machine = IsdnMachine(NacImage.load('Ie030002.nac'), flash_nvram=nvram)
    machine.run(10_000_000)
    assert machine.dte_framing() == 0
    for index in range(CONFIGURATION_PAGES):
        page = nvram[index * PAGE_SIZE:(index + 1) * PAGE_SIZE]
        assert page_is_sealed(page)


def test_default_store_migrates_framing_but_custom_store_preserves_it(tmp_path):
    original = set_dte_framing(default_nvram(), 3)
    default = tmp_path / 'flashnvram.sav'
    custom = tmp_path / 'custom.sav'
    default.write_bytes(original)
    custom.write_bytes(original)
    migrated = load_nvram(default)
    assert load_nvram(custom) == original
    assert default.read_bytes() == original
    for index in range(CONFIGURATION_PAGES):
        offset = index * PAGE_SIZE + DTE_FORMAT_OFFSET
        assert migrated[offset] & 7 == 0
        assert migrated[offset] & 0xf8 == original[offset] & 0xf8


def test_launcher_defaults_legacy_custom_profile_to_8n1(tmp_path):
    profile = tmp_path / 'legacy.sav'
    legacy = set_dte_framing(default_nvram(), 3)
    for option, expected in [([], '8N1'), (['--dte-framing', 'stored'], '7E1')]:
        profile.write_bytes(legacy)
        result = subprocess.run(
            [sys.executable, '-m', 'courier_emu', 'isdn-run', 'Ie030002.nac',
             '--flash-nvram', str(profile), '--instructions', '10000000', *option],
            capture_output=True, text=True, check=True)
        assert json.loads(result.stdout)['dte_framing'] == expected
import json
import subprocess
import sys
