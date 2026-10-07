"""The native B-channel path does what the Python one does, frame for frame."""
import random

import pytest

from courier_emu.am79c30 import Am79C30
from courier_emu.dsp import NativeC5x
from courier_emu.imodem_dsp import ImodemDsp

ROUTINGS = [
    (0x16,),                 # B1 <-> Bd
    (0x17, 0x28),            # B1 <-> Be, B2 <-> Bf
    (0x16, 0x12),            # B1 <-> Bd and B1 <-> B2
    (0x66,),                 # two peripheral ports joined
    (),                      # nothing routed
]


def build(native, routing):
    dsc = Am79C30()
    for index, value in enumerate(routing):
        dsc.blocks[0x41 + index] = bytearray([value])
        dsc.bearer_generation += 1
    dsc.write_data  # keep the linter honest about the attribute
    mailbox = ImodemDsp(dsc)
    mailbox.core = NativeC5x.from_program(0, b"\x00\x00")
    if native:
        assert mailbox.attach_native_bearer()
    dsc.activate()
    mailbox.lookahead_channels = (1,)
    return dsc, mailbox


def snapshot(dsc, mailbox):
    return (bytes(dsc.bearer_tx[1]), bytes(dsc.bearer_tx[2]),
            bytes(dsc.bearer_rx_heard[1]), bytes(dsc.bearer_rx_heard[2]),
            {c: dsc.bearer_routed[c] for c in (1, 2) if dsc.bearer_routed[c]},
            dict(dsc.bearer_underruns), dsc.bearer_frames,
            list(dsc.bearer_rx[1]), list(dsc.bearer_rx[2]),
            bytes(mailbox.pcm_tx), mailbox._pcm_partial, len(mailbox._ahead),
            mailbox.core.g711_rx_pending(), mailbox._sh.pcm_cursor)


@pytest.mark.parametrize("routing", ROUTINGS)
@pytest.mark.parametrize("seed", range(6))
def test_native_exchange_matches_python(routing, seed):
    rng = random.Random(seed)
    python = build(False, routing)
    native = build(True, routing)
    for step in range(120):
        action = rng.choice(["queue", "queue", "exchange", "exchange", "exchange",
                             "prefeed", "route", "line", "cancel"])
        for dsc, mailbox in (python, native):
            local = random.Random(seed * 1000 + step)
            if action == "queue":
                channel = local.choice((1, 1, 2))
                dsc.queue_bearer(channel, bytes(local.randrange(256)
                                                for _ in range(local.randrange(0, 40))))
            elif action == "exchange":
                octets = bytes(local.randrange(256) for _ in range(local.randrange(0, 9)))
                mailbox._sh.pcm_cursor = 0
                mailbox._sync_pcm(octets)
            elif action == "prefeed":
                mailbox.prefeed()
            elif action == "route":
                dsc.blocks[0x41] = bytearray([local.choice((0x16, 0x17, 0x15))])
                dsc.bearer_generation += 1
                dsc._bearer_changed()
                mailbox.cancel_lookahead()
            elif action == "line":
                dsc.set_liu_state(local.choice((4, 5, 5, 5)))
            elif action == "cancel":
                mailbox.cancel_lookahead()
        assert snapshot(*native) == snapshot(*python), (step, action)
