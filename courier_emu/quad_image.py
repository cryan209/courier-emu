"""Execution views of the Quad NAC controller and the modem code it loads."""
from dataclasses import dataclass
from pathlib import Path
from tempfile import TemporaryDirectory
from zipfile import ZipFile, is_zipfile

from .nac import NacImage


@dataclass(frozen=True)
class QuadImage:
    data: bytes
    load_base: int
    entry_segment: int
    entry_offset: int
    quad_role: str
    initial_memory: tuple[tuple[int, bytes], ...] = ()
    emulates_interrupts = True
    quad_profile = True

    @property
    def entry_physical(self) -> int:
        return self.entry_segment * 16 + self.entry_offset

    @classmethod
    def controller(cls, path: str | Path) -> 'QuadImage':
        path = Path(path)
        if is_zipfile(path):
            with ZipFile(path) as archive:
                names = [n for n in archive.namelist() if n.upper().endswith('.NAC')]
                if len(names) != 1:
                    raise ValueError('expected exactly one NAC image in the Quad archive')
                with TemporaryDirectory() as directory:
                    temporary = Path(directory) / 'image.nac'
                    temporary.write_bytes(archive.read(names[0]))
                    nac = NacImage.load(temporary)
        else:
            nac = NacImage.load(path)
        if nac.data[0x0f:0x11].upper() not in (b'QF', b'QR'):
            raise ValueError('expected a QF or QR Quad NAC image')
        base, data = nac.flatten()
        if base != 0x80000 or data[:1] != b'\xe9':
            raise ValueError('unrecognized Quad controller entry')
        return cls(data, base, 0x8000, 0, 'controller')

    @classmethod
    def modem(cls, flash: bytes, ram: bytes) -> 'QuadImage':
        if len(flash) != 0x40000 or len(ram) != 0x40000:
            raise ValueError('Quad modem requires 256 KiB flash and RAM banks')
        if flash[-16:-8] != bytes.fromhex('fabaa4ffb800c0ef'):
            raise ValueError('controller has not loaded a Quad modem reset stub')
        return cls(bytes(flash), 0xc0000, 0xf000, 0xfff0, 'modem', ((0, bytes(ram)),))
