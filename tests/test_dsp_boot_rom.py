"""Boot the measured 20.16 MHz DSP through its ROM and ASIC windows."""
from pathlib import Path

import pytest

from courier_emu.bridge import CourierDspBridge
from courier_emu.images import load_image

ROOT = Path(__file__).resolve().parents[1]


@pytest.mark.parametrize('path', [
    'IDSDL302.ROM',
    'artifacts/courier-board-21210-capture-403/courier-board.rom',
])
def test_window_download_executes_boot_rom(path):
    bridge = CourierDspBridge(load_image(ROOT / path))
    try:
        assert bridge.boot_rom_enabled
        assert bridge.core.state()['pc'] == 0
        assert bridge.core.data(0x9000) == 0  # resident is not preloaded
        payload = bridge.expected_bootstrap
        for repeat in range(2):
            for offset in range(0, len(payload), 8):
                strobe, ports = bridge.transfer.windows[(offset // 8) % 2]
                chunk = payload[offset:offset + 8].ljust(8, b'\xff')
                for port, byte in zip(range(ports, ports + 16, 2), chunk):
                    bridge.write(port, 1, byte)
                bridge.write(bridge.transfer.command_port, 1, strobe)
            assert bridge.bootstrap_match
            assert bridge.bootstraps == repeat + 1
            bridge.write(bridge.transfer.command_port, 1, bridge.transfer.checksum_strobe)
            assert bridge.core.state()['pc'] == 0  # no forced firmware entry
            bridge.core.step(1_500_000)
            serial = bridge.core.serial_state()
            assert serial['line_frame_interrupts'] > 100
            assert serial['dxr_writes'] > 100
            assert serial['spc_writes'] == 5  # one prologue, no reset runaway
            assert bridge.core.data(0x9000) == int.from_bytes(payload[0x2000:0x2002], 'little')
            mapping = bridge.core.memory_map()
            assert mapping['iptr'] == 0
            assert mapping['mpmc'] == 0
            assert mapping['program_rom'] > 400_000
            assert mapping['rom_holes'] == 0
    finally:
        bridge.core.close()


def test_idle_wakes_without_vectoring_when_globally_masked():
    from courier_emu.dsp import NativeC5x
    class Image:
        def dsp_program_segments(self):
            # SPLK IMR,#8; SETC INTM; IDLE; NOP
            return [(0, bytes.fromhex('04ae080041be22be008b'))]
    core = NativeC5x(Image())
    try:
        core.step(3)
        assert core.state()['idle']
        pc = core.state()['pc']
        core.interrupt(2)  # not enabled in IMR
        assert core.state()['idle']
        core.interrupt(3)
        assert not core.state()['idle']
        assert core.state()['pc'] == pc
        assert core.state()['flags'] & 0x80
    finally:
        core.close()


def test_pmst_visibility_is_not_the_vector_pointer():
    from courier_emu.dsp import NativeC5x
    class Image:
        def dsp_program_segments(self):
            return [(0, bytes.fromhex('070840be008b'))]  # LAMM PMST; CLRC INTM; NOP
    core = NativeC5x(Image())
    try:
        core.host_write(7, 0x0780)  # AVIS and reserved bits, no IPTR
        core.step(1)
        assert core.state()['acc'] == 0x0080
        assert core.memory_map()['iptr'] == 0
        core.host_write(7, 0x0880)
        core.set_pc(0)
        core.step(1)
        assert core.state()['acc'] == 0x0880
        assert core.memory_map()['iptr'] == 1
        core.host_write(4, 8)
        core.step(1)
        core.interrupt(3)
        assert core.state()['pc'] == 0x0808
    finally:
        core.close()
