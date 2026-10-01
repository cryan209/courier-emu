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
