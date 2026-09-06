import json
import sys
from pathlib import Path
from courier_emu.images import load_image
from courier_emu.machine import CourierMachine
from courier_emu.nvram import CourierNvram

COMMANDS = ['AT', 'ATI0', 'ATI1', 'ATI2', 'ATI3', 'ATI4', 'ATI5', 'ATI6', 'ATI7',
            'ATS0?', 'ATS0=7', 'ATS0?', 'ATS0=0', 'ATS0?', 'ATS3?', 'ATS4?', 'ATS5?',
            'ATE0', 'AT', 'ATE1', 'ATV0', 'AT', 'ATV1', 'AT+NOTACOMMAND', 'AT',
            'ATL1', 'ATM0', 'ATX4', 'ATI4', 'AT&F', 'AT', 'ATZ', 'AT']

class ScriptConsole:
    poll_instructions = 8192
    closed = False
    def __init__(self):
        self.machine = None
        self.rows = []
        self.active = None
        self.last_output = 0
        self.start = None
        self.previous_received = 0
    def write(self, byte):
        if self.active is not None:
            self.active['raw'].append(byte)
            self.last_output = self.machine.instructions
    def poll(self):
        m = self.machine
        if self.active is not None:
            if self.start is None and m.uart.received > self.previous_received:
                self.start = m.instructions
            text = bytes(b & 127 for b in self.active['raw']).decode('ascii', 'replace')
            finished = text.endswith(('\r\nOK\r\n', '\r\nERROR\r\n', '0\r', '4\r'))
            if finished and self.start is not None and m.uart.received - self.previous_received >= len(self.active['command']) + 1 and not m.serial_rx and m.instructions - self.start > 1_500_000 and m.instructions - self.last_output > 250_000:
                self.active['status'] = 'response'
            elif self.start is not None and m.instructions - max(self.start, self.last_output) > 5_000_000:
                self.active['status'] = 'timeout'
            else:
                return b''
            self.active['text'] = text
            self.active['instructions'] = m.instructions
            self.active['rx_remaining'] = len(m.serial_rx)
            print(json.dumps({k:v for k,v in self.active.items() if k != 'raw'}), flush=True)
            self.rows.append(self.active)
            if self.active['status'] == 'timeout':
                m.request_stop()
                return b''
            self.active = None
        if len(self.rows) == len(COMMANDS):
            m.request_stop()
            return b''
        command = COMMANDS[len(self.rows)]
        self.active = {'command': command, 'raw': []}
        self.start = None
        self.last_output = m.instructions
        self.previous_received = m.uart.received
        return command.encode() + b'\r'
    def close(self):
        self.closed = True
    def summary(self):
        return {'commands_completed':len(self.rows)}

rom, label = sys.argv[1:]
console = ScriptConsole()
m = CourierMachine(load_image(rom), nvram=CourierNvram.idsl302_fixture(),
                   tick_ms=5, board_id=7, console=console)
console.machine = m
result = m.run(180_000_000)
report = {'rom':rom, 'status':result.status, 'instructions':m.instructions,
          'uart':m.uart.status(), 'serial_bytes':len(m.serial),
          'commands':console.rows, 'trace':result.serial_trace}
out = Path('artifacts/rom-at-smoke-20260906')
out.mkdir(parents=True, exist_ok=True)
(out / (label+'.json')).write_text(json.dumps(report, indent=2)+'\n')
(out / (label+'.txt')).write_text('\n'.join('> '+r['command']+' ['+r['status']+']\n'+r['text'] for r in console.rows))
print('DONE',label,result.status,m.instructions,m.uart.status(),flush=True)
