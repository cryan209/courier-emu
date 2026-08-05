from __future__ import annotations

from pathlib import Path
import tempfile
import threading
import unittest

from courier_emu.daa import INSTRUCTIONS_PER_MS
from courier_emu.line import (
    LINE_FRAME_INSTRUCTIONS,
    LINE_FRAME_MS,
    LINE_FRAME_SAMPLES,
    MAX_SOCKET_PATH,
    LineFrame,
    LineLink,
)


class LineFrameTests(unittest.TestCase):
    def test_a_frame_survives_the_wire(self) -> None:
        frame = LineFrame(
            instructions=1_234_567, off_hook=True, ringing=False, samples=[0, -1, 32_767, -32_768]
        )
        encoded = frame.encode()
        decoded = LineFrame.decode(encoded[:8], encoded[8:])
        self.assertEqual(decoded.instructions, 1_234_567)
        self.assertTrue(decoded.off_hook)
        self.assertFalse(decoded.ringing)
        self.assertEqual(decoded.samples, [0, -1, 32_767, -32_768])

    def test_a_frame_is_one_asic_frame_of_line_time(self) -> None:
        self.assertEqual(LINE_FRAME_MS, 100)
        self.assertEqual(LINE_FRAME_INSTRUCTIONS, 100 * INSTRUCTIONS_PER_MS)


class LineLinkTests(unittest.TestCase):
    def setUp(self) -> None:
        # A UNIX socket path is short, and the platform temporary directory is
        # not: on macOS it is a per-user path under /var/folders.
        self.directory = tempfile.TemporaryDirectory(dir="/tmp")
        self.path = str(Path(self.directory.name) / "line.sock")
        self.addCleanup(self.directory.cleanup)

    def _pair(self) -> tuple[LineLink, LineLink]:
        listener = LineLink(path=self.path, listen=True)
        connector = LineLink(path=self.path)
        opened = threading.Thread(target=listener.open)
        opened.start()
        connector.open()
        opened.join()
        self.addCleanup(listener.close)
        self.addCleanup(connector.close)
        return listener, connector

    def test_each_side_takes_the_other_side_off_the_line(self) -> None:
        listener, connector = self._pair()
        answering = threading.Thread(
            target=listener.exchange,
            args=(LineFrame(0, off_hook=True, ringing=False, samples=[1, 2, 3]),),
        )
        answering.start()
        connector.exchange(LineFrame(0, off_hook=False, ringing=False, samples=[4, 5, 6]))
        answering.join()

        self.assertTrue(connector.peer_off_hook)
        self.assertFalse(listener.peer_off_hook)
        self.assertEqual(connector.receive_audio(), [1, 2, 3])
        self.assertEqual(listener.receive_audio(), [4, 5, 6])
        self.assertEqual(connector.frames, 1)
        self.assertEqual(listener.frames, 1)

    def test_audio_can_be_taken_a_piece_at_a_time(self) -> None:
        listener, connector = self._pair()
        answering = threading.Thread(
            target=listener.exchange,
            args=(LineFrame(0, off_hook=True, ringing=False, samples=[1, 2, 3, 4]),),
        )
        answering.start()
        connector.exchange(LineFrame(0, off_hook=True, ringing=False, samples=[]))
        answering.join()

        self.assertEqual(connector.receive_audio(2), [1, 2])
        self.assertEqual(connector.receive_audio(), [3, 4])
        self.assertEqual(connector.receive_audio(), [])

    def test_a_peer_that_stops_early_ends_the_call(self) -> None:
        # A run that hits its instruction limit first must not hang the other
        # side for the rest of its own budget.
        listener, connector = self._pair()
        listener.close()
        for _ in range(4):
            connector.exchange(LineFrame(0, off_hook=True, ringing=False, samples=[0]))
        self.assertFalse(connector.connected)
        self.assertFalse(connector.peer_off_hook)
        self.assertIsNotNone(connector.error)

    def test_an_oversized_socket_path_is_named_in_the_error(self) -> None:
        link = LineLink(path="/tmp/" + "x" * MAX_SOCKET_PATH)
        with self.assertRaises(ValueError) as caught:
            link.open()
        self.assertIn(str(MAX_SOCKET_PATH), str(caught.exception))

    def test_status_reports_the_line_without_opening_it(self) -> None:
        link = LineLink(path=self.path)
        status = link.status()
        self.assertFalse(status["connected"])
        self.assertEqual(status["frames"], 0)
        self.assertEqual(status["samples_sent"], 0)
        self.assertEqual(LINE_FRAME_SAMPLES, 960)


if __name__ == "__main__":
    unittest.main()
