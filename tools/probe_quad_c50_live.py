"""Run the Quad card with its C50 endpoint answering, and watch for parameter 0x1f2.

The endpoint steps a C5x core on an instruction budget alongside the CPU and
raises the strobed ready bit on 0x98 only once the DSP has pulled the queued
words, so the CPU waits on the DSP instead of on a floating bus.
"""
import argparse
import json
from pathlib import Path

from courier_emu.machine import CourierMachine
from courier_emu.quad_image import QuadImage
from courier_emu.quad_c50 import QuadC50Endpoint
from courier_emu.nvram import CourierNvram, IDSDL403_NVRAM

ROOT = Path(__file__).resolve().parents[1]
IN = ROOT / 'artifacts/quad-identify-20260910'
OUT = ROOT / 'artifacts/quad-c50-live-20260910'

WATCH = {
    0xCEC04: 'dsp_load_entry', 0xCEC2D: 'dsp_load_ok', 0xCEE5D: 'dsp_load_fail',
    0xCEC26: 'dsp_give_up', 0xF3D24: 'msg_cursor_seed', 0xF4975: 'msg_buffer_fill',
    0xF4889: 'param_id_compare', 0xF88DB: 'param_1f2_handler',
}

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--instructions', type=lambda value: int(value, 0),
                        default=6_000_000)
    parser.add_argument('--command', action='append', default=['ATQ0V1'])
    parser.add_argument('--digital-call', action='store_true')
    parser.add_argument('--law', choices=('mu', 'a'), default='mu')
    parser.add_argument('--track-executed', action='store_true')
    parser.add_argument('--overlay-request', type=lambda value: int(value, 0))
    args = parser.parse_args()
    OUT.mkdir(parents=True, exist_ok=True)
    endpoint = QuadC50Endpoint()
    if args.digital_call:
        endpoint.connect_digital_call(law=args.law)
    image = QuadImage.modem((IN/'flash.bin').read_bytes(), (IN/'ram.bin').read_bytes())
    machine = CourierMachine(image, quad_terminal=True, tick_ms=5, quad_c50=endpoint,
                             nvram=CourierNvram(data=bytearray(IDSDL403_NVRAM)),
                             serial_input=('\r'.join(args.command) + '\r').encode('ascii'),
                             track_executed=args.track_executed,
                             pc_watch={
                                 0xC7CFC: 'call_entry', 0xC7D06: 'call_kind',
                                 0xC7D12: 'line_gate', 0xC7D2A: 'bearer_gate',
                                 0xC7D33: 'profile_gate', 0xC7D3F: 'accepted',
                                 0xC7D7B: 'rejected',
                                 0xD6AC4: 'dsp_poll_install',
                                 0xD6AD7: 'dsp_request_store',
                                 0xCEE5F: 'overlay_request',
                                 0xCA7E4: 'originate_overlay_poll',
                                 0xCAB68: 'answer_overlay_poll',
                             },
                             peek={address: f'{address:04x}' for address in (
                                 0x878A, 0xA88C, 0xA895, 0xA897, 0x9D08,
                                 0x82FE, 0x8311, 0x81AA, 0x81AE,
                             )})
    counts: dict[int, int] = {}
    def observe(pc):
        if pc in WATCH:
            counts[pc] = counts.get(pc, 0) + 1
        if (pc == 0xC93E0 and machine.instructions > 4_600_000
                and args.overlay_request is not None
                and not observe.injected):
            machine.uc.mem_write(0x9D3D, bytes((args.overlay_request & 0xFF,)))
            observe.injected = True
    observe.injected = False
    machine._code_observer = observe
    result = machine.run(args.instructions)
    terminal = machine.quad_terminal
    raw = bytes(machine.serial)
    report = dict(status=result.status, instructions=result.instructions,
                  terminal_text=bytes(b & 0x7f for b in raw[
                      terminal.output_start or 0:]).decode('ascii', errors='replace'),
                  input_remaining=len(machine.serial_rx),
                  endpoint=endpoint.status(),
                  g711_tx_hex=endpoint.transmit_g711()[:64].hex(),
                  executed=[f'{pc:05x}' for pc in sorted(machine.executed)],
                  cpu_watch=result.pc_watch, cpu_peek=result.peek,
                  io_summary=result.io_summary,
                  overlay_injected=observe.injected,
                  dsp_status_mmr=(hex(endpoint.core.library.courier_c5x_get_io(
                      endpoint.core.handle, 0x57)) if endpoint.core else None),
                  watched={name: counts.get(pc, 0) for pc, name in WATCH.items()})
    (OUT/'results.json').write_text(json.dumps(report, indent=1)+'\n')
    print(json.dumps(report, indent=1))
