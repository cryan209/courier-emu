#!/usr/bin/env python3
"""Preflight the 3453C monitor candidate; --flash explicitly enables option 2."""
from pathlib import Path
import argparse, hashlib, json, struct, sys, time
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from courier_emu.xmodem_sdl import Port, frame
from tools.build_3453c_dsp_monitor import BASE_DIGEST, crc
ROOT=Path(__file__).resolve().parents[1]

def validate(candidate,backup):
    data=candidate.read_bytes();stock=backup.read_bytes()
    manifest=json.loads(candidate.with_name('manifest.json').read_text())
    if hashlib.sha256(stock).hexdigest()!=BASE_DIGEST:raise ValueError('backup is not the hardware-verified stock image')
    if len(data)!=0xb8000 or len(stock)!=len(data):raise ValueError('wrong firmware length')
    if hashlib.sha256(data).hexdigest()!=manifest['patched_sha256']:raise ValueError('candidate hash disagrees with manifest')
    if data[:0x200]!=stock[:0x200] or data[0x206:0x2f0]!=stock[0x206:0x2f0]:raise ValueError('image identity changed')
    if crc(data[:0x200])!=struct.unpack_from('<H',data,0x200)[0] or crc(data[0x206:])!=struct.unpack_from('<H',data,0x202)[0]:raise ValueError('invalid boot CRC')
    checks=manifest['verification']
    if not checks['header_and_payload_crc_valid'] or checks['dsp_cases_passed']<12 or checks['cpu_cases_passed']<10:raise ValueError('handler validation incomplete')
    return data,{'bytes':len(data),'sha256':manifest['patched_sha256'],'backup_sha256':BASE_DIGEST,
                 'handler_validation':checks,'full_boot_validated':False}

def text_until(port,needle,timeout=8):
    data=bytearray();end=time.monotonic()+timeout
    while time.monotonic()<end:
        byte=port.byte(.2)
        if byte is not None:data.append(byte)
        if needle in data:return bytes(data)
    raise TimeoutError(f'Expected {needle!r}, received {bytes(data)!r}')

def feedback(port,timeout=30):
    end=time.monotonic()+timeout
    while time.monotonic()<end:
        byte=port.byte(.2)
        if byte in (0x06,0x15,0x18,0x43):return byte
    raise TimeoutError('XMODEM acknowledgement timed out')

def upload(port,data,log):
    port.write(b'AT\r');text_until(port,b'\r\nOK')
    port.write(b'ATI7\r');identity=text_until(port,b'\r\nOK')
    if b'99345303' not in identity or b'2.3.33' not in identity or b'2.1.41' not in identity:raise ValueError('unexpected target modem')
    port.write(b'ATXMODEM\r');menu=text_until(port,b'>')
    if b'(2) Write firmware' not in menu:raise ValueError('expected updater menu missing')
    port.write(b'2');prompt=text_until(port,b'firmware update')
    log['identity']=identity.decode('ascii','replace');log['prompt']=prompt.decode('ascii','replace')
    first=feedback(port)
    if first not in (0x15,0x43):raise RuntimeError('unexpected initial handshake')
    use_crc=first==0x43;log['crc_mode']=use_crc
    # The stock receiver accepts 128-byte frames and groups eight into each
    # flash commit. This intentionally uses its original SOH path.
    log['blocks_acked']=0;log['retries']=0;last=time.monotonic()
    for offset in range(0,len(data),128):
        block=offset//128+1;packet=frame(block,data[offset:offset+128],use_crc)
        for attempt in range(10):
            port.write(packet);reply=feedback(port)
            if reply==0x06:break
            if reply==0x18:raise RuntimeError('modem cancelled upload')
            if reply not in (0x15,0x43):raise RuntimeError('unexpected frame acknowledgement')
            log['retries']+=1
        else:raise RuntimeError(f'block {block} rejected repeatedly')
        log['blocks_acked']=block
        if time.monotonic()-last>25:
            print(f'{offset+128:,}/{len(data):,} bytes acknowledged',flush=True);last=time.monotonic()
    for attempt in range(10):
        port.write(b'\x04');reply=feedback(port)
        if reply==0x06:break
        if reply==0x18:raise RuntimeError('modem cancelled completion')
    else:raise RuntimeError('EOT not acknowledged')
    completion=text_until(port,b'>',30)
    log['completion']=completion.decode('ascii','replace')
    if b'TRANSFER SUCCESSFUL' not in completion and b'TRANSFER SUCESSFUL' not in completion:raise RuntimeError('modem did not report successful transfer')
    log['transfer_successful']=True
    port.write(b'\x1b')
    for attempt in range(10):
        time.sleep(2);port.write(b'AT\r')
        try:text_until(port,b'\r\nOK',3);break
        except TimeoutError:continue
    else:raise RuntimeError('no AT response after reset; hardware recovery may be required')
    log['post_reset_at_ok']=True
    port.write(b'ATGU\r');display=text_until(port,b'\r\nOK')
    if b'DSPMON ' not in display:raise RuntimeError('patched monitor marker absent after reboot')
    log['monitor_marker']=display.decode('ascii','replace')

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--candidate',type=Path,default=ROOT/'artifacts/3453c-dsp-monitor-patch-20261003/2_3_33-dsp-monitor.candidate.xmf')
    p.add_argument('--backup',type=Path,default=ROOT/'artifacts/3453c-firmware-read-20261003/firmware.bin')
    p.add_argument('--device',default='/dev/cu.usbserial-FT4TQOFT');p.add_argument('--baud',type=int,default=19200)
    p.add_argument('--flash',action='store_true',help='erase/program application flash using option 2')
    p.add_argument('--log',type=Path)
    args=p.parse_args();data,log=validate(args.candidate,args.backup)
    if not args.flash:print(json.dumps(log,indent=2));return
    if args.log is None:p.error('--flash requires a new --log path')
    with args.log.open('x') as stream:
        try:
            with Port(args.device,args.baud) as port:
                try:upload(port,data,log)
                except BaseException:
                    # Leave the updater available; do not force a reset after
                    # an incomplete flash. CAN only cancels the transfer.
                    port.write(b'\x18\x18\x18');raise
        except BaseException as error:
            log['error']=f'{type(error).__name__}: {error}';raise
        finally:stream.write(json.dumps(log,indent=2)+'\n');stream.flush()
    print(json.dumps(log,indent=2))

if __name__=='__main__':main()
