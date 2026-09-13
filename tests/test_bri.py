"""The Q.921/Q.931 peer, checked against the standards it is built from."""
from courier_emu import bri


class Wire:
    """A stand-in for the S interface, so the peer can be driven without
    booting the firmware.

    It offers exactly the three things the chip offers a line - the receive
    buffer, the transmit buffer, and the state its receiver reports - and
    nothing else, so a peer that reached for anything more would fail here.
    """

    def __init__(self, activated=True):
        self.activated = activated
        self.liu_state = bri.F7_ACTIVATED if activated else bri.F3_DEACTIVATED
        self.to_modem = []
        self.from_modem = []
        self.line_states = []

    def deliver_frame(self, frame):
        self.to_modem.append(bytes(frame))

    def take_sent(self):
        frames, self.from_modem = self.from_modem, []
        return frames

    def set_liu_state(self, state):
        self.liu_state = state
        self.line_states.append(state)
        self.activated = state == bri.F7_ACTIVATED


class InboundSipPeer:
    def __init__(self):
        self.polled = 0
        self.rang = 0
        self.started = 0
        self.ended = False

    def poll(self):
        self.polled += 1

    def incoming_call(self):
        return "8406", "7349195"

    def remote_ended(self):
        return self.ended

    def ring(self):
        self.rang += 1

    def start(self):
        self.started += 1

    def exchange(self, octets):
        return b"\xff" * len(octets)

    def stop(self):
        pass

    def status(self):
        return {}


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
    peer = bri.BriNetwork(activate_at=None)
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
    peer = bri.BriNetwork(activate_at=None)
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
    peer = bri.BriNetwork(establish="terminal", activate_at=None)
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
    peer = bri.BriNetwork(activate_at=None)
    peer.state = bri.MULTIPLE_FRAME
    setup = bri.q931_message(bri.SETUP, 0x0A, True,
                             bri.element(bri.IE_BEARER_CAPABILITY,
                                         bri.BEARER_UNRESTRICTED_64K)
                             + bri.called_party_number("5551212"))
    wire.from_modem.append(bri.i_frame(0, 0, ns=0, nr=0, pf=False, info=setup))
    peer.service(wire, 0)

    # Basic-access signalling has a one-frame window. Each acknowledgement
    # releases the next call-control message; CONNECT needs a Q.931 ACK too.
    assert peer.call_state == "connect-request"
    assert peer.vs == 1
    for nr in (1, 2, 3):
        wire.from_modem.append(bri.s_frame(0, 0, bri.S_RR, False, nr, False))
        peer.service(wire, nr * 1000)
    kinds = [bri.decode(frame, from_user=False) for frame in wire.to_modem]
    assert kinds[0].kind == "S"
    messages = [bri.decode_q931(frame.info).message_type
                for frame in kinds if frame.kind == "I"]
    assert messages == [bri.CALL_PROCEEDING, bri.ALERTING, bri.CONNECT]
    assert peer.call_state == "connect-request"
    assert peer.vr == 1 and peer.vs == 3
    assert any("calling 5551212" in text for _, text in peer.events)
    assert peer.status()["outbound_setup"] == {
        "bearer_capability": "88 90",
        "low_layer_compatibility": None,
    }
    wire.from_modem.append(bri.i_frame(0, 0, 1, 3, False,
        bri.q931_message(bri.CONNECT_ACKNOWLEDGE, 0x0A, True)))
    peer.service(wire, 4000)
    assert peer.call_state == "active"


def test_the_peer_records_both_outbound_setup_bearer_fields():
    wire = Wire()
    peer = bri.BriNetwork(activate_at=None)
    peer.state = bri.MULTIPLE_FRAME
    setup = bri.q931_message(
        bri.SETUP, 1, True,
        bri.element(bri.IE_BEARER_CAPABILITY,
                    bri.audio_bearer())
        + bri.element(bri.IE_LOW_LAYER_COMPATIBILITY,
                      bri.LLC_V120 + bytes.fromhex("48763bc0c2e2")))
    wire.from_modem.append(bri.i_frame(0, 0, 0, 0, False, setup))
    peer.service(wire, 0)
    assert peer.status()["outbound_setup"] == {
        "bearer_capability": "90 90 a2",
        "low_layer_compatibility": "88 90 28 48 76 3b c0 c2 e2",
    }


def test_an_out_of_sequence_i_frame_is_rejected_rather_than_accepted():
    wire = Wire()
    peer = bri.BriNetwork(activate_at=None)
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
    peer = bri.BriNetwork(activate_at=None, call_at=0,
                          call_from="5551000", call_to="5551212")
    peer.state = bri.MULTIPLE_FRAME
    peer.service(wire, 0)
    frame = bri.decode(wire.to_modem[-1], from_user=False)
    assert frame.kind == "I"
    message = bri.decode_q931(frame.info)
    assert message.message_type == bri.SETUP
    assert message.number(bri.IE_CALLING_PARTY_NUMBER) == "5551000"
    assert message.number(bri.IE_CALLED_PARTY_NUMBER) == "5551212"


def test_an_inbound_sip_call_places_an_audio_call_and_tracks_alerting():
    wire = Wire()
    peer = bri.BriNetwork(activate_at=None)
    peer.state = bri.MULTIPLE_FRAME
    sip = InboundSipPeer()
    peer.media_peer = sip

    peer.service(wire, 0)
    setup_frame = bri.decode(wire.to_modem[-1], from_user=False)
    setup = bri.decode_q931(setup_frame.info)
    assert setup.message_type == bri.SETUP
    assert setup.number(bri.IE_CALLING_PARTY_NUMBER) == "8406"
    assert setup.number(bri.IE_CALLED_PARTY_NUMBER) == "7349195"
    assert setup.elements[bri.IE_BEARER_CAPABILITY] == bri.audio_bearer()
    assert sip.polled == 1

    alerting = bri.q931_message(bri.ALERTING, 1, True)
    wire.from_modem.append(bri.i_frame(0, 0, ns=0, nr=1, pf=False,
                                       info=alerting))
    peer.service(wire, 1000)
    assert peer.call_state == "delivered"
    assert sip.rang == 1


def test_an_explicit_bri_number_maps_a_sip_extension_to_the_terminal():
    wire = Wire()
    peer = bri.BriNetwork(activate_at=None, call_to="7349195")
    peer.state = bri.MULTIPLE_FRAME
    peer.media_peer = InboundSipPeer()
    peer.service(wire, 0)
    setup = bri.decode_q931(bri.decode(wire.to_modem[-1], from_user=False).info)
    assert setup.number(bri.IE_CALLED_PARTY_NUMBER) == "7349195"


def test_sip_bye_clears_the_bri_call():
    wire = Wire()
    peer = bri.BriNetwork(activate_at=None)
    peer.state = bri.MULTIPLE_FRAME
    peer.call_reference = 7
    peer.call_state = "active"
    peer._call_originated_by_network = True
    sip = InboundSipPeer()
    sip.ended = True
    peer.media_peer = sip

    peer.service(wire, 0)
    messages = [bri.decode_q931(bri.decode(frame, from_user=False).info)
                for frame in wire.to_modem
                if bri.decode(frame, from_user=False).kind == "I"]
    assert messages[-1].message_type == bri.DISCONNECT
    assert messages[-1].cause_value == bri.CAUSE_NORMAL_CLEARING
    assert peer.call_state == "release-request"


def test_the_nt_walks_the_line_up_rather_than_jumping_it():
    # The firmware's layer-1 machine dispatches on the state it is in and
    # drops an event that skips ahead, so an NT that jumped straight to F7
    # would leave the modem thinking the line is still down. The walk is the
    # network's, so this is the peer's own contract.
    wire = Wire(activated=False)
    peer = bri.BriNetwork()
    for step in range(0, bri.ACTIVATE_AT_INSTRUCTIONS
                      + 4 * bri.LINE_STEP_INSTRUCTIONS,
                      bri.LINE_STEP_INSTRUCTIONS // 4):
        peer.service(wire, step)
    assert wire.line_states == list(bri.NT_ACTIVATION_WALK)
    assert wire.activated


def test_the_nt_can_drop_the_line_again():
    wire = Wire(activated=False)
    peer = bri.BriNetwork(
        deactivate_at=bri.ACTIVATE_AT_INSTRUCTIONS
        + 10 * bri.LINE_STEP_INSTRUCTIONS)
    for step in range(0, bri.ACTIVATE_AT_INSTRUCTIONS
                      + 12 * bri.LINE_STEP_INSTRUCTIONS,
                      bri.LINE_STEP_INSTRUCTIONS // 4):
        peer.service(wire, step)
    assert wire.line_states[-1] == bri.F3_DEACTIVATED
    assert peer.state == bri.TEI_UNASSIGNED


def test_the_peer_never_reaches_past_the_line():
    # The point of the peer is that it is a peer: if it ever needed anything
    # but the two buffers and the line state it would be poking the modem
    # instead of talking to it. A wire with nothing else on it is the check.
    wire = Wire()
    peer = bri.BriNetwork(activate_at=None, call_at=0)
    for step in range(0, 10 * bri.T200_INSTRUCTIONS, bri.T200_INSTRUCTIONS // 4):
        peer.service(wire, step)
    assert wire.to_modem and peer.frames_out == len(wire.to_modem)


def test_the_isdn_block_accounts_for_itself_exactly():
    # The field offsets come from the firmware's own ATI12 descriptor table,
    # and the check on having read it right is that the fields tile the block
    # with no gap and no overlap: a wrong offset anywhere breaks the total.
    from courier_emu import imodem_config as config

    fields = [
        (config.SWITCH_PROTOCOL, 1), (config.BUS_CONFIGURATION, 1),
        (config.VOICE_SPID, config.NUMBER_LENGTH),
        (config.DATA_SPID, config.NUMBER_LENGTH),
        (config.VOICE_DIRECTORY_NUMBER, config.NUMBER_LENGTH),
        (config.DATA_DIRECTORY_NUMBER, config.NUMBER_LENGTH),
        (config.VOICE_TEI, config.TEI_LENGTH),
        (config.DATA_TEI, config.TEI_LENGTH),
        (config.DIALING_MODE, 1),
    ]
    cursor = 0
    for offset, length in fields:
        assert offset == cursor, f"{offset} leaves a gap or overlaps"
        cursor += length
    assert cursor == config.ISDN_BLOCK_LENGTH


def test_the_dipswitch_bank_reads_the_way_the_firmware_expects():
    # Both switches are bits of port 0x12, and the board's signal helper
    # reports one present when its bit reads 0 - the same inversion the
    # modem-status lines carry. An all-on bank therefore reads 0x00, which is
    # what the port answered before it was modelled at all.
    from courier_emu.isdn import DIPSWITCH_BITS, DIPSWITCH_PORT, IsdnMachine
    from courier_emu.nac import NacImage

    image = NacImage.load("Ie030002.nac")
    assert IsdnMachine(image).read_port(DIPSWITCH_PORT) == 0x00
    for switch, mask in DIPSWITCH_BITS.items():
        machine = IsdnMachine(image, dipswitches={switch: False})
        assert machine.read_port(DIPSWITCH_PORT) == mask

    # An explicit --port assignment still overrides the bank, so the older way
    # of poking this port keeps working.
    machine = IsdnMachine(image, port_values={DIPSWITCH_PORT: 0x33})
    assert machine.read_port(DIPSWITCH_PORT) == 0x33


def test_the_firmware_trace_ring_decodes_to_its_own_lines():
    from courier_emu import imodem_trace

    # The printer packs characters two to a word low byte first, so the ring
    # read as bytes is already the text, and terminates each entry with CRLF.
    raw = b"LINE_ACTIVE Detected\r\nl4_DISCONN : modem primitive\r\n"
    assert imodem_trace.decode(raw) == [
        "LINE_ACTIVE Detected",
        "l4_DISCONN : modem primitive",
    ]
    # Capacity is the gap between the ring and its index, in words.
    assert imodem_trace.TRACE_WORDS == 2048
    assert imodem_trace.ring_address() == 0xCE0 * 16 + 0xA79A


def test_reading_the_trace_of_a_machine_that_has_not_run_is_empty():
    from courier_emu import imodem_trace
    from courier_emu.isdn import IsdnMachine
    from courier_emu.nac import NacImage

    # No unicorn instance yet, so there is nothing to read and nothing to
    # invent - an index outside the ring reads as empty rather than decoding
    # whatever happens to be at the address.
    machine = IsdnMachine(NacImage.load("Ie030002.nac"))
    assert imodem_trace.read(machine) == []


def test_an_unanswered_setup_is_retransmitted_once_and_then_cleared():
    # Q.931 T303. Without it the peer sits on `call-present` for the rest of
    # a run, reporting a call no terminal ever took - which is exactly how a
    # firmware that ignores the SETUP came to look like a peer that had
    # placed one successfully.
    wire = Wire()
    peer = bri.BriNetwork(activate_at=None, call_at=0)
    peer.state = bri.MULTIPLE_FRAME
    peer.service(wire, 0)
    assert peer.call_state == "call-present"
    setups = len(wire.to_modem)
    wire.from_modem.append(bri.s_frame(0, 0, bri.S_RR, False, 1, False))
    peer.service(wire, 1000)

    peer.service(wire, bri.T303_INSTRUCTIONS)
    assert len(wire.to_modem) == setups + 1        # retransmitted once
    assert peer.call_state == "call-present"
    wire.from_modem.append(bri.s_frame(0, 0, bri.S_RR, False, 2, False))
    peer.service(wire, bri.T303_INSTRUCTIONS + 1000)

    peer.service(wire, 2 * bri.T303_INSTRUCTIONS)
    assert len(wire.to_modem) == setups + 1        # and no more
    assert peer.call_state == "null"
    assert any("clearing the call" in text for _, text in peer.events)


def test_rej_retransmits_the_unacknowledged_payload_and_keeps_sequence():
    wire = Wire()
    peer = bri.BriNetwork(activate_at=None, call_at=0)
    peer.state = bri.MULTIPLE_FRAME
    peer.service(wire, 0)
    original = wire.to_modem[-1]
    wire.from_modem.append(bri.s_frame(0, 0, bri.S_REJ, False, 0, False))
    peer.service(wire, 100)
    assert wire.to_modem[-1] == original
    assert peer.vs == 1
    wire.from_modem.append(bri.s_frame(0, 0, bri.S_RR, False, 1, False))
    peer.service(wire, 200)
    assert peer.status()['unacknowledged_ns'] is None


def test_lapd_rejects_truncated_control_and_invalid_address():
    for raw in (b'\x00\x01\x00', b'\x01\x01\x03', b'\x00\x00\x03'):
        assert bri.decode(raw) is None


def test_nt_deactivation_clears_an_active_call_and_pending_signalling():
    wire = Wire()
    peer = bri.BriNetwork(activate_at=None, deactivate_at=100)
    peer.state = bri.MULTIPLE_FRAME
    peer.call_reference = 7
    peer.call_state = 'active'
    peer.service(wire, 0)
    peer._send_layer3(0, bri.q931_message(bri.CONNECT, 7, False))
    peer.service(wire, 100)
    assert peer.call_state == 'null' and peer.call_reference is None
    assert peer.status()['unacknowledged_ns'] is None


def test_active_call_moves_media_on_the_selected_b_channel_only():
    from courier_emu.am79c30 import Am79C30

    dsc = Am79C30()
    dsc.set_liu_state(bri.F7_ACTIVATED)
    # The firmware's MCR1=16h route: B1 <-> peripheral port Bd.
    dsc.blocks[0x41] = bytearray((0x16,))
    peer = bri.BriNetwork(activate_at=None)
    peer.activated_at = 0
    peer.state = bri.MULTIPLE_FRAME
    peer.call_state = 'active'
    peer.media_channel = 1
    peer.queue_media(b'\x11\x22')

    peer.service(dsc, 0)
    assert peer.status()['media']['rx_delivered'] == 2
    assert bytes(dsc.bearer_rx[1]) == b'\x11\x22'

    # Two DSP frames consume switch input and put the DSP's octets on B1.
    assert dsc.clock_bearer({6: 0x33})[6] == 0x11
    assert dsc.clock_bearer({6: 0x44})[6] == 0x22
    peer.service(dsc, 1)
    assert peer.media_tx == b'\x33\x44'
    assert peer.status()['media']['tx_non_ff'] == 2


def test_outgoing_call_uses_the_channel_requested_by_the_modem():
    wire = Wire()
    peer = bri.BriNetwork(activate_at=None)
    peer.state = bri.MULTIPLE_FRAME
    setup = bri.q931_message(
        bri.SETUP, 9, True,
        bri.channel_identification(2) + bri.called_party_number('5551212'))
    wire.from_modem.append(bri.i_frame(0, 0, 0, 0, False, setup))
    peer.service(wire, 0)
    assert peer.media_channel == 2
    proceeding = next(
        bri.decode_q931(frame.info)
        for raw in wire.to_modem
        if (frame := bri.decode(raw, from_user=False)).kind == 'I')
    assert proceeding.elements[bri.IE_CHANNEL_IDENTIFICATION][0] & 3 == 2


def test_pre_call_idle_is_not_reported_as_connected_media():
    from courier_emu.am79c30 import Am79C30

    dsc = Am79C30()
    dsc.set_liu_state(bri.F7_ACTIVATED)
    dsc.blocks[0x41] = bytearray((0x16,))
    peer = bri.BriNetwork(activate_at=None)
    peer.activated_at = 0
    dsc.clock_bearer({6: 0xff})
    peer.service(dsc, 0)
    peer.call_state = 'active'
    peer.media_channel = 1
    dsc.clock_bearer({6: 0x55})
    peer.service(dsc, 1)
    assert peer.media_tx == b'\x55'


def test_a_layer_3_answer_stops_t303():
    wire = Wire()
    peer = bri.BriNetwork(activate_at=None, call_at=0)
    peer.state = bri.MULTIPLE_FRAME
    peer.service(wire, 0)
    wire.from_modem.append(bri.i_frame(
        0, 0, ns=0, nr=1, pf=False,
        info=bri.q931_message(bri.CALL_PROCEEDING, 1, False)))
    peer.service(wire, 1000)
    before = len(wire.to_modem)
    peer.service(wire, 3 * bri.T303_INSTRUCTIONS)
    assert len(wire.to_modem) == before            # nothing retransmitted


def test_the_peer_notices_the_line_going_down_underneath_it():
    # The firmware can deactivate its own LIU. A peer that only ever reads
    # back the state it set would keep reporting a data link that cannot
    # exist - which is what made a firmware-side line drop look like a peer
    # bug in the first place.
    wire = Wire(activated=False)
    peer = bri.BriNetwork()
    for step in range(0, bri.ACTIVATE_AT_INSTRUCTIONS
                      + 4 * bri.LINE_STEP_INSTRUCTIONS,
                      bri.LINE_STEP_INSTRUCTIONS // 4):
        peer.service(wire, step)
    peer.state = bri.MULTIPLE_FRAME
    assert peer.status()["line"] == "active"

    # the firmware drops it, with nothing on the peer's side asking for that
    wire.activated = False
    wire.liu_state = bri.F3_DEACTIVATED
    peer.service(wire, bri.ACTIVATE_AT_INSTRUCTIONS
                 + 10 * bri.LINE_STEP_INSTRUCTIONS)
    assert peer.status()["line"] == "down"
    assert peer.state == bri.TEI_UNASSIGNED
    assert peer.call_state == "null"
    assert any("went down underneath us" in text for _, text in peer.events)


def test_the_chips_random_registers_are_a_generator_not_storage():
    # The Am79C30's RNGR pair is what the firmware reads for a TEI Identity
    # Request's reference number. Answering it out of the register file gave
    # Ri 0 on every request ever made in this harness.
    from courier_emu.am79c30 import Am79C30, DLC_RNGR1, DLC_RNGR2

    part = Am79C30()
    part.select(DLC_RNGR1)
    values = [part.read_data() for _ in range(6)]
    assert any(values), "a generator that only returns zero is the old bug"
    assert len(set(values)) > 1

    # ...but reproducible, so a run can be debugged twice.
    twin = Am79C30()
    twin.select(DLC_RNGR1)
    assert [twin.read_data() for _ in range(6)] == values

    # Both registers draw from the same generator, as one part would.
    part.select(DLC_RNGR2)
    assert part.read_data() != 0 or part.rng_reads > 6


def test_the_lsr_carries_the_handset_hook_in_its_top_two_bits():
    # Recovered from the firmware, not a datasheet: with LSR bit 7 asserted
    # its own trace log prints STAT_OFFHOOK when bit 6 is clear and
    # STAT_ONHOOK when it is set. Bit 7 is a change indication, so reading
    # LSR acknowledges it.
    from courier_emu.am79c30 import (
        Am79C30, F7_ACTIVATED, IR_LIU, LIU_LSR, LSR_HOOK_CHANGED,
        LSR_ON_HOOK, LSR_STATE_FIELD,
    )

    part = Am79C30()
    part.set_liu_state(F7_ACTIVATED)
    part.ir = 0

    # Resting: on hook, nothing changed, and the F-state is untouched.
    part.select(LIU_LSR)
    resting = part.read_data()
    assert resting & LSR_ON_HOOK
    assert not resting & LSR_HOOK_CHANGED
    assert resting & 7 == LSR_STATE_FIELD[F7_ACTIVATED]

    # Lifting it interrupts, the way a line-state change does.
    part.set_hook(False)
    assert part.ir & IR_LIU
    part.select(LIU_LSR)
    lifted = part.read_data()
    assert lifted & LSR_HOOK_CHANGED and not lifted & LSR_ON_HOOK

    # ...and the change is acknowledged by that read, not left standing.
    part.select(LIU_LSR)
    assert not part.read_data() & LSR_HOOK_CHANGED

    # Setting it to what it already is is not a change.
    before = part.hook_changes
    part.set_hook(False)
    assert part.hook_changes == before


def test_a_run_lifts_the_handset_when_it_is_asked_to():
    from courier_emu.isdn import IsdnMachine
    from courier_emu.nac import NacImage

    machine = IsdnMachine(NacImage.load("Ie030002.nac"), offhook_at=1000)
    assert machine.dsc.status()["hook"] == "on-hook"

    machine.instructions = 500
    machine.poll_timers()
    assert machine.dsc.on_hook, "not due yet"

    machine.instructions = 1500
    machine.poll_timers()
    assert not machine.dsc.on_hook
    assert machine.dsc.hook_changes == 1

    # and only once, however many times the timers run
    machine.instructions = 9000
    machine.poll_timers()
    assert machine.dsc.hook_changes == 1



def test_the_activated_lsr_value_is_the_one_the_firmware_transmits_in():
    # The firmware stores (LSR & 7) + 2 and its D-channel transmit gate at
    # 0x71c9b admits a frame only when that byte is 7, so the activated state
    # has to report 5. Reporting 6 instead - which this model did - stores 8,
    # and every frame queued for transmission is dropped: no TEI request goes
    # out, layer 2 never starts, and ATI12 reports Data Link Layer Inactive.
    from courier_emu.am79c30 import (
        Am79C30, F2_SENSING, F7_ACTIVATED, LIU_LSR, LSR_STATE_FIELD,
    )

    assert LSR_STATE_FIELD[F7_ACTIVATED] == 5
    part = Am79C30()
    part.set_liu_state(F7_ACTIVATED)
    part.on_hook = False
    part.select(LIU_LSR)
    assert (part.read_data() & 7) + 2 == 7, "the firmware's activated state"

    # And the state the layer-1 machine polls its way out of stores 3.
    part = Am79C30()
    part.set_liu_state(F2_SENSING)
    part.on_hook = False
    part.select(LIU_LSR)
    assert (part.read_data() & 7) + 2 == 3


def test_the_frame_check_sequence_leaves_iso_3309_s_residue():
    # A frame carrying its own good FCS runs to F0B8 and nothing else does,
    # which is the whole of the receiver's check.
    from courier_emu.v120 import FCS_GOOD, crc16, frame_check

    frame = bytes.fromhex("0a016f")
    assert crc16(frame + frame_check(frame)) == FCS_GOOD
    corrupted = bytearray(frame + frame_check(frame))
    corrupted[1] ^= 0x01
    assert crc16(bytes(corrupted)) != FCS_GOOD


def test_zero_bit_insertion_survives_a_payload_full_of_flags():
    # The point of the stuffing is that a frame can contain the flag and the
    # idle mark without either being mistaken for framing.
    from courier_emu.v120 import HdlcReceiver, HdlcTransmitter

    payload = bytes.fromhex("0a0100") + b"\x7e\xff\xff\x7e\x3e"
    for lsb_first in (True, False):
        transmitter = HdlcTransmitter(lsb_first)
        transmitter.send(payload)
        receiver = HdlcReceiver(lsb_first)
        receiver.feed(transmitter.octets(64))
        assert list(receiver.frames) == [payload]
        assert receiver.fcs_errors == receiver.aborts == receiver.runts == 0


def test_the_logical_link_identifier_spans_both_address_octets():
    # 13 bits across two octets with the C/R bit between them, and the same
    # asymmetry Q.921 gives that bit: one side's command is the other's
    # response, written the same way on the wire.
    from courier_emu.v120 import LLI_DEFAULT, address, decode

    assert LLI_DEFAULT == 256
    octets = address(LLI_DEFAULT, command=True, from_network=True)
    assert octets == bytes((0x0A, 0x01))
    seen = decode(octets + b"\x6f", from_network=False)
    assert seen is not None
    assert seen.lli == 256 and seen.command and seen.name == "SABME"

    # And a link identifier that uses both halves comes back whole.
    wide = address(0x1234, command=False, from_network=True)
    assert decode(wide + b"\x6f", from_network=True).lli == 0x1234


def test_the_link_answers_a_modem_that_establishes_first():
    # The peer offers to send SABME, but a terminal that gets there first is
    # answered rather than talked over.
    from courier_emu.v120 import HdlcReceiver, HdlcTransmitter, V120Link, address

    link = V120Link(establish=False)
    link.start()
    assert link.state == "released"

    modem = HdlcTransmitter()
    modem.send(address(256, command=True, from_network=False) + b"\x7f")
    reply = link.exchange(modem.octets(32))
    assert link.state == "established"

    seen = HdlcReceiver()
    seen.feed(reply)
    answer = [frame for frame in seen.frames]
    assert answer and answer[0][2] & ~0x10 == 0x63, "UA"
