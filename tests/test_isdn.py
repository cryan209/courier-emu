from __future__ import annotations

from pathlib import Path
import unittest

from courier_emu.isdn import (
    BOARD_STATUS_PORT,
    DEFAULT_COUNTER_IRQ,
    ENTRY_OFFSET,
    ENTRY_SEGMENT,
    UART_A_BASE,
    UART_LSR,
    IsdnMachine,
)
from courier_emu.nac import NacImage
from courier_emu.pic import MASTER_COMMAND, MASTER_DATA


ROOT = Path(__file__).resolve().parents[1]
IMAGE = ROOT / "Ie030002.nac"

try:  # pragma: no cover - the import is the check
    import unicorn  # noqa: F401

    HAVE_UNICORN = True
except ImportError:  # pragma: no cover
    HAVE_UNICORN = False


class PortRoutingTests(unittest.TestCase):
    """Port decode is testable without executing anything."""

    def setUp(self) -> None:
        self.machine = IsdnMachine.__new__(IsdnMachine)
        IsdnMachine.__init__(self.machine, None)  # type: ignore[arg-type]

    def test_board_status_answers_the_ready_bits(self) -> None:
        self.assertEqual(self.machine.read_port(BOARD_STATUS_PORT), 0x07)

    def test_uart_line_status_reports_the_transmitter_free(self) -> None:
        self.assertEqual(self.machine.read_port(UART_A_BASE + UART_LSR), 0x60)

    def test_uart_writes_are_captured_as_serial(self) -> None:
        for byte in b"OK":
            self.machine.write_port(UART_A_BASE, byte)
        self.assertEqual(bytes(self.machine.serial[UART_A_BASE]), b"OK")

    def test_download_ports_are_captured(self) -> None:
        self.machine.write_port(0x40, 0xAA)
        self.machine.write_port(0x42, 0xBB)
        self.assertEqual(bytes(self.machine.download), b"\xaa\xbb")

    def test_pit_and_pic_ports_reach_their_models(self) -> None:
        self.machine.write_port(MASTER_COMMAND, 0x11)
        self.machine.write_port(MASTER_DATA, 0x20)
        self.assertEqual(self.machine.pic.master.vector_base, 0x20)

    def test_seeded_ports_answer_unmodelled_reads(self) -> None:
        machine = IsdnMachine(None, port_values={0x1234: 0x5A})  # type: ignore[arg-type]
        self.assertEqual(machine.read_port(0x1234), 0x5A)
        self.assertEqual(machine.read_port(0x1235), 0)

    def test_timer_wraps_raise_the_configured_line(self) -> None:
        machine = IsdnMachine(None, counter_irq={0: 10})  # type: ignore[arg-type]
        machine.pit.write(0xF043, 0x34, 0)
        machine.pit.write(0xF040, 0x44, 0)
        machine.pit.write(0xF040, 0x07, 0)
        machine.instructions = 5_000_000
        machine.poll_timers()
        self.assertGreater(machine.timer_ticks, 0)
        # IRQ10 arrives on the slave, which also asserts the master's cascade.
        self.assertTrue(machine.pic.slave.irr & (1 << 2))
        self.assertTrue(machine.pic.master.irr & (1 << 2))


class DefaultsTests(unittest.TestCase):
    def test_entry_is_the_recovered_initialiser(self) -> None:
        self.assertEqual((ENTRY_SEGMENT, ENTRY_OFFSET), (0x4030, 0x0000))

    def test_the_tick_defaults_to_the_line_the_sweep_identified(self) -> None:
        self.assertEqual(DEFAULT_COUNTER_IRQ, {0: 10})


@unittest.skipUnless(IMAGE.exists(), "ISDN Courier NAC image is not present")
@unittest.skipUnless(HAVE_UNICORN, "executing the image needs Unicorn")
class BootTests(unittest.TestCase):
    """The boot milestones, each independently checkable."""

    @classmethod
    def setUpClass(cls) -> None:
        cls.image = NacImage.load(IMAGE)
        cls.machine = IsdnMachine(cls.image)
        cls.result = cls.machine.run(12_000_000)

    def test_it_runs_without_faulting(self) -> None:
        self.assertEqual(self.result.status, "instruction-limit")
        self.assertIsNone(self.result.error)

    def test_it_clears_ram_and_relocates(self) -> None:
        # The clear loop runs one iteration per paragraph of the low 256 KiB and
        # the relocation copy moves 0x41c0 bytes, so both show up as hot code.
        self.assertGreater(self.machine.pc_counts[0x4031D], 100_000)
        self.assertGreater(self.machine.pc_counts[0x40367], 8_000)

    def test_it_leaves_the_flash_image_and_runs_relocated_code(self) -> None:
        base, flat = self.machine._flat_image()
        ran_in_ram = [pc for pc in self.machine.pc_counts if pc < base]
        self.assertTrue(ran_in_ram)

    def test_vrtx_supervisor_calls_are_made(self) -> None:
        self.assertIn("0x30", self.result.software_interrupts)
        self.assertGreater(self.result.software_interrupts["0x30"], 10)

    def test_the_pit_is_programmed_with_the_expected_divisors(self) -> None:
        initial = [counter.initial for counter in self.machine.pit.counters]
        self.assertEqual(initial, [1860, 8928, 35714])
        self.assertTrue(all(counter.mode == 2 for counter in self.machine.pit.counters))

    def test_the_pic_is_programmed_to_the_pc_at_vector_map(self) -> None:
        self.assertEqual(self.machine.pic.master.vector_base, 0x20)
        self.assertEqual(self.machine.pic.slave.vector_base, 0x28)

    def test_irq0_is_left_masked_which_is_why_the_tick_is_elsewhere(self) -> None:
        self.assertTrue(self.machine.pic.master.mask & 0x01)

    def test_hardware_interrupts_are_delivered(self) -> None:
        self.assertGreater(self.result.hardware_interrupts, 100)
        self.assertGreater(self.result.timer_ticks, 100)

    def test_the_tick_delay_loop_completes(self) -> None:
        # 0xa45df is the compare in the tick-delay routine and 0xa45e5 is the
        # instruction after it. Reaching the exit is what separates a delivered
        # tick from a spin, and is the evidence the IRQ10 default rests on.
        self.assertGreater(self.machine.pc_counts[0xA45E5], 0)

    def test_the_device_download_stream_is_captured(self) -> None:
        self.assertGreater(self.result.download_bytes, 10_000)

    def test_result_serialises(self) -> None:
        value = self.result.to_dict()
        self.assertEqual(value["entry"], "4030:0000")
        self.assertIn("pit", value)
        self.assertIn("pic", value)


@unittest.skipUnless(IMAGE.exists(), "ISDN Courier NAC image is not present")
@unittest.skipUnless(HAVE_UNICORN, "executing the image needs Unicorn")
class TickRoutingTests(unittest.TestCase):
    def test_irq0_leaves_the_delay_loop_spinning(self) -> None:
        # The contrast that identifies IRQ10: with the PC-AT routing the tick is
        # masked, so the delay loop never completes.
        machine = IsdnMachine(NacImage.load(IMAGE), counter_irq={0: 0})
        machine.run(12_000_000)
        self.assertEqual(machine.pc_counts[0xA45E5], 0)
        self.assertGreater(machine.pc_counts[0xA45DF], 1_000_000)
