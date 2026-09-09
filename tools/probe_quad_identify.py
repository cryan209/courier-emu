"""Measure isolated QF identification/diagnostic replies using the CPU adapter."""
import json
import sys
from concurrent.futures import ProcessPoolExecutor, as_completed
from pathlib import Path
from courier_emu.machine import CourierMachine
from courier_emu.quad_board import QuadBoard
from courier_emu.quad_image import QuadImage
from courier_emu.nvram import CourierNvram, IDSDL403_NVRAM

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'artifacts/quad-identify-20260910'


def run_command(command, nvram=True):
    image = QuadImage.modem((OUT/'flash.bin').read_bytes(), (OUT/'ram.bin').read_bytes())
    # The QF settings EEPROM is the same 93C66 part the 302/403 carry, reached
    # over the same 186EB PIO lines machine.py already translates. Seeding it
    # is what makes ATI7 report a profile the firmware actually read rather
    # than the 0x1d its decoder returns from an absent part.
    device = CourierNvram(data=bytearray(IDSDL403_NVRAM)) if nvram else None
    m = CourierMachine(image, quad_terminal=True, tick_ms=5, nvram=device,
                       serial_input=('ATQ0V1\r'+command+'\r').encode())
    boundary = None
    last_size = 0
    last_change = 0
    def observe(pc):
        nonlocal boundary, last_size, last_change
        if m.quad_terminal.opened == 2 and boundary is None:
            boundary = len(m.serial)
        if len(m.serial) != last_size:
            last_size = len(m.serial)
            last_change = m.instructions
        if (boundary is not None and not m.serial_rx and not m.uart.pending
                and bytes(m.uc.mem_read(0x81f8,2)) == b'\xe6\x91'
                and m.instructions - last_change > 200_000):
            m.stop_requested = True
    m._code_observer = observe
    r=m.run(12_000_000)
    raw=bytes(m.serial)[boundary:] if boundary is not None else b''
    return dict(command=command, response=bytes(b&127 for b in raw).decode('ascii'),
                raw_hex=raw.hex(), status=r.status, error=r.error,
                instructions=r.instructions, input_remaining=len(m.serial_rx),
                opened=m.quad_terminal.opened, nvram=nvram,
                final_state=bytes(m.uc.mem_read(0x81f8,2)).hex())


if __name__ == '__main__':
    OUT.mkdir(parents=True, exist_ok=True)
    board=QuadBoard()
    m=CourierMachine(QuadImage.controller(ROOT/'docs/x2/Qf060003.zip'),quad_board=board)
    result=m.run(8_000_000)
    if result.error: raise RuntimeError(result.error)
    board.flush()
    (OUT/'flash.bin').write_bytes(board.flash[0]);(OUT/'ram.bin').write_bytes(board.ram[0])
    nvram='--no-nvram' not in sys.argv
    commands=['ATI']+[f'ATI{i}' for i in range(31)]+[f'ATY{i}' for i in range(10,21)]
    rows={}
    with ProcessPoolExecutor(max_workers=3) as pool:
        jobs={pool.submit(run_command, command, nvram):command for command in commands}
        for future in as_completed(jobs):
            row=future.result();rows[row['command']]=row
            (OUT/'results.json').write_text(json.dumps([rows[c] for c in commands if c in rows],indent=2)+'\n')
            print(json.dumps(row),flush=True)
