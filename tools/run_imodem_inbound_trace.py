"""Launch a real-Courier capture with the existing PBX test account."""
import argparse
from datetime import datetime, timezone
import os
from pathlib import Path
import subprocess
import sys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--extension', default='2903')
    parser.add_argument('--directory', type=Path)
    parser.add_argument('--decision-pc', default='85f5',
                        help='DSP reply enqueue instruction to observe, hexadecimal')
    args = parser.parse_args()
    if not args.extension.isdecimal():
        parser.error('Extension must contain only digits')
    root = Path(__file__).resolve().parents[1]
    directory = args.directory or root / 'artifacts' / (
        'real-courier-pcm-trace-' + datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'))
    directory = directory.resolve()
    directory.mkdir(parents=True, exist_ok=True)
    if (directory / 'timeline.jsonl').exists():
        parser.error('Use a fresh capture directory')
    environment = dict(os.environ)
    if not environment.get('COURIER_SIP_PASSWORD'):
        # Match only the selected test account; never print or persist its secret.
        auth = subprocess.check_output([
            'ssh', '-o', 'BatchMode=yes', 'root@asterisk.net.cryan.nz',
            f"sed -n '/^\\[auth{args.extension}\\]/,/^\\[/p' /etc/asterisk/pjsip.conf",
        ], text=True, timeout=20)
        settings = dict((key.strip(), value.strip())
                        for line in auth.splitlines() if '=' in line
                        for key, value in [line.split('=', 1)])
        password = settings.get('password')
        if not password:
            parser.error('No password found for the selected PBX test account')
        environment['COURIER_SIP_PASSWORD'] = password
    command = [sys.executable, '-m', 'tools.trace_imodem_inbound',
               '--diagnostics-dir', str(directory),
               '--decision-pc', args.decision_pc,
               'isdn-run', 'Ie030002.nac', '--with-dsp', '--terminal', '--report',
               '--flash-nvram', str(root / 'artifacts/real-courier-inbound/nvram.sav'),
               '--bri-network', '--bri-establish', 'terminal', '--bri-call-to', '7349195',
               '--bri-sip', 'asterisk.net.cryan.nz', '--bri-sip-username', args.extension,
               '--bri-sip-register', '--bri-sip-local-port', '5062',
               '--bri-sip-record', str(directory / 'caller-to-imodem.g711'),
               '--bri-tx-g711', str(directory / 'imodem-to-caller.g711'),
               '--bri-rx-heard', str(directory / 'imodem-heard.g711')]
    print(f'Capture directory: {directory}', flush=True)
    with (directory / 'run.log').open('w') as report:
        return subprocess.call(command, cwd=root, env=environment, stderr=report)


if __name__ == '__main__':
    raise SystemExit(main())
