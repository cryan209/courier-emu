"""The Am79C30's direct registers, exercised the way the firmware drives them.

Each test walks the sequence the firmware's own code walks, at the addresses
named in courier_emu/am79c30.py, so a change that breaks one of these breaks
the part's agreement with the ISR rather than an invented contract.
"""
from courier_emu.am79c30 import (
    Am79C30, COMMAND_PORT, DATA_PORT, DCB_PORT, DER_PORT, DSR1_PORT, DSR2_PORT,
    DLC_DTCR, DSR1_RX_FRAME_END, DSR1_TX_FRAME_DONE, DSR2_RX_BYTE,
    DSR2_RX_LAST_BYTE, DSR2_TX_ROOM, F1_INACTIVE, F7_ACTIVATED, IR_DSR1,
    IR_LIU, IR_RX_BYTE, LIU_LSR,
)


def read_register(dsc: Am79C30, register: int, count: int = 1) -> bytes:
    dsc.write(COMMAND_PORT, register)
    return bytes(dsc.read(DATA_PORT) for _ in range(count))


def drain_frame(dsc: Am79C30) -> bytes:
    """The receive loop at 71e64: read DCRB, then DSR2, until the frame ends."""
    out = bytearray()
    while True:
        out.append(dsc.read(DCB_PORT))
        status = dsc.read(DSR2_PORT)
        if status & DSR2_RX_LAST_BYTE:
            return bytes(out)
        if not status & DSR2_RX_BYTE:
            return bytes(out)


def test_line_state_is_reported_as_the_firmware_decodes_it():
    dsc = Am79C30()
    assert dsc.liu_state == F1_INACTIVE
    # The resting handset is on hook, which is the persistent LSR bit 6.
    assert read_register(dsc, LIU_LSR) == b"\x40"

    dsc.set_liu_state(F7_ACTIVATED)
    # 70eb3: state = (LSR & 7) + 2, and 7 is the activated state that admits
    # D-channel transmission and brings layer 2 up.
    assert (read_register(dsc, LIU_LSR)[0] & 7) + 2 == 7
    assert dsc.activated


def test_a_state_change_raises_the_line_status_interrupt():
    dsc = Am79C30()
    assert not dsc.interrupting()
    dsc.set_liu_state(F7_ACTIVATED)
    assert dsc.interrupting()
    # 71ec0: the ISR reads IR at the command port, and reading clears it.
    assert dsc.read(COMMAND_PORT) & IR_LIU
    assert dsc.read(COMMAND_PORT) == 0
    assert not dsc.interrupting()


def test_a_state_that_does_not_change_raises_nothing():
    dsc = Am79C30()
    dsc.set_liu_state(F7_ACTIVATED)
    dsc.read(COMMAND_PORT)
    dsc.set_liu_state(F7_ACTIVATED)
    assert not dsc.interrupting()


def test_a_received_frame_arrives_byte_by_byte_and_ends():
    dsc = Am79C30()
    dsc.deliver_frame(bytes.fromhex("02 01 7f"))
    assert dsc.read(COMMAND_PORT) & IR_RX_BYTE
    assert dsc.read(DSR2_PORT) & DSR2_RX_BYTE

    assert drain_frame(dsc) == bytes.fromhex("02 01 7f")
    # The status handler at 72caf then reads DSR1, DER and DRCR.
    assert dsc.read(DSR1_PORT) & DSR1_RX_FRAME_END
    assert dsc.read(DER_PORT) == 0
    assert read_register(dsc, 0x89, 2) == b"\x03\x00"


def test_two_frames_keep_their_own_boundaries_and_lengths():
    dsc = Am79C30()
    dsc.deliver_frame(b"\x02\x01\x7f")
    dsc.deliver_frame(b"\xfc\xff\x03\x0f")
    assert drain_frame(dsc) == b"\x02\x01\x7f"
    assert read_register(dsc, 0x89, 2) == b"\x03\x00"
    assert drain_frame(dsc) == b"\xfc\xff\x03\x0f"
    assert read_register(dsc, 0x89, 2) == b"\x04\x00"
    assert not dsc.read(DSR2_PORT) & DSR2_RX_BYTE


def test_a_transmitted_frame_closes_when_dtcr_is_written():
    dsc = Am79C30()
    frame = b"\x00\x01\x7f\x73"
    # 71cf3: push bytes while DSR2 says there is room...
    for byte in frame:
        assert dsc.read(DSR2_PORT) & DSR2_TX_ROOM
        dsc.write(DCB_PORT, byte)
    assert dsc.take_sent() == []
    # ...then 71d3c writes the length to DTCR, low byte first.
    dsc.write(COMMAND_PORT, DLC_DTCR)
    dsc.write(DATA_PORT, len(frame) & 0xFF)
    dsc.write(DATA_PORT, len(frame) >> 8)

    assert dsc.take_sent() == [frame]
    assert dsc.take_sent() == []
    assert dsc.read(COMMAND_PORT) & IR_DSR1
    assert dsc.read(DSR1_PORT) & DSR1_TX_FRAME_DONE
    assert dsc.tx_length_mismatch == 0


def test_a_length_that_disagrees_with_the_bytes_is_counted():
    dsc = Am79C30()
    for byte in b"\x01\x02\x03":
        dsc.write(DCB_PORT, byte)
    dsc.write(COMMAND_PORT, DLC_DTCR)
    dsc.write(DATA_PORT, 2)
    dsc.write(DATA_PORT, 0)
    assert dsc.tx_length_mismatch == 1
    assert dsc.take_sent() == [b"\x01\x02"]


def test_the_indirect_file_still_walks_its_block_widths():
    dsc = Am79C30()
    dsc.write(COMMAND_PORT, 0x88)  # DLC_1_7, a seven-register block
    for value in range(1, 9):
        dsc.write(DATA_PORT, value)
    assert dsc.overruns[0x88] == 1
    assert read_register(dsc, 0x88, 7) == bytes(range(1, 8))
