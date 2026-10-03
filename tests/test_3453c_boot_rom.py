import struct
from pathlib import Path

from courier_emu import boot_rom
from courier_emu.bridge import CourierDspBridge
from courier_emu.dsp import NativeC5x
from courier_emu.xmf import XmfImage

ROOT = Path(__file__).resolve().parents[1]


def test_recovered_rom_executes_download_into_shared_external_ram():
    bridge = CourierDspBridge(XmfImage.load(ROOT / '2_3_33.XMF'))
    try:
        assert bridge.core.model == 'c52'
        assert bridge.core.program(0) == 0x7980
        resident = bridge.expected_bootstrap
        for offset in range(0, 32, 8):
            bridge.window[:] = resident[offset:offset + 8]
            bridge.board3453.commit()
        assert bridge.board3453.words_verified == 16
        expected = struct.unpack('<16H', resident[:32])
        assert tuple(bridge.core.program(0x1000 + i) for i in range(16)) == expected
        assert tuple(bridge.core.data(0x1000 + i) for i in range(16)) == expected
        assert bridge.core.io(0x57) & 0x100 == 0
    finally:
        bridge.core.close()


def test_c52_rom_does_not_create_saram_or_courier_external_alias():
    with NativeC5x.from_program(0x6000, b'', model='c52') as core:
        core.load_rom(boot_rom.mask_rom_3453c())
        core.load_program(struct.pack('<2H', 0xAE07, 0x0030), 0x6000)
        core.set_pc(0x6000)
        core.step(1)
        for program, data in [(0x1000, 0x800), (0x8000, 0x8000)]:
            core.load_program(struct.pack('<H', 0x1234), program)
            core.set_data(data, 0x5678)
            assert core.program(program) == 0x1234
            assert core.data(data) == 0x5678


def test_3453c_guest_mailbox_alias_resets_free_slots_and_acknowledges_input():
    # SPLK @7d,#ffff; OUT @7d,8057; IN @7e,805e; SPLK @7d,#1; OUT @7d,8057.
    code = struct.pack('<10H', 0xAE7D, 0xFFFF, 0x0C7D, 0x8057,
                       0xAF7E, 0x805E, 0xAE7D, 1, 0x0C7D, 0x8057)
    with NativeC5x.from_program(0x6000, code, model='c52') as core:
        core.configure_host_mailbox()
        core.set_host_io_base(0x8000)
        core.set_pc(0x6000)
        core.step(2)
        assert core.io(0x8057) == core.io(0x57) == 6
        core.set_io(0x805E, 0x0088)
        core.set_io(0x8057, 7)
        core.step(3)
        assert core.data(0x7E) == 0x0088
        assert core.io(0x8057) == 6
