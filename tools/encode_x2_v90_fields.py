#!/usr/bin/env python3
"""Encode the recovered x2 and V.90 negotiation fields in wire order.

Bit zero in the returned lists is transmitted first.  INFO CRCs cover only
the information body: the leading fill/sync and trailing fill are excluded.
"""

from __future__ import annotations

import argparse
import json


INFO_FILL = (1, 1, 1, 1)
INFO_SYNC = (0, 1, 1, 1, 0, 0, 1, 0)
X2_RATE_CODE_TO_BPS = (
    33333, 37333, 41333, 42666, 44000, 45333, 46666, 48000,
    49333, 50666, 52000, 53333, 54666, 56000, 57333, 64000,
)


def lsb_bits(value: int, width: int) -> list[int]:
    if value < 0 or value >= 1 << width:
        raise ValueError(f"{value} does not fit in {width} bits")
    return [(value >> bit) & 1 for bit in range(width)]


def bits_value(bits: list[int] | tuple[int, ...]) -> int:
    return sum(bit << index for index, bit in enumerate(bits))


def crc16_v34(body: list[int]) -> int:
    """Return the reflected x^16+x^12+x^5+1 CRC used by V.34 INFO."""
    crc = 0xFFFF
    for bit in body:
        feedback = (crc & 1) ^ bit
        crc >>= 1
        if feedback:
            crc ^= 0x8408
    return crc


def info_frame(body: list[int]) -> list[int]:
    crc = crc16_v34(body)
    return [*INFO_FILL, *INFO_SYNC, *body, *lsb_bits(crc, 16), *INFO_FILL]


def x2_info0(capabilities: int, *, acknowledge: bool = False) -> list[int]:
    """Build the 17 information bits at V.34 INFO0 positions 12..28."""
    return [*lsb_bits(capabilities, 16), int(acknowledge)]


def x2_modulation_parameters(carrier: int, rate_1: int, rate_2: int) -> int:
    """Build x2's proprietary 7-bit carrier/rate/rate marker body."""
    if carrier not in (0, 1):
        raise ValueError("carrier must be 0 (low) or 1 (high)")
    if not 0 <= rate_1 <= 7 or not 0 <= rate_2 <= 7:
        raise ValueError("symbol-rate indices must fit in three bits")
    return carrier | (rate_1 << 1) | (rate_2 << 4)


def x2_pcm_rate(rate_index: int) -> tuple[int, int]:
    """Decode the DSP's local x2 measurement index into K and nominal bit/s."""
    if not 0 <= rate_index <= 31:
        raise ValueError("x2 PCM rate index must fit in five bits")
    bits_per_six_symbol_frame = rate_index + 22
    nominal_bps = bits_per_six_symbol_frame * 8000 // 6
    return bits_per_six_symbol_frame, nominal_bps


def x2_rate_code_from_measurement(rate_index: int) -> int:
    """Translate the measured analogue-path index 10..21 to x2 code 3..14."""
    if not 10 <= rate_index <= 21:
        raise ValueError("measured x2 rate index must be in the range 10..21")
    return rate_index - 7


def x2_rate_code(rate_bps: int) -> int:
    """Return the four-bit ordinal in x2's complete 16-entry rate ladder."""
    try:
        return X2_RATE_CODE_TO_BPS.index(rate_bps)
    except ValueError as exc:
        raise ValueError(f"unsupported x2 rate {rate_bps}") from exc


def reverse_bits(value: int, width: int) -> int:
    """Reverse a fixed-width field (MP is stored opposite to wire order)."""
    return bits_value(list(reversed(lsb_bits(value, width))))


def v34_mp_rate_word(call_to_answer: int, answer_to_call: int) -> int:
    """Pack MP bits 20:27 as they appear in the firmware's first MP word.

    The MP receiver stores ITU bits 20:23 in word bits 9:6 and bits 24:27 in
    word bits 5:2.  Within each field the first transmitted (least
    significant) field bit therefore occupies the highest DSP bit.
    """
    if not 0 <= call_to_answer < 16 or not 0 <= answer_to_call < 16:
        raise ValueError("MP maximum-rate fields must fit in four bits")
    return reverse_bits(call_to_answer, 4) << 6 | reverse_bits(answer_to_call, 4) << 2


def v90_info1a(
    *, uinfo: int, upstream_rate: int, selector: int = 6, frequency_offset: int = 0
) -> list[int]:
    """Build the 38 information bits at V.90 INFO1a positions 12..49."""
    body = [0] * 38

    def put(first_itu_bit: int, width: int, value: int) -> None:
        start = first_itu_bit - 12
        body[start : start + width] = lsb_bits(value, width)

    put(25, 7, uinfo)
    put(34, 3, upstream_rate)
    put(37, 3, selector)
    put(40, 10, frequency_offset)
    return body


def bit_string(bits: list[int]) -> str:
    return "".join(str(bit) for bit in bits)


def packed_hex(bits: list[int]) -> str:
    """Pack time-first bits into octets, first transmitted bit in bit zero."""
    padded = bits + [0] * (-len(bits) % 8)
    return bytes(bits_value(padded[i : i + 8]) for i in range(0, len(padded), 8)).hex()


def describe(kind: str, body: list[int]) -> dict[str, object]:
    frame = info_frame(body)
    return {
        "kind": kind,
        "body_bit_count": len(body),
        "body_bits_time_first": bit_string(body),
        "body_value_lsb_first": f"0x{bits_value(body):x}",
        "crc": f"0x{crc16_v34(body):04x}",
        "frame_bit_count": len(frame),
        "frame_bits_time_first": bit_string(frame),
        "frame_packed_lsb_first_hex": packed_hex(frame),
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="kind", required=True)

    x2_marker = sub.add_parser("x2-marker")
    x2_marker.add_argument("--carrier", type=int, choices=(0, 1), required=True)
    x2_marker.add_argument("--rate-1", type=int, choices=range(8), required=True)
    x2_marker.add_argument("--rate-2", type=int, choices=range(8), required=True)

    x2_info = sub.add_parser("x2-info0")
    x2_info.add_argument("--capabilities", type=lambda text: int(text, 0), required=True)
    x2_info.add_argument("--acknowledge", action="store_true")

    x2_rate = sub.add_parser("x2-rate")
    x2_rate.add_argument("--index", type=int, choices=range(32), required=True)

    mp_rate = sub.add_parser("mp-rate-fields")
    mp_rate.add_argument("--call-to-answer", type=int, choices=range(16), required=True)
    mp_rate.add_argument("--answer-to-call", type=int, choices=range(16), required=True)

    x2_wire_rate = sub.add_parser("x2-wire-rate")
    group = x2_wire_rate.add_mutually_exclusive_group(required=True)
    group.add_argument("--rate", type=int)
    group.add_argument("--measurement-index", type=int, choices=range(10, 22))

    v90_info = sub.add_parser("v90-info1a")
    v90_info.add_argument("--uinfo", type=int, choices=range(128), required=True)
    v90_info.add_argument("--upstream-rate", type=int, choices=range(8), required=True)
    v90_info.add_argument("--selector", type=int, choices=range(8), default=6)
    v90_info.add_argument("--frequency-offset", type=int, choices=range(1024), default=0)

    args = parser.parse_args()
    if args.kind == "x2-marker":
        code = x2_modulation_parameters(args.carrier, args.rate_1, args.rate_2)
        result = describe(args.kind, lsb_bits(code, 7))
        result["code"] = f"0x{code:02x}"
        result["fields"] = {
            "carrier_bit_0": args.carrier,
            "rate_1_bits_1_3": args.rate_1,
            "rate_2_bits_4_6": args.rate_2,
        }
    elif args.kind == "x2-info0":
        result = describe(
            args.kind, x2_info0(args.capabilities, acknowledge=args.acknowledge)
        )
    elif args.kind == "x2-rate":
        k, bps = x2_pcm_rate(args.index)
        result = {
            "kind": args.kind,
            "local_dsp_measurement_index": args.index,
            "bits_per_six_symbol_frame": k,
            "nominal_bits_per_second": bps,
            "exact_rate": f"{k} * 8000 / 6",
            "warning": "This telemetry index is not a proven on-wire MP field.",
        }
    elif args.kind == "mp-rate-fields":
        word = v34_mp_rate_word(args.call_to_answer, args.answer_to_call)
        result = {
            "kind": args.kind,
            "itu_mp_bits_20_23_call_to_answer": args.call_to_answer,
            "itu_mp_bits_24_27_answer_to_call": args.answer_to_call,
            "dsp_word_0_bits_9_2": f"0x{word:04x}",
        }
    elif args.kind == "x2-wire-rate":
        code = (x2_rate_code(args.rate) if args.rate is not None
                else x2_rate_code_from_measurement(args.measurement_index))
        result = {
            "kind": args.kind,
            "x2_rate_code": code,
            "four_bit_time_first": bit_string(lsb_bits(code, 4)),
            "nominal_bits_per_second": X2_RATE_CODE_TO_BPS[code],
            "dsp_nibble_reversed": f"0x{reverse_bits(code, 4):x}",
        }
    else:
        result = describe(
            args.kind,
            v90_info1a(
                uinfo=args.uinfo,
                upstream_rate=args.upstream_rate,
                selector=args.selector,
                frequency_offset=args.frequency_offset,
            ),
        )
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
