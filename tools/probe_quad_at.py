"""Load a QF modem through its controller, then exercise its CPU byte terminal.

Run with PYTHONPATH=. python tools/probe_quad_at.py. This explicitly opts into
an autobaud adapter; it does not model DSP execution or physical DTE timing.
"""
import argparse
import json
from hashlib import sha256
from pathlib import Path

from courier_emu.machine import CourierMachine
from courier_emu.quad_board import QuadBoard
from courier_emu.quad_image import QuadImage

ROOT = Path(__file__).resolve().parents[1]


def probe(commands=('ATQ0V1', 'AT', 'AT+NOTACOMMAND', 'AT')):
    board = QuadBoard()
    controller = CourierMachine(
        QuadImage.controller(ROOT / 'docs/x2/Qf060003.zip'), quad_board=board)
    boot = controller.run(8_000_000)
    if boot.error:
        raise RuntimeError(boot.error)
    board.flush()
    image = QuadImage.modem(bytes(board.flash[0]), bytes(board.ram[0]))
    wire = ('\r'.join(commands) + '\r').encode('ascii')
    machine = CourierMachine(image, tick_ms=5, quad_terminal=True,
        serial_input=wire, pc_watch={
            0xc11b0: 'serial_receive', 0xcfc6d: 'attention',
            0xc9dd3: 'command_collect', 0xc97a9: 'command_dispatch',
        })
    result = machine.run(12_000_000)
    terminal = machine.quad_terminal
    raw = bytes(machine.serial)
    # QF's output carries parity in bit 7. Keep the raw register bytes too.
    text = bytes(b & 0x7f for b in raw[terminal.output_start or 0:]).decode('ascii')
    return dict(mode='QF060003 CPU byte terminal (autobaud adapter)',
        commands=list(commands), input_hex=wire.hex(),
        controller_status=boot.status, modem_status=result.status,
        error=result.error, flash_sha256=sha256(image.data).hexdigest(),
        serial_raw_hex=raw.hex(), terminal_text=text,
        input_remaining=len(machine.serial_rx), bytes_received=terminal.received,
        commands_opened=terminal.opened, watch_counts=dict(machine.pc_watch_counts),
        final_command_state=bytes(machine.uc.mem_read(0x81f8, 2)).hex())


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--command', action='append', help='AT command; repeat for a sequence')
    parser.add_argument('--output', type=Path,
        default=ROOT / 'artifacts/quad-at-20260910/results.json')
    args = parser.parse_args()
    result = probe(args.command) if args.command else probe()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, indent=2))
    if result['error'] or result['input_remaining']:
        raise SystemExit(1)
