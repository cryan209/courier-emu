#!/usr/bin/env python3
"""Run inside the Tower d-modem container; expose slmodemd PCM on stdio."""
import os
from pathlib import Path
import select
import socket
import subprocess
import sys
import time
import tty
import hashlib
import json

if len(sys.argv) == 3:
    source = socket.socket(fileno=int(sys.argv[2]))
    target = socket.socket(socket.AF_UNIX)
    target.connect(os.environ['IMODEM_PROBE_SOCKET'])
    while True:
        ready, _, _ = select.select([source, target], [], [])
        for stream in ready:
            data = stream.recv(65536)
            if not data:
                sys.exit(0)
            (target if stream is source else source).sendall(data)

out = Path(sys.argv[1])
out.mkdir(exist_ok=True)
listener = socket.socket(socket.AF_UNIX)
path = str(out / 'audio.sock')
os.environ['IMODEM_PROBE_SOCKET'] = path
os.chmod(out, 0o755)
listener.bind(path)
os.chmod(path, 0o666)  # slmodemd drops its audio child to its unprivileged UID.
listener.listen(1)
log = (out / 'slmodemd.log').open('wb')
process = subprocess.Popen(['/src/slmodemd/slmodemd', '-d9', '-e', __file__],
                           cwd=out, stdout=log, stderr=log)
try:
    for _ in range(100):
        text = (out / 'slmodemd.log').read_text(errors='replace')
        import re
        match = re.search(r"TTY is `([^']+)'", text)
        if match: break
        time.sleep(.05)
    else: raise RuntimeError('No slmodemd PTY')
    fd = os.open(match[1], os.O_RDWR | os.O_NOCTTY | os.O_NONBLOCK)
    tty.setraw(fd)
    # Permit V.34 fallback for V.90; the debug log identifies the chosen mode.
    protocol = os.environ.get('IMODEM_PROBE_PROTOCOL', 'v34')
    modulation = {'v34': 'AT+MS=34,0,2400,33600',
                  'v90': 'AT+MS=90,1,28000,56000'}[protocol]
    ec_command = 'AT\\N4%C0' if os.environ.get('IMODEM_PROBE_EC') == '1' else 'AT\\N0%C0'
    for command in ['ATX3E0', modulation, ec_command, 'ATD123']:
        os.write(fd, command.encode() + b'\r')
        time.sleep(.1)
    listener.settimeout(10)
    audio, _ = listener.accept()
    ttylog = (out / 'tty.log').open('wb')
    payload_enabled = os.environ.get('IMODEM_PROBE_PAYLOAD') == '1'
    sentlog = (out / 'payload-sent.jsonl').open('w')
    terminal = bytearray()
    audio_bytes = 0
    next_payload = None
    payload_sequence = 0
    payload_limit = int(os.environ.get('IMODEM_PROBE_PAYLOAD_PACKETS', '150'))
    while True:
        ready, _, _ = select.select([audio, sys.stdin.buffer, fd], [], [], 10)
        if not ready: raise TimeoutError('Audio idle')
        for stream in ready:
            if stream == fd:
                data = os.read(fd, 65536)
                ttylog.write(data); ttylog.flush()
                if next_payload is None:
                    terminal.extend(data)
                    if re.search(rb'CONNECT[^\r\n]*\r\n', terminal) and payload_enabled:
                        next_payload = audio_bytes // 384 + 50
            elif stream is audio:
                data = audio.recv(65536)
                if not data: sys.exit(0)
                sys.stdout.buffer.write(data); sys.stdout.buffer.flush()
            else:
                data = os.read(0, 65536)
                if not data: sys.exit(0)
                audio.sendall(data)
                audio_bytes += len(data)
        if next_payload is not None and payload_sequence < payload_limit and audio_bytes // 384 >= next_payload:
            packet = ('SL_TO_IMODEM %06d ' % payload_sequence +
                      hashlib.sha256(str(payload_sequence).encode()).hexdigest() + '\r\n').encode()
            count = os.write(fd, packet)
            sentlog.write(json.dumps({'block': audio_bytes // 384, 'hex': packet[:count].hex()}) + '\n')
            sentlog.flush()
            payload_sequence += 1
            next_payload = audio_bytes // 384 + 50
finally:
    process.terminate()
    try: process.wait(timeout=5)
    except subprocess.TimeoutExpired: process.kill(); process.wait()
    listener.close()
    if os.path.exists(path): os.unlink(path)
