#!/usr/bin/env python3
"""Trace Ie030002 VRTX initialization, task creation, and first task execution.

Uses the existing IsdnMachine peripheral model without changing firmware bytes.
Example: .venv/bin/python tools/imodem_vrtx_trace.py --output /tmp/vrtx.json
Requires Unicorn and may require execution outside the macOS sandbox for JIT.
Addresses are verified only for Ie030002; this is a version-specific probe.
"""
from __future__ import annotations

import argparse
from collections import Counter
import json
from pathlib import Path
import struct
import sys
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from courier_emu.isdn import IsdnMachine
from courier_emu.xmp import XmpImage


def trace(image: XmpImage, instructions: int) -> dict:
    import unicorn
    from unicorn import x86_const as x86

    # Fail rather than silently tracing unrelated addresses in another release.
    if image.payload[0x354E0:0x354E5] != bytes.fromhex('b83000cd30'):
        raise ValueError('expected Ie030002 VRTX initialization call')
    if image.payload[0x1B:0x25] != bytes.fromhex('25005b009700d2000d01'):
        raise ValueError('unexpected Ie030002 dispatch table')
    original_uc = unicorn.Uc
    services: Counter[int] = Counter()
    tasks: list[dict] = []
    milestones: list[dict] = []
    task_returns: list[dict] = []
    pending: dict[int, int] = {}
    task_activity: dict[int, dict] = {}
    machine = IsdnMachine(image)
    register_names = ('ax', 'bx', 'cx', 'dx', 'ds', 'es', 'ss', 'sp')

    def make_uc(*args, **kwargs):
        uc = original_uc(*args, **kwargs)

        def service(uc, address, size, data):
            regs = {name: uc.reg_read(getattr(x86, 'UC_X86_REG_' + name.upper()))
                    for name in register_names}
            number = regs['ax']
            services[number] += 1
            if tasks:
                # Kernel workspace segment 0010 comes from the descriptor
                # at 98d1:0000. Its current-TCB pointer is at workspace +8;
                # the task-create routine stores the task ID at TCB +9.
                tcb = struct.unpack('<H', uc.mem_read(0x108, 2))[0]
                task_id = uc.mem_read(0x100 + tcb + 9, 1)[0]
                activity = task_activity.setdefault(task_id, {'service_calls': 0})
                activity.update(service_calls=activity['service_calls'] + 1,
                                last_service=f'{number:02x}',
                                last_instruction=machine.instructions)
                if number == 0x27:
                    activity['last_queue_wait'] = uc.reg_read(x86.UC_X86_REG_DI)
            if number not in (0, 0x30, 0x31):
                return
            stack = bytes(uc.mem_read(regs['ss'] * 16 + regs['sp'], 6))
            ip, cs, flags = struct.unpack('<HHH', stack)
            call = {'service': f'{number:02x}', 'instruction': machine.instructions,
                    'return_to': f'{cs:04x}:{ip:04x}', 'registers': regs}
            milestones.append(call)
            if number != 0:
                return
            segment, offset = regs['es'], regs['bx']
            target = segment * 16 + offset
            task = {'id': regs['cx'] & 255, 'priority': regs['cx'] >> 8,
                    'entry': f'{segment:04x}:{offset:04x}',
                    'physical': f'0x{target:05x}', 'created_at': machine.instructions,
                    'first_execution': None}
            tasks.append(task)
            pending[regs['ss'] * 16 + regs['sp'] + 6] = len(tasks) - 1

            def first(uc, address, size, data):
                if task['first_execution'] is None:
                    task['first_execution'] = machine.instructions
            uc.hook_add(unicorn.UC_HOOK_CODE, first, begin=target, end=target)

        def returned(uc, address, size, data):
            key = uc.reg_read(x86.UC_X86_REG_SS) * 16 + uc.reg_read(x86.UC_X86_REG_SP)
            index = pending.pop(key, None)
            if index is not None:
                status = uc.reg_read(x86.UC_X86_REG_AX)
                tasks[index]['create_status'] = status
                task_returns.append({'id': tasks[index]['id'], 'status': status})

        uc.hook_add(unicorn.UC_HOOK_CODE, service, begin=0x73600, end=0x73600)
        # Return from the task-create INT 30 in the C wrapper at 4063:02ae.
        uc.hook_add(unicorn.UC_HOOK_CODE, returned, begin=0x408F3, end=0x408F3)
        return uc

    with patch.object(unicorn, 'Uc', make_uc):
        result = machine.run(instructions)
    for task in tasks:
        task['activity'] = task_activity.get(task['id'], {})
    return {'image_sha256': image.digest, 'payload_sha256': image.payload_digest,
            'model': 'existing IsdnMachine defaults; no guest code patches',
            'services': {f'{k:02x}': v for k, v in sorted(services.items())},
            'tasks': tasks, 'milestones': milestones, 'task_returns': task_returns,
            'result': result.to_dict()}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('image', nargs='?', default='Ie030002.xmp')
    parser.add_argument('--instructions', type=int, default=3_000_000)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    report = trace(XmpImage.load(args.image), args.instructions)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps({'status': report['result']['status'], 'tasks': report['tasks'],
                      'services': report['services']}, indent=2))


if __name__ == '__main__':
    main()
