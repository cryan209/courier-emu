import struct

from courier_emu.dsp import NativeC5x


def program(*words: int) -> bytes:
    return struct.pack(f"<{len(words)}H", *words)


def test_masked_interrupt_latches_ifr_then_vectors_when_enabled():
    # SPLK @IMR,#XINT ; CLRC INTM. The interrupt arrives first, while both
    # IMR and global recognition are disabled.
    words = [0xAE04, 1 << 5, 0xBE40]
    words.extend([0x8B00] * (0x0D - len(words)))
    with NativeC5x.from_program(0, program(*words), rebuild=True) as core:
        core.interrupt(5)

        assert core.register(0x06) == 1 << 5
        assert core.state()["pc"] == 0

        core.step(1)  # IMR enables XINT, but INTM is still set.
        assert core.state()["pc"] == 2
        assert core.register(0x06) == 1 << 5

        core.step(1)  # CLRC INTM recognizes the already-pending source.
        assert core.state()["pc"] == 0x0C
        assert core.register(0x06) == 0
        assert core.stack()[0] == 3


def test_nmi_is_taken_at_boundary_without_using_imr_or_ifr():
    words = [0x8B00] * 0x26
    with NativeC5x.from_program(0, program(*words)) as core:
        core.set_pc(0x10)
        core.nmi()

        # The pin callback latches the event; it does not rewrite PC in the
        # middle of the host instruction that drove the pin.
        assert core.state()["pc"] == 0x10
        assert core.register(0x06) == 0

        core.step(1)
        assert core.state()["pc"] == 0x25
        assert core.stack()[0] == 0x10


def test_nmi_waits_until_a_repeated_instruction_finishes():
    words = [0xBB02, 0x8B00, 0x8B00]
    words.extend([0x8B00] * (0x26 - len(words)))
    with NativeC5x.from_program(0, program(*words)) as core:
        core.step(1)  # RPT #2: execute the following instruction three times.
        core.nmi()

        core.step(1)
        assert core.state()["pc"] == 1
        core.step(1)
        assert core.state()["pc"] == 1
        core.step(1)
        assert core.state()["pc"] == 2

        core.step(1)
        assert core.state()["pc"] == 0x25
        assert core.stack()[0] == 2
