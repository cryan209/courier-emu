"""The network at the other end of the I-modem's S interface.

The modem's own side of a BRI is hardware and firmware this repository
models from the image: the Am79C30A in `am79c30.py` carries layer 1 and the
D-channel framing, and Q.921 and Q.931 above it are 386 code
(docs/imodem-isdn-front-end.md).  What has never existed here is the *other*
end - an NT and a switch for the modem to talk to.  Without one the D
channel has nobody on it, and a point-to-point TE that correctly waits for
the network to establish the data link waits forever.

So this module is not a model of anything on the board.  It is a peer, built
from Q.921 and Q.931 the way any other terminal on the bus would be, and it
is deliberately kept on the network side of the line: it drives the S
interface up the way an NT does, it issues the commands a switch issues, and
everything it knows about the modem it learns from frames the firmware
actually sent.

Two things follow from that and are worth stating, because they are the
difference between a peer and a shortcut:

* It never writes the modem's memory and never pokes its registers.  The
  only two doors are `Am79C30.deliver_frame` and `Am79C30.take_sent`, which
  are the chip's own receive and transmit buffers.
* It does not pretend the modem said something it did not.  Every transition
  below is driven by a frame off the wire or by a timer, and a frame that
  does not decode is counted rather than assumed away.

## What it speaks

**Layer 1.**  `activate` walks I.430 F3 -> F6 -> F7, which is INFO2 followed
by INFO4 - the NT's half of an activation.  The firmware's own layer-1
machine dispatches on the state it is in and drops an event that skips
ahead, so the walk is in order rather than a jump to F7
(docs/imodem-d-channel.md).

**Layer 2, Q.921.**  Address decoding for SAPI and TEI, the U, S and I
formats, and two procedures:

* *TEI assignment* on SAPI 63 / TEI 127, for a multipoint bus: an Identity
  Request from the terminal is answered with an Identity Assigned carrying
  the first free TEI from 64 up.
* *Multiple frame establishment*: the network sends SABME and expects UA,
  after which I frames carry layer 3 in both directions with the usual
  N(S)/N(R) accounting and RR acknowledgement.

  Which end sends SABME is the part worth being careful about.  On a
  point-to-point line the TE has a fixed TEI of 0 and either end may
  establish; the network doing it is what a TE that transmits nothing is
  waiting for.  On a multipoint line the terminal establishes after it has
  a TEI, so the peer waits instead.  `establish` chooses.

**Layer 3, Q.931.**  Enough call control to answer a call the modem places
and to place one at it: SETUP, CALL PROCEEDING, ALERTING, CONNECT, CONNECT
ACKNOWLEDGE, DISCONNECT, RELEASE, RELEASE COMPLETE, and the information
elements those carry that matter here - bearer capability, channel
identification, called and calling party number, cause.

The B channel remains an opaque 8 kHz octet stream here.  The switch queues
network octets into the selected B channel and drains the octets the modem
sent on it; companding and interpretation belong to the connected endpoint.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from collections import deque
from typing import Any, Callable

from .pit import INSTRUCTIONS_PER_SECOND as _INSTRUCTIONS_PER_SECOND
from .am79c30 import (
    F2_SENSING, F3_DEACTIVATED, F6_SYNCHRONIZED, F7_ACTIVATED,
)
from .v120 import V120Link


# -- Q.921 ----------------------------------------------------------------

SAPI_CALL_CONTROL = 0
SAPI_MANAGEMENT = 63
TEI_BROADCAST = 127
TEI_POINT_TO_POINT = 0

# The first TEI the network may assign. 0-63 are fixed values a terminal is
# configured with; 64-126 are the automatic range this peer hands out.
TEI_AUTOMATIC_FIRST = 64
TEI_AUTOMATIC_LAST = 126

# U-format control bytes, quoted with P/F set; `_u` strips it when clear.
U_SABME = 0x6F
U_UA = 0x73
U_DISC = 0x53
U_DM = 0x1F
U_UI = 0x03
U_FRMR = 0x87
PF_BIT = 0x10

# S-format control, first octet.
S_RR = 0x01
S_RNR = 0x05
S_REJ = 0x09

# TEI management messages, Q.921 Annex D.
MEI = 0x0F
ID_REQUEST = 0x01
ID_ASSIGNED = 0x02
ID_DENIED = 0x03
ID_CHECK_REQUEST = 0x04
ID_CHECK_RESPONSE = 0x05
ID_REMOVE = 0x06
ID_VERIFY = 0x07

TEI_MESSAGE_NAMES = {
    ID_REQUEST: "ID_REQUEST", ID_ASSIGNED: "ID_ASSIGNED",
    ID_DENIED: "ID_DENIED", ID_CHECK_REQUEST: "ID_CHECK_REQUEST",
    ID_CHECK_RESPONSE: "ID_CHECK_RESPONSE", ID_REMOVE: "ID_REMOVE",
    ID_VERIFY: "ID_VERIFY",
}


def _u(base: int, pf: bool) -> int:
    return (base & ~PF_BIT) | (PF_BIT if pf else 0)


@dataclass
class Lapd:
    """One decoded LAPD frame.

    `command` is the direction the C/R bit encodes, resolved against the side
    that *sent* the frame: Q.921 gives the two sides opposite senses, so the
    bit alone does not say whether a frame is a command without knowing who
    sent it. This peer is the network, so a frame it receives came from the
    user side, where C/R 0 is a command and 1 is a response.
    """

    sapi: int
    tei: int
    command: bool
    control: int
    info: bytes = b""
    # Set for the formats that carry them; None otherwise.
    ns: int | None = None
    nr: int | None = None
    pf: bool = False
    kind: str = "U"

    @property
    def modifier(self) -> int:
        """The U-format control byte with P/F removed, for comparison."""
        return self.control & ~PF_BIT


def decode(frame: bytes, from_user: bool = True) -> Lapd | None:
    """Decode a LAPD frame, or None if it is too short to be one.

    The frame is what the DLC hands over: address, control and information,
    with the flags and the FCS already stripped by the chip.
    """
    if len(frame) < 3 or frame[0] & 1 or not frame[1] & 1:
        return None
    sapi = frame[0] >> 2
    cr_bit = (frame[0] >> 1) & 1
    tei = frame[1] >> 1
    control = frame[2]
    # Q.921 table 1: user commands and network responses carry C/R 0.
    command = (cr_bit == 0) if from_user else (cr_bit == 1)

    if (control & 1) == 0:                      # I format
        if len(frame) < 4:
            return None
        return Lapd(sapi, tei, command, control, frame[4:], ns=control >> 1,
                    nr=frame[3] >> 1, pf=bool(frame[3] & 1), kind="I")
    if (control & 3) == 1:                      # S format
        if len(frame) < 4:
            return None
        return Lapd(sapi, tei, command, control, b"", nr=frame[3] >> 1,
                    pf=bool(frame[3] & 1), kind="S")
    return Lapd(sapi, tei, command, control, frame[3:],   # U format
                pf=bool(control & PF_BIT), kind="U")


def _address(sapi: int, tei: int, command: bool) -> bytes:
    """The two address octets, from the network side.

    The network's commands carry C/R 1 and its responses 0, which is the
    mirror of the user side - the one asymmetry in the address field.
    """
    cr_bit = 1 if command else 0
    return bytes([(sapi << 2) | (cr_bit << 1), (tei << 1) | 1])


def u_frame(sapi: int, tei: int, base: int, command: bool, pf: bool,
            info: bytes = b"") -> bytes:
    return _address(sapi, tei, command) + bytes([_u(base, pf)]) + info


def s_frame(sapi: int, tei: int, base: int, command: bool, nr: int,
            pf: bool) -> bytes:
    return _address(sapi, tei, command) + bytes(
        [base, ((nr & 0x7F) << 1) | (1 if pf else 0)]
    )


def i_frame(sapi: int, tei: int, ns: int, nr: int, pf: bool,
            info: bytes) -> bytes:
    return _address(sapi, tei, True) + bytes(
        [(ns & 0x7F) << 1, ((nr & 0x7F) << 1) | (1 if pf else 0)]
    ) + info


def tei_message(message: int, reference: int, ai: int) -> bytes:
    """A TEI-management UI frame's information field, Q.921 Annex D."""
    return bytes([MEI, (reference >> 8) & 0xFF, reference & 0xFF, message,
                  ((ai & 0x7F) << 1) | 1])


# -- Q.931 ----------------------------------------------------------------

PROTOCOL_DISCRIMINATOR = 0x08

ALERTING = 0x01
CALL_PROCEEDING = 0x02
CONNECT = 0x07
CONNECT_ACKNOWLEDGE = 0x0F
SETUP = 0x05
SETUP_ACKNOWLEDGE = 0x0D
DISCONNECT = 0x45
RELEASE = 0x4D
RELEASE_COMPLETE = 0x5A
STATUS = 0x7D
STATUS_ENQUIRY = 0x75

MESSAGE_NAMES = {
    ALERTING: "ALERTING", CALL_PROCEEDING: "CALL_PROCEEDING",
    CONNECT: "CONNECT", CONNECT_ACKNOWLEDGE: "CONNECT_ACKNOWLEDGE",
    SETUP: "SETUP", SETUP_ACKNOWLEDGE: "SETUP_ACKNOWLEDGE",
    DISCONNECT: "DISCONNECT", RELEASE: "RELEASE",
    RELEASE_COMPLETE: "RELEASE_COMPLETE", STATUS: "STATUS",
    STATUS_ENQUIRY: "STATUS_ENQUIRY",
}

IE_BEARER_CAPABILITY = 0x04
IE_CAUSE = 0x08
IE_CALL_STATE = 0x14
IE_CHANNEL_IDENTIFICATION = 0x18
IE_PROGRESS_INDICATOR = 0x1E
IE_CALLING_PARTY_NUMBER = 0x6C
IE_KEYPAD_FACILITY = 0x2C
IE_LOW_LAYER_COMPATIBILITY = 0x7C
IE_CALLED_PARTY_NUMBER = 0x70

# Bearer capabilities, Q.931 section 4.5.5: the transfer-capability byte, the
# transfer mode and rate, and the layer-1 protocol.
CAPABILITY_SPEECH = 0x80
CAPABILITY_AUDIO_31KHZ = 0x90
# G.711's two companding laws, as layer-1 protocol codes. This modem takes
# mu-law and refuses A-law outright - a 3.1 kHz call offered as A3 is cleared
# with cause 88, the same refusal a wrong called number gets, which is what
# made an earlier reading blame the bearer class rather than the law.
LAW_MU = 0xA2
LAW_A = 0xA3
BEARER_SPEECH = bytes([CAPABILITY_SPEECH, 0x90, LAW_A])
BEARER_UNRESTRICTED_64K = bytes([0x88, 0x90])      # unrestricted digital


def audio_bearer(capability: int = CAPABILITY_AUDIO_31KHZ,
                 law: int = LAW_MU) -> bytes:
    """An analogue call across the bearer: 64 kbit/s of companded audio.

    This is the one a modem answers as a modem. There is no ISDN carrier to
    establish and no rate adaption on top: the B channel is 8000 octets per
    second of G.711 and the datapump drives it directly, which is also what
    puts the I-modem on the digital side of a V.90 or x2 connection.
    """
    return bytes([capability, 0x90, law])

# Q.931 table 4-13, the ones this peer sends or has seen come back.
CAUSE_NAMES = {
    16: "normal call clearing",
    17: "user busy",
    18: "no user responding",
    19: "no answer from user",
    30: "response to STATUS ENQUIRY",
    65: "bearer capability not implemented",
    88: "incompatible destination",
    96: "mandatory information element is missing",
}

# Low layer compatibility for a V.120 call, Q.931 section 4.5.19: unrestricted
# digital at 64 kbit/s, then a layer 1 protocol of V.120 with more octets to
# follow. What follows is the rate adaption itself, which V120Link supplies.
LLC_V120 = bytes([0x88, 0x90, 0x28])

CAUSE_NORMAL_CLEARING = 16
CAUSE_USER_BUSY = 17
CAUSE_NO_ANSWER = 19


@dataclass
class Q931:
    """One decoded Q.931 message."""

    call_reference: int
    from_originator: bool
    message_type: int
    elements: dict[int, bytes] = field(default_factory=dict)

    @property
    def name(self) -> str:
        return MESSAGE_NAMES.get(self.message_type,
                                 f"0x{self.message_type:02x}")

    @property
    def cause_value(self) -> int | None:
        """The cause value a clearing message carries, if it carries one."""
        raw = self.elements.get(IE_CAUSE)
        if not raw:
            return None
        # Octet 3 is coding standard and location, and a diagnostic may follow
        # octet 4; the cause value is the low seven bits of the first octet
        # whose extension bit is set after the location.
        for octet in raw[1:]:
            if octet & 0x80:
                return octet & 0x7F
        return None

    def number(self, element: int) -> str:
        """The digits of a called or calling party number element."""
        raw = self.elements.get(element)
        if not raw:
            return ""
        # One octet of type/plan, then a second when the extension bit of the
        # first is clear - which is what a calling party number carries.
        start = 1 if raw[0] & 0x80 else 2
        return raw[start:].decode("ascii", "replace")


def decode_q931(info: bytes) -> Q931 | None:
    if len(info) < 3 or info[0] != PROTOCOL_DISCRIMINATOR:
        return None
    length = info[1] & 0x0F
    if len(info) < 2 + length + 1:
        return None
    reference = 0
    from_originator = True
    for index in range(length):
        byte = info[2 + index]
        if index == 0:
            # The high bit of the first octet is the call reference flag: set
            # means the message comes from the side that did not allocate it.
            from_originator = not (byte & 0x80)
            byte &= 0x7F
        reference = (reference << 8) | byte
    cursor = 2 + length
    message = Q931(reference, from_originator, info[cursor])
    cursor += 1
    while cursor < len(info):
        identifier = info[cursor]
        if identifier & 0x80:
            # A single-octet element carries its value in the low nibble.
            message.elements[identifier & 0xF0] = bytes([identifier & 0x0F])
            cursor += 1
            continue
        if cursor + 1 >= len(info):
            break
        size = info[cursor + 1]
        message.elements[identifier] = bytes(info[cursor + 2:cursor + 2 + size])
        cursor += 2 + size
    return message


def element(identifier: int, contents: bytes) -> bytes:
    return bytes([identifier, len(contents)]) + contents


def called_party_number(digits: str, plan: int = 0x81) -> bytes:
    """A called party number element: type/plan, then IA5 digits."""
    return element(IE_CALLED_PARTY_NUMBER,
                   bytes([plan]) + digits.encode("ascii"))


def calling_party_number(digits: str, plan: int = 0x01,
                         presentation: int = 0x80) -> bytes:
    """A calling party number: type/plan with its extension bit clear, then
    the presentation/screening octet, then the digits."""
    return element(IE_CALLING_PARTY_NUMBER,
                   bytes([plan, presentation]) + digits.encode("ascii"))


def channel_identification(channel: int = 1, exclusive: bool = True) -> bytes:
    """B1 or B2, as a basic-rate channel identification element."""
    value = 0x80 | (0x08 if exclusive else 0x00) | (channel & 3)
    return element(IE_CHANNEL_IDENTIFICATION, bytes([value]))


def cause(value: int, location: int = 0x02) -> bytes:
    """A cause element: coding standard and location, then the value."""
    return element(IE_CAUSE, bytes([0x80 | location, 0x80 | (value & 0x7F)]))


def q931_message(message_type: int, call_reference: int,
                 from_originator: bool, elements: bytes = b"") -> bytes:
    """Build a Q.931 message with a one-octet call reference.

    One octet is what a basic-rate interface uses, and what the modem sends.
    """
    flag = 0x00 if from_originator else 0x80
    return (bytes([PROTOCOL_DISCRIMINATOR, 0x01,
                   flag | (call_reference & 0x7F), message_type]) + elements)


# -- the peer -------------------------------------------------------------

# -- layer 1, the NT's half of I.430 ------------------------------------

# An NT terminates the S bus, and activation is its job: it sends INFO2, the
# terminal synchronises and answers INFO3, and the NT sends INFO4. What the
# Am79C30A reports is the *terminal's* own F state as that happens, which is
# why the walk below is the states the modem passes through rather than the
# INFO signals the network puts on the wire.
#
# F2 comes first for a reason that is the firmware's, not I.430's: its
# layer-1 machine dispatches on the state it is already in, and an interface
# handed F7 straight out of F1 drops the event and never moves
# (docs/imodem-d-channel.md). So the network walks it, as a network does.
NT_ACTIVATION_WALK = (F2_SENSING, F6_SYNCHRONIZED, F7_ACTIVATED)
# Far enough apart that the firmware's machine runs between the steps. This
# is the spacing `isdn-run --line-activate` has always used.
LINE_STEP_INSTRUCTIONS = 500_000
# When the network brings the line up. Early, because everything else in a
# run waits on it, and because an NT with a line to offer offers it.
ACTIVATE_AT_INSTRUCTIONS = 3_000_000

# The peer's timers are in harness instructions at the same rate the 8254
# model uses, so a second here is the second the firmware's timers count.

T200_INSTRUCTIONS = _INSTRUCTIONS_PER_SECOND          # 1 s, Q.921 default
N200 = 3                                              # retransmissions
# How long after the line comes up the network establishes the data link.
# Q.921 has no figure for this; it is the switch's own pause, and a short one
# keeps a run from spending its instruction budget waiting.
ESTABLISH_DELAY_INSTRUCTIONS = _INSTRUCTIONS_PER_SECOND // 2

# Q.931 T303: how long the network waits for a response to a SETUP before
# retransmitting it, and how many times. A call that is never answered has to
# end, or the peer sits claiming a call is in progress that nobody took.
T303_INSTRUCTIONS = 4 * _INSTRUCTIONS_PER_SECOND
T303_RETRANSMISSIONS = 1

# Layer 2 states, named after Q.921 section 5.
TEI_UNASSIGNED = "tei-unassigned"
TEI_ASSIGNED = "tei-assigned"
AWAITING_ESTABLISH = "awaiting-establishment"
MULTIPLE_FRAME = "multiple-frame-established"
AWAITING_RELEASE = "awaiting-release"


@dataclass
class BriNetwork:
    """An NT and a switch, on the far side of the modem's S interface.

    Drive it by calling `service` with the chip and the run's instruction
    count; it reads what the firmware transmitted and answers. Everything it
    does is visible in `events`, which is the record a run reports.
    """

    # Which end establishes the data link. On a point-to-point line the
    # network does, and a TE waiting for it is why the modem transmits
    # nothing on its own; on a multipoint line the terminal does, once it has
    # a TEI, and the peer waits.
    establish: str = "network"
    # The TEI the network talks to on a point-to-point line.
    tei: int = TEI_POINT_TO_POINT
    # When the NT brings the S interface up, and when it drops it again.
    # None for either leaves that transition to whoever else is driving the
    # line - `isdn-run --line-activate`, or nobody.
    activate_at: int | None = ACTIVATE_AT_INSTRUCTIONS
    deactivate_at: int | None = None
    # A number to call the modem on, and when. None places no call.
    call_at: int | None = None
    call_from: str = "5551000"
    call_to: str = ""
    bearer: bytes = BEARER_UNRESTRICTED_64K
    # Opaque G.711/64-kbit/s media offered by the far endpoint.  Keeping this
    # separate from Q.931's bearer capability is intentional: unrestricted
    # data and speech are both byte-wide B-channel streams at this boundary.
    media_rx: deque = field(default_factory=deque)

    # -- state, none of which is configuration -----------------------------
    state: str = TEI_UNASSIGNED
    vs: int = 0                      # the next N(S) the network will send
    vr: int = 0                      # the next N(S) it expects from the modem
    # Q.921 5.9.5: basic-access signalling has a default window of one.
    _send_queue: deque = field(default_factory=deque)
    _outstanding: tuple[int, int, bytes] | None = None
    _i_expiry: int | None = None
    _i_retries: int = 0
    _remote_busy: bool = False
    assigned_teis: dict[int, int] = field(default_factory=dict)
    activated_at: int | None = None
    _line_walk: list = field(default_factory=list)
    _line_started: bool = False
    _deactivated: bool = False
    _t200_expiry: int | None = None
    _retransmissions: int = 0
    _pending_sabme: bool = False
    _call_placed: bool = False
    _t303_expiry: int | None = None
    _setup_retransmissions: int = 0
    _setup: bytes = b""
    call_reference: int | None = None
    call_state: str = "null"
    events: list[tuple[int, str]] = field(default_factory=list)
    frames_in: int = 0
    frames_out: int = 0
    undecodable: int = 0
    instructions: int = 0
    _sink: Callable[[bytes], None] | None = None
    # A far end for the B channel, when the run wants one: anything with
    # start(), stop() and exchange(octets) -> octets. V120Link is one, and
    # bearer_sip.BearerSipLine is another. Without one the bearer stays opaque
    # and --bri-rx-g711 replays whatever it is given.
    v120: V120Link | None = None
    media_peer: Any = None
    # The digits off the modem's own SETUP, once it has placed a call.
    dialled: str = ""
    # Exact bearer fields from the last SETUP the modem originated.  These
    # are retained after call clearing because they are useful evidence about
    # which call type the firmware selected from its profile.
    outbound_bearer: bytes | None = None
    outbound_low_layer: bytes | None = None
    media_channel: int | None = None
    media_tx: bytearray = field(default_factory=bytearray)
    _media_tx_cursor: dict[int, int] = field(
        default_factory=lambda: {1: 0, 2: 0})
    media_rx_delivered: int = 0

    def queue_media(self, octets: bytes | bytearray) -> None:
        """Queue network-to-modem octets for the connected B channel."""
        self.media_rx.extend(bytes(octets))

    # -- driving -----------------------------------------------------------

    def service(self, dsc: Any, instructions: int) -> None:
        """One pass: take what the modem sent, answer it, and run the timers."""
        self.instructions = instructions
        self._sink = dsc.deliver_frame
        self._line(dsc)
        if not dsc.activated:
            return
        if self.activated_at is None:
            self.activated_at = instructions
            self._note("layer 1 active, the NT has the line up")
        for frame in dsc.take_sent():
            self.frames_in += 1
            self._receive(frame)
        self._timers()
        self._service_media(dsc)

    def _service_media(self, dsc: Any) -> None:
        """Carry the B channel, either opaquely or as a V.120 far end."""
        # Not every harness has a bearer. Reaching it through the chip's own
        # buffers is what keeps this a peer, so the peer does without when the
        # optional bearer interface is not there.
        if not hasattr(dsc, "bearer_tx") or not hasattr(dsc, "queue_bearer"):
            return
        active = self.call_state == "active" and self.media_channel is not None
        fresh = b""
        for channel in (1, 2):
            stream = dsc.bearer_tx[channel]
            start = self._media_tx_cursor[channel]
            if active and channel == self.media_channel:
                fresh = bytes(stream[start:])
                # Output recorded before CONNECT would be the idle DS0, not
                # call media, and the cursor keeps it from appearing as such.
                self.media_tx.extend(fresh)
            self._media_tx_cursor[channel] = len(stream)
        if not active:
            return
        peer = self.v120 if self.v120 is not None else self.media_peer
        if peer is not None:
            # The bearer is a conversation rather than a recording: what the
            # modem sent decides what goes back, one octet for one octet.
            peer.start()
            reply = peer.exchange(fresh)
            if reply:
                dsc.queue_bearer(self.media_channel, reply)
                self.media_rx_delivered += len(reply)
            return
        if self.media_rx:
            octets = bytes(self.media_rx)
            self.media_rx.clear()
            dsc.queue_bearer(self.media_channel, octets)
            self.media_rx_delivered += len(octets)

    def _line(self, dsc: Any) -> None:
        """The NT's own half of the line: bring it up, and drop it again.

        Nothing here reaches past `set_liu_state`, which is the chip
        reporting what its receiver sees on the S interface - the same door
        a real line uses.
        """
        if (self.deactivate_at is not None and not self._deactivated
                and self.instructions >= self.deactivate_at):
            self._deactivated = True
            self._line_walk = []
            self.activated_at = None
            self.state = TEI_UNASSIGNED
            self._t200_expiry = None
            self._reset_link()
            self._clear_call()
            self._note("the NT drops the line: back to F3")
            dsc.set_liu_state(F3_DEACTIVATED)
            return
        if not dsc.activated and self.activated_at is not None \
                and not self._line_walk:
            # The line went down without this peer dropping it - the firmware
            # deactivated its own LIU. Everything above layer 1 is gone with
            # it, so the peer's idea of the link has to go too rather than
            # reporting a data link that cannot exist.
            self._note("the line went down underneath us: layer 2 is gone")
            self.activated_at = None
            self.state = TEI_UNASSIGNED
            self._t200_expiry = None
            self._t303_expiry = None
            self._reset_link()
            self._clear_call()
            # Do not walk it straight back up. The terminal dropped its own
            # LIU, and an NT that immediately re-activated would hide exactly
            # the behaviour worth seeing. `--bri-deactivate-at` aside, the
            # line comes up once per run.
            self._line_walk = []
        if self.activate_at is None or self._deactivated:
            return
        if not self._line_started:
            if self.instructions < self.activate_at:
                return
            self._line_started = True
            self._line_walk = list(NT_ACTIVATION_WALK)
            self._note("the NT starts activation: INFO2 on the S interface")
        if not self._line_walk:
            return
        due = self.activate_at + LINE_STEP_INSTRUCTIONS * (
            len(NT_ACTIVATION_WALK) - len(self._line_walk)
        )
        if self.instructions >= due:
            dsc.set_liu_state(self._line_walk.pop(0))

    def _note(self, text: str) -> None:
        self.events.append((self.instructions, text))

    def _reset_link(self) -> None:
        self.vs = self.vr = 0
        self._send_queue.clear()
        self._outstanding = None
        self._i_expiry = None
        self._i_retries = 0
        self._remote_busy = False

    def _clear_call(self) -> None:
        self.call_state = "null"
        self.call_reference = None
        self._t303_expiry = None
        self.media_channel = None
        for peer in (self.v120, self.media_peer):
            if peer is not None:
                peer.stop()

    def _send(self, frame: bytes) -> None:
        if self._sink is None:
            return
        self.frames_out += 1
        self._sink(frame)

    # -- layer 2 -----------------------------------------------------------

    def _receive(self, frame: bytes) -> None:
        decoded = decode(frame, from_user=True)
        if decoded is None:
            self.undecodable += 1
            self._note(f"undecodable frame {frame.hex()}")
            return
        if decoded.sapi == SAPI_MANAGEMENT:
            self._tei_management(decoded)
            return
        if decoded.sapi != SAPI_CALL_CONTROL:
            self._note(f"frame for SAPI {decoded.sapi}, which this peer does "
                       "not serve")
            return
        if decoded.kind == "U":
            self._unnumbered(decoded)
        elif decoded.kind == "S":
            self._supervisory(decoded)
        else:
            self._information(decoded)

    def _unnumbered(self, frame: Lapd) -> None:
        modifier = frame.modifier
        if modifier == _u(U_SABME, False):
            # The terminal is establishing - a multipoint line, or one where
            # it got there first. Either way the answer is UA and both ends
            # reset their counters.
            self._reset_link()
            self.state = MULTIPLE_FRAME
            self._t200_expiry = None
            self._pending_sabme = False
            self._note(f"SABME from TEI {frame.tei}, answering UA")
            self._send(u_frame(SAPI_CALL_CONTROL, frame.tei, U_UA, False,
                               frame.pf))
            return
        if modifier == _u(U_UA, False):
            if self.state == AWAITING_ESTABLISH:
                self.state = MULTIPLE_FRAME
                self._reset_link()
                self._t200_expiry = None
                self._retransmissions = 0
                self._note("UA for the network's SABME: layer 2 established")
            return
        if modifier == _u(U_DISC, False):
            self.state = TEI_ASSIGNED
            self._reset_link()
            self._clear_call()
            self._note(f"DISC from TEI {frame.tei}, answering UA")
            self._send(u_frame(SAPI_CALL_CONTROL, frame.tei, U_UA, False,
                               frame.pf))
            return
        if modifier == _u(U_DM, False):
            # The terminal has no data link in that state. Q.921 has the
            # network retry; reporting it is what matters here.
            self._note(f"DM from TEI {frame.tei} in state {self.state}")
            return
        if modifier == _u(U_UI, False):
            self._note(f"UI on SAPI 0 from TEI {frame.tei}: "
                       f"{frame.info.hex()}")
            return
        self._note(f"unhandled U frame, control {frame.control:#04x}")

    def _supervisory(self, frame: Lapd) -> None:
        base = frame.control & 0x0F
        self._remote_busy = base == S_RNR
        if not self._acknowledge(frame.nr):
            return
        if base == S_RR:
            if frame.command and frame.pf:
                # An RR command with P set is a poll; the response is an RR
                # with F set carrying the network's own N(R).
                self._send(s_frame(SAPI_CALL_CONTROL, frame.tei, S_RR, False,
                                   self.vr, True))
            self._flush_layer3()
            return
        if base == S_REJ:
            self._note(f"REJ N(R)={frame.nr}, retransmitting from there")
            if self._outstanding:
                self._transmit_outstanding()
            else:
                self._flush_layer3()
            return
        if base == S_RNR:
            self._note(f"RNR from TEI {frame.tei}")

    def _information(self, frame: Lapd) -> None:
        if not self._acknowledge(frame.nr):
            return
        if frame.ns != self.vr:
            # Out of sequence: Q.921 says reject and ask for the one expected.
            self._note(f"I frame N(S)={frame.ns}, expected {self.vr}")
            self._send(s_frame(SAPI_CALL_CONTROL, frame.tei, S_REJ, False,
                               self.vr, frame.pf))
            return
        self.vr = (self.vr + 1) % 128
        self._send(s_frame(SAPI_CALL_CONTROL, frame.tei, S_RR, False, self.vr,
                           frame.pf))
        message = decode_q931(frame.info)
        if message is None:
            self._note(f"I frame whose information is not Q.931: "
                       f"{frame.info.hex()}")
            return
        self._call_control(message, frame.tei)
        self._flush_layer3()

    def _send_layer3(self, tei: int, info: bytes) -> None:
        self._send_queue.append((tei, info))
        self._flush_layer3()

    def _acknowledge(self, nr: int | None) -> bool:
        if self._outstanding is not None and nr == self.vs:
            self._outstanding = None
            self._i_expiry = None
            self._i_retries = 0
        elif nr != (self._outstanding[1] if self._outstanding else self.vs):
            self._note(f"invalid acknowledgement N(R)={nr}, V(S)={self.vs}")
            return False
        return True

    def _flush_layer3(self) -> None:
        if (self.state != MULTIPLE_FRAME or self._remote_busy
                or self._outstanding is not None or not self._send_queue):
            return
        tei, info = self._send_queue.popleft()
        self._outstanding = (tei, self.vs, info)
        self.vs = (self.vs + 1) % 128
        self._transmit_outstanding()

    def _transmit_outstanding(self) -> None:
        tei, ns, info = self._outstanding
        self._send(i_frame(SAPI_CALL_CONTROL, tei, ns, self.vr, False, info))
        self._i_expiry = self.instructions + T200_INSTRUCTIONS

    def _tei_management(self, frame: Lapd) -> None:
        info = frame.info
        if len(info) < 5 or info[0] != MEI:
            self._note(f"management frame that is not a TEI message: "
                       f"{info.hex()}")
            return
        reference = (info[1] << 8) | info[2]
        message = info[3]
        ai = info[4] >> 1
        name = TEI_MESSAGE_NAMES.get(message, f"0x{message:02x}")
        if message == ID_REQUEST:
            if ai == TEI_BROADCAST:
                assigned = self._allocate_tei(reference)
            else:
                # The terminal asked for a particular value; Q.921 lets the
                # network grant it if it is free.
                assigned = ai if ai not in self.assigned_teis.values() else None
                if assigned is not None:
                    self.assigned_teis[reference] = assigned
            if assigned is None:
                self._note(f"ID_REQUEST ref {reference}: no TEI free, denied")
                self._send(u_frame(SAPI_MANAGEMENT, TEI_BROADCAST, U_UI, True,
                                   False,
                                   tei_message(ID_DENIED, reference, ai)))
                return
            self._note(f"ID_REQUEST ref {reference}: assigning TEI {assigned}")
            self.tei = assigned
            self.state = TEI_ASSIGNED
            self._send(u_frame(SAPI_MANAGEMENT, TEI_BROADCAST, U_UI, True,
                               False,
                               tei_message(ID_ASSIGNED, reference, assigned)))
            return
        if message == ID_VERIFY:
            self._note(f"ID_VERIFY for TEI {ai}, checking it")
            self._send(u_frame(SAPI_MANAGEMENT, TEI_BROADCAST, U_UI, True,
                               False,
                               tei_message(ID_CHECK_REQUEST, 0, ai)))
            return
        self._note(f"TEI management {name}, ref {reference}, Ai {ai}")

    def _allocate_tei(self, reference: int) -> int | None:
        taken = set(self.assigned_teis.values())
        for candidate in range(TEI_AUTOMATIC_FIRST, TEI_AUTOMATIC_LAST + 1):
            if candidate not in taken:
                self.assigned_teis[reference] = candidate
                return candidate
        return None

    def _timers(self) -> None:
        if self._i_expiry is not None and self.instructions >= self._i_expiry:
            if self._i_retries >= N200:
                self._note("T200 exhausted awaiting I-frame acknowledgement")
                self._reset_link()
                self._clear_call()
                self.state = TEI_ASSIGNED
            else:
                self._i_retries += 1
                if self._remote_busy:
                    self._send(s_frame(0, self.tei, S_RR, True, self.vr, True))
                    self._i_expiry = self.instructions + T200_INSTRUCTIONS
                else:
                    self._transmit_outstanding()
        if (self.establish == "network" and self.state == TEI_UNASSIGNED
                and self.activated_at is not None
                and self.instructions >= self.activated_at
                + ESTABLISH_DELAY_INSTRUCTIONS):
            self._establish()
        if self._t200_expiry is not None and self.instructions >= self._t200_expiry:
            self._t200()
        if (self.call_at is not None and not self._call_placed
                and self.instructions >= self.call_at):
            self._place_call()
        if self._t303_expiry is not None and self.instructions >= self._t303_expiry:
            self._t303()

    def _establish(self) -> None:
        self.state = AWAITING_ESTABLISH
        self._retransmissions = 0
        self._pending_sabme = True
        self._note(f"the network establishes the data link: SABME to TEI "
                   f"{self.tei}")
        self._send(u_frame(SAPI_CALL_CONTROL, self.tei, U_SABME, True, True))
        self._t200_expiry = self.instructions + T200_INSTRUCTIONS

    def _t200(self) -> None:
        self._t200_expiry = None
        if self.state != AWAITING_ESTABLISH:
            return
        self._retransmissions += 1
        if self._retransmissions > N200:
            self._note(f"T200 expired {N200} times with no UA: the terminal "
                       "is not answering SABME")
            self.state = TEI_UNASSIGNED
            self._pending_sabme = False
            return
        self._note(f"T200 expired, SABME retransmission "
                   f"{self._retransmissions}")
        self._send(u_frame(SAPI_CALL_CONTROL, self.tei, U_SABME, True, True))
        self._t200_expiry = self.instructions + T200_INSTRUCTIONS

    # -- layer 3 -----------------------------------------------------------

    def _place_call(self) -> None:
        self._call_placed = True
        self.call_reference = 1
        self.call_state = "call-present"
        self.media_channel = 1
        elements = (element(IE_BEARER_CAPABILITY, self.bearer)
                    + channel_identification(1)
                    + calling_party_number(self.call_from))
        if self.v120 is not None and self.v120.llc is not None:
            # A V.120 call can say so in the SETUP, and the modem does parse
            # it: offering this changes its verdict, from answering the call to
            # clearing it with MISC_INFO. Which is why it is off by default -
            # the octets below are what the standards say to send and the
            # firmware disagrees with them, so they are a probe rather than a
            # setting. See docs/imodem-v120.md.
            elements += element(IE_LOW_LAYER_COMPATIBILITY,
                                LLC_V120 + self.v120.llc)
        if self.call_to:
            elements += called_party_number(self.call_to)
        self._setup = q931_message(SETUP, self.call_reference, True, elements)
        self._setup_retransmissions = 0
        self._t303_expiry = self.instructions + T303_INSTRUCTIONS
        if self.state == MULTIPLE_FRAME:
            self._note(f"SETUP to the modem from {self.call_from}")
            self._send_setup()
            return
        # No data link, which on a multipoint bus is the normal case for an
        # incoming call: the network has no idea which terminal wants it, and
        # no terminal has asked for a TEI yet. Q.931 puts the SETUP on the
        # broadcast data link instead - a UI frame to TEI 127 - and whichever
        # terminal takes the call gets a TEI and establishes to answer. This
        # is the one path that reaches a terminal that has never transmitted.
        self._note(f"SETUP from {self.call_from} on the broadcast data link, "
                   "TEI 127: no terminal has a TEI yet")
        self._send_setup()

    def _t303(self) -> None:
        """T303: nobody answered the SETUP.

        Q.931 has the network retransmit it once and then clear the call. A
        peer that instead sat on `call-present` for the rest of the run would
        be reporting a call that no terminal ever took.
        """
        self._t303_expiry = None
        if self.call_state not in ("call-present",):
            return
        if self._setup_retransmissions >= T303_RETRANSMISSIONS:
            self._note("T303 expired with no response: clearing the call")
            self.call_state = "null"
            self.call_reference = None
            return
        self._setup_retransmissions += 1
        self._note(f"T303 expired, SETUP retransmission "
                   f"{self._setup_retransmissions}")
        self._send_setup()
        self._t303_expiry = self.instructions + T303_INSTRUCTIONS

    def _send_setup(self) -> None:
        if self.state == MULTIPLE_FRAME:
            self._send_layer3(self.tei, self._setup)
            return
        self._send(u_frame(SAPI_CALL_CONTROL, TEI_BROADCAST, U_UI, True,
                           False, self._setup))

    def _call_control(self, message: Q931, tei: int) -> None:
        # The cause belongs in the note. A modem that refuses a call says why
        # in the message it refuses it with, and a report that prints only the
        # message type throws that away: "RELEASE_COMPLETE" and
        # "RELEASE_COMPLETE, cause 88 incompatible destination" are different
        # amounts of evidence.
        value = message.cause_value
        because = ("" if value is None else
                   f", cause {value}"
                   f"{' ' + CAUSE_NAMES[value] if value in CAUSE_NAMES else ''}")
        self._note(f"{message.name} call reference "
                   f"{message.call_reference}{because}")
        # Any layer 3 answer at all means the SETUP was taken, so T303 stops.
        self._t303_expiry = None
        reference = message.call_reference
        if message.message_type == SETUP:
            # The modem is placing a call. Take the number it dialled, accept
            # the channel, and walk the call up the way a switch does.
            self.call_reference = reference
            channel = message.elements.get(IE_CHANNEL_IDENTIFICATION, b"")
            requested_channel = channel[0] & 3 if channel else 1
            self.media_channel = requested_channel if requested_channel in (1, 2) else 1
            self.call_state = "call-received"
            self.outbound_bearer = message.elements.get(IE_BEARER_CAPABILITY)
            self.outbound_low_layer = message.elements.get(
                IE_LOW_LAYER_COMPATIBILITY)
            # The I-modem puts its digits in the keypad facility rather than
            # a called party number - `ATDT8406` arrives as IE 2c, '8406' in
            # ASCII - which is why this used to report a dial as "(no number)"
            # while the modem was dialling perfectly well.
            dialled = (message.number(IE_CALLED_PARTY_NUMBER)
                       or message.elements.get(IE_KEYPAD_FACILITY, b"")
                       .decode("ascii", "replace"))
            self.dialled = dialled
            self._note(f"the modem is calling {dialled or '(no number)'}")
            peer = self.v120 if self.v120 is not None else self.media_peer
            if dialled and peer is not None and hasattr(peer, "dial"):
                peer.dial(dialled)
            self._send_layer3(tei, q931_message(
                CALL_PROCEEDING, reference, False,
                channel_identification(self.media_channel)))
            self._send_layer3(tei, q931_message(ALERTING, reference, False))
            self._send_layer3(tei, q931_message(CONNECT, reference, False))
            self.call_state = "connect-request"
            return
        if message.message_type == CONNECT:
            # The modem answered a call the network placed.
            self.call_state = "active"
            channel = message.elements.get(IE_CHANNEL_IDENTIFICATION, b"")
            if channel:
                self.media_channel = channel[0] & 3
            if self.media_channel not in (1, 2):
                self.media_channel = 1
            self._send_layer3(tei, q931_message(CONNECT_ACKNOWLEDGE, reference,
                                                True))
            return
        if message.message_type == CONNECT_ACKNOWLEDGE:
            if reference == self.call_reference and self.call_state == "connect-request":
                self.call_state = "active"
            return
        if message.message_type in (ALERTING, CALL_PROCEEDING):
            self.call_state = "delivered"
            return
        if message.message_type == DISCONNECT:
            self.call_state = "release-request"
            self._send_layer3(tei, q931_message(
                RELEASE, reference, not message.from_originator))
            return
        if message.message_type == RELEASE:
            self._clear_call()
            self._send_layer3(tei, q931_message(
                RELEASE_COMPLETE, reference, not message.from_originator))
            return
        if message.message_type == RELEASE_COMPLETE:
            self._clear_call()
            return
        if message.message_type == STATUS_ENQUIRY:
            self._send_layer3(tei, q931_message(
                STATUS, reference, not message.from_originator,
                cause(30) + element(IE_CALL_STATE, bytes([0x00]))))

    # -- reporting ---------------------------------------------------------

    def status(self) -> dict[str, object]:
        return {
            "line": ("down" if self.activated_at is None and
                     not self._line_walk else
                     "activating" if self._line_walk else "active"),
            "state": self.state,
            "tei": self.tei,
            "assigned_teis": dict(self.assigned_teis),
            "call_state": self.call_state,
            "call_reference": self.call_reference,
            "v120": self.v120.status() if self.v120 is not None else None,
            "media_peer": (self.media_peer.status()
                           if self.media_peer is not None else None),
            "dialled": self.dialled,
            "outbound_setup": (
                None if self.outbound_bearer is None else {
                    "bearer_capability": self.outbound_bearer.hex(" "),
                    "low_layer_compatibility": (
                        None if self.outbound_low_layer is None
                        else self.outbound_low_layer.hex(" ")
                    ),
                }
            ),
            "media": {
                "channel": self.media_channel,
                "rx_pending": len(self.media_rx),
                "rx_delivered": self.media_rx_delivered,
                "tx_octets": len(self.media_tx),
                "tx_non_ff": sum(value != 0xff for value in self.media_tx),
            },
            "frames_from_modem": self.frames_in,
            "frames_to_modem": self.frames_out,
            "undecodable": self.undecodable,
            "vs": self.vs,
            "vr": self.vr,
            "pending_layer3": len(self._send_queue),
            "unacknowledged_ns": self._outstanding[1] if self._outstanding else None,
            "events": [{"instructions": at, "event": text}
                       for at, text in self.events],
        }
