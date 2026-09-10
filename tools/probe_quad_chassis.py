"""Run the Quad controller and one modem channel by taking turns.

Checks that each side resumes where it stopped, and reports the slot identity
byte at channel offset 0xbae1 - the one targeted write the controller makes
into a selected channel, which the card reads at 0xf64ec and reports back as
parameter 0x00f3.
"""
import json
from pathlib import Path

from courier_emu.quad_chassis import QuadChassis

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'artifacts/quad-chassis-20260910'

if __name__ == '__main__':
    OUT.mkdir(parents=True, exist_ok=True)
    chassis = QuadChassis(archive=ROOT / 'docs/x2/Qf060003.zip',
                          controller_slice=8_000_000, modem_slice=1_000_000)
    report = {'controller_turn_1': chassis.run_controller(),
              'slot_after_controller': hex(chassis.channel_byte(0xBAE1))}
    report['modem_turn_1'] = chassis.run_modem(quad_terminal=True, tick_ms=5)
    report['slot_after_modem'] = hex(chassis.channel_byte(0xBAE1))
    first = dict(chassis.status())
    chassis.controller_slice = chassis.modem_slice = 500_000
    report['turn_2'] = chassis.turn(quad_terminal=True, tick_ms=5)
    report['resumed'] = {
        'controller': [first['controller_instructions'],
                       chassis.controller_instructions],
        'modem': [first['modem_instructions'], chassis.modem_instructions],
    }
    report['status'] = chassis.status()
    (OUT / 'results.json').write_text(json.dumps(report, indent=1) + '\n')
    print(json.dumps(report, indent=1))
