from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import signal

from .codec import DAA_REVISION, CodecBringUp, SiliconDaa, nearest_sample_rate
from .console import SerialConsole
from .daa import CourierDaa, DAA_LINE_STATES, RingSource
from .flash import ParameterFlash
from .images import load_image
from .line import LineLink
from .machine import CourierMachine
from .nvram import CourierNvram
from .parameters import load_sector
from .sip import SipConfig, SipSession
from .xmf import XmfImage


def _number(value: str) -> int:
    return int(value, 0)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("image")
    parser.add_argument("--instructions", type=_number, required=True)
    parser.add_argument("--port", action="append", default=[])
    parser.add_argument("--runtime-port", action="append", default=[])
    parser.add_argument("--uart-port", action="append", type=_number, default=[])
    parser.add_argument("--real-delays", action="store_true")
    parser.add_argument("--with-dsp", action="store_true")
    parser.add_argument("--force-online", action="store_true")
    parser.add_argument("--dsp-batch", type=_number, default=256)
    parser.add_argument("--daa-line", choices=DAA_LINE_STATES)
    parser.add_argument("--sip-server")
    parser.add_argument("--sip-target", default="")
    parser.add_argument("--sip-username", default="courier")
    parser.add_argument("--sip-password-env", default="COURIER_SIP_PASSWORD")
    parser.add_argument("--sip-local-port", type=_number, default=0)
    parser.add_argument("--rtp-local-port", type=_number, default=0)
    parser.add_argument("--dsp-rx-pcm")
    parser.add_argument("--dsp-tx-pcm")
    parser.add_argument("--serial-input-hex", default="")
    parser.add_argument("--nvram")
    parser.add_argument("--board-id", default="")
    parser.add_argument("--dip", action="append", default=[])
    parser.add_argument("--parameter-sector")
    parser.add_argument("--parameter-flash")
    parser.add_argument("--tick-ms", type=_number, default=None)
    parser.add_argument("--tick-source", default=None)
    parser.add_argument("--int1-after", type=_number)
    parser.add_argument("--line-link")
    parser.add_argument("--line-listen", action="store_true")
    parser.add_argument("--daa-codec", action="store_true")
    parser.add_argument("--daa-codec-line", type=int, choices=(1, 2), default=1)
    parser.add_argument("--daa-codec-rate", type=_number, default=9_600)
    parser.add_argument("--daa-codec-revision", type=_number, default=DAA_REVISION)
    parser.add_argument("--ring-cadence")
    parser.add_argument("--ring-start", type=_number, default=0)
    parser.add_argument("--ring-count", type=_number, default=0)
    parser.add_argument(
        "--serial-fd",
        type=int,
        help="inherited descriptor carrying live terminal bytes both ways",
    )
    args = parser.parse_args()

    console = SerialConsole(args.serial_fd) if args.serial_fd is not None else None

    ports: dict[int, int] = {}
    for assignment in args.port:
        key, separator, value = assignment.partition("=")
        if not separator:
            raise SystemExit(f"invalid port assignment: {assignment!r}")
        ports[_number(key)] = _number(value)

    runtime_ports: dict[int, int] = {}
    for assignment in args.runtime_port:
        key, separator, value = assignment.partition("=")
        if not separator:
            raise SystemExit(f"invalid runtime port assignment: {assignment!r}")
        runtime_ports[_number(key)] = _number(value)

    dsp_rx_samples: list[int] = []
    if args.dsp_rx_pcm:
        pcm = Path(args.dsp_rx_pcm).read_bytes()
        if len(pcm) & 1:
            raise SystemExit("DSP RX PCM must contain complete 16-bit samples")
        dsp_rx_samples = [
            int.from_bytes(pcm[index : index + 2], "little", signed=True)
            for index in range(0, len(pcm), 2)
        ]

    sip = None
    if args.sip_server:
        sip = SipSession(
            SipConfig(
                server=args.sip_server,
                username=args.sip_username,
                password=os.environ.get(args.sip_password_env, ""),
                target=args.sip_target,
                local_port=args.sip_local_port,
                rtp_port=args.rtp_local_port,
            )
        )

    line = None
    if args.line_link:
        line = LineLink(path=args.line_link, listen=args.line_listen)
        line.open()

    ring = None
    if args.ring_cadence:
        on_text, _, off_text = args.ring_cadence.partition(":")
        ring = RingSource(
            on_ms=_number(on_text),
            off_ms=_number(off_text),
            start_ms=args.ring_start,
            count=args.ring_count,
        )

    codec = None
    if args.daa_codec:
        codec = CodecBringUp(
            SiliconDaa(args.daa_codec_line, revision=args.daa_codec_revision),
            rate=nearest_sample_rate(args.daa_codec_rate),
        )

    machine = CourierMachine(
        load_image(args.image),
        port_values=ports,
        runtime_port_values=runtime_ports,
        uart_ports=set(args.uart_port),
        fast_delays=not args.real_delays,
        with_dsp=args.with_dsp,
        dsp_rx_samples=dsp_rx_samples,
        dsp_tx_pcm=args.dsp_tx_pcm,
        serial_input=bytes.fromhex(args.serial_input_hex),
        daa=CourierDaa(args.daa_line) if args.daa_line else None,
        ring=ring,
        codec=codec,
        int1_after_ms=args.int1_after,
        nvram=CourierNvram.load(args.nvram) if args.nvram else None,
        board_id=None if args.board_id == "none" else int(args.board_id, 0),
        dip_closed=frozenset(args.dip),
        parameter_sector=load_sector(args.parameter_sector) if args.parameter_sector else None,
        parameter_flash=ParameterFlash.load(args.parameter_flash)
        if args.parameter_flash
        else None,
        tick_ms=args.tick_ms,
        tick_source=args.tick_source,
        sip=sip,
        line=line,
        force_online=args.force_online,
        dsp_batch=args.dsp_batch,
        console=console,
    )
    if console is not None:
        # Detaching the terminal closes its end of the channel, which the
        # console notices; a signal covers the case where the parent goes
        # away without that, so either way the run still reports itself.
        for number in (signal.SIGINT, signal.SIGTERM):
            signal.signal(number, lambda *_: machine.request_stop())
    print(json.dumps(machine.run(args.instructions).to_dict(), sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
