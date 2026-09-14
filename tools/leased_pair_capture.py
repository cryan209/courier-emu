"""Capture AT dialogue from two real Couriers joined by a leased-line link.

Both ends hang off this host's USB serial adapters. Run with
PYTHONPATH=. python tools/leased_pair_capture.py. This talks to physical
hardware: it finds each DTE rate by probing for OK, escapes to command mode
with +++, runs the query set, then returns the modem to data mode with ATO.
Nothing here dials, resets, or writes NVRAM.
"""
import argparse
import json
import os
import termios
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RATES = (115200, 57600, 38400, 19200, 9600)
# ATI6 carries the link diagnostics; I11 the connection statistics.
QUERIES = ('ATI3', 'ATI4', 'ATI5', 'ATI6', 'ATI7', 'ATI10', 'ATI11')


def open_port(path, baud):
    fd = os.open(path, os.O_RDWR | os.O_NOCTTY | os.O_NONBLOCK)
    attrs = termios.tcgetattr(fd)
    iflag, oflag, cflag, lflag, ispeed, ospeed, cc = attrs
    cflag = termios.CS8 | termios.CREAD | termios.CLOCAL | termios.CRTSCTS
    cc = list(cc)
    cc[termios.VMIN] = 0
    cc[termios.VTIME] = 0
    termios.tcsetattr(fd, termios.TCSANOW,
        [0, 0, cflag, 0, baud, baud, cc])
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


def find_rate(path):
    """An answering modem in data mode stays mute, so probe after escaping."""
    for baud in RATES:
        fd = open_port(path, baud)
        escape = escape_to_command(fd)
        reply = exchange(fd, 'AT', 0.8)
        if 'OK' in reply['text']:
            return fd, baud, escape, reply
        os.close(fd)
    raise RuntimeError(f'{path}: no OK at any of {RATES}')


def escape_to_command(fd):
    time.sleep(1.1)          # guard time before
    os.write(fd, b'+++')
    chunks = drain(fd, 1.6)  # guard time after, plus the OK
    return b''.join(d for _, d in chunks).decode('ascii', 'replace')


def capture(paths, queries, resume):
    ends = []
    for path in paths:
        fd, baud, escape, hello = find_rate(path)
        end = dict(port=path, dte_baud=baud, escape_text=escape,
            hello=hello, queries=[])
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
    parser.add_argument('--no-resume', action='store_true',
        help='leave the modem in command mode instead of sending ATO')
    parser.add_argument('--output', type=Path,
        default=ROOT / 'artifacts/leased-pair/capture.json')
    args = parser.parse_args()
    result = capture(args.port, tuple(args.query) if args.query else QUERIES,
        not args.no_resume)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, indent=2))
