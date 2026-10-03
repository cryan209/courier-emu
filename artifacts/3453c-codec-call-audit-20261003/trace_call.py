"""Reproduce the bounded dial/hook trace with a disposable parameter flash."""
import argparse
from dataclasses import asdict
import json
from pathlib import Path
import shutil
import tempfile

from capstone import Cs, CS_ARCH_X86, CS_MODE_16
from courier_emu.codec import CodecBringUp, SiliconDaa
from courier_emu.daa import CourierDaa
from courier_emu.flash import ParameterFlash
from courier_emu.machine import CourierMachine
from courier_emu.xmf import XmfImage

parser = argparse.ArgumentParser()
parser.add_argument('--parameters', type=Path, required=True)
parser.add_argument('--output', type=Path, required=True)
parser.add_argument('--hardware-timers', choices=('interrupts', 'full'))
args = parser.parse_args()
image = XmfImage.load('2_3_33.XMF')
dis = Cs(CS_ARCH_X86, CS_MODE_16)
records = []

def observe(pc):
    if 2346200 <= machine.instructions <= 2349300:
        uc = machine.uc
        regs = machine._x86_const
        fields = [uc.reg_read(getattr(regs, 'UC_X86_REG_' + r)) for r in ('AX','BX','CX','DX','FLAGS')]
        ins = next(dis.disasm(bytes(uc.mem_read(pc, 15)), pc, count=1), None)
        records.append(f'{machine.instructions:8d} {pc:05x} ' + ' '.join(f'{v:04x}' for v in fields) + f'  {ins.mnemonic} {ins.op_str}')

with tempfile.TemporaryDirectory() as tmp:
    flash = Path(tmp) / 'parameters.bin'
    shutil.copyfile(args.parameters, flash)
    machine = CourierMachine(image, with_dsp=True, board_id=0, tick_ms=5,
        serial_input=b'ATX1S27=1S58=1DT5551234\r', daa=CourierDaa('disconnected'),
        codec=CodecBringUp(SiliconDaa(1, revision=19)),
        parameter_flash=ParameterFlash.load(flash), code_observer=observe)
    if args.hardware_timers:
        machine.emulate_interrupts = True
        machine.timers.answers_reads = args.hardware_timers == 'full'
    try:
        result = machine.run(3_000_000)
        report = result.to_dict()
    except RuntimeError as error:
        report = {'error': str(error), 'instructions': machine.instructions,
                  'timers': machine.timers.status(),
                  'bridge': asdict(machine.dsp_bridge.status())}
    args.output.with_suffix('.json').write_text(json.dumps(report, indent=2))
    if machine.dsp_bridge.core:
        machine.dsp_bridge.core.close()
args.output.write_text('instruction pc    ax   bx   cx   dx flags  instruction\n' + '\n'.join(records) + '\n')
