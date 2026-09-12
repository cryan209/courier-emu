import struct
from pathlib import Path

from courier_emu.dsp import NativeC5x
from courier_emu.quad_c50 import (
    LANE_BASE,
    LANE_STRIDE,
    RESIDENT_ORIGIN,
    RESIDENT_WORDS,
    RUNTIME_STATUS_PORT,
    QuadC50Endpoint,
)


def _tx_program(codeword: int) -> bytes:
    # splk @22, #40cc releases the serial port in the Quad's own format: SPC
    # bit 2, FO, set for eight-bit bytes, which is what makes one octet per
    # frame the right thing to expect. A program that never writes SPC is not
    # entitled to an opinion about the word format - the 302 writes 40c8 to the
    # same register and gets sixteen-bit words (docs/quad-dsp-pcm-path.md).
    # Then lacl #codeword; samm @21 (DXR); b 8004, the branch keeping the DSP -
    # not the host model - responsible for every byte in the transmit latch.
    words = (0xAE22, 0x40CC, 0xB800 | codeword, 0x9021, 0x7980, 0x8004)
    return struct.pack(f"<{len(words)}H", *words)


def _dsp_square_tone_program() -> bytes:
    # Main: release the Quad-format serial port, enable interrupts, then idle.
    words = [0xAE22, 0x40CC, 0xAE04, 0x0020,
             0xBE40, 0xBE22, 0x7980, 0x8005]
    words += [0x8B00] * (0x10 - len(words))
    # Frame ISR: toggle the G.711 sign bit and put the resulting octet in DXR.
    words += [0x6960, 0xBFD0, 0x0080, 0x9060, 0x9021, 0xBE3A]
    return struct.pack(f"<{len(words)}H", *words)


def test_native_digital_timeslot_preserves_g711_octets_at_8khz():
    core = NativeC5x.from_program(0x8000, _tx_program(0xA5))
    try:
        core.configure_digital_pcm(idle_codeword=0xD5)
        core.configure_line_frame_interrupt(5, 0xFFFF)
        core.set_pc(0x8000)
        core.queue_g711_rx(bytes((0x00, 0x7F, 0x80, 0xFF)))
        core.step(13_000)

        # 20.16 MHz / 8 kHz = 2520 cycles per frame. No companding conversion or
        # sign extension is allowed at this byte-formatted hardware boundary.
        assert core.codec_state()["frame_period"] == 2520
        assert core.g711_tx()[:4] == bytes((0xA5,) * 4)
        # Once the four queued octets are consumed the A-law idle octet is
        # clocked, rather than stale receive data being repeated.
        assert core.serial_state()["drr"] == 0xD5
    finally:
        core.close()


def test_quad_endpoint_buffers_g711_until_the_real_dsp_has_booted():
    endpoint = QuadC50Endpoint()
    endpoint.connect_digital_call(law="a")
    endpoint.receive_g711(b"\x55\xd5")

    assert endpoint.digital_call
    assert endpoint.g711_idle == 0xD5
    assert endpoint._g711_rx == b"\x55\xd5"
    assert endpoint.transmit_g711() == b""


def test_digital_call_waits_for_rom_download_before_clocking_octets():
    # A small transmit loop padded to the CPU's resident transfer size. It
    # must be loaded by the actual recovered ROM before any DS0 frame occurs.
    words = [0xAE22, 0x40CC, 0xB8A5, 0x9021, 0x7980, 0x8004]
    words += [0] * (RESIDENT_WORDS - len(words))
    endpoint = QuadC50Endpoint(program=words)
    endpoint.connect_digital_call(law="a")
    endpoint.receive_g711(b"\x55")
    endpoint._start_core()
    try:
        endpoint.service(100)
        assert endpoint.status()["boot_pending"]
        assert endpoint.transmit_g711() == b""
        assert endpoint._g711_rx == b"\x55"
        for _ in range(100):
            endpoint.service(1000)
            if not endpoint.status()["boot_pending"]:
                break
        assert not endpoint.status()["boot_pending"]
        assert endpoint.core.serial_state()["codec_rx_consumed"] == RESIDENT_WORDS + 3
        assert endpoint.status()["pcm_active"]
        assert endpoint._g711_rx == b""
        endpoint.service(1000)
        assert endpoint.transmit_g711()[-4:] == b"\xa5" * 4
        endpoint._strobe(0xFF)
        assert not endpoint.status()["pcm_active"]
        assert endpoint._event_cursor == 0
    finally:
        if endpoint.core is not None:
            endpoint.core.close()


def test_quad_runtime_overlay_waits_for_the_resident_c50_ack():
    stream = (Path(__file__).parents[1] /
              "artifacts/quad-c50-20260910/stream.bin").read_bytes()
    resident = stream[16:16 + RESIDENT_WORDS * 2]
    core = NativeC5x.from_program(RESIDENT_ORIGIN, resident)
    endpoint = QuadC50Endpoint(core=core, started=True, _in_reset=False)
    try:
        # The CPU request table supplies the overlay destination before it
        # starts the stream; use request 1's real destination here.
        core.set_data(0xFF63, 0xC300)
        core.set_pc(RESIDENT_ORIGIN)
        core.step(10_000)

        endpoint.write(RUNTIME_STATUS_PORT, 1, 4)
        assert endpoint.read(RUNTIME_STATUS_PORT, 1) & 4

        words = (0x1234, 0x5678, 0x9ABC, 0xDEF0)
        for index, word in enumerate(words):
            port = LANE_BASE + LANE_STRIDE * index
            endpoint.write(port, 1, word & 0xFF)
            endpoint.write(port + 2, 1, word >> 8)
        endpoint.write(RUNTIME_STATUS_PORT, 1, 2)
        assert endpoint.read(RUNTIME_STATUS_PORT, 1) & 2 == 0

        endpoint.service(2_000)
        assert endpoint.read(RUNTIME_STATUS_PORT, 1) & 2
        assert endpoint.program[-4:] == list(words)
        assert endpoint.runtime_bursts == endpoint.runtime_acks == 1
    finally:
        core.close()


def test_c50_program_produces_a_g711_tone_on_the_digital_timeslot():
    core = NativeC5x.from_program(0x8000, _dsp_square_tone_program())
    try:
        core.set_data(0x60, 0x1C)
        core.configure_digital_pcm(idle_codeword=0xFF)
        core.configure_line_frame_interrupt(5, 0x8010)
        core.set_pc(0x8000)
        core.step(40_000)

        emitted = core.g711_tx()[2:10]
        # The C50 ISR, not the line model, writes alternating signed mu-law
        # levels. At an 8 kHz frame rate this is a deterministic 4 kHz tone.
        assert emitted == bytes((0x1C, 0x9C)) * 4
        assert core.serial_state()["last_dxr_pc"] == 0x8014
    finally:
        core.close()
