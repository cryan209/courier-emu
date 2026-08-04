from __future__ import annotations

import argparse
import json
from pathlib import Path

from .machine import CourierMachine
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
    parser.add_argument("--dsp-rx-pcm")
    parser.add_argument("--dsp-tx-pcm")
    parser.add_argument("--serial-input-hex", default="")
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
    )
    print(json.dumps(machine.run(args.instructions).to_dict(), sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
