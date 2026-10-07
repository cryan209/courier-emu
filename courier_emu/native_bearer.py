"""Python views of the B-channel path that lives in native/bearer.hpp.

`NativeBearer` owns the native state. The proxies stand in for the containers
`Am79C30` and `ImodemDsp` used to hold (`bearer_rx`, `bearer_tx`,
`bearer_rx_heard`, `bearer_rx_fed`, `bearer_routed`, `pcm_tx`), with the few
operations the rest of the code and the tests use, so the Python methods that
are the reference for the native ones keep working on the same state.
"""
from __future__ import annotations

import ctypes
from typing import Iterator

from .dsp import load_library

RX, TX, HEARD, PCM = 0, 1, 2, 3
_ROUTED0, _ROUTED1, _FRAMES, _FED0, _FED1 = range(5)


class NativeBearer:
    def __init__(self) -> None:
        lib = self.library = load_library()
        c = ctypes
        lib.courier_bearer_create.restype = c.c_void_p
        lib.courier_bearer_destroy.argtypes = [c.c_void_p]
        lib.courier_bearer_length.argtypes = [c.c_void_p, c.c_int, c.c_int]
        lib.courier_bearer_length.restype = c.c_size_t
        lib.courier_bearer_read.argtypes = [
            c.c_void_p, c.c_int, c.c_int, c.c_size_t, c.c_size_t, c.c_char_p]
        lib.courier_bearer_read.restype = c.c_size_t
        lib.courier_bearer_tail.argtypes = [
            c.c_void_p, c.c_int, c.c_int, c.c_size_t, c.c_char_p, c.c_size_t]
        lib.courier_bearer_tail.restype = c.c_size_t
        lib.courier_bearer_append.argtypes = [
            c.c_void_p, c.c_int, c.c_int, c.c_char_p, c.c_size_t]
        lib.courier_bearer_rx_popleft.argtypes = [c.c_void_p, c.c_int]
        lib.courier_bearer_rx_popleft.restype = c.c_int
        lib.courier_bearer_rx_appendleft.argtypes = [c.c_void_p, c.c_int, c.c_int]
        lib.courier_bearer_rx_clear.argtypes = [c.c_void_p, c.c_int]
        lib.courier_bearer_get.argtypes = [c.c_void_p, c.c_int]
        lib.courier_bearer_get.restype = c.c_uint64
        lib.courier_bearer_set.argtypes = [c.c_void_p, c.c_int, c.c_uint64]
        lib.courier_bearer_configure.argtypes = [
            c.c_void_p, c.c_int, c.c_uint, c.c_char_p, c.c_char_p, c.c_uint64]
        lib.courier_bearer_set_mode.argtypes = [
            c.c_void_p, c.c_uint32, c.c_int, c.c_uint]
        lib.courier_bearer_ahead_count.argtypes = [c.c_void_p]
        lib.courier_bearer_ahead_count.restype = c.c_size_t
        lib.courier_bearer_lookahead_valid.argtypes = [c.c_void_p]
        lib.courier_bearer_ahead_clear.argtypes = [c.c_void_p]
        lib.courier_bearer_ahead_popleft.argtypes = [c.c_void_p]
        lib.courier_bearer_ahead_popleft.restype = c.c_int64
        lib.courier_bearer_cancel.argtypes = [c.c_void_p, c.c_void_p]
        lib.courier_bearer_prefeed.argtypes = [c.c_void_p, c.c_void_p]
        lib.courier_bearer_exchange.argtypes = [
            c.c_void_p, c.c_void_p, c.c_char_p, c.c_size_t, c.c_char_p]
        lib.courier_bearer_exchange.restype = c.c_size_t
        lib.courier_bearer_partial.argtypes = [c.c_void_p, c.c_char_p]
        lib.courier_bearer_partial.restype = c.c_size_t
        lib.courier_bearer_set_partial.argtypes = [c.c_void_p, c.c_char_p, c.c_size_t]
        self.handle = lib.courier_bearer_create()
        self._buffer = ctypes.create_string_buffer(1 << 16)
        self._mode: tuple | None = None
        self._remainder = ctypes.create_string_buffer(1 << 12)

    def close(self) -> None:
        if self.handle:
            self.library.courier_bearer_destroy(self.handle)
            self.handle = None

    def __del__(self) -> None:  # pragma: no cover - interpreter shutdown order
        try:
            self.close()
        except Exception:
            pass

    # -- streams ---------------------------------------------------------------

    def length(self, kind: int, channel: int) -> int:
        return self.library.courier_bearer_length(self.handle, kind, channel)

    def read(self, kind: int, channel: int, start: int, stop: int) -> bytes:
        count = max(0, min(stop, self.length(kind, channel)) - start)
        if not count:
            return b""
        if count > len(self._buffer):
            self._buffer = ctypes.create_string_buffer(count)
        got = self.library.courier_bearer_read(
            self.handle, kind, channel, start, start + count, self._buffer)
        return self._buffer.raw[:got]

    def tail(self, kind: int, channel: int, start: int) -> tuple[bytes, int]:
        """(everything from `start` on, the stream's length): one native call."""
        buffer = self._buffer
        total = self.library.courier_bearer_tail(
            self.handle, kind, channel, start, buffer, len(buffer))
        if total - start > len(buffer):
            buffer = self._buffer = ctypes.create_string_buffer(total - start)
            self.library.courier_bearer_tail(
                self.handle, kind, channel, start, buffer, len(buffer))
        return (buffer.raw[:total - start] if total > start else b""), total

    def append(self, kind: int, channel: int, data: bytes) -> None:
        if data:
            self.library.courier_bearer_append(self.handle, kind, channel, data, len(data))

    # -- scalars ---------------------------------------------------------------

    def get(self, which: int) -> int:
        return self.library.courier_bearer_get(self.handle, which)

    def set(self, which: int, value: int) -> None:
        self.library.courier_bearer_set(self.handle, which, value)

    # -- configuration ---------------------------------------------------------

    def configure(self, activated: bool, routes: list[tuple[int, int]],
                  slots: list[int | None], generation: int) -> None:
        packed = bytes(value for route in routes[:3] for value in route)
        self.library.courier_bearer_configure(
            self.handle, int(activated), min(len(routes), 3), packed or b"\0",
            bytes((slots + [None, None])[index] or 0 for index in range(2)),
            generation)

    def set_mode(self, channels: tuple[int, ...], frame_service: bool,
                 lookahead_frames: int) -> None:
        mask = 0
        for channel in channels:
            mask |= 1 << (channel - 1)
        mode = (mask, bool(frame_service), lookahead_frames)
        if mode != self._mode:
            self._mode = mode
            self.library.courier_bearer_set_mode(
                self.handle, mask, int(frame_service), lookahead_frames)

    # -- the lookahead and the exchange ----------------------------------------

    def ahead_count(self) -> int:
        return self.library.courier_bearer_ahead_count(self.handle)

    def lookahead_valid(self) -> bool:
        return bool(self.library.courier_bearer_lookahead_valid(self.handle))

    def ahead_popleft(self) -> tuple[dict, dict, list]:
        """The oldest frame settled ahead, in the form `bearer_finish_frame` takes."""
        packed = self.library.courier_bearer_ahead_popleft(self.handle)
        if packed < 0:
            raise IndexError("pop from an empty lookahead")
        values = (packed & 0xFF, (packed >> 8) & 0xFF)
        taken_bits, heard_bits = (packed >> 16) & 0xFF, (packed >> 24) & 0xFF
        inputs = {1: values[0], 2: values[1]}
        heard = {channel: inputs[channel] for channel in (1, 2)
                 if heard_bits & (1 << (channel - 1))}
        taken = [channel for channel in (1, 2) if taken_bits & (1 << (channel - 1))]
        return inputs, heard, taken

    def cancel(self, core_handle: int | None) -> None:
        self.library.courier_bearer_cancel(self.handle, core_handle)

    def prefeed(self, core_handle: int | None) -> None:
        self.library.courier_bearer_prefeed(self.handle, core_handle)

    def exchange(self, core_handle: int, octets: bytes) -> bytes:
        """Settle what the C5x transmitted; what is left is the caller's to do."""
        size = len(octets) + 2
        if size > len(self._remainder):
            self._remainder = ctypes.create_string_buffer(size)
        left = self.library.courier_bearer_exchange(
            self.handle, core_handle, octets, len(octets), self._remainder)
        return self._remainder.raw[:left] if left else b""

    @property
    def partial(self) -> bytes:
        cell = ctypes.create_string_buffer(1)
        count = self.library.courier_bearer_partial(self.handle, cell)
        return cell.raw[:count]

    @partial.setter
    def partial(self, value: bytes) -> None:
        self.library.courier_bearer_set_partial(self.handle, bytes(value), len(value))


class RxQueue:
    """`collections.deque` as `bearer_rx[channel]` used it."""

    def __init__(self, bearer: NativeBearer, channel: int) -> None:
        self._b, self._channel = bearer, channel - 1

    def __len__(self) -> int:
        return self._b.length(RX, self._channel)

    def __bool__(self) -> bool:
        return self._b.length(RX, self._channel) > 0

    def extend(self, octets) -> None:
        self._b.append(RX, self._channel, bytes(octets))

    def popleft(self) -> int:
        value = self._b.library.courier_bearer_rx_popleft(self._b.handle, self._channel)
        if value < 0:
            raise IndexError("pop from an empty deque")
        return value

    def appendleft(self, value: int) -> None:
        self._b.library.courier_bearer_rx_appendleft(self._b.handle, self._channel, value)

    def clear(self) -> None:
        self._b.library.courier_bearer_rx_clear(self._b.handle, self._channel)

    def __iter__(self) -> Iterator[int]:
        return iter(self._b.read(RX, self._channel, 0, len(self)))


class Stream:
    """`bytearray` as `bearer_tx[channel]`, `bearer_rx_heard[channel]` and `pcm_tx` used it."""

    def __init__(self, bearer: NativeBearer, kind: int, channel: int = 0) -> None:
        self._b, self._kind, self._channel = bearer, kind, channel - 1 if channel else 0

    def __len__(self) -> int:
        return self._b.length(self._kind, self._channel)

    def __bool__(self) -> bool:
        return len(self) > 0

    def append(self, value: int) -> None:
        self._b.append(self._kind, self._channel, bytes((value & 0xFF,)))

    def extend(self, octets) -> None:
        self._b.append(self._kind, self._channel, bytes(octets))

    def tail(self, start: int) -> tuple[bytes, int]:
        return self._b.tail(self._kind, self._channel, start)

    def __getitem__(self, index):
        if (isinstance(index, slice) and index.step is None
                and index.start is not None and index.stop is not None
                and index.start >= 0 and index.stop >= 0):
            # A bounded slice needs no length: the native read clamps.
            count = index.stop - index.start
            if count <= 0:
                return b""
            b = self._b
            if count > len(b._buffer):
                b._buffer = ctypes.create_string_buffer(count)
            got = b.library.courier_bearer_read(
                b.handle, self._kind, self._channel, index.start, index.stop, b._buffer)
            return b._buffer.raw[:got]
        total = len(self)
        if isinstance(index, slice):
            start, stop, step = index.indices(total)
            data = self._b.read(self._kind, self._channel, start, stop)
            return data if step == 1 else data[::step]
        if index < 0:
            index += total
        if not 0 <= index < total:
            raise IndexError("index out of range")
        return self._b.read(self._kind, self._channel, index, index + 1)[0]

    def __iter__(self) -> Iterator[int]:
        return iter(self._b.read(self._kind, self._channel, 0, len(self)))

    def __bytes__(self) -> bytes:
        return self._b.read(self._kind, self._channel, 0, len(self))

    def __eq__(self, other) -> bool:
        try:
            return bytes(self) == bytes(other)
        except TypeError:
            return NotImplemented

    __hash__ = None  # type: ignore[assignment]


class Flags:
    """`{1: bool, 2: bool}` as `bearer_rx_fed` used it."""

    def __init__(self, bearer: NativeBearer) -> None:
        self._b = bearer

    def __getitem__(self, channel: int) -> bool:
        return bool(self._b.get(_FED0 + channel - 1))

    def __setitem__(self, channel: int, value: bool) -> None:
        self._b.set(_FED0 + channel - 1, int(bool(value)))


class Routed:
    """The Counter `bearer_routed`: frames routed per B channel."""

    def __init__(self, bearer: NativeBearer) -> None:
        self._b = bearer

    def __getitem__(self, channel: int) -> int:
        return self._b.get(_ROUTED0 + channel - 1) if channel in (1, 2) else 0

    def __setitem__(self, channel: int, value: int) -> None:
        self._b.set(_ROUTED0 + channel - 1, value)

    def keys(self):
        return [channel for channel in (1, 2) if self[channel]]

    def __iter__(self):
        return iter(self.keys())

    def __len__(self) -> int:
        return len(self.keys())

    def items(self):
        return [(channel, self[channel]) for channel in self.keys()]

    def get(self, channel: int, default=None):
        return self[channel] if self[channel] else default


def frames_get(bearer: NativeBearer) -> int:
    return bearer.get(_FRAMES)


def frames_set(bearer: NativeBearer, value: int) -> None:
    bearer.set(_FRAMES, value)


class AheadView:
    """The `deque` of frames settled ahead, as `ImodemDsp._sync_pcm` walks it."""

    def __init__(self, bearer: NativeBearer) -> None:
        self._b = bearer

    def __len__(self) -> int:
        return self._b.ahead_count()

    def __bool__(self) -> bool:
        return self._b.ahead_count() > 0

    def popleft(self):
        return self._b.ahead_popleft()

    def clear(self) -> None:
        self._b.library.courier_bearer_ahead_clear(self._b.handle)
