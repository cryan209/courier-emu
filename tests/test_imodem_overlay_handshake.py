from pathlib import Path

import pytest

from courier_emu.dsp import NativeC5x
from courier_emu.imodem_dsp import ImodemDsp
from courier_emu.nac import NacImage


def test_call_overlay_command_acknowledges_supervisor_pre_download_strobe():
    endpoint = ImodemDsp()
    endpoint.core = NativeC5x.from_program(0, b"")
    endpoint.reset_status = False
    try:
        endpoint.core.set_io(0x57, 2)
        # b152c requests completion before b152e queues command 2. The
        # supervisor cannot enter its sender until b1545 reads bit 2 ready.
        endpoint.write(0x1e, 4)
        assert endpoint.read(0x1e) & 4 == 0
        endpoint._command(2, 0xa000)
        assert endpoint.read(0x1e) & 4 == 4
        assert endpoint.core.io(0x57) == 2
        assert endpoint.core.data(0x0bff) == 0xa000
        endpoint._sync()
        assert endpoint.tx_ready
        assert endpoint.consumed == 1

        # The final strobe belongs to the DSP, and must not rewind the
        # destination advanced by its BLDP loop or erase its completion bit.
        endpoint.core.set_data(0x0bff, 0xd658)
        endpoint.write(0x1e, 4)
        assert endpoint.core.data(0x0bff) == 0xd658
        assert endpoint.core.io(0x57) == 0x0402

        # The recovery startup pair must return to the resident dispatcher.
        endpoint._command(2, 0xd100)
        assert endpoint.core.io(0x57) & 1
        assert endpoint.core.data(0x0bff) == 0xd658
    finally:
        endpoint.close()


@pytest.mark.parametrize('status', [0x0402, 0x0702, 0x07b2])
def test_foreground_ack_matches_native_resident_and_preserves_other_status(status):
    # Execute the original resident's command-2 handler as the reference,
    # rather than checking only the Python shortcut's chosen bit mask.
    image = NacImage.load(Path(__file__).resolve().parents[1] / 'Ie030002.nac')
    _, payload = image.flatten()
    resident = payload[0xa8690:0xa8690 + 0x247c]
    endpoint = ImodemDsp()
    endpoint.core = NativeC5x.from_program(0x8000, resident)
    endpoint.reset_status = False
    try:
        with NativeC5x.from_program(0x8000, resident) as reference:
            reference.configure_host_mailbox()
            reference.set_data(0x7a, 0xa000)  # dispatcher argument cell
            reference.set_io(0x57, status)
            reference.set_pc(0x840f)
            reference.step(3)  # SMMR destination, LACC 0700, SAMM PA7
            assert reference.state()['pc'] == 0x8414

            endpoint.core.set_io(0x57, status)
            endpoint._command(2, 0xa000)
            assert endpoint.core.data(0x0bff) == reference.data(0x0bff) == 0xa000
            assert endpoint.core.io(0x57) == reference.io(0x57)
            assert endpoint.read(0x1e) & 7 == 7
            endpoint._sync()
            assert endpoint.tx_ready
    finally:
        endpoint.close()


def test_new_dsp_does_not_inherit_foreground_overlay_ownership():
    endpoint = ImodemDsp()
    endpoint.core = NativeC5x.from_program(0, b'')
    endpoint.reset_status = False
    endpoint._command(2, 0xa000)
    endpoint.close()
    endpoint.core = NativeC5x.from_program(0, b'')
    try:
        endpoint.core.set_data(0x0bff, 0x1234)
        endpoint.core.set_io(0x57, 2)
        endpoint.write(0x1e, 4)
        endpoint._command(2, 0x9260)
        # Startup must reach the native dispatcher and consume its command;
        # a stale foreground shortcut would erase both pending bits here.
        assert endpoint.core.io(0x57) == 0x0403
        assert endpoint.core.data(0x0bff) == 0x1234
    finally:
        endpoint.close()
