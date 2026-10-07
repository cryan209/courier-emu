"""The native lane port models answer what the Python handlers answer."""
import ctypes

from courier_emu.dsp import ImodemHostIo, ImodemShared, LaneHostIo, NativeC5x


def access(model, direction, port, value=0, now=0, size=1):
    out = ctypes.c_uint16()
    function = ctypes.CFUNCTYPE(
        ctypes.c_int, ctypes.c_void_p, ctypes.c_int, ctypes.c_uint16,
        ctypes.c_int, ctypes.c_uint16, ctypes.c_uint64,
        ctypes.POINTER(ctypes.c_uint16))(model.function)
    served = function(model.context, direction, port, size, value, now,
                      ctypes.byref(out))
    return served, out.value


def core():
    return NativeC5x.from_program(0, b"\x00\x00")


def test_analog_lanes_read_the_dsp_cells_and_commit_window_bytes():
    window = bytearray(b"\xff" * 8)
    other = bytearray(b"\xff" * 8)
    dsp = core()
    model = LaneHostIo()
    try:
        for index in range(12):
            model.set_lane(index, window if index < 8 else other, index % 8)
        model.configure(dsp.handle, True, command_port=0x18, ack_port=0x1A,
                        lane_first=0x40, banks=6, dsp_first=0x58,
                        dsp_status=0x56)
        # Window stores land in the supervisor's own bytes.
        assert access(model, 2, 0x42, 0x5A)[0] == 1
        assert window[1] == 0x5A
        # Odd lane ports and ports it does not model are declined.
        assert access(model, 2, 0x41, 1)[0] == 0
        assert access(model, 1, 0x20)[0] == 0
        # A command strobe publishes the selected banks and raises their bits.
        dsp.set_io(0x56, 0)
        window[0], window[1] = 0x34, 0x12
        assert access(model, 2, 0x18, 0x01)[0] == 1
        assert dsp.io(0x58) == 0x1234 and dsp.io(0x56) & 1
        # The ack port raises the high half.
        assert access(model, 2, 0x1A, 0x02)[0] == 1
        assert dsp.io(0x56) >> 8 == 0x02
        # Status reads are the inverted bits with the idle pattern on top.
        served, value = access(model, 1, 0x18)
        assert served and value == 0xC0 | (~dsp.io(0x56) & 0x3F)
        served, value = access(model, 1, 0x1A)
        assert served and value == 0xC0 | (~(dsp.io(0x56) >> 8) & 0x3F)
        served, value = access(model, 1, 0x40)
        assert served and value == dsp.io_output(0x58) & 0xFF
        reads, writes, last, seen = model.take_counts()
        assert reads[0x18] == 1 and writes[0x18] == 1 and last[0x1A] == 0x02
        # Not live: the status ports go back to Python.
        model.configure(dsp.handle, False, command_port=0x18, ack_port=0x1A,
                        lane_first=0x40, banks=6, dsp_first=0x58,
                        dsp_status=0x56)
        assert access(model, 1, 0x18)[0] == 0
    finally:
        model.close()
        dsp.close()


def test_imodem_model_shares_state_and_holds_back_for_python():
    shared = ImodemShared()
    dsp = core()
    model = ImodemHostIo(shared, cycles_per_instruction=8.064, read_quantum=32)
    try:
        # Lane stores need no core, and live in the shared bytes.
        assert access(model, 2, 0x44, 0xAB)[0] == 1
        assert shared.lanes[0x44] == 0xAB and shared.lane_writes == 1
        assert access(model, 2, 0x58, 1)[0] == 0
        assert access(model, 1, 0x18)[0] == 0          # no live core yet
        model.configure(dsp.handle, True)
        shared.dsp_instructions = 100
        dsp.set_io(0x56, 0)
        # A read inside the quantum answers without running the C5x.
        served, value = access(model, 1, 0x18, now=110)
        assert served and value == 0xC0 | 0x3F
        assert shared.dsp_instructions == 100
        # The loader's reset request is Python's.
        assert access(model, 2, 0x18, 0xFF, now=110)[0] == 0
        # A latch write publishes lane words into the DSP's cells.
        shared.lanes[0x40], shared.lanes[0x42] = 0x21, 0x43
        assert access(model, 2, 0x18, 0x01, now=110)[0] == 1
        assert dsp.io(0x58) == 0x4321 and dsp.io(0x56) & 1
        assert shared.latch_writes == 1
        # Work the harness owes stops further native service until it is done.
        shared.needs_service = 1
        assert access(model, 1, 0x18, now=500)[0] == 0
        shared.needs_service = 0
        assert access(model, 1, 0x18, now=110)[0] == 1
        reads, writes = model.take_counts()
        assert reads[0x18] == 2 and writes[0x44] == 1 and writes[0x18] == 1
    finally:
        model.close()
        dsp.close()


def test_imodem_model_serves_the_host_port_status_and_strobes():
    shared = ImodemShared()
    dsp = core()
    model = ImodemHostIo(shared, cycles_per_instruction=8.064, read_quantum=32)
    try:
        model.configure(dsp.handle, True)
        shared.dsp_instructions = 100
        shared.tx_ready = 0
        dsp.set_io(0x57, 0)
        # 0x1c reads the mailbox status word: transmit-ready, reply-present.
        served, value = access(model, 1, 0x1C, now=110)
        assert served and value == 1 and shared.tx_ready == 1
        shared.rx_present = 1
        assert access(model, 1, 0x1C, now=110) == (1, 3)
        # A reply the harness has yet to offer is its to deal with.
        shared.rx_present = 0
        dsp.set_io(0x57, 0)
        dsp.set_io(0x5F, 0x1234)
        # Writes to 0x1c that commit or acknowledge are declined; others no-ops.
        assert access(model, 2, 0x1C, 0x00, now=110)[0] == 1
        assert access(model, 2, 0x1C, 0x01, now=110)[0] == 0
        assert access(model, 2, 0x1C, 0x02, now=110)[0] == 0
        # 0x1e: strobes publish the window's words and raise the status bits.
        shared.lanes[0x40], shared.lanes[0x42] = 0x21, 0x43
        shared.lanes[0x48], shared.lanes[0x4A] = 0x65, 0x87
        assert access(model, 2, 0x1E, 0x01, now=110)[0] == 1
        assert dsp.io(0x58) == 0x4321 and dsp.io(0x57) == 0x0100
        assert access(model, 2, 0x1E, 0x02, now=110)[0] == 1
        assert dsp.io(0x5A) == 0x8765 and dsp.io(0x57) == 0x0300
        served, value = access(model, 1, 0x1E, now=110)
        assert served and value == (~0x03 & 7)
        # The log the harness replays: writes (8|value) and reads, in order.
        assert list(shared.ov_log[:shared.ov_len]) == [8 | 1, 8 | 2, 4]
        reads, writes = model.take_counts()
        assert reads[0x1C] == 2 and reads[0x1E] == 1
        assert writes[0x1C] == 1 and writes[0x1E] == 2
        # Not live: Python's.
        model.configure(dsp.handle, False)
        assert access(model, 1, 0x1E, now=110)[0] == 0
    finally:
        model.close()
        dsp.close()


def test_analog_model_serves_the_mailbox_status_ports_from_the_latch():
    dsp = core()
    model = LaneHostIo()
    try:
        model.configure(dsp.handle, False, command_port=0x18, ack_port=0x1A,
                        lane_first=0x40, banks=6, dsp_first=0x58,
                        dsp_status=0x56)
        # Until the harness says the runtime protocol is up, they are Python's.
        assert access(model, 1, 0x1C)[0] == 0
        assert access(model, 1, 0x1E)[0] == 0
        model.configure_mailbox(runtime=True, pending=False, inbound=False,
                                overlay=True, overlay_status=0x07,
                                zero_ok=True, status_cell=0x57)
        # Room for a host word unless the DSP has one pending; bit 1 when the
        # DSP's send-complete flag (inverted in the latch) is up.
        dsp.set_io(0x57, 0x0006)
        assert access(model, 1, 0x1C) == (1, 1)
        dsp.set_io(0x57, 0x0001)
        assert access(model, 1, 0x1C) == (1, 2)
        dsp.set_io(0x57, 0x0004)
        assert access(model, 1, 0x1C) == (1, 3)
        model.configure_mailbox(runtime=True, pending=True, inbound=True,
                                overlay=False, overlay_status=0x07,
                                zero_ok=True, status_cell=0x57)
        dsp.set_io(0x57, 0x0006)
        assert access(model, 1, 0x1C) == (1, 2)
        assert access(model, 1, 0x1E)[0] == 0
        # Writes that do nothing are served; commits and strobes are not.
        assert access(model, 2, 0x1C, 0)[0] == 1
        assert access(model, 2, 0x1C, 2)[0] == 0
        assert access(model, 2, 0x1E, 0)[0] == 1
        assert access(model, 2, 0x1E, 4)[0] == 0
        reads, writes, last, seen = model.take_counts()
        assert reads[0x1C] == 4 and writes[0x1C] == 1 and writes[0x1E] == 1
        assert seen[0x1C] == 1 and last[0x1C] == 0
    finally:
        model.close()
        dsp.close()
