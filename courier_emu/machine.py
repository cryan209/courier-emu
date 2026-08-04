from __future__ import annotations

from collections import Counter, deque
from dataclasses import asdict, dataclass, field
from typing import Any

from .xmf import FLASH_PHYSICAL_BASE, XmfImage
from .bridge import CourierDspBridge


ADDRESS_SPACE_SIZE = 0x100000
MAX_SERIAL_BYTES = 64 * 1024
MAX_SERIAL_TRACE_EVENTS = 256


def attention_body(command: bytes) -> bytes | None:
    """Return the body accepted by the Courier DTE attention detector."""
    if len(command) >= 2 and command[:2] in (b"AT", b"at"):
        return command[2:]
    return None


@dataclass
class IoEvent:
    direction: str
    port: int
    size: int
    value: int
    pc: int


@dataclass
class MmioEvent:
    direction: str
    address: int
    size: int
    value: int
    pc: int


@dataclass
class RunResult:
    status: str
    instructions: int
    registers: dict[str, int]
    milestones: list[str] = field(default_factory=list)
    io_events: list[IoEvent] = field(default_factory=list)
    mmio_events: list[MmioEvent] = field(default_factory=list)
    io_event_count: int = 0
    mmio_event_count: int = 0
    io_summary: dict[str, int] = field(default_factory=dict)
    output_latches: dict[str, int] = field(default_factory=dict)
    mmio_summary: dict[str, int] = field(default_factory=dict)
    hot_addresses: list[tuple[int, int]] = field(default_factory=list)
    last_addresses: list[int] = field(default_factory=list)
    serial_text: str = ""
    serial_truncated: bool = False
    serial_input_remaining: int = 0
    serial_interrupts: int = 0
    serial_trace: list[str] = field(default_factory=list)
    accelerated_delays: int = 0
    error: str | None = None
    dsp_bridge: dict[str, Any] | None = None
    interrupt_vectors: dict[str, str] = field(default_factory=dict)

    def to_dict(self) -> dict[str, Any]:
        value = asdict(self)
        value["hot_addresses"] = [list(item) for item in self.hot_addresses]
        return value


class CourierMachine:
    """A 1 MiB 80186 execution harness with observable board I/O."""

    def __init__(
        self,
        image: XmfImage,
        *,
        port_values: dict[int, int] | None = None,
        runtime_port_values: dict[int, int] | None = None,
        uart_ports: set[int] | None = None,
        max_io_events: int = 128,
        fast_delays: bool = True,
        with_dsp: bool = False,
        dsp_rx_samples: list[int] | None = None,
        dsp_tx_pcm: str | None = None,
        serial_input: bytes = b"",
    ) -> None:
        self.image = image
        self.port_values = dict(port_values or {})
        self.runtime_port_values = dict(runtime_port_values or {})
        self.output_latches: dict[int, int] = {}
        self.uart_ports = set(uart_ports or set())
        self.max_io_events = max_io_events
        self.fast_delays = fast_delays
        self.io_events: list[IoEvent] = []
        self.mmio_events: list[MmioEvent] = []
        self.io_counts: Counter[tuple[str, int, int]] = Counter()
        self.mmio_counts: Counter[tuple[str, int, int]] = Counter()
        self.serial = bytearray()
        self.serial_truncated = False
        self.serial_rx: deque[int] = deque(serial_input)
        self.serial_interrupts = 0
        self.serial_trace: list[str] = []
        self._serial_started = False
        self._serial_irq_requested = False
        self._serial_in_handler = False
        self._serial_irq_mode: str | None = None
        self._serial_tx_pump = False
        self._serial_empty_probes = 0
        self._serial_cooldown = 0
        self._previous_address: int | None = None
        self.executed: Counter[int] = Counter()
        self.last_addresses: deque[int] = deque(maxlen=64)
        self.instructions = 0
        self.interrupt: int | None = None
        self.accelerated_delays = 0
        self.milestones: list[str] = []
        self.dsp_bridge = (
            CourierDspBridge(image, rx_samples=dsp_rx_samples) if with_dsp else None
        )
        self.dsp_tx_pcm = dsp_tx_pcm
        self._milestone_addresses = {
            0x5B9F0: "supervisor-entry",
            0x69D05: "dsp-transfer",
            0x7E133: "startup-crc",
            0x65512: "main-loop",
        }

    def _capture_serial(self, value: int) -> None:
        if len(self.serial) < MAX_SERIAL_BYTES:
            self.serial.append(value & 0xFF)
        else:
            self.serial_truncated = True

    def _trace_serial(self, event: str) -> None:
        if len(self.serial_trace) < MAX_SERIAL_TRACE_EVENTS:
            self.serial_trace.append(event)

    def run(self, instruction_limit: int = 250_000) -> RunResult:
        try:
            from unicorn import (
                UC_ARCH_X86,
                UC_HOOK_CODE,
                UC_HOOK_INSN,
                UC_HOOK_INTR,
                UC_HOOK_MEM_READ,
                UC_HOOK_MEM_WRITE,
                UC_MODE_16,
                Uc,
                UcError,
            )
            from unicorn.x86_const import (
                UC_X86_INS_IN,
                UC_X86_INS_OUT,
                UC_X86_REG_AX,
                UC_X86_REG_BP,
                UC_X86_REG_BX,
                UC_X86_REG_CS,
                UC_X86_REG_CX,
                UC_X86_REG_DI,
                UC_X86_REG_DS,
                UC_X86_REG_DX,
                UC_X86_REG_ES,
                UC_X86_REG_FLAGS,
                UC_X86_REG_IP,
                UC_X86_REG_SI,
                UC_X86_REG_SP,
                UC_X86_REG_SS,
            )
        except ImportError as exc:
            raise RuntimeError(
                "execution needs Unicorn: install with `python -m pip install '.[execute]'`"
            ) from exc

        uc = Uc(UC_ARCH_X86, UC_MODE_16)
        uc.mem_map(0, ADDRESS_SPACE_SIZE)
        uc.mem_write(FLASH_PHYSICAL_BASE, self.image.data)

        uc.reg_write(UC_X86_REG_CS, self.image.entry_segment)
        uc.reg_write(UC_X86_REG_IP, self.image.entry_offset)
        uc.reg_write(UC_X86_REG_DS, 0)
        uc.reg_write(UC_X86_REG_ES, 0)
        uc.reg_write(UC_X86_REG_SS, 0)
        uc.reg_write(UC_X86_REG_SP, 0xFFFE)

        def current_pc() -> int:
            return ((uc.reg_read(UC_X86_REG_CS) << 4) + uc.reg_read(UC_X86_REG_IP)) & 0xFFFFF

        def reverse_byte(value: int) -> int:
            value = ((value & 0x55) << 1) | ((value >> 1) & 0x55)
            value = ((value & 0x33) << 2) | ((value >> 2) & 0x33)
            return ((value << 4) | (value >> 4)) & 0xFF

        def serial_wire_value(value: int) -> int:
            # Some Courier board revisions wire the UART data bus backwards.
            # The firmware records that variant in bit zero at 0000:067e and
            # reverses every byte in its ISR. Model the wire, while exposing
            # ordinary terminal byte order to callers.
            reversed_bus = bool(bytes(uc.mem_read(0x67E, 1))[0] & 1)
            return reverse_byte(value) if reversed_bus else value

        def inject_serial_interrupt() -> bool:
            vector = bytes(uc.mem_read(0x0E * 4, 4))
            offset = int.from_bytes(vector[:2], "little")
            segment = int.from_bytes(vector[2:], "little")
            if not (offset or segment):
                return False
            flags = uc.reg_read(UC_X86_REG_FLAGS)
            if not flags & 0x0200:
                return False
            ss = uc.reg_read(UC_X86_REG_SS)
            sp = uc.reg_read(UC_X86_REG_SP)
            return_cs = uc.reg_read(UC_X86_REG_CS)
            return_ip = uc.reg_read(UC_X86_REG_IP)

            def push(value: int) -> None:
                nonlocal sp
                sp = (sp - 2) & 0xFFFF
                address = ((ss << 4) + sp) & 0xFFFFF
                uc.mem_write(address, (value & 0xFFFF).to_bytes(2, "little"))

            # 80186 interrupt entry pushes FLAGS, CS, then IP; IRET pops the
            # inverse order. The interrupt controller's EOI remains handled by
            # the firmware at ff02.
            push(flags)
            push(return_cs)
            push(return_ip)
            uc.reg_write(UC_X86_REG_SP, sp)
            uc.reg_write(UC_X86_REG_FLAGS, flags & ~0x0300)
            uc.reg_write(UC_X86_REG_CS, segment)
            uc.reg_write(UC_X86_REG_IP, offset)
            self._serial_irq_mode = "rx" if self.serial_rx else "tx"
            self._serial_in_handler = True
            self._serial_irq_requested = False
            self.serial_interrupts += 1
            self.serial_trace.append(
                f"inject {self._serial_irq_mode} {segment:04x}:{offset:04x} "
                f"return={return_cs:04x}:{return_ip:04x}"
            )
            return True

        def on_code(_uc: Any, address: int, _size: int, _data: Any) -> None:
            if self._serial_started and address == 0x65F03:
                # The physical DTE front-end recognizes the attention prefix
                # before handing a command body to this banked parser. Our
                # direct UART ISR path bypasses that small state machine, so
                # reproduce its observable contract here: the parser receives
                # the bytes after an all-upper or all-lower "AT" prefix.
                length = bytes(_uc.mem_read(0x1CF4, 1))[0]
                command = bytes(_uc.mem_read(0x1CF5, length))
                body = attention_body(command)
                if body is not None:
                    _uc.mem_write(0x1CF5, body + b"\x00\x00")
                    _uc.mem_write(0x1CF4, bytes((len(body),)))
                    self._trace_serial(f"attention body={body!r}")
                    if self.dsp_bridge is not None:
                        self.dsp_bridge.arm_dial_tones(body)
            if self._serial_started and address == 0x5CE2B:
                terminal_value = _uc.reg_read(UC_X86_REG_AX) & 0xFF
                self._capture_serial(terminal_value)
                ss = _uc.reg_read(UC_X86_REG_SS)
                sp = _uc.reg_read(UC_X86_REG_SP)
                stack_address = ((ss << 4) + sp) & 0xFFFFF
                stack = bytes(_uc.mem_read(stack_address, 8))
                words = ",".join(
                    f"{int.from_bytes(stack[index:index + 2], 'little'):04x}"
                    for index in range(0, len(stack), 2)
                )
                self._trace_serial(f"fifo {terminal_value:02x} stack={words}")
            if address == 0x5D5B0 and len(self.serial_trace) < 64:
                self.serial_trace.append("entered-uart-isr")
            if self._serial_in_handler and self._previous_address in (0x5D608, 0x5D640):
                self.serial_trace.append(f"iret {self._previous_address:05x}")
                callbacks = bytes(_uc.mem_read(0x2A8, 6))
                rx_callback = int.from_bytes(callbacks[:2], "little")
                tx_callback = int.from_bytes(callbacks[2:4], "little")
                command_callback = int.from_bytes(callbacks[4:6], "little")
                command_state = bytes(_uc.mem_read(0x1CEE, 7))
                self.serial_trace.append(
                    f"state rxcb={rx_callback:04x} txcb={tx_callback:04x} "
                    f"cmdcb={command_callback:04x} "
                    f"flags={command_state[0]:02x} len={command_state[6]:02x}"
                )
                self._serial_in_handler = False
                self._serial_irq_mode = None
                self._serial_cooldown = 128 if self.serial_rx else 512
            self.instructions += 1
            self.executed[address] += 1
            self.last_addresses.append(address)
            if self.dsp_bridge is not None:
                self.dsp_bridge.clock_x86()
            milestone = self._milestone_addresses.get(address)
            if milestone is not None and milestone not in self.milestones:
                self.milestones.append(milestone)
                if milestone == "main-loop":
                    self.port_values.update(self.runtime_port_values)
            if milestone == "main-loop" and not self._serial_started:
                # The selected UART board normally installs these near-call
                # vectors. With all unknown board-ID inputs reading high, the
                # firmware reaches its dispatcher without selecting a UART
                # variant, leaving null vectors that jump to the fatal entry.
                # Install the standard command-mode RX, empty-TX, and no-op
                # acknowledge callbacks only when board discovery left them
                # unset.
                serial_callbacks = ((0x2A8, 0xACDF), (0x2AA, 0x1FCE), (0x2AE, 0x2088))
                for pointer, fallback in serial_callbacks:
                    if pointer == 0x2A8 and self.serial_rx:
                        _uc.mem_write(pointer, fallback.to_bytes(2, "little"))
                        self.serial_trace.append(f"callback {pointer:03x}={fallback:04x}")
                    elif bytes(_uc.mem_read(pointer, 2)) == b"\x00\x00":
                        _uc.mem_write(pointer, fallback.to_bytes(2, "little"))
                        self.serial_trace.append(f"callback {pointer:03x}={fallback:04x}")
                if self.serial_rx:
                    command_flags = bytes(_uc.mem_read(0x1CEE, 1))[0] | 0x40
                    _uc.mem_write(0x1CEE, bytes((command_flags,)))
                    # a8d9 is the supervisor's command-line-ready state: RX
                    # event 8 (the configured terminator) advances it to a910,
                    # whose next dispatcher poll invokes the AT parser over
                    # the buffer at 1cf5.
                    _uc.mem_write(0x2AC, (0xA8D9).to_bytes(2, "little"))
                    self.serial_trace.append("callback 2ac=a8d9")
                    # With no NVRAM device, the loaded profile leaves Q1
                    # (quiet mode) selected at 092f. A directly attached DTE
                    # starts from the factory Q0 profile so result codes reach
                    # the terminal.
                    _uc.mem_write(0x92F, b"\x00")
                self._serial_started = True
                self._serial_tx_pump = not self.serial_rx
                self._serial_cooldown = 512
            # The fatal-error blinker uses a calibrated self-looping LOOP.
            if self.fast_delays and address == 0x5C772:
                _uc.reg_write(UC_X86_REG_CX, 1)
                self.accelerated_delays += 1
            # The 80186 peripheral block has just been relocated to ff00. The
            # startup waits for timer/status bit 0x20, which a CPU-only core
            # cannot produce.
            if self.fast_delays and address == 0x5BA29:
                value = int.from_bytes(_uc.mem_read(0xFF46, 2), "little")
                _uc.mem_write(0xFF46, (value | 0x20).to_bytes(2, "little"))
                self.accelerated_delays += 1
            # Firmware delay helpers either burn CX or wait for the timer ISR
            # to advance the tick at 0000:0152. Advance both without inventing
            # asynchronous interrupts in the CPU-only harness.
            if self.fast_delays and address == 0x5C0F3:
                _uc.reg_write(UC_X86_REG_CX, 1)
                self.accelerated_delays += 1
            if self.fast_delays and address == 0x5C0E3:
                ah = (_uc.reg_read(UC_X86_REG_AX) >> 8) & 0xFF
                _uc.mem_write(0x152, bytes((ah,)))
                self.accelerated_delays += 1
            if self.fast_delays and address in (0x5D6E5, 0x5D70E, 0x5D734):
                cl = _uc.reg_read(UC_X86_REG_CX) & 0xFF
                _uc.mem_write(0x14E, bytes((cl,)))
                self.accelerated_delays += 1
            # Command-mode initialization also waits directly on the 10 ms
            # timer countdown at 0000:0289 instead of using the delay helper.
            if self.fast_delays and address in (0x5DB9D, 0x5DBE7):
                _uc.mem_write(0x289, b"\x00\x00")
                self.accelerated_delays += 1
            # The same initialization waits for an 80186 peripheral-ready
            # indication in the relocated interrupt-control block.
            if self.fast_delays and address == 0x5CE19:
                value = int.from_bytes(_uc.mem_read(0xFF66, 2), "little")
                _uc.mem_write(0xFF66, (value | 0x08).to_bytes(2, "little"))
                self.accelerated_delays += 1
            if self._serial_started and not self._serial_in_handler:
                if self._serial_cooldown:
                    self._serial_cooldown -= 1
                elif self.serial_rx:
                    if _uc.reg_read(UC_X86_REG_FLAGS) & 0x0200:
                        self._serial_irq_requested = True
                        _uc.emu_stop()
                elif self._serial_tx_pump:
                    tx_callback = int.from_bytes(_uc.mem_read(0x2AA, 2), "little")
                    if tx_callback not in (0, 0x1FCE):
                        if _uc.reg_read(UC_X86_REG_FLAGS) & 0x0200:
                            self._serial_irq_requested = True
                            _uc.emu_stop()
            self._previous_address = address

        def on_in(_uc: Any, port: int, size: int, _data: Any) -> int:
            mask = (1 << (size * 8)) - 1
            if self._serial_started and port == 0 and size == 1:
                value = self.output_latches.get(0, 0) & ~0x08
                if self._serial_irq_mode == "rx" and self.serial_rx:
                    value |= 0x08
                if len(self.serial_trace) < 64:
                    self.serial_trace.append(
                        f"status {value:02x} mode={self._serial_irq_mode} pc={current_pc():05x}"
                    )
            elif (
                self._serial_started
                and port == 0x0A
                and size == 1
                and self._serial_irq_mode == "rx"
                and self.serial_rx
            ):
                terminal_value = self.serial_rx.popleft()
                value = serial_wire_value(terminal_value)
                terminator = bytes(_uc.mem_read(0x8E3, 1))[0]
                self.serial_trace.append(
                    f"rx terminal={terminal_value:02x} wire={value:02x} "
                    f"terminator={terminator:02x} pc={current_pc():05x}"
                )
                if not self.serial_rx:
                    self._serial_tx_pump = True
            else:
                bridged = self.dsp_bridge.read(port, size) if self.dsp_bridge is not None else None
                value = self.port_values.get(port, bridged if bridged is not None else mask)
            value &= mask
            self._record_io("in", port, size, value, current_pc())
            return value

        def on_out(_uc: Any, port: int, size: int, value: int, _data: Any) -> None:
            mask = (1 << (size * 8)) - 1
            value &= mask
            self.output_latches[port] = value
            self._record_io("out", port, size, value, current_pc())
            if self.dsp_bridge is not None:
                self.dsp_bridge.write(port, size, value)
            if port in self.uart_ports:
                self._capture_serial(value)
            if (
                self._serial_started
                and self._serial_irq_mode == "tx"
                and port == 0x0A
                and size == 1
            ):
                terminal_value = serial_wire_value(value & 0xFF)
                if terminal_value == 0xFF:
                    self.serial_trace.append(f"tx-idle pc={current_pc():05x}")
                    self._serial_empty_probes += 1
                    self._serial_tx_pump = self._serial_empty_probes < 3
                    self._serial_cooldown = 4096
                else:
                    self.serial_trace.append(f"tx {terminal_value:02x} pc={current_pc():05x}")
                    self._capture_serial(terminal_value)
                    self._serial_empty_probes = 0
                    self._serial_tx_pump = True

        def on_interrupt(_uc: Any, number: int, _data: Any) -> None:
            self.interrupt = number
            _uc.emu_stop()

        def on_mmio_read(_uc: Any, _access: int, address: int, size: int, _value: int, _data: Any) -> None:
            self.mmio_counts[("read", address, size)] += 1
            if len(self.mmio_events) < self.max_io_events:
                value = int.from_bytes(_uc.mem_read(address, size), "little")
                self.mmio_events.append(MmioEvent("read", address, size, value, current_pc()))

        def on_mmio_write(_uc: Any, _access: int, address: int, size: int, value: int, _data: Any) -> None:
            self.mmio_counts[("write", address, size)] += 1
            if len(self.mmio_events) < self.max_io_events:
                self.mmio_events.append(MmioEvent("write", address, size, value, current_pc()))

        uc.hook_add(UC_HOOK_CODE, on_code)
        uc.hook_add(UC_HOOK_INSN, on_in, None, 1, 0, UC_X86_INS_IN)
        uc.hook_add(UC_HOOK_INSN, on_out, None, 1, 0, UC_X86_INS_OUT)
        uc.hook_add(UC_HOOK_INTR, on_interrupt)
        uc.hook_add(UC_HOOK_MEM_READ, on_mmio_read, None, 0xFF00, 0xFFFF)
        uc.hook_add(UC_HOOK_MEM_WRITE, on_mmio_write, None, 0xFF00, 0xFFFF)

        status = "instruction-limit"
        error: str | None = None
        try:
            begin = self.image.entry_physical
            while self.instructions < instruction_limit:
                uc.emu_start(begin, ADDRESS_SPACE_SIZE, count=instruction_limit - self.instructions)
                if not self._serial_irq_requested:
                    break
                if not inject_serial_interrupt():
                    self._serial_cooldown = 64
                    self._serial_irq_requested = False
                begin = current_pc()
                self.serial_trace.append(f"resume {begin:05x}")
            if self.interrupt is not None:
                status = "software-interrupt"
            elif self.instructions < instruction_limit:
                status = "stopped"
            elif "main-loop" in self.milestones:
                status = "main-loop"
        except UcError as exc:
            status = "emulation-error"
            error = str(exc)

        register_ids = {
            "ax": UC_X86_REG_AX,
            "bx": UC_X86_REG_BX,
            "cx": UC_X86_REG_CX,
            "dx": UC_X86_REG_DX,
            "si": UC_X86_REG_SI,
            "di": UC_X86_REG_DI,
            "bp": UC_X86_REG_BP,
            "sp": UC_X86_REG_SP,
            "cs": UC_X86_REG_CS,
            "ip": UC_X86_REG_IP,
            "ds": UC_X86_REG_DS,
            "es": UC_X86_REG_ES,
            "ss": UC_X86_REG_SS,
            "flags": UC_X86_REG_FLAGS,
        }
        registers = {name: uc.reg_read(reg) for name, reg in register_ids.items()}
        final_callbacks = bytes(uc.mem_read(0x2A8, 6))
        self.serial_trace.append(
            "final callbacks="
            + ",".join(
                f"{int.from_bytes(final_callbacks[index:index + 2], 'little'):04x}"
                for index in range(0, 6, 2)
            )
        )
        serial_settings = (0x652, 0x92E, 0x92F, 0x8ED, 0x1FEC, 0x1CF0)
        self.serial_trace.append(
            "final settings="
            + ",".join(f"{address:04x}:{bytes(uc.mem_read(address, 1))[0]:02x}" for address in serial_settings)
        )
        if self.interrupt is not None:
            error = f"software interrupt {self.interrupt:#x}"
        bridge_result = asdict(self.dsp_bridge.status()) if self.dsp_bridge is not None else None
        if self.dsp_bridge is not None and self.dsp_tx_pcm:
            self.dsp_bridge.save_tx_pcm(self.dsp_tx_pcm)
        vector_data = bytes(uc.mem_read(0, 0x400))
        interrupt_vectors: dict[str, str] = {}
        for vector in range(256):
            offset = int.from_bytes(vector_data[vector * 4 : vector * 4 + 2], "little")
            segment = int.from_bytes(vector_data[vector * 4 + 2 : vector * 4 + 4], "little")
            if offset or segment:
                interrupt_vectors[f"{vector:#04x}"] = f"{segment:04x}:{offset:04x}"
        if self.dsp_bridge is not None:
            self.dsp_bridge.close()
        return RunResult(
            status=status,
            instructions=self.instructions,
            registers=registers,
            milestones=self.milestones,
            io_events=self.io_events,
            mmio_events=self.mmio_events,
            io_event_count=sum(self.io_counts.values()),
            mmio_event_count=sum(self.mmio_counts.values()),
            io_summary=self._summarize(self.io_counts),
            output_latches={
                f"{port:#06x}": value for port, value in sorted(self.output_latches.items())
            },
            mmio_summary=self._summarize(self.mmio_counts),
            hot_addresses=self.executed.most_common(20),
            last_addresses=list(self.last_addresses),
            serial_text=self.serial.decode("ascii", "backslashreplace"),
            serial_truncated=self.serial_truncated,
            serial_input_remaining=len(self.serial_rx),
            serial_interrupts=self.serial_interrupts,
            serial_trace=self.serial_trace,
            accelerated_delays=self.accelerated_delays,
            error=error,
            dsp_bridge=bridge_result,
            interrupt_vectors=interrupt_vectors,
        )

    def _record_io(self, direction: str, port: int, size: int, value: int, pc: int) -> None:
        self.io_counts[(direction, port, size)] += 1
        if len(self.io_events) < self.max_io_events:
            self.io_events.append(IoEvent(direction, port, size, value, pc))

    @staticmethod
    def _summarize(counts: Counter[tuple[str, int, int]]) -> dict[str, int]:
        ordered = sorted(counts.items(), key=lambda item: (-item[1], item[0]))
        return {
            f"{direction} {address:#06x}/{size}": count
            for (direction, address, size), count in ordered
        }
