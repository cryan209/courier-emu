"""The Q.921/Q.931 peer, checked against the standards it is built from."""
from courier_emu import bri


class Wire:
    """A stand-in for the chip's two buffers, so the peer can be driven
    without booting the firmware. `service` only ever touches these."""

    def __init__(self, activated=True):
        self.activated = activated
        self.to_modem = []
        self.from_modem = []

    def deliver_frame(self, frame):
        self.to_modem.append(bytes(frame))

    def take_sent(self):
        frames, self.from_modem = self.from_modem, []
        return frames


def test_crc_free_frame_encoding_round_trips():
    frame = bri.u_frame(0, 0, bri.U_SABME, command=True, pf=True)
    assert frame == bytes([0x02, 0x01, 0x7F])
    decoded = bri.decode(frame, from_user=False)
    assert decoded.sapi == 0 and decoded.tei == 0
    assert decoded.kind == "U" and decoded.pf
    assert decoded.modifier == bri._u(bri.U_SABME, False)


def test_the_cr_bit_means_opposite_things_on_the_two_sides():
    # Q.921 table 1: a command from the user carries C/R 0, one from the
    # network carries 1. The same octet therefore decodes differently
    # depending on who sent it, which is the one asymmetry worth a test.
    frame = bytes([0x00, 0x01, 0x7F])
    assert bri.decode(frame, from_user=True).command is True
    assert bri.decode(frame, from_user=False).command is False


def test_i_and_s_formats_carry_their_sequence_numbers():
    information = bri.i_frame(0, 64, ns=3, nr=5, pf=False, info=b"\x08\x01\x01")
    decoded = bri.decode(information, from_user=False)
    assert decoded.kind == "I" and decoded.ns == 3 and decoded.nr == 5
    assert decoded.info == b"\x08\x01\x01"

    supervisory = bri.s_frame(0, 64, bri.S_RR, command=False, nr=7, pf=True)
    decoded = bri.decode(supervisory, from_user=False)
    assert decoded.kind == "S" and decoded.nr == 7 and decoded.pf


def test_the_network_establishes_the_link_and_the_terminal_answers():
    wire = Wire()
    peer = bri.BriNetwork()
    peer.service(wire, 0)
    peer.service(wire, bri.ESTABLISH_DELAY_INSTRUCTIONS)
    assert peer.state == bri.AWAITING_ESTABLISH
    sabme = bri.decode(wire.to_modem[-1], from_user=False)
    assert sabme.modifier == bri._u(bri.U_SABME, False) and sabme.command

    wire.from_modem.append(bri.u_frame(0, 0, bri.U_UA, command=False, pf=True))
    peer.service(wire, bri.ESTABLISH_DELAY_INSTRUCTIONS + 1000)
    assert peer.state == bri.MULTIPLE_FRAME
    assert peer.vs == 0 and peer.vr == 0


def test_t200_retransmits_sabme_and_then_gives_up():
    wire = Wire()
    peer = bri.BriNetwork()
    peer.service(wire, 0)
    now = bri.ESTABLISH_DELAY_INSTRUCTIONS
    peer.service(wire, now)
    for _ in range(bri.N200 + 1):
        now += bri.T200_INSTRUCTIONS
        peer.service(wire, now)
    # N200 retransmissions, then the peer stops and says so rather than
    # retransmitting forever.
    assert peer.state == bri.TEI_UNASSIGNED
    assert sum("retransmission" in text for _, text in peer.events) == bri.N200


def test_a_tei_request_is_answered_with_an_assignment():
    wire = Wire()
    peer = bri.BriNetwork(establish="terminal")
    wire.from_modem.append(
        bri.u_frame(bri.SAPI_MANAGEMENT, bri.TEI_BROADCAST, bri.U_UI,
                    command=True, pf=False,
                    info=bri.tei_message(bri.ID_REQUEST, 0x1234,
                                         bri.TEI_BROADCAST))
    )
    peer.service(wire, 0)
    answer = bri.decode(wire.to_modem[-1], from_user=False)
    assert answer.sapi == bri.SAPI_MANAGEMENT and answer.tei == bri.TEI_BROADCAST
    assert answer.info[0] == bri.MEI
    assert answer.info[3] == bri.ID_ASSIGNED
    assert (answer.info[1] << 8 | answer.info[2]) == 0x1234
    assert answer.info[4] >> 1 == bri.TEI_AUTOMATIC_FIRST
    assert peer.tei == bri.TEI_AUTOMATIC_FIRST


def test_a_setup_from_the_modem_is_walked_up_to_connect():
    wire = Wire()
    peer = bri.BriNetwork()
    peer.state = bri.MULTIPLE_FRAME
    setup = bri.q931_message(bri.SETUP, 0x0A, True,
                             bri.element(bri.IE_BEARER_CAPABILITY,
                                         bri.BEARER_UNRESTRICTED_64K)
                             + bri.called_party_number("5551212"))
    wire.from_modem.append(bri.i_frame(0, 0, ns=0, nr=0, pf=False, info=setup))
    peer.service(wire, 0)

    # An RR acknowledging the I frame, then the three call-control messages.
    kinds = [bri.decode(frame, from_user=False) for frame in wire.to_modem]
    assert kinds[0].kind == "S"
    messages = [bri.decode_q931(frame.info).message_type
                for frame in kinds if frame.kind == "I"]
    assert messages == [bri.CALL_PROCEEDING, bri.ALERTING, bri.CONNECT]
    assert peer.call_state == "active"
    assert peer.vr == 1 and peer.vs == 3
    assert any("calling 5551212" in text for _, text in peer.events)


def test_an_out_of_sequence_i_frame_is_rejected_rather_than_accepted():
    wire = Wire()
    peer = bri.BriNetwork()
    peer.state = bri.MULTIPLE_FRAME
    wire.from_modem.append(
        bri.i_frame(0, 0, ns=4, nr=0, pf=False,
                    info=bri.q931_message(bri.SETUP, 1, True))
    )
    peer.service(wire, 0)
    answer = bri.decode(wire.to_modem[-1], from_user=False)
    assert answer.kind == "S" and (answer.control & 0x0F) == bri.S_REJ
    assert peer.vr == 0 and peer.call_state == "null"


def test_a_call_the_network_places_reaches_the_modem_as_setup():
    wire = Wire()
    peer = bri.BriNetwork(call_at=0, call_from="5551000", call_to="5551212")
    peer.state = bri.MULTIPLE_FRAME
    peer.service(wire, 0)
    frame = bri.decode(wire.to_modem[-1], from_user=False)
    assert frame.kind == "I"
    message = bri.decode_q931(frame.info)
    assert message.message_type == bri.SETUP
    assert message.number(bri.IE_CALLING_PARTY_NUMBER) == "5551000"
    assert message.number(bri.IE_CALLED_PARTY_NUMBER) == "5551212"


def test_the_peer_never_reaches_past_the_two_buffers():
    # The point of the peer is that it is a peer: if it ever needed anything
    # but deliver_frame and take_sent it would be poking the modem instead of
    # talking to it. A wire with nothing else on it is the check.
    wire = Wire()
    peer = bri.BriNetwork(call_at=0)
    for step in range(0, 10 * bri.T200_INSTRUCTIONS, bri.T200_INSTRUCTIONS // 4):
        peer.service(wire, step)
    assert wire.to_modem and peer.frames_out == len(wire.to_modem)
