"""Run the stock QF 6.0.3 DSP DTMF generator and serial transmit path.

The harness supplies frame scheduling and the resident's normal idle-RAM
fixtures.  Every sample is calculated by the captured QF C50 instructions:
selector 0x8de0, oscillators 0x8e54/0x8e60, sine helper 0x92da, mixer 0x82be,
and serial ISR 0x83e1.  No host-side oscillator contributes samples.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
from pathlib import Path
import struct
import wave

from .dsp import NativeC5x
from .vpcm import DECODE

RATE = 7_200
DIGITS = "0123456789#*ABCD"
ROWS = (697, 770, 852, 941)
# QF uses 0x3b21 for the fourth column, approximately 1663 Hz at this rate.
# That differs from the analog Courier's otherwise-identical 0x3a10/1633 Hz.
COLUMNS = (1_209, 1_336, 1_477, 1_663)

RESIDENT_SOURCE = 0x20000
RESIDENT_BYTES = 0xF450
RESIDENT_ORIGIN = 0x8000
SELECTOR = 0x8DE0
MIXER = 0x82BE
MIXER_TOP = 0x82AD
SINE = 0x92DA
ISR = 0x83E1
ISR_RETURN = 0x83F9
BUFFER = 0x0BD1
G711_EXPAND = 0x8115
G711_COMPRESS = 0x817F
G711_LAW_SELECT = 0x8238
G711_FLAGS = 0x039F
G711_ALAW_FLAG = 0x4000
ANSWER_INCREMENT = 0x4AAB
ANSWER_VARIANTS = {
    "ans": 0x8E60,
    "ans-reversals": 0x8E3B,
    "ansam": 0x8E14,
    "ansam-reversals": 0x8E18,
}
ANSWER_ARM = 0xB0CA
ANSWER_REVERSAL_SAMPLES = 0x0CA7
ANSWER_AMPLITUDE = 0x06CF

# The first six words establish DP/ARP and enter the stock mixer.  The second
# entry calls the selector once.  These are scheduling glue, not sample code.
FRAME_DRIVER = (0xBC07, 0xBF01, 0xBF0F, 0x0BD0, 0x7980, MIXER)
ARM_DRIVER = (0xBC07, 0x7A80, SELECTOR, 0x7980, 0)
# Scheduling glue for the resident compressor's real ABI. The sample is put in
# ACCB at its native 16-bit scale, ARP=1 is required by the repeated NORM *-
# exponent search, and AR7 points one word before the serial buffer because the
# stock exit at 0x81ad advances it before storing the codeword.
G711_INPUT = 0x03E0
G711_DRIVER = (
    0xBC07, 0x6A60, 0xBE1E,       # ldp 7; lacc16 @60; sacb
    0xBF09, 0x0000, 0x8B89,       # lar ar1,#0; mar *,ar1 (select ARP 1)
    0xBF0F, BUFFER - 1,            # lar ar7,#(BUFFER-1)
    0x7980, G711_COMPRESS,         # b 817f
)

FIXTURES = (
    (0x3FB, 1), (0x3F1, 0x0C08), (0x392, 0x3000),
    (0x39B, 0x8327), (0x390, 0x0BD0), (0x398, 3), (0x399, 3),
)


def resident_from_ram(ram: bytes) -> bytes:
    if len(ram) < RESIDENT_SOURCE + RESIDENT_BYTES:
        raise ValueError("QF channel RAM does not contain the C50 resident")
    resident = ram[RESIDENT_SOURCE:RESIDENT_SOURCE + RESIDENT_BYTES]
    words = struct.unpack(f"<{len(resident) // 2}H", resident)
    checks = {
        SELECTOR: (0xBC07, 0x087A, 0xBFB0, 0x000F),
        0x8E54: (0x6A74, 0x7E80, SINE, 0x6141),
        0x8E60: (0x6A72, 0x7E80, SINE, 0x6140),
        SINE: (0x997D, 0x6D7B, 0xA080, 0x527D),
        ISR: (0xBC07, 0x1019, 0xBA01, 0x9019),
        # The Quad does not rely on a host codec. These are the resident's
        # arithmetic G.711 paths: mu-law inversion/bias and A-law 0x55 toggle.
        G711_EXPAND: (0x4880, 0x1C89, 0xBE01, 0xBFB4, 0x7F00),
        G711_COMPRESS: (0x411F, 0xE100, 0x8197, 0xBE1F, 0xBE43),
        0x8194: (0xBE01, 0x7980, 0x81AD),
        0x81AB: (0xBFDC, 0x0055),
        G711_LAW_SELECT: (0x087A, 0xBFB0, 0x000F, 0xBF09, 0xFFD9),
        ANSWER_ARM: (0xBF80, ANSWER_INCREMENT, 0x7A80, 0x8DBD),
        0xB0D0: (0xAE75, ANSWER_REVERSAL_SAMPLES),
        0xB0DD: (0xAE1A, 0x8E18),
        0xB0E0: (0xAE1A, 0x8E14, 0xAE73, ANSWER_AMPLITUDE),
    }
    for address, expected in checks.items():
        offset = address - RESIDENT_ORIGIN
        if tuple(words[offset:offset + len(expected)]) != expected:
            raise ValueError(f"QF stock DSP routine mismatch at {address:04x}")
    return resident


def _until(core: NativeC5x, pc: int, limit: int) -> None:
    for _ in range(limit):
        core.step(1)
        if core.state()["pc"] == pc:
            return
    raise RuntimeError(f"stock QF audio path did not reach {pc:04x}: {core.state()}")


def render(ram: bytes, digit: str, count: int = 1_440) -> tuple[list[int], dict]:
    if digit not in DIGITS or count <= 0:
        raise ValueError("expected one DTMF digit and a positive sample count")
    resident = resident_from_ram(ram)
    driver = FRAME_DRIVER + ARM_DRIVER
    with NativeC5x.from_program(RESIDENT_ORIGIN, resident) as core:
        core.load_rom(struct.pack(f"<{len(driver)}H", *driver))
        core.set_mpmc_pin(0)
        for address, value in FIXTURES:
            core.set_data(address, value)
        # The core's direct-address test surface uses the seven-bit operand;
        # the selector itself establishes DP 7 before reading @7a.
        core.set_data(0x7A, DIGITS.index(digit))
        core.set_pc(len(FRAME_DRIVER))
        _until(core, 0, 300)

        samples: list[int] = []
        for _ in range(count):
            _until(core, MIXER_TOP, 500)
            word = core.data(BUFFER)
            core.set_pc(ISR)
            _until(core, ISR_RETURN, 100)
            if core.serial_state()["dxr"] != word:
                raise RuntimeError("QF serial ISR did not transmit the mixer word")
            samples.append(word if word < 0x8000 else word - 0x10000)
            core.set_data(0x390, 0x0BD0)
            core.set_pc(0)
        return samples, core.serial_state()


def render_g711(ram: bytes, digit: str, *, law: str,
                count: int = 1_600) -> tuple[bytes, list[int], dict]:
    """Run a stock QF tone through its stock compressor and serial ISR.

    The oscillator/mixer works at 7.2 kHz while the DS0 is 8 kHz. This component
    runner supplies their 9:10 frame schedule; it does not calculate or encode
    samples. Every emitted codeword is calculated by QF's compressor at 0x817f
    and written to DXR by its ISR.
    """
    if law not in DECODE or count <= 0:
        raise ValueError("law is 'a' or 'mu' and count must be positive")
    source_count = (count * RATE + 7_999) // 8_000
    linear, _ = render(ram, digit, source_count)
    return compress_g711(ram, linear, law=law, count=count)


def compress_g711(ram: bytes, linear: list[int], *, law: str,
                  count: int) -> tuple[bytes, list[int], dict]:
    """Execute QF's compressor and ISR for already firmware-made samples."""
    if law not in DECODE or count <= 0 or not linear:
        raise ValueError("law is 'a' or 'mu', count and samples must be nonzero")
    resident = resident_from_ram(ram)
    driver = G711_DRIVER
    with NativeC5x.from_program(RESIDENT_ORIGIN, resident) as core:
        core.load_rom(struct.pack(f"<{len(driver)}H", *driver))
        core.set_mpmc_pin(0)
        for address, value in FIXTURES:
            core.set_data(address, value)
        flags = core.data(G711_FLAGS) & ~G711_ALAW_FLAG
        if law == "a":
            flags |= G711_ALAW_FLAG
        core.set_data(G711_FLAGS, flags)

        codewords = bytearray()
        for frame in range(count):
            # Exact 9:10 phase relationship: floor(n*9/10) selects the latest
            # stock 7.2 kHz mixer result for each 8 kHz highway symbol.
            sample = linear[min(frame * 9 // 10, len(linear) - 1)]
            core.set_data(G711_INPUT, sample & 0xFFFF)
            core.set_pc(0)
            _until(core, 0x80B7, 100)
            codeword = core.data(BUFFER) & 0xFF
            core.set_data(0x390, BUFFER - 1)
            core.set_pc(ISR)
            _until(core, ISR_RETURN, 100)
            if core.serial_state()["dxr"] & 0xFF != codeword:
                raise RuntimeError("QF serial ISR did not transmit the G.711 codeword")
            codewords.append(codeword)
        decoded = [DECODE[law](value) for value in codewords]
        return bytes(codewords), decoded, core.serial_state()


def render_answer(ram: bytes, variant: str = "ansam-reversals",
                  count: int = 7_200) -> tuple[list[int], dict]:
    """Execute QF's 2100 Hz ANS/ANSam oscillator family and mixer."""
    if variant not in ANSWER_VARIANTS or count <= 0:
        raise ValueError("unknown answer-tone variant or non-positive count")
    resident = resident_from_ram(ram)
    callback = ANSWER_VARIANTS[variant]
    # The reversal callback's BANZ uses the current auxiliary register. The
    # stock main reaches the mixer with ARP=1; make that ABI explicit here.
    frame = (0xBC07, 0xBF01, 0xBF0F, BUFFER - 1, 0x8B89, 0x7980, MIXER)
    arm = (
        0xBC07, 0xBF80, ANSWER_INCREMENT, 0x7A80, 0x8DBD,
        0xAE75, ANSWER_REVERSAL_SAMPLES,
        0xAE1A, callback,
    )
    if variant.startswith("ansam"):
        arm += (0xAE73, ANSWER_AMPLITUDE)
    arm += (0x7980, 0)
    driver = frame + arm
    with NativeC5x.from_program(RESIDENT_ORIGIN, resident) as core:
        core.load_rom(struct.pack(f"<{len(driver)}H", *driver))
        core.set_mpmc_pin(0)
        for address, value in FIXTURES:
            core.set_data(address, value)
        core.set_pc(len(frame))
        _until(core, 0, 300)
        samples = []
        for _ in range(count):
            _until(core, MIXER_TOP, 500)
            word = core.data(BUFFER)
            samples.append(word if word < 0x8000 else word - 0x10000)
            core.set_data(0x390, BUFFER - 1)
            core.set_pc(0)
        armed = {
            "callback": core.data(0x39A),
            "increment": core.data(0x3F2),
            "amplitude": core.data(0x3F3),
            "reversal_reload": core.data(0x3F5),
        }
        return samples, armed


def render_answer_g711(ram: bytes, variant: str, *, law: str,
                       count: int = 8_000) -> tuple[bytes, list[int], dict]:
    source_count = (count * RATE + 7_999) // 8_000
    linear, armed = render_answer(ram, variant, source_count)
    codewords, decoded, serial = compress_g711(
        ram, linear, law=law, count=count)
    return codewords, decoded, {"armed": armed, "serial": serial}


def spectrum(samples: list[int], *, rate: int = RATE) -> dict[str, object]:
    def magnitude(frequency: int) -> float:
        return abs(sum(
            value * complex(math.cos(2 * math.pi * frequency * index / rate),
                            math.sin(2 * math.pi * frequency * index / rate))
            for index, value in enumerate(samples)
        ))
    bins = {frequency: magnitude(frequency) for frequency in (*ROWS, *COLUMNS)}
    return {
        "row": max(ROWS, key=bins.get),
        "column": max(COLUMNS, key=bins.get),
        "magnitudes": bins,
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--ram", type=Path, required=True)
    parser.add_argument("--digits", default="123456789*0#ABCD")
    parser.add_argument("--law", choices=("a", "mu", "both"), default="both")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if not args.digits or any(digit not in DIGITS for digit in args.digits):
        parser.error("invalid DTMF digits")
    args.output.mkdir(parents=True, exist_ok=False)
    ram = args.ram.read_bytes()
    combined: list[int] = []
    reports = []
    laws = ("a", "mu") if args.law == "both" else (args.law,)
    wire = {law: bytearray() for law in laws}
    for digit in args.digits:
        samples, serial = render(ram, digit)
        combined.extend(samples)
        combined.extend([0] * (RATE // 10))
        g711_report = {}
        for law in laws:
            codewords, decoded, wire_serial = render_g711(
                ram, digit, law=law, count=1_600)
            wire[law].extend(codewords)
            wire[law].extend(bytes([0xD5 if law == "a" else 0xFF]) * 800)
            g711_report[law] = {
                "codewords": len(codewords),
                "sha256": hashlib.sha256(codewords).hexdigest(),
                "spectrum": spectrum(decoded, rate=8_000),
                "dxr_writes": wire_serial["dxr_writes"],
                "last_dxr_pc": hex(wire_serial["last_dxr_pc"]),
            }
        reports.append({
            "digit": digit,
            "spectrum": spectrum(samples),
            "sample_sha256": hashlib.sha256(
                struct.pack(f"<{len(samples)}h", *samples)).hexdigest(),
            "dxr_writes": serial["dxr_writes"],
            "last_dxr_pc": hex(serial["last_dxr_pc"]),
            "g711": g711_report,
        })
    with wave.open(str(args.output / "stock-qf-dtmf.wav"), "wb") as output:
        output.setnchannels(1)
        output.setsampwidth(2)
        output.setframerate(RATE)
        output.writeframes(struct.pack(f"<{len(combined)}h", *combined))
    for law, codewords in wire.items():
        (args.output / f"stock-qf-dtmf-{law}law.g711").write_bytes(codewords)
    report = {
        "producer": "stock QF060003 TMS320C50 routines",
        "sample_rate": RATE,
        "g711_sample_rate": 8_000,
        "g711_producer": "QF060003 compressor 0x817f and serial ISR 0x83e1",
        "laws": list(laws),
        "tones": reports,
    }
    (args.output / "results.json").write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
