"""Range captures preserve address ordering and never accept stale replies."""
from pathlib import Path
import hashlib
import importlib.util
import json
import pytest

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('monitor_host',ROOT/'tools/3453c_monitor.py')
host=importlib.util.module_from_spec(spec);spec.loader.exec_module(host)

class Words:
    def __init__(self,fail=None):self.requests=[];self.fail=fail
    def request(self,tag,address):
        self.requests.append((tag,address))
        if address==self.fail:raise TimeoutError('no fresh reply')
        return {0x100:0x1234,0x101:0xabcd,0x102:0x00ff}.get(address,address)

def test_inclusive_range_binary_and_metadata(tmp_path):
    monitor=Words();out=tmp_path/'data.bin';progress=[]
    report=host.dump_range(monitor,'data',0x100,0x102,out,lambda *args:progress.append(args))
    assert monitor.requests==[(0x89,0x100),(0x89,0x101),(0x89,0x102)]
    assert out.read_bytes()==b'\x34\x12\xcd\xab\xff\x00'
    assert report['complete'] and report['completed_words']==3 and report['bytes']==6
    assert report['sha256']==hashlib.sha256(out.read_bytes()).hexdigest()
    assert json.loads((tmp_path/'data.bin.json').read_text())==report
    assert progress[-1]==(3,3,0x102)
    assert not (tmp_path/'data.bin.partial').exists()

def test_program_upper_endpoint(tmp_path):
    monitor=Words();out=tmp_path/'program.bin'
    host.dump_range(monitor,'program',0x7ffe,0x7fff,out)
    assert monitor.requests==[(0x8a,0x7ffe),(0x8a,0x7fff)]
    assert out.read_bytes()==b'\xfe\x7f\xff\x7f'

def test_failure_preserves_partial_and_marks_incomplete(tmp_path):
    out=tmp_path/'data.bin'
    with pytest.raises(TimeoutError):host.dump_range(Words(fail=0x101),'data',0x100,0x102,out)
    assert not out.exists()
    assert (tmp_path/'data.bin.partial').read_bytes()==b'\x34\x12'
    report=json.loads((tmp_path/'data.bin.partial.json').read_text())
    assert not report['complete'] and report['completed_words']==1
    assert report['error'].startswith('TimeoutError')

@pytest.mark.parametrize('space,start,end',[('data',0xff,0x100),('data',0x100,0x400),('program',0,0x8000),('program',2,1),('other',0,1)])
def test_reject_invalid_range_before_any_request(tmp_path,space,start,end):
    monitor=Words()
    with pytest.raises(ValueError):host.dump_range(monitor,space,start,end,tmp_path/'dump.bin')
    assert monitor.requests==[] and list(tmp_path.iterdir())==[]

@pytest.mark.parametrize('suffix',['','.json','.partial','.partial.json'])
def test_existing_capture_is_not_overwritten(tmp_path,suffix):
    out=tmp_path/'dump.bin';existing=Path(str(out)+suffix);existing.write_bytes(b'keep')
    monitor=Words()
    with pytest.raises(FileExistsError):host.dump_range(monitor,'program',0,1,out)
    assert existing.read_bytes()==b'keep' and monitor.requests==[]

def test_request_waits_for_fresh_reply_and_accepts_sequence_wrap(monkeypatch):
    monitor=host.Monitor(None);commands=[]
    replies=iter([b'DSPMON 0071 1111 FFFF',b'OK',b'DSPMON 0071 1111 FFFF',b'DSPMON 0071 BEEF 0000'])
    def command(text,timeout=3):commands.append(text);return next(replies)
    monitor.command=command;monkeypatch.setattr(host.time,'sleep',lambda _:None)
    assert monitor.request(0x89,0x123)==0xbeef
    assert commands==['ATGU','ATG00890123','ATGU','ATGU']

def test_stock_firmware_stops_before_dsp_request():
    monitor=host.Monitor(None);commands=[]
    def command(text,timeout=3):commands.append(text);return b'\r\nOK\r\n'
    monitor.command=command
    with pytest.raises(RuntimeError,match='not installed'):monitor.request(0x8a,0)
    assert commands==['ATGU']

def test_cli_rejects_invalid_range_before_opening_serial(monkeypatch,tmp_path):
    def port(*args):raise AssertionError('serial port should not open')
    monkeypatch.setattr(host,'Port',port)
    with pytest.raises(SystemExit) as error:host.main(['dump','program','0000','8000','--output',str(tmp_path/'dump.bin')])
    assert error.value.code==2

@pytest.mark.parametrize('reply,accepted',[(b'\r\nDSPMON 0071 BEEF 000A\r\n\r\nERROR\r\n',True),(b'\r\nERROR\r\n',False)])
def test_hardware_query_error_only_accepted_with_cache_record(reply,accepted):
    class Port:
        def __init__(self):self.pending=bytearray(reply)
        def write(self,data):assert data==b'ATGU\r'
        def byte(self,timeout):return self.pending.pop(0) if self.pending else None
    monitor=host.Monitor(Port())
    if accepted:assert monitor.cached()==(0x71,0xbeef,10)
    else:
        with pytest.raises(RuntimeError,match='ERROR'):monitor.cached()

class StreamPort:
    def __init__(self,reply):self.reply=iter(reply);self.writes=[]
    def write(self,data):self.writes.append(data)
    def byte(self,timeout):return next(self.reply,None)

def test_fast_stream_checks_framing_and_byte_order(tmp_path):
    port=StreamPort(b'ATGD00000001\r\r\nDSPDUMP 1234ABCD\r\nDSPEND\r\n\r\nOK\r\n')
    out=tmp_path/'stream.bin'
    report=host.dump_range(host.Monitor(port),'program',0,1,out,fast=True)
    assert out.read_bytes()==b'\x34\x12\xcd\xab'
    assert port.writes==[b'ATGD00000001\r'] and report['complete']

@pytest.mark.parametrize('tail',[b'\r\nERROR\r\n',b'\r\nBADEND\r\n\r\nOK\r\n'])
def test_fast_stream_bad_completion_preserves_partial(tmp_path,tail):
    port=StreamPort(b'DSPDUMP 1234ABCD'+tail);out=tmp_path/'stream.bin'
    with pytest.raises(RuntimeError):host.dump_range(host.Monitor(port),'program',0,1,out,fast=True)
    assert not out.exists() and Path(str(out)+'.partial').read_bytes()==b'\x34\x12\xcd\xab'

def test_rom_stream_uses_separate_selector(tmp_path):
    port=StreamPort(b'DSPDUMP 79800670\r\nDSPEND\r\n\r\nOK\r\n')
    out=tmp_path/'rom.bin'
    report=host.dump_range(host.Monitor(port),'rom',0,1,out,fast=True)
    assert port.writes==[b'ATGE00000001\r']
    assert out.read_bytes()==b'\x80\x79\x70\x06' and report['transport']=='ATGE ROM stream'

def test_rom_window_bound_rejected_before_request(tmp_path):
    port=StreamPort(b'');out=tmp_path/'rom.bin'
    with pytest.raises(ValueError):host.dump_range(host.Monitor(port),'rom',0,0x2000,out,fast=True)
    assert not port.writes and not list(tmp_path.iterdir())
