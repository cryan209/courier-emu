from courier_emu.am79c30 import Am79C30, REGISTERS


def test_iom2_slots_do_not_follow_mux_register_order():
    chip = Am79C30()
    chip.activate()
    chip.blocks[0xC0] = b'\x07'
    chip.blocks[0x41] = b'\x27'  # B2 -> Be, deliberately programmed first.
    chip.blocks[0x42] = b'\x16'  # B1 -> Bd.
    assert chip.peripheral_slots(2) == [6, 7]
    chip.queue_bearer(1, b'\x12')
    chip.queue_bearer(2, b'\x34')
    output = chip.clock_bearer({6: 0x56, 7: 0x78})
    assert [output[p] for p in chip.peripheral_slots(2)] == [0x12, 0x34]
    assert chip.bearer_tx[1] == b'\x56'
    assert chip.bearer_tx[2] == b'\x78'


def test_port_modes_and_ic_selection_define_fixed_slots():
    chip = Am79C30()
    chip.blocks[0xC0] = b'\x00'
    assert chip.peripheral_slots(3) == [None, None, None]
    chip.blocks[0xC0] = b'\x01'
    assert chip.peripheral_slots(3) == [6, 7, 8]
    chip.blocks[0xC0] = b'\x07'
    assert chip.peripheral_slots(6) == [6, 7, None, None, 8, None]
    chip.blocks[0xC0] = b'\x0f'
    assert chip.peripheral_slots(6) == [6, 7, None, None, None, 8]


def test_peripheral_control_register_addresses_match_datasheet():
    assert REGISTERS[0xC8][0] == 'PP_PPCR2'
    assert REGISTERS[0xC9][0] == 'PP_PPCR3'
    assert REGISTERS[0xC4][0] == 'PP_CI0_DATA'
