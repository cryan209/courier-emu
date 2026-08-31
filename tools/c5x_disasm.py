#!/usr/bin/env python3
"""Small standalone TMS320C5x disassembler used by the firmware tools.

Opcode names and formats follow MAME's BSD-3-Clause tms320c5x disassembler.
"""
from __future__ import annotations

from dataclasses import dataclass


ZL = ("", "gt", "neq", "gt", "", "lt", "neq", "lt",
      "", "gt", "eq", "geq", "", "lt", "eq", "leq")
CV = ("", "nc", "nov", "nc nov", "", "c", "nov", "c nov",
      "", "nc", "ov", "nc ov", "", "c", "ov", "c ov")
TP = ("bio", "tc", "ntc", "")


@dataclass(frozen=True)
class Instruction:
    pc: int
    words: tuple[int, ...]
    text: str
    target: int | None = None
    flow: str = "next"

    @property
    def size(self) -> int:
        return len(self.words)


def address(opcode: int) -> str:
    low = opcode & 0x7f
    if not opcode & 0x80:
        return f"@{low:02x}"
    nar = low & 7
    forms = {
        0x0: "*", 0x1: f"*, ar{nar}", 0x2: "*-", 0x3: f"*-, ar{nar}",
        0x4: "*+", 0x5: f"*+, ar{nar}", 0x8: "*br0-",
        0x9: f"*br0-, ar{nar}", 0xa: "*0-", 0xb: f"*0-, ar{nar}",
        0xc: "*0+", 0xd: f"*0+, ar{nar}", 0xe: "*br0+",
        0xf: f"*br0+, ar{nar}",
    }
    return forms.get((low >> 3) & 0xf, "*?")


def condition(opcode: int) -> str:
    mask, value = opcode & 0xf, (opcode >> 4) & 0xf
    zl = (value & 0xc) | ((mask >> 2) & 3)
    cv = ((value << 2) & 0xc) | (mask & 3)
    return ", ".join(part for part in (ZL[zl], CV[cv], TP[(opcode >> 8) & 3]) if part)


def decode(words: list[int] | tuple[int, ...], pc: int) -> Instruction:
    op = words[pc]
    base = op >> 8
    extra = 0
    target: int | None = None
    flow = "next"

    def imm() -> int:
        nonlocal extra
        extra += 1
        return words[(pc + extra) & 0xffff]

    a = address(op)
    text = f".word   {op:04x}"
    if base <= 0x07: text = f"lar     ar{base & 7}, {a}"
    elif base == 0x08: text = f"lamm    {a}"
    elif base == 0x09: text = f"smmr    {a}, #{imm():04x}"
    elif base == 0x0a: text = f"subc    {a}"
    elif base == 0x0b: text = f"rpt     {a}"
    elif base == 0x0c: text = f"out     {a}, {imm():04x}"
    elif base == 0x0d: text = f"ldp     {a}"
    elif base == 0x0e: text = f"lst     st0, {a}"
    elif base == 0x0f: text = f"lst     st1, {a}"
    elif 0x10 <= base <= 0x1f: text = f"lacc    {a}" + (f", {base & 15}" if base & 15 else "")
    elif 0x20 <= base <= 0x2f: text = f"add     {a}" + (f", {base & 15}" if base & 15 else "")
    elif 0x30 <= base <= 0x3f: text = f"sub     {a}" + (f", {base & 15}" if base & 15 else "")
    elif 0x40 <= base <= 0x4f: text = f"bit     {base & 15}, {a}"
    elif base in range(0x50, 0x78):
        names = {0x50:"mpya",0x51:"mpys",0x52:"sqra",0x53:"sqrs",0x54:"mpy",0x55:"mpyu",
                 0x57:"bldp",0x58:"xpl",0x59:"opl",0x5a:"apl",0x5b:"cpl",0x60:"addc",
                 0x61:"add16",0x62:"adds",0x63:"addt",0x64:"subb",0x65:"sub16",0x66:"subs",
                 0x67:"subt",0x68:"zalr",0x69:"lacl",0x6a:"lacc16",0x6b:"lact",0x6c:"xor",
                 0x6d:"or",0x6e:"and",0x6f:"bitt",0x70:"lta",0x71:"ltp",0x72:"ltd",
                 0x73:"lt",0x74:"lts",0x75:"lph",0x76:"pshd",0x77:"dmov"}
        if base in names: text = f"{names[base]:7} {a}"
        elif 0x5c <= base <= 0x5f:
            text = f"{('xpl','opl','apl','cpl')[base-0x5c]:7} {a}, #{imm():04x}"
    elif base == 0x78: text = f"adrk    #{op & 0xff:02x}"
    elif 0x79 <= base <= 0x7f:
        names = {0x79:"b",0x7a:"call",0x7b:"banz",0x7c:"sbrk",0x7d:"bd",0x7e:"calld",0x7f:"banzd"}
        if base == 0x7c: text = f"sbrk    #{op & 0xff:02x}"
        else:
            target = imm(); text = f"{names[base]:7} {target:04x}, {a}"
            flow = "call" if base in (0x7a,0x7e) else "branch"
    elif 0x80 <= base <= 0x87: text = f"sar     ar{base & 7}, {a}"
    elif base == 0x88: text = f"samm    {a}"
    elif base == 0x89: text = f"lmmr    {a}, {imm():04x}"
    elif base == 0x8a: text = f"popd    {a}"
    elif base == 0x8b: text = "nop" if op == 0x8b00 else f"mar     {a}"
    elif base == 0x8c: text = f"spl     {a}"
    elif base == 0x8d: text = f"sph     {a}"
    elif base == 0x8e: text = f"sst     st0, {a}"
    elif base == 0x8f: text = f"sst     st1, {a}"
    elif 0x90 <= base <= 0x97: text = f"sacl    {a}" + (f", {base & 7}" if base & 7 else "")
    elif 0x98 <= base <= 0x9f: text = f"sach    {a}" + (f", {base & 7}" if base & 7 else "")
    elif base in (0xa0,0xa2):
        text = f"{('norm' if base == 0xa0 else 'mac'):7} {a}, {imm():04x}"
    elif base in (0xa3,0xa4,0xa6,0xa7,0xaa,0xab,0xac,0xad):
        text = f"{ {0xa3:'macd',0xa4:'blpd',0xa6:'tblr',0xa7:'tblw',0xaa:'mads',0xab:'madd',0xac:'bldd',0xad:'bldd'}[base]:7} {a}"
    elif base in (0xa5,0xa8,0xa9,0xae,0xaf):
        text = f"{ {0xa5:'blpd',0xa8:'bldd',0xa9:'bldd',0xae:'splk',0xaf:'in'}[base]:7} {a}, #{imm():04x}"
    elif 0xb0 <= base <= 0xb7: text = f"lar     ar{base & 7}, #{op & 0xff:02x}"
    elif base == 0xb8: text = f"add     #{op & 0xff:02x}"
    elif base == 0xb9: text = f"lacl    #{op & 0xff:02x}"
    elif base == 0xba: text = f"sub     #{op & 0xff:02x}"
    elif base == 0xbb: text = f"rpt     #{op & 0xff:02x}"
    elif base in (0xbc,0xbd): text = f"ldp     #{op & 0x1ff:03x}"
    elif base == 0xbe:
        names = {0x00:'abs',0x01:'cmpl',0x02:'neg',0x03:'pac',0x04:'apac',0x05:'spac',0x09:'sfl',0x0a:'sfr',0x0c:'rol',0x0d:'ror',0x10:'addb',0x11:'adcb',0x12:'andb',0x13:'orb',0x14:'rolb',0x15:'rorb',0x16:'sflb',0x17:'sfrb',0x18:'sbb',0x19:'sbbb',0x1a:'xorb',0x1b:'crgt',0x1c:'crlt',0x1d:'exar',0x1e:'sacb',0x1f:'lacb',0x20:'bacc',0x21:'baccd',0x22:'idle',0x23:'idle2',0x30:'cala',0x32:'pop',0x38:'reti',0x3a:'rete',0x3c:'push',0x3d:'calad',0x58:'zpr',0x59:'zap',0x5a:'sath',0x5b:'satl'}
        controls = {0x40:'clrc intm',0x41:'setc intm',0x42:'clrc ovm',0x43:'setc ovm',0x44:'clrc cnf',0x45:'setc cnf',0x46:'clrc sxm',0x47:'setc sxm',0x4a:'clrc tc',0x4b:'setc tc',0x4c:'clrc xf',0x4d:'setc xf',0x4e:'clrc carry',0x4f:'setc carry'}
        sub = op & 0xff
        if sub in names: text = names[sub]
        elif sub in controls: text = controls[sub]
        elif 0x60 <= sub <= 0x7f: text = f"intr    {sub & 0x1f}"; flow = "call"
        elif sub in (0x80,0x81,0x82,0x83): text = f"{('mpy','and','or','xor')[sub-0x80]:7} #{imm():04x}"
        elif sub in (0xc4,0xc5,0xc6): text = f"{('rpt','rptz','rptb')[sub-0xc4]:7} #{imm():04x}"
    elif base == 0xbf:
        sub, shift = (op >> 4) & 15, op & 15
        if sub == 0 and op & 8: text = f"lar     ar{op & 7}, #{imm():04x}"
        elif sub == 0: text = f"spm     #{op & 3}"
        elif sub == 4: text = f"cmpr    {('eq','lt','gt','neq')[op & 3]}"
        elif 8 <= sub <= 13: text = f"{('lacc','add','sub','and','or','xor')[sub-8]:7} #{(imm() << shift) & 0xffffffff:08x}"
        elif sub == 14: text = f"bsar    {shift + 1}"
    elif 0xc0 <= base <= 0xdf: text = f"mpy     #{op & 0x1fff:04x}"
    elif 0xe0 <= base <= 0xe3:
        target = imm(); text = f"bcnd    {target:04x}" + (f", {condition(op)}" if condition(op) else ""); flow = "branch"
    elif base in (*range(0xe4,0xe8), *range(0xf4,0xf8)):
        text = f"xc      {1 + ((op >> 12) & 1)}" + (f", {condition(op)}" if condition(op) else "")
    elif 0xe8 <= base <= 0xeb:
        target = imm(); text = f"cc      {target:04x}" + (f", {condition(op)}" if condition(op) else ""); flow = "call"
    elif 0xec <= base <= 0xef:
        text = "ret" if op == 0xef00 else "retc    " + condition(op); flow = "return"
    elif 0xf0 <= base <= 0xf3:
        target = imm(); text = f"bcndd   {target:04x}" + (f", {condition(op)}" if condition(op) else ""); flow = "branch"
    elif 0xf8 <= base <= 0xfb:
        target = imm(); text = f"ccd     {target:04x}" + (f", {condition(op)}" if condition(op) else ""); flow = "call"
    elif 0xfc <= base <= 0xff:
        text = "retd" if op == 0xff00 else "retcd   " + condition(op); flow = "return"

    return Instruction(pc, tuple(words[pc:pc + extra + 1]), text, target, flow)


def disassemble(words: list[int] | tuple[int, ...], first: int, last: int) -> list[Instruction]:
    result = []
    pc = first
    while pc < last:
        instruction = decode(words, pc)
        result.append(instruction)
        pc += instruction.size
    return result
