from __future__ import annotations

from pathlib import Path

from .nac import NacFormatError, NacImage
from .rom import CourierRom, RomFormatError
from .xmd import XmdFormatError, XmdImage
from .xmf import XmfFormatError, XmfImage
from .xmp import XmpFormatError, XmpImage


def load_image(path: str | Path) -> XmfImage | CourierRom | XmpImage | XmdImage | NacImage:
    """Load an XMF payload, a flash ROM, a whole-flash XMD, or an ISDN XMP or NAC.

    They are told apart by their own contents rather than by extension: an XMF
    starts with the Courier text header, a ROM ends with the 80186 reset vector,
    an XMP starts with its own magic and carries an obfuscated body, an XMD is
    0x80080 bytes and decodes to an image ending in the 80186 reset stub, and a
    NAC declares its record-stream length in its header.
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
                    return XmdImage.load(path)
                except XmdFormatError as xmd_error:
                    try:
                        return NacImage.load(path)
                    except NacFormatError as nac_error:
                        raise XmfFormatError(
                            f"{Path(path).name} is not a Courier XMF ({xmf_error}), "
                            f"ROM ({rom_error}), XMP ({xmp_error}), "
                            f"XMD ({xmd_error}), or NAC ({nac_error})"
                        ) from nac_error
