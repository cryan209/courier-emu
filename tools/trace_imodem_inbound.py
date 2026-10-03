"""Run the normal I-modem CLI with timestamped RTP and DSP observations.

Example: python -m tools.trace_imodem_inbound --diagnostics-dir artifacts/pcm-trace
         isdn-run Ie030002.nac --with-dsp --terminal ...
"""
import argparse
import json
from pathlib import Path
import threading
import time

from courier_emu import cli


class Trace:
    def __init__(self, directory):
        directory.mkdir(parents=True, exist_ok=True)
        self.file = (directory / 'timeline.jsonl').open('x')
        self.origin = time.monotonic()
        self.lock = threading.Lock()

    def write(self, kind, **fields):
        row = {'seconds': time.monotonic() - self.origin, 'kind': kind, **fields}
        with self.lock:
            self.file.write(json.dumps(row) + '\n')
            if kind != 'rtp':
                self.file.flush()

    def close(self):
        with self.lock:
            self.file.close()


class TracedRtpSocket:
    def __init__(self, wrapped, session, trace):
        self.wrapped = wrapped
        self.session = session
        self.trace = trace

    def __getattr__(self, name):
        return getattr(self.wrapped, name)

    def record(self, direction, packet, peer):
        self.trace.write('rtp', direction=direction,
                         call_id=self.session.call_id, peer=list(peer),
                         packet_hex=packet.hex())

    def sendto(self, packet, peer):
        result = self.wrapped.sendto(packet, peer)
        self.record('tx', packet, peer)
        return result

    def recvfrom(self, size):
        packet, peer = self.wrapped.recvfrom(size)
        self.record('rx', packet, peer)
        return packet, peer


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__, add_help=False)
    parser.add_argument('--diagnostics-dir', type=Path, required=True)
    parser.add_argument('--decision-pc', type=lambda value: int(value, 16),
                        help='observe a DSP instruction and its caller, hexadecimal')
    options, cli_arguments = parser.parse_known_args(argv)
    trace = Trace(options.diagnostics_dir)
    original_session = cli.SipSession
    original_pump = cli.interactive_pump

    def session(config):
        value = original_session(config)
        value.rtp_socket = TracedRtpSocket(value.rtp_socket, value, trace)
        return value

    def interactive_pump(**kwargs):
        base = original_pump(**kwargs)
        next_snapshot = 0.0
        serial_cursor = 0
        observed_core = None
        # Shared flags, receive parser, timeout and training state; reading
        # these cells does not change the guest's protocol decisions.
        decision_addresses = (list(range(0x60, 0x80)) +
                              list(range(0x310, 0x360)) +
                              list(range(0x380, 0x400)) +
                              list(range(0xffd8, 0xffe8)))

        def pump(machine):
            nonlocal next_snapshot, serial_cursor, observed_core
            base(machine)
            serial = machine.channels[machine.command_base].tx
            if len(serial) > serial_cursor:
                trace.write('serial_rx', hex=bytes(serial[serial_cursor:]).hex())
                serial_cursor = len(serial)
            now = time.monotonic()
            if now < next_snapshot:
                return
            next_snapshot = now + 0.1
            core = getattr(machine.mailbox, 'core', None)
            if core is None:
                return
            if options.decision_pc is not None:
                if core is not observed_core:
                    core.set_pc_capture(options.decision_pc, decision_addresses)
                    core.set_pc_trace_range(options.decision_pc, options.decision_pc)
                    observed_core = core
                    trace.write('decision_configuration', pc=options.decision_pc,
                                addresses=decision_addresses)
                captures = core.pc_captures()
                if captures:
                    callers = core.pc_trace()
                    # Retain the actual mapped instructions: runtime images
                    # may differ from an end-of-call dump used for comparison.
                    reply_callers = [row for row in callers
                                     if row['pc'] == options.decision_pc]
                    windows = {}
                    if len(reply_callers) == len(captures):
                        for capture, caller in zip(captures, reply_callers):
                            if capture[2] & 0xffff != 6:
                                continue
                            address = (caller['acc'] >> 16) & 0xffff
                            first = max(0, address - 48)
                            windows[f'{first:04x}'] = [
                                core.program(pc) for pc in range(first, min(65536, address + 16))]
                    trace.write('dsp_decisions', pc=options.decision_pc,
                                captures=captures, callers=callers,
                                program_windows=windows,
                                bearer_tx=len(machine.bri.media_tx),
                                bearer_rx_heard=len(machine.dsc.bearer_rx_heard[1]))
                    core.clear_pc_captures()
                    core.clear_pc_trace()
            peer = machine.bri.media_peer if machine.bri else None
            sip = peer.session if peer else None
            trace.write(
                'dsp', instructions=machine.instructions,
                peripheral_instructions=machine._peripheral_instructions(),
                coalesced_timer_edges=list(machine._timer_coalesced_wraps),
                hardware_interrupts=machine.hardware_interrupts,
                call_state=machine.bri.call_state if machine.bri else None,
                call_id=sip.call_id if sip else None,
                sip_state=sip.state if sip else None,
                core=core.state(),
                # Includes supervisor/datapump shared state and receive state;
                # observations only, with no writes or forced training steps.
                data_words=[core.data(address) for address in range(0x400)],
                bearer_tx=len(machine.bri.media_tx) if machine.bri else 0,
                bearer_rx=machine.bri.media_rx_delivered if machine.bri else 0,
                receive_fill=peer.underrun if peer else 0,
                preanswer_samples=peer.preanswer_octets if peer else 0,
                rtp_tx_queued=len(sip._tx_codewords) if sip else 0,
                rtp_rx_queued=len(sip._rx_codewords) if sip else 0,
            )
        return pump

    cli.SipSession = session
    cli.interactive_pump = interactive_pump
    try:
        return cli.main(cli_arguments)
    finally:
        # cli.main closes the RTP worker before the trace stream is closed.
        cli.SipSession = original_session
        cli.interactive_pump = original_pump
        trace.close()


if __name__ == '__main__':
    raise SystemExit(main())
