from pathlib import Path
import struct,json
from difflib import SequenceMatcher
root=Path(__file__).resolve().parents[2]
p=Path(__file__).resolve().parent
old_path=root/'artifacts/dsp-onchip-rom-20mhz-8k/c5x-onchip-rom-8k.bin'
a=struct.unpack('<8192H',old_path.read_bytes());b=struct.unpack('<4096H',(p/'dsp-mask-rom-0000-0fff.bin').read_bytes())
blocks=sorted(SequenceMatcher(None,a,b,autojunk=False).get_matching_blocks(),key=lambda m:m.size,reverse=True)
report={'older_rom':str(old_path),'old_words':len(a),'new_words':len(b),
 'same_address_matching_words_in_first_4096':sum(x==y for x,y in zip(a,b)),
 'vector_words_matching_in_first_48':sum(a[n]==b[n] for n in range(48)),
 'relocated_exact_blocks_ge_16_words':[{'old_start':f'{m.a:04X}','new_start':f'{m.b:04X}','words':m.size} for m in blocks if m.size>=16],
 'metric_limitation':'Address equality is not a code-relatedness percentage; ROM layout changed and tables/routines relocated.',
 'older_reset_target':'0670','new_reset_target':'0F46',
 'older_loader':'0610..0659; memory-mapped 0056 status and 0058..005F payload; alternate four-word groups/strobes 1 and 2, finish 4',
 'new_loader':'0F46..0F7C; I/O 8057 status and 8058..805B payload; one four-word window, acknowledge 0100, finish 0200',
 'mica_evidence':{'source':str(Path('/Users/scottcryan/MicaEmu/tools/mica_dsp_boot.py')),
  'part_from_board_notes':'TMS320LBC53SPZ, C53 family',
  'dsp_runtime_pmst':'003A (MP/MC=1)',
  'diagnostic_and_downloader_program_origin':'4000',
  'loader_host_registers':'0050..0052',
  'rom_contents_comparison':'Impossible without a physical MICA DSP ROM dump; no claim of binary compatibility.',
  'separate_missing_board_rom':'The MICA i960 board boot ROM is not in downloaded Portware and is unrelated to this TI DSP binary.'}}
(p/'rom-comparison.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps(report,indent=2))
