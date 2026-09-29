import struct

from courier_emu.dsp import NativeC5x


def program(*words: int) -> bytes:
    return struct.pack(f"<{len(words)}H", *words)


def repeated_macd_cycles(taps: int) -> int:
    # lar ar1,#0300 ; mar *,ar1 ; rpt #(taps-1) ; macd 0x0000,*-
    # Coefficients come from program 0x0000 (the image itself); the delay line
    # is in B1 DARAM at 0x0300 - the phase-3 receiver's own placement
    # (rpt #51 / rpt #a1 macd over 0x04xx at 0x9ee5 and 0x9ef3).
    words = (0xBF09, 0x0300, 0x8B89, 0xBB00 | (taps - 1), 0xA390, 0x0000)
    with NativeC5x.from_program(0x8000, program(*words), rebuild=True) as core:
        core.set_pc(0x8000)
        core.step(3)
        before = core.state()["cycles"]
        core.step(1)
        return core.state()["cycles"] - before


def test_repeated_macd_over_daram_retires_a_tap_per_cycle():
    # SPRU056D 6-155: operand 2 in DARAM, repeated: n + 2.
    assert repeated_macd_cycles(82) == 84
    assert repeated_macd_cycles(162) == 164


def test_step_cycles_reports_native_progress_without_undershooting():
    # nop ; b 0000. The branch takes four cycles, so a cycle budget may be
    # exceeded by the final instruction but must never be undershot.
    with NativeC5x.from_program(0, program(0x5500, 0x7980, 0x0000),
                               rebuild=True) as core:
        instructions, cycles = core.step_cycles(10)

        assert instructions > 0
        assert cycles >= 10
        state = core.state()
        assert state["instructions"] == instructions
        assert state["cycles"] == cycles


def test_imodem_advance_collects_state_with_the_cycle_run():
    with NativeC5x.from_program(0, program(0x5500, 0x7980, 0x0000),
                               rebuild=True) as core:
        instructions, cycles, status, tag, value, writes, pcm = (
            core.advance_imodem(10, 0)
        )

        assert instructions > 0
        assert cycles >= 10
        assert (status, tag, value, writes, pcm) == (
            0xFFFF, 0xFFFF, 0xFFFF, 0, b""
        )


def test_cycle_budget_fast_forwards_idle_without_changing_state():
    cores = [
        NativeC5x.from_program(0x8000, program(0xBE22), rebuild=True)
        for _ in range(2)
    ]
    try:
        slow, fast = cores
        slow.set_pc(0x8000)
        fast.set_pc(0x8000)
        slow.step(1)
        fast.step(1)
        slow.step(20_000)
        instructions, cycles = fast.step_cycles(20_000)

        assert instructions == 20_000
        assert cycles == 20_000
        assert slow.state() == fast.state()
        assert slow.serial_state() == fast.serial_state()
    finally:
        for core in cores:
            core.close()


def test_idle_fast_forward_stops_at_pcm_frame_boundaries():
    cores = [
        NativeC5x.from_program(0x8000, program(0xBE22), rebuild=True)
        for _ in range(2)
    ]
    try:
        slow, fast = cores
        for core in cores:
            core.set_pc(0x8000)
            core.configure_digital_pcm(clock_hz=40_320_000)
            core.configure_line_frame_interrupt(5, 0xFFFF)
            core.queue_g711_rx(bytes(range(16)))
            core.step(1)

        slow.step(20_000)
        fast.step_cycles(20_000)

        assert slow.state() == fast.state()
        assert slow.serial_state() == fast.serial_state()
        assert slow.g711_tx() == fast.g711_tx()
        assert slow.g711_rx_pending() == fast.g711_rx_pending()
        assert slow.g711_rx_underruns() == fast.g711_rx_underruns()
    finally:
        for core in cores:
            core.close()


def test_idle_fast_forward_stops_at_timer_expiry():
    # PRD=TIM=100, timer running with a one-cycle prescaler, then IDLE.
    code = program(0xAE25, 100, 0xAE24, 100, 0xAE26, 0, 0xBE22)
    cores = [
        NativeC5x.from_program(0x8000, code, rebuild=True)
        for _ in range(2)
    ]
    try:
        slow, fast = cores
        for core in cores:
            core.set_pc(0x8000)
            core.step(4)

        slow.step(1_000)
        fast.step_cycles(1_000)

        assert slow.state() == fast.state()
        assert slow.register(0x24) == fast.register(0x24)
        assert slow.register(0x26) == fast.register(0x26)
        assert slow.register(0x06) == fast.register(0x06)
    finally:
        for core in cores:
            core.close()
