"""Exercise the uploader against a simulated modem; no serial device is opened."""
from pathlib import Path
import importlib.util
import pytest

ROOT=Path(__file__).resolve().parents[1]
spec=importlib.util.spec_from_file_location('monitor_flash',ROOT/'tools/flash_3453c_monitor.py')
flash=importlib.util.module_from_spec(spec);spec.loader.exec_module(flash)

class Receiver:
    def __init__(self,bad_identity=False):self.pending=bytearray();self.received=bytearray();self.commands=[];self.block=1;self.bad_identity=bad_identity
    def write(self,data):
        if data[:1]==b'\x01':
            assert len(data)==132
            assert data[1]==(self.block&255) and data[1]^data[2]==255
            assert sum(data[3:131])&255==data[131]
            self.received.extend(data[3:131]);self.block+=1;self.pending.extend(b'\x06');return
        self.commands.append(data)
        if data==b'AT\r':self.pending.extend(b'\r\nOK\r\n')
        elif data==b'ATI7\r':self.pending.extend(b'\r\n'+(b'wrong modem' if self.bad_identity else b'99345303 2.3.33 2.1.41')+b'\r\nOK\r\n')
        elif data==b'ATXMODEM\r':self.pending.extend(b'\r\n(1) Read firmware\r\n(2) Write firmware\r\n>')
        elif data==b'2':self.pending.extend(b'\r\nReady to receive firmware update\r\n\x15')
        elif data==b'\x04':self.pending.extend(b'\x06\r\n*TRANSFER SUCESSFUL*\r\n>')
        elif data==b'\x1b':pass
        elif data==b'ATGU\r':self.pending.extend(b'\r\nDSPMON 0000 0000 0000\r\nOK\r\n')
        else:raise AssertionError(f'unexpected command {data!r}')
    def byte(self,timeout):
        if not self.pending:return None
        value=self.pending[0];del self.pending[0];return value

def test_complete_transfer_and_reset_verification(monkeypatch):
    monkeypatch.setattr(flash.time,'sleep',lambda _:None)
    data=bytes(range(256))*2944 # Exact application image transfer length.
    receiver=Receiver();report={};flash.upload(receiver,data,report)
    assert receiver.received==data
    assert report['blocks_acked']==5888 and report['retries']==0
    assert report['transfer_successful'] and report['post_reset_at_ok']
    assert receiver.commands.index(b'2')<receiver.commands.index(b'\x04')<receiver.commands.index(b'ATGU\r')

def test_wrong_modem_never_enters_updater():
    receiver=Receiver(bad_identity=True)
    with pytest.raises(ValueError,match='unexpected target'):flash.upload(receiver,b'\0'*128,{})
    assert b'ATXMODEM\r' not in receiver.commands and receiver.received==b''
