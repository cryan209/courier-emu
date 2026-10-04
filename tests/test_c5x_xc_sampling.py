"""XC pipeline conditions from SPRU056D 4.5.6 and 6-278."""
import struct
import pytest
from courier_emu.dsp import NativeC5x

def run(program, steps):
    core=NativeC5x.from_program(0x6000,struct.pack('<%dH'%len(program),*program))
    core.set_pc(0x6000)
    core.step(steps)
    return core

@pytest.mark.parametrize('add,expected', [((0xb807,),0xeeee),((0xbf90,0x1234),0)])
def test_xc_eq_uses_one_cycle_old_condition(add,expected):
    # TI examples 4-6/4-7: the short ADD does not affect XC; the long ADD does.
    with run((0xb900,*add,0xf788,0xae60,0xeeee),4) as core:
        assert core.data(0x60)==expected
        assert core.state()['acc']==(7 if len(add)==1 else 0x1234)

def test_xc_lt_keeps_subtract_result_across_intervening_lacl():
    # The original PCM bitmap summarizer loads its counter between SUB and XC.
    with run((0xb903,0xba14,0xb900,0xe744,0xb801),5) as core:
        assert core.state()['acc']==1

@pytest.mark.parametrize('flag_set,flag_clear,xc',[
    (0xbe4f,0xbe4e,0xf711),  # carry
    (0xbe4b,0xbe4a,0xf500),  # TC
])
def test_xc_samples_status_before_single_cycle_predecessor(flag_set,flag_clear,xc):
    with run((flag_set,0x8b00,flag_clear,xc,0xae60,0xaaaa),5) as core:
        assert core.data(0x60)==0xaaaa

def test_xc_after_delayed_branch_samples_last_delay_instruction_prestate():
    # The final delay-slot ADD must not erase the EQ sampled before it.
    with run((0x7d80,0x6004,0xb900,0xb807,0xf788,0xae60,0xeeee),3) as core:
        assert core.data(0x60)==0xeeee

def test_cpl_long_immediate_result_reaches_following_xc():
    # CPL #lk is two cycles, so its TC is available to the XC that follows it.
    program=(0x5f60,0x1234,0xf500,0xae61,0xaaaa)
    core=NativeC5x.from_program(0x6000,struct.pack('<%dH'%len(program),*program))
    with core:
        core.set_data(0x60,0x1234); core.set_data(0x61,0)
        core.set_pc(0x6000); core.step(3)
        assert core.data(0x61)==0xaaaa

@pytest.mark.parametrize('opcode',[0x5e60,0x5f60,0x5d60,0x5c60])
def test_logical_long_immediates_take_two_cycles(opcode):
    program=(opcode,0x00ff,0x8b00)
    core=NativeC5x.from_program(0x6000,struct.pack('<%dH'%len(program),*program))
    with core:
        core.set_pc(0x6000); before=core.state()['cycles']; core.step(1)
        assert core.state()['cycles']-before==2
