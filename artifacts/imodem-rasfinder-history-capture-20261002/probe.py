import json
import os
import time
from pathlib import Path

from courier_emu import cli
from tools.probe_imodem_analog_pair import OverlayAudit

out = Path(__file__).resolve().parent
original = cli.IsdnMachine


class AuditedMachine(original):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        audit = OverlayAudit(self.mailbox)
        self.mailbox.write = audit.write
        pump = self.serial_pump
        snapshots = []
        next_snapshot = 0
        started = time.monotonic()
        traced_core = None
        traces = []
        decisions = []
        addresses = [0x03e4, 0x03e5, 0x03e8, 0x03e9, 0x0393, 0x038f,
                     0x006f, 0x039f, 0x006d, 0x006e, 0x0011]
        addresses += list(range(0xfaa0, 0xfae0)) + list(range(0x0800, 0x0880))
        (out / 'capture-addresses.json').write_text(json.dumps(addresses))

        def observe(machine):
            nonlocal next_snapshot, traced_core
            if pump:
                pump(machine)
            if machine.instructions < next_snapshot:
                return
            core = machine.mailbox.core
            if core and core is not traced_core:
                core.set_pc_trace_range(0x97b6, 0x97dc)
                core.set_data_trace_filter(0x03e8)
                core.trace_data_writes()
                core.set_pc_capture(0x9bff, addresses)
                traced_core = core
            if core:
                decisions.extend(core.pc_captures())
                core.clear_pc_captures()
                (out / 'decisions.json').write_text(json.dumps(decisions))
                (out / 'reference-writes.json').write_text(json.dumps(core.data_events()))
                traces.append({'instructions': machine.instructions,
                               'wall_seconds': time.monotonic() - started,
                               'trace': core.pc_trace()})
                core.clear_pc_trace()
                (out / 'receive-traces.json').write_text(json.dumps(traces))
            snapshots.append({
                'wall_seconds': time.monotonic() - started,
                'instructions': machine.instructions,
                'call_state': machine.bri.call_state,
                'dsp': core.state() if core else None,
                'stack': core.stack() if core else None,
                'status': core.io(0x57) if core else None,
                'cells': {f'{a:04x}': core.data(a) for a in
                          (0x0bff, 0x0061, 0x006d, 0x006f, 0x031a,
                           0x0337, 0x03c8, 0x03cb, 0x0394, 0x03e0,
                           0x03e2, 0x03d4, 0x03e4, 0x03e5,
                           0x03e8, 0x03e9, 0x0379, 0x0820, 0x0821,
                           0x0810, 0x0811)} if core else {},
                'recent_commands': list(machine.mailbox.commands)[-4:],
                'recent_replies': list(machine.mailbox.replies)[-4:],
                'overlay_transfers': len(audit.records),
            })
            (out / 'checkpoints.json').write_text(json.dumps(snapshots, indent=2))
            (out / 'overlay-verification.json').write_text(json.dumps(audit.records, indent=2))
            next_snapshot = machine.instructions + 5_000_000

        self.serial_pump = observe
        close = self.mailbox.close

        def capture_close():
            core = self.mailbox.core
            if core:
                (out / 'dsp-program.bin').write_bytes(b''.join(
                    core.program(i).to_bytes(2, 'little') for i in range(65536)))
                (out / 'dsp-data.bin').write_bytes(b''.join(
                    core.data(i).to_bytes(2, 'little') for i in range(65536)))
            (out / 'overlay-verification.json').write_text(json.dumps(audit.records, indent=2))
            close()

        self.mailbox.close = capture_close


cli.IsdnMachine = AuditedMachine
raise SystemExit(cli.main([
    'isdn-run', 'Ie030002.nac', '--with-dsp', '--no-flash-nvram',
    '--instructions', '220000000', '--bri-network', '--bri-establish', 'terminal',
    '--bri-sip', 'asterisk.net.cryan.nz', '--bri-sip-username', '2903',
    '--bri-sip-record', str(out / 'rasfinder-to-imodem.g711'),
    '--bri-tx-g711', str(out / 'imodem-to-rasfinder.g711'),
    '--send-after', '30000000', '--send-every', '0',
    '--send', 'AT*V2=3', '--send', 'ATS58=33', '--send', 'AT&W', '--send', 'ATDT3999',
]))
