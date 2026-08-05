from __future__ import annotations

from dataclasses import dataclass, field


# Register-level model of the Courier's silicon DAA.
#
# The board carries an Si3021 (system side) and an Si3014 (line side); the
# datasheet in `docs/SI3038.PDF` is for the AC'97 sibling of that pair, the
# Si3024 + Si3014. Only the AC'97 half of the family has a published register
# map here, so these addresses are the Si3038's. The *fields* are the line
# side's and are shared across the family; the *numbering* is not, and the
# serial part reaches the same fields through its own control frames. Treat an
# address in this module as "the Si3038 register that carries this field",
# never as an address the Courier's firmware emits.
#
# Nothing in the firmware runs this bring-up. The 80186 never reads ports
# 0x40..0x4e (it only writes them), so it cannot observe the readiness byte the
# procedure polls, and the C52's only external reads are the host mailbox
# window at its I/O 0x50 and the line ADC at 0x54. The sequence therefore
# belongs to the interposed ASIC, which AN16 section 1.3 has mastering the
# serial bus. `CodecBringUp` is that master.

EXTENDED_ID = 0x3C
POWER_CONTROL = 0x3E
SAMPLE_RATE = (0x40, 0x42)
LEVEL = (0x46, 0x48)
GPIO_CONFIGURATION = 0x4C
GPIO_POLARITY = 0x4E
GPIO_STICKY = 0x50
GPIO_WAKE_MASK = 0x52
GPIO_STATUS = 0x54
CHIP_ID = 0x5A
LINE_CONFIGURATION_1 = 0x5C
LINE_STATUS = 0x5E
LINE_CONFIGURATION_2 = 0x62
LINE_CONFIGURATION_3 = 0x64

LINE_SIDE_REGISTERS = (
    LINE_CONFIGURATION_1,
    LINE_STATUS,
    LINE_CONFIGURATION_2,
    LINE_CONFIGURATION_3,
)

# Register 3Eh, bits 13:8 — one power-down bit per subsystem, all set at reset.
POWER_DOWN_GPIO = 1 << 8  # PRA
POWER_DOWN_RESERVED = 1 << 9  # PRB
POWER_DOWN_ADC1 = 1 << 10  # PRC
POWER_DOWN_DAC1 = 1 << 11  # PRD
POWER_DOWN_ADC2 = 1 << 12  # PRE
POWER_DOWN_DAC2 = 1 << 13  # PRF
POWER_DOWN_MASK = 0x3F00

# Register 3Eh, bits 7:0 — readiness, read-only.
READY_GPIO = 1 << 0
READY_MREF = 1 << 1
READY_ADC1 = 1 << 2
READY_DAC1 = 1 << 3
READY_ADC2 = 1 << 4
READY_DAC2 = 1 << 5
# The values the datasheet's initialization step 4 says to poll for.
READY_CODE = {1: 0x0F, 2: 0x33}

# Register 5Eh, line side status.
STATUS_CHARGE_PUMP_DISABLE = 1 << 10  # PDC
STATUS_RECEIVE_OVERLOAD = 1 << 9  # ROV
STATUS_BILLING_TONE = 1 << 8  # BTD
STATUS_LINK_ERROR = 1 << 7  # CLE
STATUS_FRAME_DETECT = 1 << 6  # FDT
STATUS_LOOP_CURRENT_SHIFT = 2  # LCS[3:0]
STATUS_RING_POSITIVE = 1 << 1  # RDTP
STATUS_RING_NEGATIVE = 1 << 0  # RDTN
# Bits the host clears by writing a zero over a one; everything else in 5Eh is
# a live reading the line side owns.
STATUS_WRITE_TO_CLEAR = (
    STATUS_RECEIVE_OVERLOAD | STATUS_BILLING_TONE | STATUS_LINK_ERROR
)

# Register 5Ch, line side configuration 1.
CONFIG_BILLING_TONE_ENABLE = 1 << 6  # BTE

# Loop current sense reports in 6 mA steps, saturating at 1111.
LOOP_CURRENT_STEP_MA = 6
LOOP_CURRENT_MAX = 0x0F
# A seized North American loop sits well inside the FCC dc mask; 25 mA is the
# middle of it and reads back as LCS = 4.
OFF_HOOK_LOOP_CURRENT_MA = 25

# Table on page 41: the rates the PLL can synthesize. The register value is the
# rate in Hz, so this is the whole encoding.
SUPPORTED_SAMPLE_RATES = (7_200, 8_000, 8_228, 8_400, 9_000, 9_600, 10_285, 12_000, 13_714)

# Register 3Ch reads back the codec's configuration straps: ID1:0 = 01 with
# LIN1 set is the first line, ID1:0 = 10 with LIN2 set is the second.
EXTENDED_ID_VALUE = {1: 0x4001, 2: 0x8002}

# Reset values, from each register's "Reset settings" line. 3Ch and 46h differ
# between a line 1 and a line 2 part, so they are filled in per instance.
RESET_VALUES: dict[int, int] = {
    POWER_CONTROL: 0xFF00,
    SAMPLE_RATE[0]: 0x0000,
    SAMPLE_RATE[1]: 0x0000,
    LEVEL[0]: 0x8080,
    LEVEL[1]: 0x0000,
    GPIO_CONFIGURATION: 0x003F,
    GPIO_POLARITY: 0x0000,
    GPIO_STICKY: 0x0000,
    GPIO_WAKE_MASK: 0x0000,
    GPIO_STATUS: 0x0000,
    LINE_CONFIGURATION_1: 0xF010,
    LINE_STATUS: 0x0000,
    LINE_CONFIGURATION_2: 0x0000,
    LINE_CONFIGURATION_3: 0x0000,
}

# Chip identity is strapped, not reset: revision A1 of a chipset part.
CHIP_ID_VALUE = 0x0011

# The revision the ASIC reports to the supervisor at power up. This is a
# board-level identity word rather than register 5Ah: the supervisor's receive
# table stores tag 0x7b's data at [0x287], `ATI7` prints it as "DAA rev", and
# the routine at 0x77eda appends " : DAA Failure (zero is Invalid)" when it is
# zero. The value is read out of the firmware, not off a part -- 0x8369d
# branches on [0x287] == 4 to print product ID "00345302" instead of the
# placeholder "XX345302", so 4 is what this build expects to find.
DAA_REVISION = 4

# Frames of settling between "powered up" and "ready". The datasheet gives no
# time, only step 4's instruction to poll, so this is the shortest schedule
# that still makes the poll meaningful: the reference and the GPIO block come
# up first, the converters a frame later.
REFERENCE_FRAMES = 1
CONVERTER_FRAMES = 2

# North America. Table 19's Canada row is OHS 0, ACT 0, DCT[1:0] = 10 (FCC
# mode), RZ 0, RT 0, and the United States shares FCC mode with it. Writing
# this over the 0xF010 reset value also lifts the call progress mutes that
# ARM[1:0] and ATM[1:0] hold at reset.
NORTH_AMERICA_CONFIGURATION_1 = 0x0010
NORTH_AMERICA_CONFIGURATION_2 = 0x0000


def nearest_sample_rate(rate: int) -> int:
    """Return the rate the PLL answers with, per register 40h's description."""
    return min(SUPPORTED_SAMPLE_RATES, key=lambda supported: abs(supported - rate))


class SiliconDaa:
    """The Si3021/Si3014 pair as a register file plus its line-side inputs.

    Registers are what a controller writes and reads. The line-side inputs
    below them -- hook state, loop current, the ring waveform -- are what the
    subscriber line does, and register 5Eh is assembled from those rather than
    stored.
    """

    def __init__(self, line: int = 1, revision: int = DAA_REVISION) -> None:
        if line not in (1, 2):
            raise ValueError(f"a codec is line 1 or line 2, got {line}")
        self.line = line
        # Reported to the supervisor at power up, not held in a register.
        self.revision = revision & 0xFFFF
        # Line-side inputs, driven by whatever models the loop.
        self.off_hook = False
        self.line_connected = False
        self.loop_current_ma = 0
        self.ring_positive = False
        self.ring_negative = False
        self.receive_overload = False
        self.billing_tone = False
        self.frames = 0
        self.resets = 0
        self.registers: dict[int, int] = {}
        self.reset()

    # -- register reset ----------------------------------------------------

    def reset(self) -> None:
        """Step 1 of the initialization procedure: a write to 3Ch."""
        self.registers = dict(RESET_VALUES)
        self.registers[EXTENDED_ID] = EXTENDED_ID_VALUE[self.line]
        self.registers[CHIP_ID] = CHIP_ID_VALUE
        if self.line == 2:
            # A line 2 part reverses the two per-line reset defaults.
            self.registers[LEVEL[0]] = 0x0000
            self.registers[LEVEL[1]] = 0x8080
            self.registers[GPIO_CONFIGURATION] = 0xFC00
        self._settling = 0
        self._sticky_status = 0
        self.resets += 1

    # -- power up ----------------------------------------------------------

    @property
    def powered(self) -> bool:
        """Whether the line side has been activated.

        Clearing *any* of this line's PR bits activates the Si3014, which is
        why the reset condition -- every PR bit set -- is the one state with no
        possibility of loading the loop.
        """
        return self.registers[POWER_CONTROL] & self._converter_power_bits != (
            self._converter_power_bits
        )

    @property
    def pll_programmed(self) -> bool:
        return bool(self.registers[SAMPLE_RATE[self.line - 1]])

    @property
    def link_up(self) -> bool:
        """ISOcap frame lock across the isolation barrier.

        Disabled by default: it needs the PR bits cleared *and* the sample rate
        programmed, so an out-of-order bring-up leaves the line side mute.
        """
        return self.powered and self.pll_programmed and self._settling >= CONVERTER_FRAMES

    @property
    def _converter_power_bits(self) -> int:
        if self.line == 1:
            return POWER_DOWN_ADC1 | POWER_DOWN_DAC1
        return POWER_DOWN_ADC2 | POWER_DOWN_DAC2

    @property
    def readiness(self) -> int:
        """Register 3Eh bits 7:0, recomputed rather than stored."""
        power = self.registers[POWER_CONTROL]
        value = 0
        if not power & POWER_DOWN_GPIO and self._settling >= REFERENCE_FRAMES:
            value |= READY_GPIO
        if not self.pll_programmed:
            # With the PLL disabled there is no line-side communication at all,
            # so the reference never comes up however long the poll runs.
            return value
        if self.powered and self._settling >= REFERENCE_FRAMES:
            value |= READY_MREF
        if self._settling >= CONVERTER_FRAMES:
            if self.line == 1:
                if not power & POWER_DOWN_ADC1:
                    value |= READY_ADC1
                if not power & POWER_DOWN_DAC1:
                    value |= READY_DAC1
            else:
                if not power & POWER_DOWN_ADC2:
                    value |= READY_ADC2
                if not power & POWER_DOWN_DAC2:
                    value |= READY_DAC2
        return value

    @property
    def ready(self) -> bool:
        return self.readiness == READY_CODE[self.line]

    def elapse(self, frames: int = 1) -> None:
        """Advance the settling clock by whole ASIC service frames."""
        if frames <= 0:
            return
        self.frames += frames
        if self.powered or not self.registers[POWER_CONTROL] & POWER_DOWN_GPIO:
            self._settling = min(self._settling + frames, CONVERTER_FRAMES)

    # -- line side ---------------------------------------------------------

    def set_hook(self, off_hook: bool) -> None:
        """Seize or release the loop.

        On the AC'97 part this is not a register at all: the controller sets
        bit 0 of output slot 12 for line 1, bit 10 for line 2. Model it as the
        command it is, and let the loop current follow it.
        """
        self.off_hook = off_hook
        self.loop_current_ma = (
            OFF_HOOK_LOOP_CURRENT_MA if off_hook and self.line_connected else 0
        )

    def set_ring(self, positive: bool, negative: bool) -> None:
        self.ring_positive = positive
        self.ring_negative = negative

    @property
    def loop_current_sense(self) -> int:
        if not self.link_up:
            return 0
        return min(LOOP_CURRENT_MAX, self.loop_current_ma // LOOP_CURRENT_STEP_MA)

    @property
    def line_status(self) -> int:
        """Register 5Eh, assembled from the line rather than stored."""
        value = self._sticky_status
        if self.link_up:
            value |= STATUS_FRAME_DETECT
            value |= self.loop_current_sense << STATUS_LOOP_CURRENT_SHIFT
            if self.ring_positive:
                value |= STATUS_RING_POSITIVE
            if self.ring_negative:
                value |= STATUS_RING_NEGATIVE
            if self.receive_overload:
                value |= STATUS_RECEIVE_OVERLOAD
            if self.billing_tone and self.registers[LINE_CONFIGURATION_1] & CONFIG_BILLING_TONE_ENABLE:
                value |= STATUS_BILLING_TONE
        return value

    # -- control interface -------------------------------------------------

    def write(self, address: int, value: int) -> None:
        value &= 0xFFFF
        if address == EXTENDED_ID:
            # Any value resets the register file. This is the only write to a
            # read-only register that means something.
            self.reset()
            return
        if address == CHIP_ID:
            return
        if address not in self.registers:
            raise ValueError(f"no register at {address:#04x}")
        if address in LINE_SIDE_REGISTERS and not self.link_up:
            # "Line-side must be activated via PR bits before valid read/write."
            # A controller that reaches across a dead barrier gets a
            # communications error rather than a stored value.
            self._sticky_status |= STATUS_LINK_ERROR
            return
        if address == POWER_CONTROL:
            self.registers[POWER_CONTROL] = (self.registers[POWER_CONTROL] & ~POWER_DOWN_MASK) | (
                value & POWER_DOWN_MASK
            )
            # Any change to the power state restarts settling; readiness is a
            # measurement of this transition, not a latch.
            self._settling = 0
            return
        if address in SAMPLE_RATE:
            self.registers[address] = nearest_sample_rate(value) if value else 0
            return
        if address == LINE_STATUS:
            # Only the three latched bits are writable, and only to zero.
            self._sticky_status &= value | ~STATUS_WRITE_TO_CLEAR
            self._sticky_status &= 0xFFFF
            return
        self.registers[address] = value

    def read(self, address: int) -> int:
        if address == POWER_CONTROL:
            return (self.registers[POWER_CONTROL] & ~0xFF) | self.readiness
        if address == LINE_STATUS:
            if not self.link_up:
                self._sticky_status |= STATUS_LINK_ERROR
            return self.line_status
        if address in LINE_SIDE_REGISTERS and not self.link_up:
            self._sticky_status |= STATUS_LINK_ERROR
            return 0
        if address not in self.registers:
            raise ValueError(f"no register at {address:#04x}")
        return self.registers[address]

    def status(self) -> dict[str, object]:
        return {
            "line": self.line,
            "revision": self.revision,
            "resets": self.resets,
            "frames": self.frames,
            "powered": self.powered,
            "pll_programmed": self.pll_programmed,
            "sample_rate": self.registers[SAMPLE_RATE[self.line - 1]],
            "link_up": self.link_up,
            "ready": self.ready,
            "readiness": f"0x{self.readiness:02x}",
            "off_hook": self.off_hook,
            "loop_current_ma": self.loop_current_ma,
            "loop_current_sense": self.loop_current_sense,
            "line_status": f"0x{self.line_status:04x}",
            # The stored file, not `read`: reaching a line-side register while
            # the barrier is down latches a communications error, and reporting
            # state must not be what causes one.
            "registers": {
                f"0x{address:02x}": f"0x{value:04x}"
                for address, value in sorted(self.registers.items())
            },
        }


@dataclass
class CodecBringUp:
    """The ASIC-side master running the datasheet's initialization procedure.

    Each `step` performs one numbered step and returns its name, so the poll in
    step 4 is a real poll: it repeats until register 3Eh's low byte reads the
    codec's readiness code, and the frames it waits through are the same frames
    the rest of the harness counts.
    """

    codec: SiliconDaa
    rate: int = 9_600
    configuration_1: int = NORTH_AMERICA_CONFIGURATION_1
    configuration_2: int = NORTH_AMERICA_CONFIGURATION_2
    level: int = 0x0000
    gpio_configuration: int = 0x0000
    index: int = 0
    polls: int = 0
    steps: list[str] = field(default_factory=list)

    @property
    def complete(self) -> bool:
        return self.index >= 7

    def step(self) -> str | None:
        """Run one step of the procedure; return its name, or None when done."""
        codec = self.codec
        line = codec.line - 1
        if self.index == 0:
            codec.write(EXTENDED_ID, 0)
            name = "register-reset"
        elif self.index == 1:
            codec.write(SAMPLE_RATE[line], self.rate)
            name = "sample-rate"
        elif self.index == 2:
            codec.write(POWER_CONTROL, 0x0000)
            name = "power-up"
        elif self.index == 3:
            self.polls += 1
            if not codec.ready:
                # Step 4 is the wait. Report the poll without advancing, and
                # let the caller give the part another frame.
                return "power-up-poll"
            name = "ready"
        elif self.index == 4:
            codec.write(GPIO_CONFIGURATION, self.gpio_configuration)
            codec.write(GPIO_POLARITY, 0x0000)
            codec.write(GPIO_STICKY, 0x0000)
            codec.write(GPIO_WAKE_MASK, 0x0000)
            name = "gpio"
        elif self.index == 5:
            codec.write(LEVEL[line], self.level)
            name = "levels"
        elif self.index == 6:
            codec.write(LINE_CONFIGURATION_1, self.configuration_1)
            codec.write(LINE_CONFIGURATION_2, self.configuration_2)
            name = "line-interface"
        else:
            return None
        self.index += 1
        self.steps.append(name)
        return name

    def service(self, frames: int = 1) -> None:
        """Give the part `frames` of settling and make what progress it allows."""
        self.codec.elapse(frames)
        if self.complete:
            return
        for _ in range(8):
            if self.complete or self.step() == "power-up-poll":
                break

    def run(self, limit: int = 16) -> bool:
        """Drive the whole procedure to completion; return whether it finished."""
        for _ in range(limit):
            if self.complete:
                return True
            self.service()
        return self.complete

    def status(self) -> dict[str, object]:
        return {
            "complete": self.complete,
            "polls": self.polls,
            "steps": list(self.steps),
            "codec": self.codec.status(),
        }
