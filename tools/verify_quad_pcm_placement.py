#!/usr/bin/env python3
"""Validate Quad overlay source bytes against the stock controller RAM copy."""
from pathlib import Path
import hashlib,json,struct,sys
ROOT=Path(__file__).resolve().parents[1];sys.path.insert(0,str(ROOT))
from courier_emu.quad_image import QuadImage
from courier_emu.quad_board import QuadBoard
from courier_emu.machine import CourierMachine
OUT=ROOT/'artifacts/x2-mapper-negotiation-20261004'
ROWS=((0x2f45,0x42e0,0xa180,0x53e02),(0x3373,0x252c,0xb400,0x580e2),(0x35c6,0xf18,0xd900,0x5a612),(0x36b8,0xcb6,0xc300,0x5b532),(0x3784,0x15d6,0xc300,0x5c1f2),(0x38e2,0x8f2,0xc800,0x5d7d2),(0x3972,0x1808,0x9440,0x5e0d2))
def main():
 OUT.mkdir(exist_ok=True);q=QuadImage.controller(ROOT/'docs/x2/Qf060003.zip');board=QuadBoard();m=CourierMachine(q,quad_board=board,max_io_events=100)
 r=m.run(8_000_000)
 assert not r.error,r.error
 board.flush();report={'controller_instructions':r.instructions,'error':r.error,'flat_sha256':hashlib.sha256(q.data).hexdigest(),'overlays':[]}
 for para,size,origin,offset in ROWS:
  expected=q.data[offset:offset+size]
  match=[bytes(ram[para*16:para*16+size])==expected for ram in board.ram]
  assert all(match),(hex(para),match)
  report['overlays'].append({'source_paragraph':hex(para),'bytes':size,'dsp_origin':hex(origin),'flat_offset':hex(offset),'matches_all_four_stock_ram_copies':match,'sha256':hashlib.sha256(expected).hexdigest()})
 (OUT/'placement-verification.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
if __name__=='__main__':main()
