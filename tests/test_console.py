from __future__ import annotations

import os
import socket
import unittest

from courier_emu.console import MAX_PENDING_OUTPUT, SerialConsole


class SerialConsoleTests(unittest.TestCase):
    def _pair(self) -> tuple[SerialConsole, socket.socket]:
        worker, terminal = socket.socketpair()
        console = SerialConsole(worker.detach())
        self.addCleanup(terminal.close)
        self.addCleanup(console.close)
        return console, terminal

    def test_poll_is_empty_until_the_terminal_types(self) -> None:
        console, terminal = self._pair()
        self.assertEqual(console.poll(), b"")
        terminal.sendall(b"ATI3\r")
        self.assertEqual(console.poll(), b"ATI3\r")
        self.assertEqual(console.received, 5)

    def test_transmitted_bytes_reach_the_terminal(self) -> None:
        console, terminal = self._pair()
        for value in b"OK\r\n":
            console.write(value)
        self.assertEqual(terminal.recv(16), b"OK\r\n")
        self.assertEqual(console.sent, 4)

    def test_a_closed_terminal_is_reported_once(self) -> None:
        console, terminal = self._pair()
        terminal.close()
        self.assertEqual(console.poll(), b"")
        self.assertTrue(console.closed)

    def test_output_nobody_reads_is_bounded(self) -> None:
        console, _terminal = self._pair()
        # Fill the socket buffer and then keep transmitting: a terminal that
        # stops reading must not stall the run or grow the queue without end.
        for _ in range(MAX_PENDING_OUTPUT * 2):
            console.write(0x41)
        self.assertLessEqual(len(console._pending), MAX_PENDING_OUTPUT)
        self.assertGreater(console.dropped, 0)

    def test_summary_reports_both_directions(self) -> None:
        console, terminal = self._pair()
        terminal.sendall(b"AT\r")
        console.poll()
        console.write(0x4F)
        summary = console.summary()
        self.assertEqual(summary["received"], 3)
        self.assertEqual(summary["sent"], 1)
        self.assertFalse(summary["closed"])

    def test_writing_to_a_closed_descriptor_does_not_raise(self) -> None:
        console, terminal = self._pair()
        terminal.close()
        console.poll()
        console.write(0x41)
        self.assertTrue(console.closed)

    def test_the_descriptor_is_left_non_blocking(self) -> None:
        console, _terminal = self._pair()
        self.assertFalse(os.get_blocking(console.fd))


if __name__ == "__main__":
    unittest.main()
