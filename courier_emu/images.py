from __future__ import annotations

from pathlib import Path

from .nac import NacFormatError, NacImage
from .rom import CourierRom, RomFormatError
from .xmf import XmfFormatError, XmfImage
from .xmp import XmpFormatError, XmpImage


def load_image(path: str | Path) -> XmfImage | CourierRom | XmpImage | NacImage:
    """Load an XMF payload, a flash ROM, or an ISDN XMP or NAC.

    They are told apart by their own contents rather than by extension: an XMF
    starts with the Courier text header, a ROM ends with the 80186 reset vector,
    an XMP starts with its own magic and carries an obfuscated body, and a NAC
    declares its record-stream length in its header.
    """
    try:
        return XmfImage.load(path)
    except XmfFormatError as xmf_error:
        try:
            return CourierRom.load(path)
        except RomFormatError as rom_error:
            try:
                return XmpImage.load(path)
            except XmpFormatError as xmp_error:
                try:
                    return NacImage.load(path)
                except NacFormatError as nac_error:
                    raise XmfFormatError(
                        f"{Path(path).name} is not a Courier XMF ({xmf_error}), "
                        f"ROM ({rom_error}), XMP ({xmp_error}), or NAC ({nac_error})"
                    ) from nac_error
