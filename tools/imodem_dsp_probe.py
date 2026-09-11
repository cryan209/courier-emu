#!/usr/bin/env python3
"""Run the unpatched Ie030002 supervisor with its downloaded native DSP."""
import argparse
from hashlib import sha256
import json
from pathlib import Path
import struct
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from courier_emu.isdn import IsdnMachine
from courier_emu.xmp import XmpImage


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True)
    parser.add_argument('--instructions', type=int, default=5_000_000)
    args = parser.parse_args()
    image = XmpImage.load('Ie030002.xmp')
    machine = IsdnMachine(image, with_dsp=True)
    try:
        result = machine.run(args.instructions)
        endpoint = machine.mailbox
        core = endpoint.core
        if core is None:
            raise AssertionError('DSP was not bootstrapped')
        checks = []
        for number, offset, length, origin in ((10, 0x9ceb0, 15072, 0xd100),
                                               (11, 0xa0990, 31994, 0x9260)):
            expected = image.payload[offset:offset+length]
            actual = b''.join(core.data(origin+i).to_bytes(2, 'little')
                              for i in range(length//2))
            checks.append({'image': number, 'origin': origin, 'bytes': length,
                           'expected_sha256': sha256(expected).hexdigest(),
                           'actual_sha256': sha256(actual).hexdigest(),
                           'mismatched_words': sum(a != b for a,b in zip(
                               struct.unpack('<'+'H'*(length//2), expected),
                               struct.unpack('<'+'H'*(length//2), actual)))})
        report = {'image_sha256': image.digest, 'run': result.to_dict(),
                  'overlays': checks, 'io': core.io_port_stats(range(0x56,0x60)),
                  'serial': core.serial_state(),
                  'ring_pointers': list(struct.unpack('<HH', machine.machine.mem_read(0x329ae,4))),
                  'queue_timeouts': machine.pc_counts[0xa5446]}
        # Separate diagnostic: seed the DSP firmware's outgoing queue, then
        # let its original sender and the original supervisor ISR exchange it.
        # This is not an unsolicited report observed during normal startup.
        from unicorn.x86_const import UC_X86_REG_CS, UC_X86_REG_IP
        pointer = core.data(0x79)
        core.set_data(pointer, 0x8074)
        core.set_data(0x0bc0 + (pointer + 1 - 0x0bc0) % 16, 0xbeef)
        core.set_data(0x78, 0x0bc0 + (pointer + 2 - 0x0bc0) % 16)
        uc = machine.machine
        start = uc.reg_read(UC_X86_REG_CS)*16 + uc.reg_read(UC_X86_REG_IP)
        uc.emu_start(start, 0x1000000, count=50000)
        report['seeded_reply_diagnostic'] = {
            'tag': 0x74, 'value': 0xbeef,
            'supervisor_status_bytes': list(uc.mem_read(0x328f2, 2)),
            'acknowledged': endpoint.replies_acked,
            'reply_pending': endpoint.rx,
            'dsp_room_to_send': bool(core.io(0x57) & 2),
            'dsp_outputs': core.io_port_stats([0x5e, 0x5f]),
        }
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(report, indent=2)+'\n')
        print(json.dumps({k: v for k,v in report.items() if k not in ('run','serial','io')},indent=2))
        print(json.dumps(result.mailbox,indent=2))
        assert result.error is None
        assert endpoint.consumed >= 4
        assert report['queue_timeouts'] == 0
        assert all(check['mismatched_words'] == 0 for check in checks)
        assert report['seeded_reply_diagnostic']['supervisor_status_bytes'] == [0x74, 0x80]
        assert endpoint.replies_acked == 1 and endpoint.rx is None
        assert core.io(0x57) & 2
    finally:
        machine.mailbox.close()


if __name__ == '__main__':
    main()
