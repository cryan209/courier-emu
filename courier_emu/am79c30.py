"""The Am79C30A Digital Subscriber Controller, as the I-modem drives it.

The board reaches the chip through eight consecutive ports at `0300`.  Two of
them are the indirect register file - a command register that selects which of
the chip's registers is addressed, and a data register that streams that
register's bytes.  Every indirect register is a *block* of a fixed width, and
the data port walks the block one byte per access, so the widths are part of
the protocol, not decoration.  They are also how the part was identified: the
firmware writes exactly seven bytes to `DLC_1_7` and exactly two to `DRCR`.

The other six are the part's *direct* registers, and the firmware's own
interrupt handler names every one of them.  Vector `0x2e` - slave IRQ14 - is
`4030:02f8`, which far-calls `71d7:000f`, and that routine is a D-channel
interrupt service in full view:

    71ec0  in 0300              read IR, the interrupt register
    71ed5  test al, 2f          loop while any of bits 0,1,2,3,5 is set
    71d97  test [bp-4], 20      bit 5: the LIU's line state changed
    71dff  test [bp-4], 1       bit 0: the transmit buffer wants more
    71e48  test [bp-4], 2       bit 1: a received byte is waiting
    71eaf  test [bp-4], 0c      bits 2,3: D-channel status and error

with the data paths underneath it reading `0304` for received bytes and
`0307` for the byte-by-byte status, and `0302`/`0303` read by the status
handler at `72caf`.  That is the Am79C30A direct map exactly - CR/IR, DR,
DSR1, DER, DCTB/DCRB, the two B-channel buffers, DSR2 - and it settles the
three ports left unaccounted for in docs/imodem-isdn-front-end.md.  `0305`
and `0306` are never touched: the B channels are routed by the MCRs to the
peripheral port, not read through the host.

What the firmware does with each is what the model has to produce, and the
transmit and receive paths are both recovered rather than assumed:

* **Transmit** (`71cb0`): push bytes to DCTB while DSR2 bit 4 says there is
  room, then write the frame's total length to DTCR as two bytes.  Writing
  DTCR is what arms the frame, so that is where this model closes one.
* **Receive** (`71e64`, again at `72e1e`): read DCRB, then DSR2 - bit 1 says
  another byte is waiting, bit 0 says the byte just read ended a frame.  The
  status handler then reads DER for the frame's errors and DRCR for its
  length, and passes the frame up only when `DER & 0x7b` is clear.
* **Line state** (`70e6f`): read LSR, take `(LSR & 7) + 2` as the interface
  state, and on a change dispatch through a six-entry table.  Adding two to a
  three-bit field puts the resting state at 4 and the top of the range at 9,
  which is I.430's F1..F8 numbered from 2 - and the entry the table reaches
  for LSR&7 = 6, internal 8, is the one that notifies layer 2 that the line
  came up.  So **LSR bits 2:0 carry the F-state, biased by one**.

Nothing here decides what the chip *does* on its own: the line state and the
received frames come from whoever is playing the network, and until a caller
says otherwise the interface sits in F1 with nothing on the D channel.
"""
from __future__ import annotations

from collections import Counter, deque
from dataclasses import dataclass, field


COMMAND_PORT = 0x0300
DATA_PORT = 0x0301

# Register block widths, in bytes. The names are the part's own; the widths
# are what the data port walks before it stops.
REGISTERS: dict[int, tuple[str, int]] = {
    0x20: ("INIT2", 1),
    0x21: ("INIT", 1),
    # The channel multiplexer: which of B1, B2 and the internal ports connect.
    0x41: ("MCR1", 1),
    0x42: ("MCR2", 1),
    0x43: ("MCR3", 1),
    0x44: ("MCR4", 1),
    0x45: ("MCR5", 1),
    # The main audio processor.
    0x61: ("MAP_X", 8),
    0x62: ("MAP_R", 8),
    0x63: ("MAP_GX", 2),
    0x64: ("MAP_GR", 2),
    0x65: ("MAP_GER", 2),
    0x66: ("MAP_STGR", 2),
    0x67: ("MAP_FTGR_1_2", 2),
    0x68: ("MAP_ATGR_1_2", 2),
    0x69: ("MAP_MMR1", 1),
    0x6A: ("MAP_MMR2", 1),
    0x6B: ("MAP_1_10", 46),
    0x6C: ("MAP_MMR3", 1),
    0x6D: ("MAP_STRA", 2),
    0x6E: ("MAP_STRF", 2),
    0x70: ("MAP_PEAKX", 2),
    0x71: ("MAP_PEAKR", 2),
    0x72: ("MAP_15_16", 2),
    # The D-channel HDLC controller.
    0x81: ("DLC_FRAR_1_2_3", 3),
    0x82: ("DLC_SRAR_1_2_3", 3),
    0x83: ("DLC_TAR", 1),
    0x84: ("DLC_DRLR", 6),
    0x85: ("DLC_DTCR", 2),
    0x86: ("DLC_DMR1", 1),
    0x87: ("DLC_DMR2", 1),
    0x88: ("DLC_1_7", 7),
    0x89: ("DLC_DRCR", 2),
    0x8A: ("DLC_RNGR1", 2),
    0x8B: ("DLC_RNGR2", 2),
    0x8C: ("DLC_FRAR4", 1),
    0x8D: ("DLC_SRAR4", 1),
    0x8E: ("DLC_DMR3", 1),
    0x8F: ("DLC_DMR4", 1),
    0x90: ("DLC_12_15", 4),
    0x91: ("DLC_ASR", 1),
    0x92: ("DLC_EFCR", 1),
    # The line interface unit: the S/T transceiver.
    0xA1: ("LIU_LSR", 1),
    0xA2: ("LIU_LPR", 1),
    0xA3: ("LIU_LMR1", 1),
    0xA4: ("LIU_LMR2", 1),
    0xA5: ("LIU_2_4", 3),
    0xA6: ("LIU_MF", 1),
    0xA7: ("LIU_MFSB", 1),
    0xA8: ("LIU_MFQB", 1),
    # The peripheral port.
    0xC0: ("PP_PPCR1", 1),
    0xC1: ("PP_PPSR", 1),
    0xC2: ("PP_PPIER", 1),
    0xC4: ("PP_PPCR2", 1),
    0xC8: ("PP_PPCR3", 1),
}

# The direct registers, at the six ports above the command/data pair. The
# names are the part's; which port is which is the firmware's interrupt
# service, above.
DSR1_PORT = 0x0302   # D-channel status 1: whole-frame events
DER_PORT = 0x0303    # D-channel error: why a received frame was no good
DCB_PORT = 0x0304    # DCTB writing, DCRB reading: the D-channel byte
BB_PORT = 0x0305     # Bb transmit/receive - never touched on this board
BC_PORT = 0x0306     # Bc transmit/receive - likewise
DSR2_PORT = 0x0307   # D-channel status 2: the byte-by-byte handshake
PORTS = range(COMMAND_PORT, DSR2_PORT + 1)

# IR, read at the command port. Each bit is named by the branch the firmware's
# ISR takes on it; the mask it loops on is 0x2f.
IR_TX_READY = 0x01   # 71dff: push more of the frame being transmitted
IR_RX_BYTE = 0x02    # 71e48: a received byte is waiting in DCRB
IR_DSR1 = 0x04       # 71eaf: DSR1 has a whole-frame event
IR_DER = 0x08        # 71eaf, same branch: DER has an error
IR_LIU = 0x20        # 71d97: the line state changed
IR_SERVICED = 0x2F   # what the ISR loops on

# DSR1, read first by the status handler at 72caf, which loops on 0x42.
DSR1_RX_FRAME_END = 0x02   # 72de6: a received frame ended
DSR1_TX_FRAME_DONE = 0x40  # 72cf5: the transmitted frame went out

# DSR2, read between bytes by both data paths.
DSR2_RX_LAST_BYTE = 0x01   # 71e9c: the byte just read ended the frame
DSR2_RX_BYTE = 0x02        # 71eaa: another byte is waiting
DSR2_TX_ROOM = 0x10        # 71d29: the transmit buffer will take a byte

# Indirect registers the model has to answer from its own state rather than
# from what was written: the line status, and the received frame's length.
LIU_LSR = 0xA1

# LSR's upper bits are not the line state. They are the handset hook, and the
# firmware names them itself: with bit 7 asserted its trace log prints
# `STAT_OFFHOOK Detected>>>` when bit 6 is clear and `STAT_ONHOOK Detected`
# when it is set (see docs/imodem-firmware-trace.md for how that log is
# read). The decode at 0x70ebd matches - bit 7 gates the whole branch, and
# `and ax, 0x40 ; sar ax, 6` lifts bit 6 out as the value it reports.
#
# That fits the board: the I-modem carries an analogue phone port, the ADP
# whose directory number `*P1` holds, and its hook switch is sensed here.
# Bit 7 is a change indication, so it is cleared when LSR is read; a modelled
# hook that never moves leaves both clear, which is what the part did before
# any of this was modelled.
LSR_HOOK_CHANGED = 0x80
LSR_ON_HOOK = 0x40

DLC_DTCR = 0x85
DLC_DRCR = 0x89

# The part's random number generators. These are not storage: the Am79C30's
# RNGR pair is a generator the host reads, and the firmware reads it to get
# the reference number for a TEI Identity Request - Ri, the value that lets
# two terminals asking at once tell their answers apart (Q.921 Annex D).
#
# Answering them out of the register file gave whatever had been written,
# which is 0, so every request this harness ever saw carried Ri 0. That is a
# legal value and not the reason a request fails, but it is not what the part
# does, and two terminals would collide on it.
#
# The sequence is a seeded LCG rather than the system generator, so a run
# stays reproducible: a harness whose frames change between runs is worse to
# debug than one whose "random" number is fixed per seed.
DLC_RNGR1 = 0x8A
DLC_RNGR2 = 0x8B
RNGR_SEED = 0x2189

# I.430's interface states, as the firmware numbers them: it reads LSR, takes
# (LSR & 7) + 2, and dispatches state - 3 through a six-entry table. F3 is the
# resting state and the one entry that notifies nobody; F7 is the activated
# line, and is what an incoming call needs before its SETUP can arrive.
F1_INACTIVE = 1
F2_SENSING = 2
F3_DEACTIVATED = 3
F6_SYNCHRONIZED = 6
F7_ACTIVATED = 7

F8_LOST_FRAMING = 8

# LSR's low three bits are the LIU's state, and the numbering is the *chip's*,
# not I.430's - the Am79C30's LIU state machine has fewer states than F1..F8.
# The firmware is the only source for it here, and it is an unambiguous one,
# because it stores `(LSR & 7) + 2` and then compares that byte all over:
#
#   LSR 0 -> stores 2   the reset state, tested at 0x71da4
#   LSR 1 -> stores 3   what the layer-1 machine at 0x62a27 polls until it
#                       leaves, so: sensing
#   LSR 2 -> stores 4   the resting state - the one entry in the dispatch
#                       table at 0x70f7e that notifies nobody
#   LSR 5 -> stores 7   **activated**. The D-channel transmit gate at 0x71c9b
#                       admits a frame only in state 7, and it is tested the
#                       same way at four other sites. A line driven here makes
#                       the whole stack run: the TEI request is transmitted, a
#                       TEI is assigned, an incoming SETUP is delivered and the
#                       firmware starts ringing.
#   LSR 6 -> stores 8   *not* activated, whatever it looks like. Driving the
#                       line here gets `LINE_ACTIVE Detected` followed by
#                       `LINE_NOT_ACTIVE Detected` out of the firmware's own
#                       log, and every frame queued for transmission is
#                       dropped by the gate above.
#
# So the mapping below is a table rather than a formula, and the entries carry
# their own evidence. F7 -> 5 is the one that matters and the one that is
# proven; the others are what the harness drives and are marked where they are
# assumed rather than shown.
LSR_STATE_FIELD = {
    F1_INACTIVE: 0,        # shown: the firmware's reset state is 2
    F2_SENSING: 1,         # shown: the machine polls state 3 until it moves
    F3_DEACTIVATED: 2,     # assumed: the resting state the table ignores
    F6_SYNCHRONIZED: 4,    # assumed: one below activated
    F7_ACTIVATED: 5,       # shown, and the whole stack depends on it
    F8_LOST_FRAMING: 6,    # shown to be a state the firmware calls not active
}

# LSR's other two bits, known only by the firmware's use of them: at 70ebd it
# treats bit 7 as a one-shot indication worth reporting upwards, carrying bit 6
# as that report's payload. Neither is needed to bring a line up, so both are
# left to the caller.
LSR_INDICATION = 0x80
LSR_INDICATION_FLAG = 0x40

# Reads whose value is not held in a written block.
DEFAULT_READS: dict[int, int] = {}


@dataclass
class Am79C30:
    """The register file, the line interface, and the D-channel controller."""

    reads: dict[int, int] = field(default_factory=lambda: dict(DEFAULT_READS))
    blocks: dict[int, bytearray] = field(default_factory=dict)
    selected: int | None = None
    cursor: int = 0
    read_counts: Counter = field(default_factory=Counter)
    write_counts: Counter = field(default_factory=Counter)
    unknown: Counter = field(default_factory=Counter)
    overruns: Counter = field(default_factory=Counter)

    # The line interface. F1 is the reset state: no signal either way.
    liu_state: int = F1_INACTIVE
    lsr_flags: int = 0
    # The handset. On hook is the resting state: nothing is lifted.
    on_hook: bool = True
    hook_changed: bool = False
    hook_changes: int = 0

    # The D channel. `rx` is the byte the host has yet to read plus the frame
    # boundaries behind it; `sent` is what the host has finished transmitting,
    # for whoever is playing the network to pick up.
    ir: int = 0
    dsr1: int = 0
    dsr2: int = 0
    der: int = 0
    rx_bytes: deque = field(default_factory=deque)
    rx_ends: set = field(default_factory=set)
    rx_lengths: deque = field(default_factory=deque)
    rx_last_was_end: bool = False
    rx_frame_length: int = 0
    tx_buffer: bytearray = field(default_factory=bytearray)
    sent: list = field(default_factory=list)
    received: int = 0
    transmitted: int = 0
    tx_length_mismatch: int = 0
    rng_state: int = RNGR_SEED
    rng_reads: int = 0
    # Opaque 64 kbit/s octets. MCR1..3 connect two logical ports per
    # register: B1=1, B2=2, Ba=3, Bb=4, Bc=5, Bd=6, Be=7, Bf=8.
    # AMD Am79C30A/32A data sheet, MUX control registers, table 18.
    bearer_rx: dict = field(default_factory=lambda: {1: deque(), 2: deque()})
    bearer_tx: dict = field(default_factory=lambda: {1: bytearray(), 2: bytearray()})
    bearer_frames: int = 0
    bearer_routed: Counter = field(default_factory=Counter)

    def bearer_routes(self) -> list[tuple[int, int]]:
        routes = []
        for register in (0x41, 0x42, 0x43):
            value = self.blocks.get(register, b'\x00')[0]
            left, right = value >> 4, value & 15
            if 1 <= left <= 8 and 1 <= right <= 8:
                routes.append((left, right))
        return routes

    def peripheral_slots(self, count: int) -> list[int | None]:
        """Which logical port each peripheral-port time slot carries.

        The part's PP clocks several eight-bit slots in each 125 us frame and
        the MUX decides which channel is in which.  This model takes the slots
        in the order the MCRs list their connections - MCR1's first - and
        leaves the rest unconnected, which is the register order the firmware
        writes rather than a decoding of PPCR1.  PPCR1 (`07` here) and PPCR2
        are recorded but not interpreted: nothing in the image has shown what
        their fields mean, and a slot map invented from them would be a guess
        wearing a datasheet's clothes.
        """
        slots: list[int | None] = []
        for left, right in self.bearer_routes():
            for port in (left, right):
                if port >= 3 and port not in slots:
                    slots.append(port)
        return (slots + [None] * count)[:count]

    def queue_bearer(self, channel: int, octets: bytes) -> None:
        """Network-to-terminal B1/B2 input, without companding conversion."""
        if channel not in (1, 2):
            raise ValueError('bearer channel must be 1 or 2')
        self.bearer_rx[channel].extend(octets)

    def clock_bearer(self, peripheral: dict[int, int], idle: int = 0xff) -> dict[int, int]:
        """Exchange one 8 kHz frame through the programmed MUX connections.

        Peripheral keys are the data sheet's logical port codes, not channel
        numbers. No default connection bypasses the firmware's MCR writes.
        """
        inputs = {port: value & 0xff for port, value in peripheral.items()}
        for channel in (1, 2):
            queue = self.bearer_rx[channel]
            inputs[channel] = queue.popleft() if queue and self.activated else idle
        outputs = {port: idle for port in range(1, 9)}
        for left, right in self.bearer_routes():
            if not self.activated and (left in (1, 2) or right in (1, 2)):
                continue
            outputs[left] = inputs.get(right, idle)
            outputs[right] = inputs.get(left, idle)
            for channel, other in ((left, right), (right, left)):
                if channel in (1, 2) and other in peripheral:
                    self.bearer_routed[channel] += 1
        for channel in (1, 2):
            self.bearer_tx[channel].append(outputs[channel])
        self.bearer_frames += 1
        return outputs

    def handles(self, port: int) -> bool:
        return port in PORTS

    # -- the line ----------------------------------------------------------

    def set_liu_state(self, state: int) -> None:
        """Put the S interface in an I.430 state, the way the line would.

        The firmware learns of this exactly as it would from the part: LSR
        changes and IR's line-status bit goes up, so its own handler at 70e6f
        reads the new state and tells layer 2 about it.
        """
        state = max(F1_INACTIVE, min(F8_LOST_FRAMING, int(state)))
        if state == self.liu_state:
            return
        self.liu_state = state
        self.ir |= IR_LIU

    def activate(self) -> None:
        """Bring the line up the way the network does, through the states."""
        self.set_liu_state(F6_SYNCHRONIZED)
        self.set_liu_state(F7_ACTIVATED)

    def deactivate(self) -> None:
        self.set_liu_state(F3_DEACTIVATED)

    @property
    def activated(self) -> bool:
        return self.liu_state == F7_ACTIVATED

    def set_hook(self, on_hook: bool) -> None:
        """Lift or replace the handset on the analogue port.

        The firmware learns of it the way it learns of a line-state change:
        LSR's change bit goes up and the part interrupts, and its own handler
        reads LSR and reports STAT_ONHOOK or STAT_OFFHOOK.
        """
        if bool(on_hook) == self.on_hook:
            return
        self.on_hook = bool(on_hook)
        self.hook_changed = True
        self.hook_changes += 1
        self.ir |= IR_LIU

    def _lsr(self) -> int:
        field = LSR_STATE_FIELD.get(self.liu_state, (self.liu_state - 1) & 7)
        value = (field & 7) | (self.lsr_flags & 0xC0)
        if self.on_hook:
            value |= LSR_ON_HOOK
        if self.hook_changed:
            value |= LSR_HOOK_CHANGED
        return value

    def _random_byte(self) -> int:
        """One byte out of the part's random number generator.

        Numerical Recipes' LCG, seeded per instance, so the bytes differ from
        each other and from zero while a run stays reproducible.
        """
        self.rng_state = (self.rng_state * 1664525 + 1013904223) & 0xFFFFFFFF
        self.rng_reads += 1
        return (self.rng_state >> 16) & 0xFF

    # -- the D channel, from the network side ------------------------------

    def deliver_frame(self, frame: bytes | bytearray) -> None:
        """Hand the host a received LAPD frame, byte by byte as the chip does."""
        frame = bytes(frame)
        if not frame:
            return
        for byte in frame:
            self.rx_bytes.append(byte)
        self.rx_ends.add(len(self.rx_bytes) - 1)
        self.rx_lengths.append(len(frame))
        self.received += 1
        self.ir |= IR_RX_BYTE
        self.dsr2 |= DSR2_RX_BYTE

    def take_sent(self) -> list:
        """Take the frames the host has transmitted since the last call."""
        frames, self.sent = self.sent, []
        return frames

    def _read_dcrb(self) -> int:
        if not self.rx_bytes:
            self.rx_last_was_end = False
            return 0
        index = 0
        value = self.rx_bytes.popleft()
        self.rx_last_was_end = index in self.rx_ends
        # The ends are counted from the front of the queue, so shift them down
        # with it rather than keeping absolute positions.
        self.rx_ends = {end - 1 for end in self.rx_ends if end > 0}
        if self.rx_last_was_end:
            # The frame is complete: DRCR reports its length, which is what
            # the status handler reads before it passes the frame up.
            self.rx_frame_length = self.rx_lengths.popleft() if self.rx_lengths else 0
            # The frame is complete: the status handler wants DSR1 to say so,
            # and it reads DER and DRCR before it passes the frame up.
            self.dsr1 |= DSR1_RX_FRAME_END
            self.der = 0
            self.ir |= IR_DSR1
        if not self.rx_bytes:
            self.dsr2 &= ~DSR2_RX_BYTE
        return value

    def _write_dctb(self, value: int) -> None:
        self.tx_buffer.append(value & 0xFF)

    def _arm_transmit(self) -> None:
        """DTCR has been written: the frame's length is now known."""
        block = self.blocks.get(DLC_DTCR)
        if block is None:
            return
        length = block[0] | (block[1] << 8)
        if length != len(self.tx_buffer):
            # The bytes and the length disagree, which on a real part would
            # send a short or a truncated frame. Count it rather than paper
            # over it: it means this model's idea of the buffer is wrong.
            self.tx_length_mismatch += 1
        self.sent.append(bytes(self.tx_buffer[:length] if length else self.tx_buffer))
        self.transmitted += 1
        self.tx_buffer.clear()
        self.dsr1 |= DSR1_TX_FRAME_DONE
        self.ir |= IR_DSR1

    def interrupting(self) -> bool:
        """Whether the part is asserting its interrupt line."""
        return bool(self.ir & IR_SERVICED)

    # -- the command port --------------------------------------------------

    def select(self, register: int) -> None:
        """Point the data port at a register and rewind to its first byte."""
        register &= 0xFF
        self.selected = register
        self.cursor = 0
        if register not in REGISTERS:
            self.unknown[register] += 1

    def read_ir(self) -> int:
        """IR, which the ISR loops on - so reading it has to clear it."""
        value = self.ir
        self.read_counts[COMMAND_PORT] += 1
        self.ir = 0
        # Whatever is still true re-arms itself, which is what keeps the ISR
        # looping until the D channel is actually drained.
        if self.rx_bytes:
            self.ir |= IR_RX_BYTE
        if self.dsr1:
            self.ir |= IR_DSR1
        return value & 0xFF

    # -- the data port -----------------------------------------------------

    def _width(self, register: int) -> int:
        entry = REGISTERS.get(register)
        return entry[1] if entry else 1

    def write_data(self, value: int) -> None:
        register = self.selected
        if register is None:
            return
        width = self._width(register)
        block = self.blocks.setdefault(register, bytearray(width))
        if self.cursor >= width:
            # A real part ignores the extra; record it rather than grow, so a
            # width that is wrong here shows up instead of hiding.
            self.overruns[register] += 1
            return
        block[self.cursor] = value & 0xFF
        self.cursor += 1
        self.write_counts[register] += 1
        if register == DLC_DTCR and self.cursor == width:
            self._arm_transmit()

    def read_data(self) -> int:
        register = self.selected
        if register is None:
            return 0
        self.read_counts[register] += 1
        if register == LIU_LSR:
            value = self._lsr()
            # A change indication, so reading it is what acknowledges it.
            self.hook_changed = False
            return value
        if register in (DLC_RNGR1, DLC_RNGR2):
            return self._random_byte()
        if register == DLC_DRCR:
            # The received frame's length, low byte first, as the status
            # handler reads it after draining the frame.
            value = (self.rx_frame_length >> (8 * self.cursor)) & 0xFF
            self.cursor += 1
            return value
        if register in self.reads:
            return self.reads[register] & 0xFF
        block = self.blocks.get(register)
        width = self._width(register)
        if block is None or self.cursor >= width:
            return 0
        value = block[self.cursor]
        self.cursor += 1
        return value

    # -- the ports ---------------------------------------------------------

    def read(self, port: int) -> int:
        if port == DATA_PORT:
            return self.read_data()
        if port == COMMAND_PORT:
            return self.read_ir()
        if port == DSR1_PORT:
            value, self.dsr1 = self.dsr1, 0
            self.read_counts[port] += 1
            return value & 0xFF
        if port == DER_PORT:
            value, self.der = self.der, 0
            self.read_counts[port] += 1
            return value & 0xFF
        if port == DSR2_PORT:
            self.read_counts[port] += 1
            value = self.dsr2 | DSR2_TX_ROOM
            if self.rx_last_was_end:
                value |= DSR2_RX_LAST_BYTE
            return value & 0xFF
        if port == DCB_PORT:
            self.read_counts[port] += 1
            return self._read_dcrb()
        self.read_counts[port] += 1
        return 0

    def write(self, port: int, value: int) -> None:
        if port == COMMAND_PORT:
            self.select(value)
        elif port == DATA_PORT:
            self.write_data(value)
        elif port == DCB_PORT:
            self.write_counts[port] += 1
            self._write_dctb(value)
        else:
            self.write_counts[port] += 1

    # -- reporting ---------------------------------------------------------

    def name(self, register: int) -> str:
        if register in PORTS:
            return {
                COMMAND_PORT: "CR_IR", DATA_PORT: "DR", DSR1_PORT: "DSR1",
                DER_PORT: "DER", DCB_PORT: "DCB", BB_PORT: "BB",
                BC_PORT: "BC", DSR2_PORT: "DSR2",
            }[register]
        entry = REGISTERS.get(register)
        return entry[0] if entry else f"unknown_{register:02x}"

    def status(self) -> dict[str, object]:
        return {
            "hook": "on-hook" if self.on_hook else "off-hook",
            "hook_changes": self.hook_changes,
            "written": {
                self.name(r): bytes(b).hex(" ")
                for r, b in sorted(self.blocks.items())
                if self.write_counts.get(r)
            },
            "read_counts": {
                self.name(r): c for r, c in self.read_counts.most_common()
            },
            "unknown_registers": {f"{r:#04x}": c for r, c in self.unknown.most_common()},
            "overruns": {self.name(r): c for r, c in self.overruns.most_common()},
            "liu_state": f"F{self.liu_state}",
            "bearer": {
                "frames": self.bearer_frames,
                "peripheral_slots": self.peripheral_slots(2),
                "routes": self.bearer_routes(),
                "routed_frames": dict(self.bearer_routed),
                "rx_pending": {channel: len(q) for channel, q in self.bearer_rx.items()},
            },
            "d_channel": {
                "frames_received": self.received,
                "frames_transmitted": self.transmitted,
                "rx_pending": len(self.rx_bytes),
                "tx_length_mismatch": self.tx_length_mismatch,
            },
        }
