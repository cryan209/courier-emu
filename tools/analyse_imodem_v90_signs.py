"""Independently decode V.90 TRN1d and Jd signs from captured mu-law bytes."""
import argparse
import json
from pathlib import Path


def descramble(bits):
    return [bits[i] ^ bits[i - 18] ^ bits[i - 23]
            for i in range(23, len(bits))]


def word(bits):
    return sum(bit << i for i, bit in enumerate(bits))


def crc(bits):
    value = 0xffff
    for bit in bits:
        feedback = (value ^ bit) & 1
        value >>= 1
        if feedback:
            value ^= 0x8408
    return value


def analyse(raw, trn_start, trn_end, jd_start, jd_end):
    # Mu-law sign bit 1 denotes positive. Differential decoding removes
    # absolute polarity; TRN1d itself is not differentially encoded.
    signs = [int(bool(code & 0x80)) for code in raw]
    trn = descramble(signs)[int(trn_start * 8000) - 23:
                            int(trn_end * 8000) - 23]
    differential = [signs[i] ^ signs[i - 1] for i in range(1, len(signs))]
    decoded = descramble(differential)
    frames = []
    for index in range(max(0, int(jd_start * 8000) - 24),
                       min(len(decoded) - 71, int(jd_end * 8000) - 24)):
        frame = decoded[index:index + 72]
        if frame[:17] != [1] * 17 or any(frame[i] for i in (17, 34, 51)):
            continue
        if any(frame[68:72]):
            continue
        payload = frame[18:34] + frame[35:51]
        received_crc = word(frame[52:68])
        if received_crc != crc(payload):
            continue
        frames.append({'sample': index + 24,
                       'word1': f'{word(payload[:16]):04x}',
                       'word2': f'{word(payload[16:]):04x}',
                       'crc': f'{received_crc:04x}'})
    return {'trn_window_seconds': [trn_start, trn_end],
            'trn_decoded_bits': len(trn), 'trn_decoded_ones': sum(trn),
            'jd_window_seconds': [jd_start, jd_end],
            'valid_jd_frames': len(frames),
            'frame_spacing_samples': sorted(set(b['sample'] - a['sample']
                                               for a, b in zip(frames, frames[1:]))),
            'frames': frames}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('capture', type=Path)
    parser.add_argument('--trn-window', nargs=2, type=float, default=[12.5, 13.5])
    parser.add_argument('--jd-window', nargs=2, type=float, default=[15, 18])
    args = parser.parse_args()
    result = analyse(args.capture.read_bytes(), *args.trn_window, *args.jd_window)
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()
