"""Checks execute emitted DSP/80186 instructions against the verified board image."""
from pathlib import Path
import importlib.util
import json
import struct
import pytest
from courier_emu.xmf import XmfImage

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('monitor_builder',ROOT/'tools/build_3453c_dsp_monitor.py')
builder=importlib.util.module_from_spec(spec)
spec.loader.exec_module(builder)

@pytest.fixture(scope='module')
def built(tmp_path_factory):
    out=tmp_path_factory.mktemp('3453c-monitor')
    builder.build(ROOT/'2_3_33.XMF',out)
    return out

def test_machine_code_and_download_metadata(built):
    report=json.loads((built/'manifest.json').read_text())
    assert report['verification']['dsp_cases_passed']==18
    assert report['verification']['cpu_cases_passed']==20
    original=XmfImage.load(ROOT/'2_3_33.XMF')
    patched=XmfImage.load(built/'2_3_33-dsp-monitor.candidate.xmf')
    old=original.dsp_segments();new=patched.dsp_segments()
    assert len(new)==len(old)==4
    assert patched.data[new[1].file_offset:new[1].end]==original.data[old[1].file_offset:old[1].end]
    assert new[1].origin==old[1].origin and new[1].words==old[1].words
    assert new[0].words%4==0
    for segment in new[1:]:assert segment.origin+segment.words<=builder.MONITOR

def test_boot_crc_matches_hardware_image_and_candidate(built):
    for path in [ROOT/'2_3_33.XMF',built/'2_3_33-dsp-monitor.candidate.xmf']:
        data=path.read_bytes()
        assert builder.crc(data[:0x200])==struct.unpack_from('<H',data,0x200)[0]
        assert builder.crc(data[0x206:])==struct.unpack_from('<H',data,0x202)[0]
    corrupt=bytearray((built/'2_3_33-dsp-monitor.candidate.xmf').read_bytes());corrupt[0x870]^=1
    assert builder.crc(corrupt[0x206:])!=struct.unpack_from('<H',corrupt,0x202)[0]

def test_builder_refuses_another_image(tmp_path):
    source=tmp_path/'other.xmf';data=bytearray((ROOT/'2_3_33.XMF').read_bytes());data[0x900]^=1;source.write_bytes(data)
    with pytest.raises(ValueError,match='verified stock'):builder.build(source,tmp_path/'out')
    assert not (tmp_path/'out').exists()
