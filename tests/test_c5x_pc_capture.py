import struct

from courier_emu.dsp import NativeC5x


def test_capture_observes_pre_store_state_without_changing_execution():
    program = struct.pack('<3H', 0xB907, 0x9060, 0xBE22)
    with NativeC5x.from_program(0x6000, program, rebuild=True) as core:
        core.set_data(0x60, 42)
        core.set_data(0x11, 0xDEAD)  # Raw backing cell differs from AR1.
        core.set_pc_capture(0x6001, [0x60, 0x11])
        core.set_pc(0x6000)
        core.step(3)
        capture, = core.pc_captures()
        assert capture[2:] == [7, 0, 1, 42, 0]
        assert core.data(0x60) == 7
        assert core.state()['idle']
        core.clear_pc_captures()
        assert core.pc_captures() == []
