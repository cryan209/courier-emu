"""Dial live modem endpoints sequentially using the existing PBX test account."""
import argparse
import json
import os
from pathlib import Path
import re
import subprocess
import sys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('targets', nargs='+')
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--instructions', type=int, default=400_000_000)
    parser.add_argument('--link-diagnostics', action='store_true',
                        help='Escape to local command mode and query ATI6 after connecting')
    parser.add_argument('--fixed-dte', action='store_true',
                        help='Use &B1 rather than the original variable-rate &B0 configuration')
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    # Capture only this account's auth stanza; never print or save its secret.
    auth = subprocess.check_output([
        'ssh', 'root@asterisk.net.cryan.nz',
        "sed -n '/^\\[auth2903\\]/,/^\\[/p' /etc/asterisk/pjsip.conf"], text=True)
    settings = dict((key.strip(), value.strip())
                    for line in auth.splitlines() if '=' in line
                    for key, value in [line.split('=', 1)])
    environment = dict(os.environ)
    environment['COURIER_SIP_PASSWORD'] = settings['password']
    summaries = []
    for target in args.targets:
        if not target.isdigit():
            parser.error('Dial targets must be numeric extensions')
        out = args.output / target
        out.mkdir(parents=True, exist_ok=True)
        if (out / 'result.json').exists():
            raise RuntimeError(f'Use a fresh output directory: {out}')
        module = 'tools.imodem_sip_link_diagnostics' if args.link_diagnostics else 'courier_emu'
        command = [sys.executable, '-m', module, 'isdn-run', 'Ie030002.nac',
                   '--with-dsp', '--no-flash-nvram', '--bri-network',
                   '--bri-establish', 'terminal', '--bri-sip', 'asterisk.net.cryan.nz',
                   '--bri-sip-username', '2903', '--bri-sip-target', target,
                   '--bri-sip-record', str(out / 'peer-to-imodem.g711'),
                   '--bri-tx-g711', str(out / 'imodem-to-peer.g711'),
                   '--bri-rx-heard', str(out / 'imodem-heard.g711'),
                   '--send', 'AT*V2=3', '--send', 'AT&W',
                   '--send', 'AT&M5&K0S58=0&B' + ('1' if args.fixed_dte else '0'), '--send', 'ATDT' + target,
                   '--send-after', '30000000', '--send-every', '0',
                   '--instructions', str(args.instructions)]
        print(f'Dialling {target}', flush=True)
        with (out / 'result.json').open('w') as stdout, (out / 'stderr.log').open('w') as stderr:
            process = subprocess.run(command, cwd=root, env=environment,
                                     stdout=stdout, stderr=stderr)
        if process.returncode:
            raise RuntimeError(f'Call {target} exited {process.returncode}; see {out / "stderr.log"}')
        result = json.loads((out / 'result.json').read_text())
        terminal = ''.join(row['text'] for row in result.get('serial_session', [])
                           if row['direction'] == 'received')
        connect = re.search(r'CONNECT[^\r\n]*', terminal)
        summary = {'dialled': target, 'connect_result': connect.group(0) if connect else None,
                   'arq': bool(connect and '/ARQ' in connect.group(0)),
                   'login_prompt_received': 'login:' in terminal,
                   'credentials_submitted': False, 'terminal': terminal,
                   'status': result['status'],
                   'sip': result['bri'].get('media_peer', {}).get('sip', {})}
        (out / 'summary.json').write_text(json.dumps(summary, indent=2) + '\n')
        summaries.append(summary)
        (args.output / 'summary.json').write_text(json.dumps(summaries, indent=2) + '\n')
        print(f'{target}: {summary["connect_result"] or "no CONNECT"}; login={summary["login_prompt_received"]}', flush=True)


if __name__ == '__main__':
    main()
