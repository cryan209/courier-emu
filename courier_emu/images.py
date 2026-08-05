from __future__ import annotations

from pathlib import Path

from .rom import CourierRom, RomFormatError
from .xmf import XmfFormatError, XmfImage


def load_image(path: str | Path) -> XmfImage | CourierRom:
    """Load either an XMF update payload or a complete flash ROM.

    The two are told apart by their own contents rather than by extension: an
    XMF starts with the Courier text header, and a ROM ends with the 80186
    reset vector.
    """
    try:
        return XmfImage.load(path)
    except XmfFormatError as xmf_error:
        try:
            return CourierRom.load(path)
        except RomFormatError as rom_error:
            raise XmfFormatError(
                f"{Path(path).name} is neither a Courier XMF ({xmf_error}) "
                f"nor a Courier ROM ({rom_error})"
            ) from rom_error
