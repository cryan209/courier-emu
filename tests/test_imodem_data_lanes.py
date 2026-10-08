import struct

from courier_emu.dsp import NativeC5x
from courier_emu.imodem_dsp import ImodemDsp


def test_runtime_data_banks_have_separate_holding_registers_and_acknowledgements():
    endpoint = ImodemDsp()
    # Send a word back through bank 5, then acknowledge the incoming word.
    program = (0xbf80, 0x1234, 0x885d, 0xbf80, 0x2020, 0x8856)
    endpoint.core = NativeC5x.from_program(0, struct.pack('<6H', *program))
    endpoint.core.configure_host_mailbox()
    endpoint.reset_status = False
    try:
        endpoint.core.set_io(0x56, 0)
        for bank in range(6):
            endpoint.write(0x40 + 4 * bank, 0x80 + bank)
            endpoint.write(0x42 + 4 * bank, 0xa0 + bank)
        endpoint.write(0x18, 0x3f)
        assert endpoint.read(0x18) == 0xc0
        assert [endpoint.core.io(0x58 + bank) for bank in range(6)] == [
            0xa080 + 0x101 * bank for bank in range(6)
        ]
        endpoint.write(0x1a, 0x3f)
        assert endpoint.read(0x1a) == 0xc0
        endpoint.core.step(6)
        assert endpoint.read(0x18) == 0xe0
        assert endpoint.read(0x1a) == 0xe0
        assert endpoint.read(0x54) == 0x34
        assert endpoint.read(0x56) == 0x12
        assert endpoint.core.io(0x5d) == 0xa585
        endpoint.write(0x1a, 0x20)
        assert endpoint.read(0x1a) == 0xc0
    finally:
        endpoint.close()


def test_stream_word_raises_0x18_bit_7_until_acknowledged():
    # The sender at 0x8980: out *, 0060, then 80 to PA6 (write-one-to-clear).
    endpoint = ImodemDsp()
    program = (0xae7d, 0x1234, 0x0c7d, 0x0060, 0xb980, 0x8856)
    endpoint.core = NativeC5x.from_program(0, struct.pack('<6H', *program))
    endpoint.core.configure_rom_codec()
    endpoint.reset_status = False
    try:
        endpoint.core.set_io(0x56, 0x80)  # acknowledged: room for a word
        assert not endpoint.read(0x18) & 0x80
        endpoint.core.step(4)
        assert endpoint.read(0x18) & 0x80
        assert (endpoint.read(0x62), endpoint.read(0x60)) == (0x12, 0x34)
        # The ISR's acknowledgement is what the resume poll at 0x894a tests.
        endpoint.write(0x18, 0x80)
        assert endpoint.core.io(0x56) & 0x80
        assert not endpoint.read(0x18) & 0x80
    finally:
        endpoint.close()
