from __future__ import annotations

import argparse
import json
import os
from pathlib import Path

from .daa import CourierDaa, DAA_LINE_STATES
from .machine import CourierMachine
from .nvram import CourierNvram
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
    args = parser.parse_args()

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

    machine = CourierMachine(
        XmfImage.load(args.image),
        port_values=ports,
        runtime_port_values=runtime_ports,
        uart_ports=set(args.uart_port),
        fast_delays=not args.real_delays,
        with_dsp=args.with_dsp,
        dsp_rx_samples=dsp_rx_samples,
        dsp_tx_pcm=args.dsp_tx_pcm,
        serial_input=bytes.fromhex(args.serial_input_hex),
        daa=CourierDaa(args.daa_line) if args.daa_line else None,
        nvram=CourierNvram.load(args.nvram) if args.nvram else None,
        board_id=None if args.board_id == "none" else int(args.board_id, 0),
        sip=sip,
    )
    print(json.dumps(machine.run(args.instructions).to_dict(), sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
