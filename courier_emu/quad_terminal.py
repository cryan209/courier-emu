"""Opt-in, CPU-only byte terminal for the recovered QF060003 modem.

This substitutes for raw-pin autobaud, not the AT parser or result generator.
It installs the firmware's fixed-baud receive entry and attention callback at
command boundaries. The scheduler, command buffer, command dispatcher, Q/V
settings and every output byte remain firmware-owned. It is deliberately not
an assertion that the Quad DSP, NIC or physical DTE timing is emulated.
"""
from dataclasses import dataclass
from typing import Any


@dataclass
class QuadTerminal:
    next_byte: int = 2_000_000
    interval: int = 100_000
    command_start: bool = True
    received: int = 0
    opened: int = 0
    output_start: int | None = None

    @staticmethod
    def validate(image: Any) -> None:
        # QF's selected modem flash has a different segment and RAM layout
        # from both the chassis controller and the standalone Courier ROMs.
        signatures = {
            0x11b0: '1e60 8cd0 8ed8 fc a168ff c6066f9f04 ff16f481',
            0xfc6d: 'c606b48900 3c61 7404 3c41 7510',
            0x961b: '93 c706f881af92 f8 c3',
            0x9581: 'c706f881e691',
        }
        if (getattr(image, 'quad_role', None) != 'modem'
                or image.load_base != 0xc0000
                or any(image.data[offset:offset + len(bytes.fromhex(code))]
                       != bytes.fromhex(code) for offset, code in signatures.items())):
            raise ValueError('Quad byte terminal requires the recovered QF060003 modem layout')

    def service(self, machine: Any, interrupts_on: bool) -> None:
        if (not interrupts_on or not machine.serial_rx or machine.uart.pending
                or machine.instructions < self.next_byte):
            return
        uc = machine.uc
        state = int.from_bytes(uc.mem_read(0x81f8, 2), 'little')
        # In particular, do not inject the next command while the preceding
        # command is still being parsed or its result is being transmitted.
        if state not in (0x91e6, 0x92af):
            return
        if self.command_start:
            if state != 0x91e6:
                return
            if self.output_start is None:
                self.output_start = len(machine.serial)
            # Same fixed-baud contract installed by QF at e51be and cfc5f.
            # Only the byte front end is replaced; never force command idle.
            uc.mem_write(0x81f4, (0xf85d).to_bytes(2, 'little'))
            uc.mem_write(0x8988, b'\x02')
            uc.mem_write(0x50, bytes.fromhex('a00d41c0'))
            for address, value in ((0xff1a, 8), (0xff3e, 0x6001),
                                   (0xff46, 0x6001)):
                machine.timers.write(address, 2, value, machine.instructions)
                uc.mem_write(address, value.to_bytes(2, 'little'))
            machine.uart.control = 0x21
            uc.mem_write(0xff64, b'\x21\x00')
            self.opened += 1
        byte = machine.serial_rx.popleft()
        machine.uart.deliver(byte)
        self.received += 1
        self.command_start = byte == 13
        self.next_byte = machine.instructions + self.interval
