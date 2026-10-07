"""Frames settled early and finished in bulk match clock_bearer frame by frame."""
import random

from courier_emu.am79c30 import Am79C30

SLOTS = [6, 7]


def make(queued):
    dsc = Am79C30()
    dsc.activate()
    # MUX register 0x41: connect B1 (1) to peripheral port Bd (6).
    dsc.blocks[0x41] = bytearray([0x16])
    dsc.queue_bearer(1, bytes(queued))
    return dsc


def state(dsc):
    return (bytes(dsc.bearer_tx[1]), bytes(dsc.bearer_tx[2]),
            bytes(dsc.bearer_rx_heard[1]), bytes(dsc.bearer_rx_heard[2]),
            dict(dsc.bearer_routed), dict(dsc.bearer_underruns),
            dsc.bearer_frames, list(dsc.bearer_rx[1]))


def test_lookahead_and_bulk_finish_equal_frame_by_frame_clocking():
    rng = random.Random(7)
    queued = [rng.randrange(256) for _ in range(40)]
    sent = [rng.randrange(256) for _ in range(2 * 25)]

    reference = make(queued)
    expected_rx = bytearray()
    for frame in range(25):
        outputs = reference.clock_bearer(
            {6: sent[2 * frame], 7: sent[2 * frame + 1]})
        expected_rx.extend(outputs.get(port, 0xFF) for port in SLOTS)

    early = make(queued)
    got_rx = bytearray()
    done = 0
    while done < 25:
        entries, octets = early.bearer_take_ahead(SLOTS, 6, (1,))
        if not entries:
            # Past what was queued: the frame-at-a-time path takes over.
            outputs = early.clock_bearer(
                {6: sent[2 * done], 7: sent[2 * done + 1]})
            got_rx.extend(outputs.get(port, 0xFF) for port in SLOTS)
            done += 1
            continue
        # Frames taken beyond the ones this test sends go back unused.
        early.bearer_return_ahead(entries[25 - done:])
        entries = entries[:25 - done]
        got_rx.extend(octets[:len(entries) * 2])
        batch = bytes(sent[2 * done:2 * (done + len(entries))])
        assert early.bearer_finish_batch(entries, batch, SLOTS)
        done += len(entries)

    assert state(early) == state(reference)
    assert bytes(got_rx) == bytes(expected_rx)


def test_nothing_is_settled_early_for_an_empty_call_channel():
    dsc = make([])
    assert dsc.bearer_take_ahead(SLOTS, 4, (1,)) == ([], b"")
    assert dsc.bearer_take_ahead(SLOTS, 4, ()) == ([], b"")
    dsc.queue_bearer(1, b"\x01\x02")
    entries, octets = dsc.bearer_take_ahead(SLOTS, 4, (1,))
    assert len(entries) == 2 and octets == b"\x01\xff\x02\xff"


def test_returned_frames_go_back_to_the_front_of_the_queue():
    dsc = make([1, 2, 3, 4])
    entries, _ = dsc.bearer_take_ahead(SLOTS, 3, (1,))
    assert list(dsc.bearer_rx[1]) == [4]
    dsc.bearer_return_ahead(entries)
    assert list(dsc.bearer_rx[1]) == [1, 2, 3, 4]
    assert not dsc.bearer_rx_heard[1]
