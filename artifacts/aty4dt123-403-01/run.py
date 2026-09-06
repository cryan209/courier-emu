from dataclasses import asdict
import json
from pathlib import Path

from courier_emu.daa import CourierDaa
from courier_emu.images import load_image
from courier_emu.machine import CourierMachine
from courier_emu.nvram import CourierNvram

out = Path('artifacts/aty4dt123-403-01')
machine = CourierMachine(
    load_image('artifacts/courier-board-21210-capture-403/courier-board.rom'),
    nvram=CourierNvram.idsl302_fixture(), tick_ms=5, board_id=7,
    serial_input=b'ATY4DT123\r', with_dsp=True,
    daa=CourierDaa(line_state='dial-tone'),
)
report = asdict(machine.run(80_000_000))
text = bytes(byte & 0x7f for byte in machine.serial).decode('ascii')
(out / 'report.json').write_text(json.dumps(report, indent=2))
(out / 'serial.txt').write_text(text)
bridge = report['dsp_bridge']
print(json.dumps({
    'status': report['status'], 'serial': text,
    'input_remaining': report['serial_input_remaining'],
    'dsp_error': bridge['error'], 'dsp': bridge['dsp'],
    'daa': bridge['daa'], 'dial_digits': bridge['dial_digits'],
    'bootstrap_match': bridge['bootstrap_match'],
    'runtime_messages': bridge['runtime_messages'],
}, indent=2), flush=True)
