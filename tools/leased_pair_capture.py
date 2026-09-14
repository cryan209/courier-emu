"""Capture AT dialogue from two real Couriers joined by a leased-line link.

Both ends hang off this host's USB serial adapters. Run with
PYTHONPATH=. python tools/leased_pair_capture.py. This talks to physical
hardware: it finds each DTE rate by probing for OK, escapes to command mode
with +++, runs the query set, then returns the modem to data mode with ATO.
Nothing here dials, resets, or writes NVRAM.
"""
import argparse
import fcntl
import json
import os
import struct
import termios
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TIOCMBIS = 0x8004746c
TIOCMGET = 0x4004746a
TIOCM_DTR = 0x002
TIOCM_RTS = 0x004
# An autobauding Courier adopts the rate it last saw AT at, so walking a list
# of rates reconfigures the modem. Ask for one rate and say so if it is mute.
DEFAULT_BAUD = 115200
# ATI6 carries the link diagnostics; I11 the connection statistics.
QUERIES = ('ATI3', 'ATI4', 'ATI5', 'ATI6', 'ATI7', 'ATI10', 'ATI11')


def open_port(path, baud, flow=True):
    fd = os.open(path, os.O_RDWR | os.O_NOCTTY | os.O_NONBLOCK)
    attrs = termios.tcgetattr(fd)
    iflag, oflag, cflag, lflag, ispeed, ospeed, cc = attrs
    cflag = termios.CS8 | termios.CREAD | termios.CLOCAL
    if flow:
        # A modem holding CTS low stalls every write while this is set.
        cflag |= termios.CRTSCTS
    cc = list(cc)
    cc[termios.VMIN] = 0
    cc[termios.VTIME] = 0
    termios.tcsetattr(fd, termios.TCSANOW,
        [0, 0, cflag, 0, baud, baud, cc])
    # &H1 keeps the modem's output shut until our RTS is up.
    fcntl.ioctl(fd, TIOCMBIS, struct.pack('I', TIOCM_DTR | TIOCM_RTS))
    termios.tcflush(fd, termios.TCIOFLUSH)
    return fd


def drain(fd, seconds):
    """Read whatever arrives inside the window, timestamped per chunk."""
    chunks = []
    end = time.monotonic() + seconds
    while time.monotonic() < end:
        try:
            data = os.read(fd, 4096)
        except BlockingIOError:
            data = b''
        if data:
            chunks.append((round(time.monotonic(), 4), data))
        else:
            time.sleep(0.02)
    return chunks


def exchange(fd, line, wait=1.5):
    os.write(fd, line.encode('ascii') + b'\r')
    chunks = drain(fd, wait)
    text = b''.join(d for _, d in chunks).decode('ascii', 'replace')
    return dict(sent=line, text=text,
        raw_hex=b''.join(d for _, d in chunks).hex(),
        first_byte_at=chunks[0][0] if chunks else None)


def modem_lines(fd):
    bits = struct.unpack('I', fcntl.ioctl(fd, TIOCMGET, struct.pack('I', 0)))[0]
    return {name: bool(bits & mask) for name, mask in (
        ('DTR', 0x002), ('RTS', 0x004), ('CTS', 0x020),
        ('DCD', 0x040), ('RI', 0x080), ('DSR', 0x100))}


def attach(path, baud, flow=True):
    """A modem in data mode stays mute, so escape first, then autobaud with AT."""
    fd = open_port(path, baud, flow)
    exchange(fd, '', 0.4)            # a bare CR, then AT, gives autobaud the rate
    escape = ''
    reply = exchange(fd, 'AT', 1.0)
    if 'OK' not in reply['text']:
        # Mute means data mode: escape, then autobaud again. Sending +++ to a
        # modem already in command mode is what makes it swallow the next line.
        escape = escape_to_command(fd)
        exchange(fd, '', 0.4)
        reply = exchange(fd, 'AT', 1.0)
    if 'OK' not in reply['text']:
        os.close(fd)
        raise RuntimeError(f'{path}: no OK at {baud}; it may be at another rate')
    return fd, baud, escape, reply


def escape_to_command(fd):
    time.sleep(1.1)          # guard time before
    os.write(fd, b'+++')
    chunks = drain(fd, 1.6)  # guard time after, plus the OK
    return b''.join(d for _, d in chunks).decode('ascii', 'replace')


def capture(paths, queries, resume, hangup=False, baud=DEFAULT_BAUD, flow=True):
    ends = []
    for path in paths:
        fd, baud, escape, hello = attach(path, baud, flow)
        end = dict(port=path, dte_baud=baud, escape_text=escape,
            hello=hello, lines=modem_lines(fd), queries=[])
        if hangup:
            # Leased-line ends redial on their own once the call is down.
            end['hangup'] = exchange(fd, 'ATH0', 3.0)
        for line in queries:
            end['queries'].append(exchange(fd, line))
        if resume:
            end['resume'] = exchange(fd, 'ATO', 2.0)
        os.close(fd)
        ends.append(end)
    return dict(mode='two real Couriers, leased-line link, live capture',
        captured_at=time.strftime('%Y-%m-%dT%H:%M:%S'),
        queries=list(queries), resumed=resume, ends=ends)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--port', action='append', required=True,
        help='serial device; repeat once per modem end')
    parser.add_argument('--query', action='append', help='AT query; repeat for a set')
    parser.add_argument('--no-flow', action='store_true',
        help='drop RTS/CTS flow control, to reach a modem holding CTS low')
    parser.add_argument('--baud', type=int, default=DEFAULT_BAUD,
        help=f'DTE rate to talk at (default {DEFAULT_BAUD})')
    parser.add_argument('--hangup', action='store_true',
        help='send ATH0 before the queries, to read the same state with no call up')
    parser.add_argument('--no-resume', action='store_true',
        help='leave the modem in command mode instead of sending ATO')
    parser.add_argument('--output', type=Path,
        default=ROOT / 'artifacts/leased-pair/capture.json')
    args = parser.parse_args()
    result = capture(args.port, tuple(args.query) if args.query else QUERIES,
        not args.no_resume, args.hangup, args.baud, not args.no_flow)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, indent=2))
