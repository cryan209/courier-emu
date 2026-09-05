from pathlib import Path
import struct
import pytest
from courier_emu.dsp import NativeC5x
from courier_emu.rom import CourierRom
from courier_emu.audio312 import render, spectrum
from tools.c5x_disasm import disassemble

ROM = Path(__file__).resolve().parents[1] / 'artifacts/courier-board-21210-capture-403/courier-board.rom'

class Image:
    def __init__(self, words):
        self.words = words
    def dsp_program_segments(self):
        return ((0, struct.pack('<%dH'%len(self.words), *self.words)),)


@pytest.mark.parametrize('opcode,expected', [(0x5260,800), (0x5360,200)])
def test_square_uses_memory_operand_and_accumulates_previous_product(opcode, expected):
    # TI SPRU056D 6-253/255: old PREG=300, ACC=500, dma=15, stale TREG=3.
    with NativeC5x(Image([0x7361,0xBE80,100,0xBF80,500,opcode,0xBE80,2])) as c:
        c.set_data(0x61,3);c.set_data(0x60,15)
        c.step(4)
        assert c.state()['acc'] == expected
        assert c.state()['preg'] == 225
        c.step(1)
        assert c.state()['preg'] == 30  # SQRA/SQRS also loaded TREG0=15


def test_pac_replaces_accumulator_without_changing_flags():
    with NativeC5x(Image([0x7360,0xBE80,5,0xBF80,100,0xBE03])) as c:
        c.set_data(0x60,7);c.step(3)
        flags = c.state()['flags']
        c.step(1)
        assert c.state()['acc'] == 35
        assert c.state()['flags'] == flags


def test_norm_sets_completion_flag_and_zero_does_not_advance_pointer():
    with NativeC5x(Image([0xBF8F,0x4000,0xA080,0xA080])) as c:
        c.step(2)
        assert c.state()['acc'] == 0x40000000
        assert not c.state()['flags'] & 4
        c.step(1)
        assert c.state()['acc'] == 0x40000000
        assert c.state()['flags'] & 4
    with NativeC5x(Image([0xA0A0])) as c:  # norm *+
        c.step(1)
        assert c.state()['flags'] & 4
        assert c.state()['ar0'] == 0


def test_norm_disassembly_does_not_swallow_following_square():
    code = disassemble([0xA080,0x527D,0x8D7E],0,3)
    assert [i.pc for i in code] == [0,1,2]
    assert code[1].text.startswith('sqra')


@pytest.mark.skipif(not ROM.exists(), reason='DSP 3.1.2 ROM capture absent')
@pytest.mark.parametrize('row,keys', [(697,'123A'),(770,'456B'),(852,'789C'),(941,'*0#D')])
def test_original_firmware_generates_all_keypad_pairs_at_serial_transmitter(row, keys):
    rom=CourierRom.load(ROM)
    for column,key in zip((1209,1336,1477,1633),keys):
        samples, serial = render(rom,key,720)
        result=spectrum(samples)
        assert (result['row'],result['column']) == (row,column)
        assert min(samples)<-10000 and max(samples)>10000
        assert all(s & 3 == 0 for s in samples)  # firmware clears codec/control bits
        assert serial['dxr_writes']==720
        assert serial['drr_reads']==720
        assert serial['last_dxr_pc']==0x818F


def test_repeated_square_walks_the_sample_buffer():
    with NativeC5x(Image([0xBF09,0x100,0x8B89,0xBB02,0x52A0,0xBE04])) as c:
        for address,value in zip(range(0x100,0x103),(3,4,5)):
            c.set_data(address,value)
        c.step(7)
        assert c.state()['acc']==50
        assert c.state()['ar1']==0x103
