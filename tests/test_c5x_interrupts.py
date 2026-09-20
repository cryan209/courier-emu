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


def test_a_maskable_interrupt_waits_for_a_repeated_instruction_to_finish():
    # The same rule NMI already obeyed. RPTC and the repeat's pointers are not
    # in the context shadow, so vectoring out of the middle of a block loses
    # the rest of it.
    words = [0xAE04, 1 << 5, 0xBE40, 0xBB02, 0x8B00, 0x8B00]
    words.extend([0x8B00] * (0x0D - len(words)))
    with NativeC5x.from_program(0, program(*words), rebuild=True) as core:
        core.step(2)                      # IMR = XINT, INTM clear
        core.step(1)                      # RPT #2
        core.interrupt(5)

        assert core.register(0x06) == 1 << 5
        for expected in (4, 4, 5):        # three passes over the same word
            core.step(1)
            assert core.state()["pc"] == expected

        core.step(1)                      # the block is done; now it vectors
        assert core.state()["pc"] == 0x0C
        assert core.register(0x06) == 0


def test_enabling_imr_alone_recognizes_an_already_latched_flag():
    # The 2.x residents rewrite IMR at 0x10bc with INTM already clear, to move
    # the primary port's frame service from XINT to RINT. A flag latched while
    # that bit was masked has to be taken at the next boundary, without waiting
    # for the source to raise it again.
    words = [0xBE40, 0xAE04, 1 << 4]
    words.extend([0x8B00] * (0x0B - len(words)))
    with NativeC5x.from_program(0, program(*words), rebuild=True) as core:
        core.step(1)                      # CLRC INTM, IMR still zero
        core.interrupt(4)                 # RINT latches, masked
        assert core.register(0x06) == 1 << 4
        assert core.state()["pc"] == 1

        core.step(1)                      # SPLK @IMR, #RINT
        assert core.state()["pc"] == 3

        core.step(1)                      # no new edge, but it is eligible now
        assert core.state()["pc"] == 0x0A
        assert core.register(0x06) == 0


def test_nmi_vectors_through_iptr_rather_than_a_fixed_0x0024():
    # NMI ignores IMR and INTM, but its slot is offset 0x24 inside the same
    # relocatable table as every other vector.
    words = [0xAE07, 1 << 11]           # SPLK @PMST, #0800 -> IPTR = 1
    words.extend([0x8B00] * (0x830 - len(words)))
    with NativeC5x.from_program(0, program(*words)) as core:
        core.step(1)
        assert core.register(0x07) >> 11 == 1
        core.nmi()
        core.step(1)
        assert core.state()["pc"] == 0x0825
        assert core.stack()[0] == 2
