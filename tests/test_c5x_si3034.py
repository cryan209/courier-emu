import struct

import pytest

from courier_emu.dsp import NativeC5x


def control(core, word):
    # 15-bit primary audio requests a separate secondary transfer with bit 0.
    core.host_write(0x21, 1)
    core.host_write(0x21, word)


def configure_pll(core, pll2=0x11):
    for word in (0x0704, 0x083f, 0x0a00, 0x0900 | pll2):
        control(core, word)


@pytest.mark.parametrize('pll2,rate', [(0x11, 7200), (0x89, 8000), (0x23, 9600)])
def test_si3034_guest_pll_fields_determine_sample_clock(pll2, rate):
    with NativeC5x.from_program(0, b'', model='c52') as core:
        core.configure_si3034_codec()
        configure_pll(core, pll2)
        state = core.codec_state()
        assert state['sample_rate'] == rate
        assert state['registers'][7:11] == [4, 63, pll2, 0]
        assert state['register_writes'] == 4


def test_si3034_control_readback_and_country_register_are_not_audio():
    with NativeC5x.from_program(0, b'', model='c52') as core:
        core.configure_si3034_codec()
        control(core, 0x112c)
        control(core, 0x3100)
        assert core.codec_state()['registers'][17] == 0x2c
        assert core.codec_state()['register_reads'] == 1
        assert core.serial_state()['dxr'] == 0x3100
        assert core.line_tx_samples() == []


def test_si3034_frame_clock_and_power_down_gate_both_audio_directions():
    with NativeC5x.from_program(0, struct.pack('<32768H', *([0x8b00] * 32768)), model='c52') as core:
        core.configure_si3034_codec()
        core.configure_line_frame_interrupt(5, 0xffff)
        configure_pll(core)
        # Finish the requested secondary clock before testing primary PCM.
        core.step(core.codec_state()['frame_period'])
        control(core, 0x0660)  # PDL clear; call-progress monitor mutes remain.
        core.step(core.codec_state()['frame_period'])
        core.host_write(0x21, 0x1236)  # bit 1 is audio, unlike the AC01.
        core.queue_codec_rx([0x4567] * 4)
        core.step(core.codec_state()['frame_period'])
        assert core.line_tx_samples()[-1] == 0x1236
        assert core.serial_state()['drr'] == 0x4567
        control(core, 0x0670)  # PDL set; serial clock continues with silence.
        core.step(core.codec_state()['frame_period'] * 2)
        assert core.line_tx_samples()[-1] == 0
        assert core.serial_state()['drr'] == 0


def test_si3034_reset_preserves_part_selection_and_resets_pll():
    with NativeC5x.from_program(0, b'', model='c52') as core:
        core.configure_si3034_codec()
        configure_pll(core)
        core.reset()
        state = core.codec_state()
        assert state['model'] == 'si3034'
        assert not state['rate_programmed']
        assert state['registers'][6] == 0x70
        assert state['registers'][7:11] == [0, 0, 0, 0]


def test_si3034_cgm_latches_with_pll2_and_software_reset_keeps_board_clock():
    with NativeC5x.from_program(0, b'', model='c52') as core:
        core.configure_si3034_codec()
        core.set_codec_mclk(4_500_000)
        configure_pll(core)
        assert core.codec_state()['sample_rate'] == 11250
        control(core, 0x0a01)
        assert core.codec_state()['sample_rate'] == 11250
        control(core, 0x0911)
        assert core.codec_state()['sample_rate'] == 7200
        control(core, 0x0180)
        state = core.codec_state()
        assert state['mclk_hz'] == 4_500_000
        assert not state['rate_programmed']
        assert state['registers'][1] == 0


def test_si3034_status_reads_follow_external_hook_and_ring_inputs():
    with NativeC5x.from_program(0, struct.pack('<32768H', *([0x8b00] * 32768)), model='c52') as core:
        core.configure_si3034_codec()
        core.configure_line_frame_interrupt(5, 0xffff)
        configure_pll(core)
        control(core, 0x0660)
        control(core, 0x0502)  # external hook pin enabled
        core.set_si3034_line(True, True, False)
        control(core, 0x2c00)
        core.step(core.codec_state()['frame_period'] // 2 + 1)
        assert core.serial_state()['drr'] == 0x44  # frame lock and 25 mA loop
        core.set_si3034_line(True, False, True)
        control(core, 0x2500)
        core.step(core.codec_state()['frame_period'] // 2 + 1)
        assert core.serial_state()['drr'] == 0x66  # both ring polarities plus RDT


def test_si3034_codec_and_3453c_mailbox_keep_opposite_direction_latches_separate():
    code = struct.pack('<4H', 0xae7d, 0x0047, 0x0c7d, 0x805e)
    with NativeC5x.from_program(0x6000, code, model='c52') as core:
        core.configure_si3034_codec()
        core.configure_host_mailbox()
        core.set_host_io_base(0x8000)
        core.set_io(0x5e, 0x0084)
        core.set_pc(0x6000)
        core.step(2)
        assert core.io(0x5e) == 0x0084
        assert core.io_output(0x5e) == 0x0047


def test_si3034_transmit_mute_does_not_stop_serial_clock():
    with NativeC5x.from_program(0, struct.pack('<32768H', *([0x8b00] * 32768)), model='c52') as core:
        core.configure_si3034_codec()
        core.configure_line_frame_interrupt(5, 0xffff)
        configure_pll(core)
        control(core, 0x0660)
        control(core, 0x0f80)
        core.step(core.codec_state()['frame_period'])
        core.host_write(0x21, 0x1234)
        before = core.codec_state()['frames_clocked']
        core.step(core.codec_state()['frame_period'])
        assert core.codec_state()['frames_clocked'] == before + 1
        assert core.line_tx_samples()[-1] == 0
