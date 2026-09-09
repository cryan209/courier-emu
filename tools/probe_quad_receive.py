"""Boot unmodified QF firmware and measure an interrupt-driven CRC frame."""
import json
from pathlib import Path
from courier_emu.machine import CourierMachine
from courier_emu.quad_board import QuadBoard
from courier_emu.quad_image import QuadImage


def crc(data):
    value = 0xffff
    for byte in data:
        value ^= byte
        for _ in range(8):
            value = (value >> 1) ^ (0x8408 if value & 1 else 0)
    return value


def probe(corrupt=False):
    root = Path(__file__).resolve().parents[1]
    # Header bytes 4..5 are trailing length, byte 7 selects the control path.
    body = bytes.fromhex('0000000004000000') + b'AB'
    packet = body + (crc(body) ^ 0xffff).to_bytes(2, 'little')
    if corrupt:
        packet = packet[:-1] + bytes([packet[-1] ^ 1])
    board = QuadBoard()
    board.usart.queue(b'22\x02' + packet)
    machine = CourierMachine(QuadImage.controller(root / 'docs/x2/Qf060003.zip'),
        quad_board=board, max_io_events=100,
        pc_watch={0x819e6:'receive', 0x819f6:'attention_first',
                  0x81a01:'attention_second', 0x81a19:'stx',
                  0x81a44:'header', 0x81afc:'body',
                  0x81b2c:'crc_ok', 0x81b7e:'control_complete'},
        mem_watch=(0x448, 0x467))
    result = machine.run(8_000_000)
    return dict(packet=packet.hex(), residue=hex(crc(packet)),
        status=result.status, error=result.error,
        counts=dict(machine.pc_watch_counts), usart=board.usart.state(),
        state=bytes(machine.uc.mem_read(0x45c,2)).hex(),
        crc=bytes(machine.uc.mem_read(0x1533,2)).hex(),
        transitions=[e['value'] for e in machine.mem_watch_events if e['address']=='045c'])

if __name__ == '__main__':
    results = {name:probe(corrupt) for name,corrupt in [('valid',False),('bad_crc',True)]}
    text = json.dumps(results, indent=2)+'\n'
    output = Path(__file__).resolve().parents[1] / 'artifacts/quad-receive-20260910/results.json'
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(text)
    print(text)
