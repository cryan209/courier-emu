from __future__ import annotations

from dataclasses import dataclass
from functools import cached_property
from hashlib import sha256
from pathlib import Path
import struct


# A NAC is the ISDN Courier's other update container. Its record stream is
# Intel HEX with the ASCII stripped out: each record is a length byte, a
# big-endian 16-bit address, a type byte, and that many data bytes. The
# big-endian address is the giveaway -- everything else in these images is
# little-endian, and Intel HEX writes its address big-endian even on x86.
#
# Unlike ASCII Intel HEX there is no per-record checksum byte. Parsing without
# one consumes this image exactly, from the end of the header to the EOF record.
HEADER_SIZE = 0x20
TRAILER_SIZE = 2

# Header fields. The version triple matches the file name: Ie030002 is 3.0.2.
VERSION_OFFSET = 0x08
PRODUCT_OFFSET = 0x0F
PRODUCT_SIZE = 3
STREAM_LENGTH_OFFSET = 0x03

RECORD_DATA = 0x00
RECORD_EOF = 0x01
RECORD_EXTENDED_SEGMENT = 0x02
RECORD_START_SEGMENT = 0x03

MAX_RECORD_DATA = 0x10

# The stream opens by setting segment 0x4000, so the image places itself at
# physical 0x40000 rather than the harness having to assume a base. That is the
# same base the XMP payload decodes at, and the same one the boot code uses when
# it installs its INT1 handler in segment 0x4000.
ERASED_BYTE = 0xFF


class NacFormatError(ValueError):
    """Raised when a file does not match the recovered Courier NAC layout."""


@dataclass(frozen=True, slots=True)
class NacRecord:
    """One binary Intel HEX record."""

    file_offset: int
    kind: int
    address: int
    data: bytes

    @property
    def length(self) -> int:
        return len(self.data)


@dataclass(frozen=True)
class NacImage:
    """A binary Intel HEX update stream and the flash image it paints."""

    path: Path
    data: bytes
    # The file offset of every record header, in stream order. The records
    # themselves are rebuilt from these on the first `records` access: an
    # image holds tens of thousands, only the report command looks at them,
    # and building them costs more than painting the flash spans does.
    record_offsets: tuple[int, ...]
    spans: tuple[tuple[int, bytes], ...]
    start_segment: int | None
    start_offset: int | None

    @classmethod
    def load(cls, path: str | Path) -> "NacImage":
        source = Path(path)
        data = source.read_bytes()
        if len(data) < HEADER_SIZE + TRAILER_SIZE:
            raise NacFormatError(f"file is too short to be a Courier NAC ({len(data):#x} bytes)")
        declared = struct.unpack_from("<I", data, STREAM_LENGTH_OFFSET)[0]
        expected = len(data) - HEADER_SIZE - TRAILER_SIZE
        if declared != expected:
            raise NacFormatError(
                f"header declares a {declared:#x}-byte record stream, "
                f"but the file holds {expected:#x}"
            )

        record_offsets: list[int] = []
        # (physical address, bytes) in record order, so that a later record
        # overwrites an earlier one at the same address, as a loader walking
        # the stream would.
        chunks: list[tuple[int, bytes]] = []
        segment: int | None = None
        start: tuple[int, int] | None = None
        offset = HEADER_SIZE
        limit = len(data) - TRAILER_SIZE
        seen_eof = False
        while offset < limit:
            if offset + 4 > limit:
                raise NacFormatError(f"truncated record header at {offset:#x}")
            length = data[offset]
            address = (data[offset + 1] << 8) | data[offset + 2]
            kind = data[offset + 3]
            if length > MAX_RECORD_DATA:
                raise NacFormatError(f"record at {offset:#x} declares {length:#x} data bytes")
            body = data[offset + 4 : offset + 4 + length]
            if len(body) != length:
                raise NacFormatError(f"truncated record body at {offset:#x}")
            record_offsets.append(offset)
            if kind == RECORD_EOF:
                seen_eof = True
                offset += 4 + length
                break
            if kind == RECORD_EXTENDED_SEGMENT:
                if length != 2:
                    raise NacFormatError(
                        f"extended segment record at {offset:#x} carries {length} bytes"
                    )
                segment = (body[0] << 8) | body[1]
            elif kind == RECORD_START_SEGMENT:
                if length != 4:
                    raise NacFormatError(
                        f"start segment record at {offset:#x} carries {length} bytes"
                    )
                start = ((body[0] << 8) | body[1], (body[2] << 8) | body[3])
            elif kind == RECORD_DATA:
                if segment is None:
                    raise NacFormatError(
                        f"data record at {offset:#x} precedes any extended segment record"
                    )
                chunks.append((segment * 16 + address, body))
            else:
                raise NacFormatError(f"unknown record type {kind:#04x} at {offset:#x}")
            offset += 4 + length
        if not seen_eof:
            raise NacFormatError("record stream ends without an EOF record")
        if offset != limit:
            raise NacFormatError(
                f"EOF record at {offset:#x} does not end the stream at {limit:#x}"
            )
        if not chunks:
            raise NacFormatError("record stream carries no data records")

        return cls(
            source.resolve(),
            data,
            tuple(record_offsets),
            _paint(chunks),
            start[0] if start else None,
            start[1] if start else None,
        )

    @property
    def header(self) -> bytes:
        return self.data[:HEADER_SIZE]

    @property
    def trailer(self) -> bytes:
        """The two bytes after the EOF record.

        Not a byte sum of the stream and not any of the common CRC-16s, so it is
        reported verbatim rather than decoded.
        """
        return self.data[-TRAILER_SIZE:]

    @property
    def digest(self) -> str:
        return sha256(self.data).hexdigest()

    @property
    def version(self) -> tuple[int, int, int]:
        major, minor, patch = self.data[VERSION_OFFSET : VERSION_OFFSET + 3]
        return major, minor, patch

    @property
    def product(self) -> str:
        window = self.data[PRODUCT_OFFSET : PRODUCT_OFFSET + PRODUCT_SIZE]
        return window.decode("ascii", "replace")

    @property
    def stream_length(self) -> int:
        return struct.unpack_from("<I", self.data, STREAM_LENGTH_OFFSET)[0]

    @property
    def load_base(self) -> int:
        return self.spans[0][0]

    @property
    def entry_physical(self) -> int | None:
        if self.start_segment is None or self.start_offset is None:
            return None
        return self.start_segment * 16 + self.start_offset

    @cached_property
    def records(self) -> tuple[NacRecord, ...]:
        """Every record of the stream, decoded from the offsets kept at load."""
        data = self.data
        return tuple(
            NacRecord(
                offset,
                data[offset + 3],
                (data[offset + 1] << 8) | data[offset + 2],
                data[offset + 4 : offset + 4 + data[offset]],
            )
            for offset in self.record_offsets
        )

    @property
    def data_records(self) -> tuple[NacRecord, ...]:
        return tuple(record for record in self.records if record.kind == RECORD_DATA)

    @property
    def painted_bytes(self) -> int:
        return sum(len(payload) for _, payload in self.spans)

    def flatten(self, fill: int = ERASED_BYTE) -> tuple[int, bytes]:
        """Return the base address and one image covering every painted span."""
        base = self.spans[0][0]
        end = max(address + len(payload) for address, payload in self.spans)
        image = bytearray([fill]) * (end - base)
        for address, payload in self.spans:
            image[address - base : address - base + len(payload)] = payload
        return base, bytes(image)

    def extract(self, directory: str | Path) -> tuple[Path, Path]:
        output = Path(directory)
        output.mkdir(parents=True, exist_ok=True)
        header_path = output / "header.bin"
        image_path = output / "int80386.bin"
        header_path.write_bytes(self.header)
        image_path.write_bytes(self.flatten()[1])
        return header_path, image_path

    def describe(self) -> dict[str, object]:
        major, minor, patch = self.version
        base, image = self.flatten()
        entry = self.entry_physical
        return {
            "path": str(self.path),
            "format": "nac",
            "size": len(self.data),
            "sha256": self.digest,
            "header_size": HEADER_SIZE,
            "product": self.product,
            "version": f"{major}.{minor}.{patch}",
            "stream_length": self.stream_length,
            "records": len(self.records),
            "data_records": len(self.data_records),
            "segment_records": sum(
                1 for record in self.records if record.kind == RECORD_EXTENDED_SEGMENT
            ),
            "load_base": base,
            "flattened_size": len(image),
            "painted_bytes": self.painted_bytes,
            "spans": [
                {"address": address, "size": len(payload)} for address, payload in self.spans
            ],
            "start_segment": (
                None
                if self.start_segment is None
                else f"{self.start_segment:04x}:{self.start_offset:04x}"
            ),
            "entry_physical": entry,
            "trailer_undecoded": self.trailer.hex(),
        }


def _paint(chunks: list[tuple[int, bytes]]) -> tuple[tuple[int, bytes], ...]:
    """Lay the data records out as the contiguous spans they cover.

    A NAC's records run in ascending, mostly contiguous order, so a record
    normally just extends the span being built and the whole stream is laid
    out in one pass. A record that writes behind a span already finished -
    which the format permits, since a later record overwrites an earlier one -
    gives up and paints the byte dictionary instead, which is far slower but
    does not care what order the records arrive in.
    """
    spans: list[tuple[int, bytearray]] = []
    start, run = -1, bytearray()
    for base, body in chunks:
        if base == start + len(run):
            run += body
            continue
        if start <= base < start + len(run):
            offset = base - start
            run[offset:offset + len(body)] = body
            continue
        if any(first <= base < first + len(payload) for first, payload in spans):
            painted: dict[int, int] = {}
            for chunk_base, chunk in chunks:
                for index, byte in enumerate(chunk):
                    painted[chunk_base + index] = byte
            return _coalesce(painted)
        if run:
            spans.append((start, run))
        start, run = base, bytearray(body)
    if run:
        spans.append((start, run))

    # Separately built spans can still meet, so join the ones that touch.
    joined: list[tuple[int, bytearray]] = []
    for first, payload in sorted(spans):
        if joined and first == joined[-1][0] + len(joined[-1][1]):
            joined[-1][1].extend(payload)
        else:
            joined.append((first, payload))
    return tuple((first, bytes(payload)) for first, payload in joined)


def _coalesce(painted: dict[int, int]) -> tuple[tuple[int, bytes], ...]:
    """Group painted bytes into contiguous (address, bytes) spans."""
    spans: list[tuple[int, bytes]] = []
    run = bytearray()
    start = None
    previous = None
    for address in sorted(painted):
        if previous is not None and address != previous + 1:
            spans.append((start, bytes(run)))
            run = bytearray()
            start = None
        if start is None:
            start = address
        run.append(painted[address])
        previous = address
    if start is not None:
        spans.append((start, bytes(run)))
    return tuple(spans)
