from __future__ import annotations

import unittest

from courier_emu.machine import attention_body, connect_result


class AttentionBodyTests(unittest.TestCase):
    def test_uppercase_attention_prefix(self) -> None:
        self.assertEqual(attention_body(b"ATY5"), b"Y5")

    def test_lowercase_attention_prefix(self) -> None:
        self.assertEqual(attention_body(b"ati7"), b"i7")

    def test_bare_attention_command(self) -> None:
        self.assertEqual(attention_body(b"AT"), b"")

    def test_mixed_case_prefix_is_rejected(self) -> None:
        self.assertIsNone(attention_body(b"AtY5"))


class ConnectResultTests(unittest.TestCase):
    def test_first_supported_rate_is_reported_in_dte_result(self) -> None:
        self.assertEqual(connect_result(), b"CONNECT 9600")

    def test_invalid_rate_is_rejected(self) -> None:
        with self.assertRaises(ValueError):
            connect_result(0)


if __name__ == "__main__":
    unittest.main()
