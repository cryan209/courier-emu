"""I-modem runtime mailbox transport, separate from DSP download handshakes.

The default endpoint captures commands; it does not execute DSP firmware or
invent replies. A DSP endpoint can consume committed commands with on_command
and publish replies with offer_reply. See docs/imodem-mailbox-service.md.
"""
from collections import Counter, deque
from typing import Callable


class ImodemMailbox:
    PORTS = (0x1C, 0x58, 0x5A, 0x5C, 0x5E)
    LANES = (0x58, 0x5A, 0x5C, 0x5E)

    def __init__(self, on_command: Callable[[int, int], None] | None = None):
        self.on_command = on_command
        self.tx_ready = True
        self.tx = bytearray(4)
        self.rx: tuple[int, int] | None = None
        self.commands: deque[tuple[int, int]] = deque(maxlen=256)
        self.committed = 0
        self.replies_acked = 0
        # What the DSP told the host, in order and by value: the datapump's
        # progress through a call is only visible here.
        self.replies: deque[tuple[int, int]] = deque(maxlen=512)
        self.reply_counts: Counter = Counter()
        # Both directions against the B1 octets the modem has clocked in
        # (0 before the call), so an exchange lines up with the far end's audio.
        self.timeline: list[tuple[int, str, int, int]] = []

    def read(self, port: int) -> int:
        if port == 0x1C:
            return int(self.tx_ready) | (2 if self.rx is not None else 0)
        lane = self.LANES.index(port)
        if self.rx is None:
            return 0
        return (self.rx[lane // 2] >> (8 * (lane % 2))) & 0xFF

    def write(self, port: int, value: int) -> None:
        if port != 0x1C:
            self.tx[self.LANES.index(port)] = value & 0xFF
            return
        # Retire the old reply before notifying an endpoint: a synchronous
        # endpoint may publish a new reply to this very command.
        if value & 2 and self.rx is not None:
            self.rx = None
            self.replies_acked += 1
        if value & 1 and self.tx_ready:
            command = (int.from_bytes(self.tx[:2], 'little'),
                       int.from_bytes(self.tx[2:], 'little'))
            self.commands.append(command)
            self.committed += 1
            self._stamp('cmd', *command)
            if self.on_command is not None:
                self.on_command(*command)

    def offer_reply(self, tag: int, value: int) -> bool:
        """Hold one DSP reply until CPU acknowledgment; never overwrite it."""
        if self.rx is not None:
            return False
        self.rx = (tag & 0xFFFF, value & 0xFFFF)
        self.replies.append(self.rx)
        self.reply_counts[f'{self.rx[0]:04x}:{self.rx[1]:04x}'] += 1
        self._stamp('reply', *self.rx)
        return True

    def _stamp(self, kind: str, tag: int, value: int) -> None:
        dsc = getattr(self, 'dsc', None)
        heard = len(dsc.bearer_rx_heard[1]) if dsc is not None else 0
        if heard and len(self.timeline) < 4000:
            self.timeline.append((heard, kind, tag, value))

    def status(self) -> dict:
        return {'endpoint': 'callback' if self.on_command else 'capture-only',
                'tx_ready': self.tx_ready, 'committed': self.committed,
                'replies_acked': self.replies_acked, 'reply_pending': self.rx,
                'recent_commands': list(self.commands),
                'recent_replies': [f'{tag:04x}:{value:04x}'
                                   for tag, value in self.replies],
                'reply_counts': dict(sorted(self.reply_counts.items())),
                'timeline': [f'{at / 8000:.4f} {kind} {tag:04x}:{value:04x}'
                             for at, kind, tag, value in self.timeline]}
