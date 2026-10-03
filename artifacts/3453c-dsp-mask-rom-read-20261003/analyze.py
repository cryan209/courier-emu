"""Verify repeated mapped windows and extract the measured 4K-word mask ROM."""
from pathlib import Path
import hashlib,json,struct,sys
ROOT=Path(__file__).resolve().parents[2];sys.path.insert(0,str(ROOT))
from courier_emu.xmf import XmfImage
from tools.c5x_disasm import disassemble
p=Path(__file__).resolve().parent
first=(p/'mapped-window-0000-1fff-read1.bin').read_bytes()
second=(p/'mapped-window-0000-1fff-read2.bin').read_bytes()
assert len(first)==16384 and first==second
previous=(ROOT/'artifacts/3453c-dsp-memory-read-20261003/dsp-program-fast-0000-7fff.bin').read_bytes()
assert first[8192:]==previous[8192:16384]
firmware=XmfImage.load(ROOT/'artifacts/3453c-dsp-rom-patch-20261003/2_3_33-dsp-monitor.candidate.xmf')
resident=firmware.dsp_segments()[0]
assert resident.origin==0x1000
assert first[8192:]==firmware.data[resident.file_offset:resident.file_offset+8192]
rom=first[:8192];words=list(struct.unpack('<4096H',rom));external=struct.unpack('<4096H',previous[:8192])
differences=sum(a!=b for a,b in zip(words,external));assert differences>4000
assert words[:2]==[0x7980,0x0f46]
verify=json.loads((p/'window-verification.json').read_text())
assert verify['pmst_before']==verify['pmst_after']=='18B8' and verify['post_capture_identification']=='D541'
rom_path=p/'dsp-mask-rom-0000-0fff.bin'
with rom_path.open('xb') as stream:stream.write(rom)
report={'source':'USRobotics 3453C, product 99345303, TI 16.0036.00 D172B1PJ92',
 'installed_firmware_sha256':firmware.digest,'program_start_word':'0000','program_end_word':'0FFF',
 'words':4096,'bytes':8192,'byte_order':'little-endian','sha256':hashlib.sha256(rom).hexdigest(),
 'repeated_window_sha256':hashlib.sha256(first).hexdigest(),'independent_reads_identical':True,
 'different_words_from_unmapped_low_program':differences,
 'upper_window_1000_1fff_matches_downloaded_resident':True,
 'pmst_before':'18B8','pmst_after':'18B8','mapping_and_monitor_restored':True,
 'reset_branch':'0000: B 0F46','boot_io_references':{f'{port:04X}':[f'{n:04X}' for n,w in enumerate(words) if w==port] for port in (0x8057,0x8058)},
 'rom_protection_observation':'External monitor obtained a repeatable, coherent mapped ROM image; protection did not block this read route.'}
(p/'manifest.json').write_text(json.dumps(report,indent=2)+'\n')
program=words+[0]*(65536-len(words))
lines=[f'{i.pc:04X}: {" ".join(f"{v:04X}" for v in i.words):12} {i.text}' for i in disassemble(program,0,0x1000)]
(p/'mask-rom-linear.asm').write_text('; Linear disassembly includes tables/constants; not every word is executable.\n'+'\n'.join(lines)+'\n')
boot=[f'{i.pc:04X}: {" ".join(f"{v:04X}" for v in i.words):12} {i.text}' for i in disassemble(program,0xf46,0xf80)]
(p/'boot-loader.asm').write_text('\n'.join(boot)+'\n')
(p/'README.md').write_text('# Recovered 3453C DSP mask ROM\n\n`dsp-mask-rom-0000-0fff.bin` contains **4,096 words / 8,192 bytes**, little-endian, at DSP program addresses **0000..0FFF**.\n\nSHA256: `'+report['sha256']+'`.\n\nTwo independently requested 0000..1FFF mapped windows matched exactly. Their upper half, 1000..1FFF, matches the patched resident downloaded from flash, including the monitor dispatcher hook, establishing that this upper region remains external RAM. The lower 4K words differ from unmapped program RAM at 4,090 of 4,096 positions and contain a coherent vector table beginning with `B 0F46`. Boot code at 0F46 uses I/O 8057/8058, matching the 3453 board’s first-download protocol.\n\nLive PMST was **18B8 before and after** each capture. The monitor returned D541 afterward. Each individual ROM read masked interrupts, temporarily cleared only PMST.MP/MC, read one word, and restored mapping and status before replying. The revision remains installed.\n\nThe observed image supports a 4K-word ROM compatible with the suspected C52-class part; this is not a broader confirmation of the exact die model. The older 302/403-board ROM is a different image.\n\n`manifest.json`, `sample-verification.json`, and `window-verification.json` preserve provenance and checks. `boot-loader.asm` is the bootstrap excerpt; `mask-rom-linear.asm` is a linear decoding that also includes tables/constants.\n')
print(json.dumps(report,indent=2));print('\n'.join(boot))
