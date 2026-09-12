"""V.120 rate adaption, as a far end for the B channel.

[imodem-b-channel-silence.md](../docs/imodem-b-channel-silence.md) ends with a
modem that answers a call, synchronises its HDLC receiver and idles the bearer
with flags - and then clears the call down, because the flags were all the far
end had to say.  This is the rest of the sentence.

It is a peer, on the same terms as `bri.py`: it reaches the modem only as
octets on the B channel, it never writes the modem's memory, and every frame it
sends is one the standards say to send.  What it is not is a model of the
I-modem's own V.120 - that is the firmware's, and the firmware is instrumented
enough to say what it makes of ours (`V120 parse failed, ret_code=`,
`Illegal TEI/SAPI received from V120 peer:`), which is the check that matters.

Three layers, bottom up:

* **HDLC** - flags, zero-bit insertion, and the 16-bit frame check sequence of
  ISO 3309.  Octets go onto a B channel least significant bit first, so that is
  the order the bits are packed and unpacked in.
* **The V.120 address** - a 13-bit logical link identifier across two octets
  with the command/response bit between them, which is LAPD's address field
  with the SAPI and TEI read as one number.  LLI 256 is the default link.
* **The data link** - Q.921's procedures at the frame level: SABME and UA to
  establish, I frames numbered modulo 128, RR to acknowledge, DISC and DM to
  clear.
"""
from __future__ import annotations

from collections import deque
from dataclasses import dataclass, field
from typing import Any, Callable

FLAG = 0x7E
# The flag, least significant bit first: 0 1 1 1 1 1 1 0.
FLAG_BITS = tuple((FLAG >> index) & 1 for index in range(8))

# The default logical link identifier, V.120 table 2. 8 and 4 are reserved for
# in-band signalling and 0 for the link's own management.
LLI_DEFAULT = 256

# Modulo-128 control fields, which is what V.120 uses. U frames are one octet.
U_SABME = 0x6F
U_UA = 0x63
U_DISC = 0x43
U_DM = 0x0F
U_FRMR = 0x87
S_RR = 0x01
S_RNR = 0x05
S_REJ = 0x09

U_NAMES = {U_SABME: "SABME", U_UA: "UA", U_DISC: "DISC", U_DM: "DM",
           U_FRMR: "FRMR"}
S_NAMES = {S_RR: "RR", S_RNR: "RNR", S_REJ: "REJ"}

# Octets at 64 kbit/s: one per 125 us. T200 is quoted in them rather than in
# instructions so the timer means the same thing whatever the harness is doing.
T200_OCTETS = 8000          # one second
N200 = 3


def crc16(data: bytes, crc: int = 0xFFFF) -> int:
    """ISO 3309's frame check sequence, the reflected CRC-16 polynomial."""
    for octet in data:
        crc ^= octet
        for _ in range(8):
            crc = (crc >> 1) ^ 0x8408 if crc & 1 else crc >> 1
    return crc


# What crc16 leaves behind when it is run over a frame that still carries its
# own good FCS: ISO 3309's residue.
FCS_GOOD = 0xF0B8


def frame_check(frame: bytes) -> bytes:
    """A frame's FCS, complemented and least significant octet first."""
    value = crc16(frame) ^ 0xFFFF
    return bytes((value & 0xFF, value >> 8))


def address(lli: int, command: bool, from_network: bool) -> bytes:
    """Two address octets carrying a 13-bit LLI and the C/R bit.

    The command/response bit has opposite senses on the two sides, exactly as
    Q.921 gives it: the same octet is a command from one end and a response
    from the other.
    """
    cr = command == from_network
    return bytes((((lli >> 7) & 0x3F) << 2 | cr << 1,
                  (lli & 0x7F) << 1 | 1))


@dataclass
class V120Frame:
    """One decoded frame off the B channel."""

    lli: int
    command: bool
    control: int
    information: bytes = b""
    nr: int | None = None
    ns: int | None = None
    kind: str = "U"

    @property
    def name(self) -> str:
        if self.kind == "I":
            return f"I N(S)={self.ns} N(R)={self.nr}"
        if self.kind == "S":
            return f"{S_NAMES.get(self.control & 0x0F, 'S?')} N(R)={self.nr}"
        return U_NAMES.get(self.control & ~0x10, f"U {self.control:#04x}")

    @property
    def poll(self) -> bool:
        if self.kind == "U":
            return bool(self.control & 0x10)
        return bool(self.nr is not None and self._pf)

    _pf: bool = False


def decode(frame: bytes, from_network: bool) -> V120Frame | None:
    """A frame's address and control, or None if it is not addressed sanely."""
    if len(frame) < 3 or not frame[1] & 1 or frame[0] & 1:
        return None
    lli = ((frame[0] >> 2) << 7) | (frame[1] >> 1)
    cr = bool(frame[0] >> 1 & 1)
    command = cr != from_network
    control = frame[2]
    if not control & 1:                       # I frame, two control octets
        if len(frame) < 4:
            return None
        return V120Frame(lli, command, control, frame[4:], kind="I",
                         ns=control >> 1, nr=frame[3] >> 1,
                         _pf=bool(frame[3] & 1))
    if control & 3 == 1:                      # S frame, two control octets
        if len(frame) < 4:
            return None
        return V120Frame(lli, command, control, b"", kind="S",
                         nr=frame[3] >> 1, _pf=bool(frame[3] & 1))
    return V120Frame(lli, command, control, frame[3:], kind="U")


class HdlcTransmitter:
    """A continuous bit stream: flags when idle, stuffed frames when not.

    `lsb_first` is which end of an octet goes onto the wire first. HDLC says
    least significant, and the flag is a palindrome so it proves nothing either
    way - but the modem's own receive handler at `eb39` reverses each octet's
    bits when a configuration word says to, so the board treats this as a
    variable and so does the peer.
    """

    def __init__(self, lsb_first: bool = True) -> None:
        self._bits: deque[int] = deque()
        self.lsb_first = lsb_first
        self.frames_sent = 0

    def send(self, frame: bytes) -> None:
        payload = frame + frame_check(frame)
        self._bits.extend(FLAG_BITS)
        ones = 0
        for octet in payload:
            for index in range(8):
                bit = (octet >> (index if self.lsb_first else 7 - index)) & 1
                self._bits.append(bit)
                if not bit:
                    ones = 0
                    continue
                ones += 1
                if ones == 5:
                    # Zero-bit insertion: five ones in the frame can never be
                    # six, so the flag stays unique on the wire.
                    self._bits.append(0)
                    ones = 0
        self._bits.extend(FLAG_BITS)
        self.frames_sent += 1

    def octets(self, count: int) -> bytes:
        out = bytearray()
        for _ in range(count):
            while len(self._bits) < 8:
                self._bits.extend(FLAG_BITS)
            value = 0
            for index in range(8):
                value |= self._bits.popleft() << (index if self.lsb_first
                                                  else 7 - index)
            out.append(value)
        return bytes(out)


class HdlcReceiver:
    """Flags, zero-bit deletion, and the FCS, in that order."""

    def __init__(self, lsb_first: bool = True) -> None:
        self._bits: list[int] = []
        self.lsb_first = lsb_first
        self._ones = 0
        self._sync = False
        self.frames: deque[bytes] = deque()
        self.flags = 0
        self.aborts = 0
        self.fcs_errors = 0
        self.runts = 0

    def feed(self, octets: bytes) -> None:
        for octet in octets:
            for index in range(8):
                self._bit((octet >> (index if self.lsb_first
                                     else 7 - index)) & 1)

    def _bit(self, bit: int) -> None:
        if bit:
            self._ones += 1
            if self._ones > 6:
                # Seven ones is an abort, and more than that is the idle mark
                # the modem sends between calls.
                if self._sync and self._bits:
                    self.aborts += 1
                self._sync = False
                self._bits = []
                return
            if self._sync:
                self._bits.append(1)
            return
        if self._ones == 6:
            # A flag closes whatever was open and opens what follows. All eight
            # of its bits went into the buffer on the way past - the leading
            # zero as data, then the six ones - so seven come back out. Two
            # flags in a row leave fewer than that, and close nothing.
            if self._sync:
                self._close(self._bits[:-7] if len(self._bits) >= 7 else [])
            self.flags += 1
            self._sync = True
            self._bits = []
            self._ones = 0
            return
        if self._ones == 5 and self._sync:
            self._ones = 0          # the inserted zero, which is not data
            return
        self._ones = 0
        if self._sync:
            self._bits.append(0)

    def _close(self, bits: list[int]) -> None:
        if not bits:
            return
        if len(bits) % 8:
            self.runts += 1
            return
        frame = bytes(
            sum(bits[base + index] << (index if self.lsb_first else 7 - index)
                for index in range(8))
            for base in range(0, len(bits), 8)
        )
        if len(frame) < 4:
            self.runts += 1
            return
        if crc16(frame) != FCS_GOOD:
            self.fcs_errors += 1
            return
        self.frames.append(frame[:-2])


@dataclass
class V120Link:
    """The data link on one logical link, and the octets it puts on B.

    `establish` says which end sends SABME.  The peer is the calling end of the
    call it placed, so it takes that on by default; a modem that establishes
    first is answered either way.
    """

    lli: int = LLI_DEFAULT
    from_network: bool = True
    establish: bool = True
    # The terminal adaption header on an I frame's information field. The bits
    # are not decoded here: this is the octet the peer sends, and the firmware's
    # own `V120 parse failed, ret_code=` is what says whether it likes it.
    header: bytes = b"\x83"
    # Low layer compatibility octets 5a and 5b, the rate adaption a SETUP can
    # offer, or None to leave the IE out. 5a: more octets follow, synchronous,
    # no in-band negotiation, user rate 64 kbit/s (10000, Q.931 table 4-6).
    # 5b: last octet, no intermediate rate, no network independent clock, no
    # flow control. The modem does not accept a call offered this way, so the
    # peer does not offer it unless asked.
    llc: bytes | None = None
    lsb_first: bool = True
    state: str = "released"
    vs: int = 0
    vr: int = 0
    va: int = 0
    octets_in: int = 0
    octets_out: int = 0
    received: bytearray = field(default_factory=bytearray)
    pending: deque = field(default_factory=deque)
    events: list = field(default_factory=list)
    note: Callable[[str], None] | None = None
    _tx: HdlcTransmitter = field(default=None)
    _rx: HdlcReceiver = field(default=None)
    _timer: int | None = None
    _retries: int = 0
    _started: bool = False
    _unacknowledged: deque = field(default_factory=deque)

    def __post_init__(self) -> None:
        self._tx = HdlcTransmitter(self.lsb_first)
        self._rx = HdlcReceiver(self.lsb_first)

    # -- what the call does to it ------------------------------------------

    def start(self) -> None:
        """The call is up: the B channel is ours to talk on."""
        if self._started:
            return
        self._started = True
        if self.establish:
            self._send_sabme()

    def stop(self) -> None:
        self._started = False
        self.state = "released"
        self._timer = None

    def send(self, data: bytes) -> None:
        """Queue user data for the modem, one I frame per call."""
        self.pending.append(bytes(data))

    # -- the bearer --------------------------------------------------------

    def exchange(self, octets: bytes) -> bytes:
        """Take what the modem sent, give back as much as it took."""
        self.octets_in += len(octets)
        self._rx.feed(octets)
        while self._rx.frames:
            self._receive(self._rx.frames.popleft())
        if self._timer is not None:
            self._timer -= len(octets)
            if self._timer <= 0:
                self._expired()
        self._fill()
        self.octets_out += len(octets)
        return self._tx.octets(len(octets))

    def _fill(self) -> None:
        while (self.state == "established" and self.pending
               and len(self._unacknowledged) < 7):
            data = self.pending.popleft()
            self._send(self._i_frame(self.vs, self.vr, data))
            self._unacknowledged.append(self.vs)
            self.vs = (self.vs + 1) % 128
            self._arm()

    # -- frames ------------------------------------------------------------

    def _address(self, command: bool) -> bytes:
        return address(self.lli, command, self.from_network)

    def _u_frame(self, control: int, command: bool, poll: bool) -> bytes:
        return self._address(command) + bytes((control | (0x10 if poll else 0),))

    def _s_frame(self, control: int, command: bool, poll: bool) -> bytes:
        return (self._address(command)
                + bytes((control, self.vr << 1 | (1 if poll else 0))))

    def _i_frame(self, ns: int, nr: int, data: bytes) -> bytes:
        return (self._address(True) + bytes((ns << 1, nr << 1))
                + self.header + data)

    def _send(self, frame: bytes) -> None:
        self._tx.send(frame)

    def _send_sabme(self) -> None:
        self.state = "establishing"
        self.vs = self.vr = self.va = 0
        self._unacknowledged.clear()
        self._send(self._u_frame(U_SABME, True, True))
        self._retries = 0
        self._arm()
        self._log(f"SABME on LLI {self.lli}")

    def _arm(self) -> None:
        self._timer = T200_OCTETS

    def _expired(self) -> None:
        self._timer = None
        self._retries += 1
        if self._retries > N200:
            self._log(f"T200 expired {N200} times: the modem never answered")
            self.state = "released"
            return
        if self.state == "establishing":
            self._send(self._u_frame(U_SABME, True, True))
            self._arm()
            self._log(f"T200 expired, SABME again ({self._retries} of {N200})")
        elif self._unacknowledged:
            self._send(self._s_frame(S_RR, True, True))
            self._arm()
            self._log(f"T200 expired, RR poll ({self._retries} of {N200})")

    def _receive(self, frame: bytes) -> None:
        decoded = decode(frame, self.from_network)
        if decoded is None:
            self._log(f"undecodable frame {frame.hex()}")
            return
        if decoded.lli != self.lli:
            self._log(f"frame for LLI {decoded.lli}, which is not ours")
            return
        if decoded.kind == "U":
            self._u(decoded)
        elif decoded.kind == "S":
            self._s(decoded)
        else:
            self._i(decoded)

    def _u(self, frame: V120Frame) -> None:
        control = frame.control & ~0x10
        if control == U_SABME:
            self.vs = self.vr = self.va = 0
            self._unacknowledged.clear()
            self._send(self._u_frame(U_UA, False, frame.poll))
            self.state = "established"
            self._timer = None
            self._log("SABME from the modem, answering UA: the link is up")
            return
        if control == U_UA:
            if self.state == "establishing":
                self.state = "established"
                self._timer = None
                self._log("UA from the modem: the link is up")
            return
        if control == U_DISC:
            self._send(self._u_frame(U_UA, False, frame.poll))
            self.state = "released"
            self._log("DISC from the modem, answering UA")
            return
        if control == U_DM:
            self._log(f"DM from the modem in state {self.state}")
            return
        self._log(f"unhandled U frame, control {frame.control:#04x}")

    def _s(self, frame: V120Frame) -> None:
        self._acknowledge(frame.nr or 0)
        if frame.control & 0x0F == S_REJ:
            self._log(f"REJ N(R)={frame.nr}")
        if frame.command and frame.poll:
            self._send(self._s_frame(S_RR, False, True))

    def _i(self, frame: V120Frame) -> None:
        self._acknowledge(frame.nr or 0)
        if frame.ns != self.vr:
            self._log(f"I frame N(S)={frame.ns}, expected {self.vr}")
            self._send(self._s_frame(S_REJ, False, frame.poll))
            return
        self.vr = (self.vr + 1) % 128
        # The header is at least one octet and extends while its top bit is
        # clear. What is behind it is the user's data.
        body = frame.information
        cut = 0
        while cut < len(body) and not body[cut] & 0x80:
            cut += 1
        self.received.extend(body[cut + 1:])
        self._log(f"I frame N(S)={frame.ns}, {len(body[cut + 1:])} octets of data")
        self._send(self._s_frame(S_RR, False, frame.poll))

    def _acknowledge(self, nr: int) -> None:
        while self._unacknowledged and self._unacknowledged[0] != nr:
            self._unacknowledged.popleft()
        self.va = nr
        if not self._unacknowledged:
            self._timer = None

    def _log(self, text: str) -> None:
        self.events.append(text)
        if self.note is not None:
            self.note(f"v120: {text}")

    # -- reporting ---------------------------------------------------------

    def status(self) -> dict[str, Any]:
        return {
            "state": self.state,
            "lli": self.lli,
            "octets": {"in": self.octets_in, "out": self.octets_out},
            "frames": {"sent": self._tx.frames_sent,
                       "flags_seen": self._rx.flags,
                       "received": self._rx.flags and len(self.received),
                       "fcs_errors": self._rx.fcs_errors,
                       "aborts": self._rx.aborts,
                       "runts": self._rx.runts},
            "vs": self.vs, "vr": self.vr, "va": self.va,
            "data_from_modem": bytes(self.received[:64]).hex(),
            "events": list(self.events),
        }
