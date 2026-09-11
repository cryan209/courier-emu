from courier_emu.imodem_mailbox import ImodemMailbox


def test_lanes_are_directional_and_commit_requires_ack():
    sent = []
    box = ImodemMailbox(lambda tag, value: sent.append((tag, value)))
    assert box.read(0x1c) == 1
    assert box.offer_reply(0x1234, 0x5678)
    for port, value in zip(box.LANES, (0x5e, 0, 2, 0)):
        box.write(port, value)
    assert sent == []
    assert [box.read(p) for p in box.LANES] == [0x34, 0x12, 0x78, 0x56]
    assert box.read(0x1c) == 3
    box.write(0x1c, 1)
    assert sent == [(0x5e, 2)]
    assert box.read(0x1c) == 3
    box.write(0x1c, 0)
    assert len(sent) == 1
    assert not box.offer_reply(9, 10)
    box.write(0x1c, 2)
    assert box.read(0x1c) == 1
    assert box.replies_acked == 1
    assert box.offer_reply(9, 10)


def test_combined_ack_preserves_new_synchronous_reply():
    box = ImodemMailbox()
    box.on_command = lambda tag, value: box.offer_reply(tag + 1, value)
    box.offer_reply(1, 2)
    box.write(0x58, 7)
    box.write(0x1c, 3)
    assert box.rx == (8, 0)
    assert box.replies_acked == 1


def test_transmit_backpressure():
    box = ImodemMailbox()
    box.tx_ready = False
    assert box.read(0x1c) == 0
    box.write(0x1c, 1)
    assert box.committed == 0
    box.tx_ready = True
    box.write(0x1c, 1)
    assert box.committed == 1
