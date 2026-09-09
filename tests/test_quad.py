"""Quad board isolation and the interrupt contract consumed by its firmware."""
import unittest

from courier_emu.quad_usart import QuadUsart
from courier_emu.quad_board import QuadBoard, WINDOW_BASE, WINDOW_SIZE
from courier_emu.timers import EbInterruptController


class QuadUsartTests(unittest.TestCase):
    def test_disabled_receiver_gates_interrupt_with_unread_fifo(self):
        u = QuadUsart()
        u.write(0x224, 1, 1)
        u.write(0x22a, 1, 2)
        u.queue(b'A')
        u.advance()
        self.assertTrue(u.irq_pending)
        u.write(0x224, 1, 2)
        self.assertFalse(u.irq_pending)
        self.assertEqual(list(u.fifo), [ord('A')])
        u.write(0x224, 1, 1)
        self.assertTrue(u.irq_pending)

    def test_fifo_full_interrupt_and_cts_gating(self):
        u = QuadUsart(cts=False)
        u.write(0x220, 1, 0x40)
        u.write(0x220, 1, 0x10)
        u.write(0x224, 1, 5)
        u.write(0x22a, 1, 3)
        u.queue(b'ABCD')
        for _ in range(2):
            u.advance()
            self.assertFalse(u.irq_pending)
        u.advance()
        self.assertEqual(u.interrupt_status(), 2)
        u.advance()
        self.assertEqual(len(u.fifo), 3)
        self.assertEqual(u.read(0x226, 1), ord('A'))
        self.assertFalse(u.irq_pending)
        u.cts = True
        self.assertEqual(u.interrupt_status(), 1)

    def test_queued_attention_yields_three_interrupts_and_then_quiesces(self):
        u = QuadUsart()
        u.queue(b'22\x02')
        for command in (0x10, 0x20, 0x30, 0x40, 0x50):
            u.write(0x224, 1, command)
        for mode in (0x93, 0x17):
            u.write(0x220, 1, mode)
        u.write(0x22a, 1, 3)
        u.advance()
        self.assertFalse(u.irq_pending)
        u.write(0x224, 1, 1)
        received = bytearray()
        for _ in range(20):
            u.advance()
            if u.irq_pending:
                self.assertEqual(u.read(0x22a, 1), 2)
                self.assertEqual(u.read(0x222, 1) & 1, 1)
                received.append(u.read(0x226, 1))
        self.assertEqual(received, b'22\x02')
        self.assertEqual(u.reads, 3)
        self.assertEqual(u.empty_reads, 0)
        self.assertFalse(u.irq_pending)

    def test_interrupt_mask_does_not_hide_raw_status(self):
        u = QuadUsart()
        u.write(0x224, 1, 5)
        u.queue(b'A')
        u.advance()
        self.assertEqual(u.read(0x22a, 1), 3)
        self.assertEqual(u.read(0x222, 1), 0x0d)
        self.assertFalse(u.irq_pending)
        u.write(0x22a, 1, 2)
        self.assertTrue(u.irq_pending)
        u.read(0x226, 1)
        self.assertFalse(u.irq_pending)
        u.write(0x22a, 1, 1)
        self.assertTrue(u.irq_pending)
        u.write(0x224, 1, 9)
        self.assertFalse(u.irq_pending)

    def test_receiver_reset_discards_fifo_and_mode_pointer_resets(self):
        u = QuadUsart()
        u.write(0x220, 1, 0x93)
        u.write(0x220, 1, 0x17)
        u.write(0x224, 1, 0x10)
        self.assertEqual(u.read(0x220, 1), 0x93)
        self.assertEqual(u.read(0x220, 1), 0x17)
        u.write(0x224, 1, 1)
        u.queue(b'A')
        u.advance()
        u.write(0x224, 1, 0x20)
        self.assertFalse(u.fifo)
        self.assertFalse(u.receiver_enabled)


class QuadMaskTests(unittest.TestCase):
    def test_quad_boot_mask_enables_int0_and_disables_int4(self):
        c = EbInterruptController()
        c.write(0xff08, 0xcc)
        self.assertTrue(c.enabled('int0'))
        self.assertTrue(c.enabled('int1'))
        self.assertTrue(c.enabled('timer'))
        for source in ('int2', 'int3', 'int4', 'serial'):
            self.assertFalse(c.enabled(source))
        c.write(0xff18, 0x1f)
        self.assertFalse(c.enabled('int0'))
        c.write(0xff18, 0x17)
        self.assertTrue(c.enabled('int0'))


class Memory:
    def __init__(self):
        self.data = bytearray(0x100000)
    def mem_read(self, address, size):
        return self.data[address:address+size]
    def mem_write(self, address, data):
        self.data[address:address+len(data)] = data


class QuadMemoryTests(unittest.TestCase):
    def test_channel_code_survives_other_channel_and_dsp_loads(self):
        board, memory = QuadBoard(), Memory()
        board.attach(memory)
        board.write_register(0xff94, 2, 0x4000)
        board.write_register(0xff96, 2, 0x800a)
        for mask, byte in ((0x80, 0x11), (0x40, 0x22), (0x20, 0x33), (0x10, 0x44)):
            board.write(0x280, 1, mask)
            memory.mem_write(WINDOW_BASE + WINDOW_SIZE - 16, bytes([byte])*16)
        board.write_register(0xff94, 2, 0)
        board.write_register(0xff96, 2, 0)
        board.write_register(0xff88, 2, 0x4000)
        board.write_register(0xff8a, 2, 0x800a)
        memory.mem_write(WINDOW_BASE + WINDOW_SIZE - 16, b'D'*16)
        board.write(0x280, 1, 0)
        self.assertEqual([b[-16:] for b in board.flash],
                         [bytes([v])*16 for v in (0x11, 0x22, 0x33, 0x44)])
        self.assertEqual(board.ram[3][-16:], b'D'*16)
        self.assertEqual(board.ram[0][-16:], bytes(16))
        self.assertEqual(memory.mem_read(WINDOW_BASE, 4), b'\xff'*4)
        self.assertFalse(board.read(0, 1) & 0x20)
