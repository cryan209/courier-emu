#!/usr/bin/env python3
"""Draw docs/asic-pinout.svg from the pin map in docs/asic-pinout.md.

The map is held here as data rather than parsed out of the prose, because the
prose carries the reasoning and the caveats and the table is only part of it.
When a reading lands or is corrected, edit PINS and re-run:

    python3 tools/draw_asic_pinout.py

Geometry follows the convention the document settles: 120 pins, 30 a side, pin
1 at the index dot in the part's own frame, numbering counter-clockwise viewed
from above - so 1-30 along the bottom, 31-60 up the right, 61-90 right to left
along the top, 91-120 down the left.
"""
from __future__ import annotations

from pathlib import Path

PINS: dict[int, tuple[str, str]] = {}


def setp(n, label, kind):
    PINS[n] = (label, kind)


setp(90,'VDD / DSP VDDD','pwr')
for i,n in enumerate(range(89,85,-1)): setp(n,'DSP A%d'%i,'dsp')
setp(85,'DSP A5','dsp')
for i,n in enumerate(range(84,76,-1)): setp(n,'CPU AD%d'%i,'cpu')
setp(74,'flash high addr','mem'); setp(71,"A0 -&gt; '32 (byte lane)",'mem'); setp(70,'A1 -&gt; RAM+flash','mem')
setp(57,'ALE  (CPU 38)','cpu'); setp(56,'WR#  (CPU 37)','cpu'); setp(55,'RD#  (CPU 36)','cpu')
setp(54,'? chip select','sus'); setp(53,'INT2/INTA0# (CPU 64)','cpu'); setp(47,'INT1 (CPU 63)','cpu')
setp(92,'DSP D15','dsp')
for i,n in enumerate(range(93,99)): setp(n,'DSP D%d'%(14-i),'dspi')
setp(99,'DSP D8','dsp'); setp(100,'? supply','sus')
setp(101,'DSP D7','dsp'); setp(102,'DSP D6','dsp')
for i,n in enumerate(range(103,108)): setp(n,'DSP D%d'%(5-i),'dspi')
setp(108,'DSP D0','dsp'); setp(109,'DSP INT2','dsp'); setp(114,'DSP IS','dsp')
for n,l in [(10,'CS'),(13,'AA'),(14,'ARQ'),(16,'HS'),(17,'SYN'),(18,'TR'),(21,'AA (2nd)'),(25,'RS'),(27,'MR')]: setp(n,l,'pan')
COL={'dsp':'#1f7a5a','dspi':'#7fb3a0','cpu':'#1d5fa8','mem':'#7a3fb0','pan':'#b8541f','pwr':'#6b6b6b','sus':'#a03060','un':'#c9c9c9'}
W=H=980; cx=cy=W/2; B=360.0
x0=cx-B/2; y0=cy-B/2; x1=cx+B/2; y1=cy+B/2
step=B/30.0; L=16.0
def pos(n):
    if n<=30: return (x0+(n-0.5)*step, y1, 'b')
    if n<=60: return (x1, y1-(n-30-0.5)*step, 'r')
    if n<=90: return (x1-(n-60-0.5)*step, y0, 't')
    return (x0, y0+(n-90-0.5)*step, 'l')
o=[];a=o.append
a(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" width="{W}" height="{H}" font-family="ui-sans-serif,Helvetica,Arial,sans-serif">')
a(f'<rect width="{W}" height="{H}" fill="#fbfaf8"/>')
a(f'<rect x="{x0}" y="{y0}" width="{B}" height="{B}" rx="8" fill="#ededea" stroke="#4a4a4a" stroke-width="2"/>')
a(f'<circle cx="{x0+22}" cy="{y1-22}" r="9" fill="none" stroke="#4a4a4a" stroke-width="2"/>')
a(f'<text x="{cx}" y="{cy-26}" text-anchor="middle" font-size="17" font-weight="600" fill="#2a2a2a">NEC USA 1-016-905</text>')
a(f'<text x="{cx}" y="{cy-4}" text-anchor="middle" font-size="12" fill="#6a6a6a">9948LV001 &#183; 120-pin QFP &#183; top view</text>')
a(f'<text x="{cx}" y="{cy+20}" text-anchor="middle" font-size="12" fill="#6a6a6a">pin 1 at the dot, counter-clockwise</text>')
a(f'<text x="{cx}" y="{cy+44}" text-anchor="middle" font-size="11" fill="#8a8a8a">Courier 2806, 25 MHz AC03 board</text>')
for n in range(1,121):
    x,y,e=pos(n); lab,cat=PINS.get(n,(None,'un')); c=COL[cat]; w=step*0.5
    if e=='b': a(f'<rect x="{x-w/2:.1f}" y="{y:.1f}" width="{w:.1f}" height="{L}" fill="{c}"/>')
    if e=='t': a(f'<rect x="{x-w/2:.1f}" y="{y-L:.1f}" width="{w:.1f}" height="{L}" fill="{c}"/>')
    if e=='l': a(f'<rect x="{x-L:.1f}" y="{y-w/2:.1f}" width="{L}" height="{w:.1f}" fill="{c}"/>')
    if e=='r': a(f'<rect x="{x:.1f}" y="{y-w/2:.1f}" width="{L}" height="{w:.1f}" fill="{c}"/>')
    if not lab: continue
    t=f'{n} &#183; {lab}'
    if e=='b': a(f'<text transform="translate({x:.1f},{y+L+8:.1f}) rotate(90)" font-size="11.5" fill="{c}">{t}</text>')
    if e=='t': a(f'<text transform="translate({x:.1f},{y-L-8:.1f}) rotate(-90)" font-size="11.5" fill="{c}">{t}</text>')
    if e=='l': a(f'<text x="{x-L-6:.1f}" y="{y+4:.1f}" text-anchor="end" font-size="11.5" fill="{c}">{t}</text>')
    if e=='r': a(f'<text x="{x+L+6:.1f}" y="{y+4:.1f}" font-size="11.5" fill="{c}">{t}</text>')
a(f'<text x="{cx}" y="30" text-anchor="middle" font-size="12.5" font-weight="600" fill="#555">top 61-90 &#8212; DSP address, CPU AD0-AD7 in, latched address out</text>')
a(f'<text x="{cx}" y="{H-14}" text-anchor="middle" font-size="12.5" font-weight="600" fill="#555">bottom 1-30 &#8212; front panel + TR/RS</text>')
a(f'<text transform="translate(20,{cy}) rotate(-90)" text-anchor="middle" font-size="12.5" font-weight="600" fill="#555">left 91-120 &#8212; DSP data bus, IS, INT2</text>')
a(f'<text transform="translate({W-16},{cy}) rotate(90)" text-anchor="middle" font-size="12.5" font-weight="600" fill="#555">right 31-60 &#8212; CPU control</text>')
lx,ly=34,60
items=[('dsp','DSP side, measured'),('dspi','DSP data, inferred'),('cpu','CPU bus, measured'),('mem','memory address, out'),('pan','panel / RS-232 handshake'),('pwr','supply'),('sus','read but unidentified'),('un','unread (%d pins)'%(120-len(PINS)))]
for i,(k,t) in enumerate(items):
    yy=ly+i*19
    a(f'<rect x="{lx}" y="{yy-9}" width="13" height="11" fill="{COL[k]}"/>')
    a(f'<text x="{lx+20}" y="{yy}" font-size="11.5" fill="#3a3a3a">{t}</text>')
nx,ny=W-330,60
a(f'<text x="{nx}" y="{ny}" font-size="11.5" font-weight="600" fill="#3a3a3a">traced, but NOT on this package:</text>')
for i,t in enumerate(['RD &#8594; U22 SN75188 pin 2','CD &#8594; U23 SN75188 pin 4','OH &#8594; RA5W-K relay pin 9','SD &#8594; CPU pin 7 (RXD1) + 74AHC04','A8-A15 &#8594; the single 74VHC573','data &#8594; flash/RAM straight onto AD0-AD15']):
    a(f'<text x="{nx}" y="{ny+17+i*17}" font-size="11.5" fill="#8a8a8a">{t}</text>')
a('</svg>')
out = Path(__file__).resolve().parent.parent / 'docs' / 'asic-pinout.svg'
out.write_text('\n'.join(o) + '\n')
print(f'{out}: {len(PINS)} pins claimed, {120 - len(PINS)} unread')
