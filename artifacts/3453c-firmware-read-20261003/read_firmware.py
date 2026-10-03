"""Receive firmware from ATXMODEM option 1; never selects write/update."""
from pathlib import Path
import hashlib, json, sys, time
sys.path.insert(0,str(Path(__file__).resolve().parents[2]))
from courier_emu.xmodem_sdl import Port, crc16
OUT=Path(__file__).resolve().parent
DEVICE='/dev/cu.usbserial-FT4TQOFT'

def text_until(port, needle, timeout=8):
    data=bytearray(); end=time.monotonic()+timeout
    while time.monotonic()<end:
        byte=port.byte(.2)
        if byte is not None:
            data.append(byte)
            if needle in data: return bytes(data)
    raise TimeoutError(f'Expected {needle!r}; received {bytes(data)!r}')

def exact(port,count):
    data=bytearray()
    for _ in range(count):
        byte=port.byte(3)
        if byte is None: raise TimeoutError('Incomplete XMODEM frame')
        data.append(byte)
    return bytes(data)

with Port(DEVICE,19200) as port:
    if '--resume' not in sys.argv:
        port.write(b'AT\r'); banner=text_until(port,b'OK')
        port.write(b'ATI7\r'); identity=text_until(port,b'OK')
        (OUT/'identity.txt').write_bytes(identity)
        if b'2.3.33' not in identity: raise RuntimeError('Unexpected firmware identity')
        port.write(b'ATXMODEM\r'); menu=text_until(port,b'>')
        (OUT/'menu.txt').write_bytes(menu)
        if b'(1) Read firmware' not in menu: raise RuntimeError('Read firmware menu absent')
        port.write(b'1'); begin=text_until(port,b'receiver')
        (OUT/'begin.txt').write_bytes(begin)
    print('Option 1 selected; receiving XMODEM firmware.',flush=True)
    expected=1; blocks=0; retries=0; wire=bytearray(); last_report=time.monotonic(); payload=bytearray()
    port.write(b'C')
    try:
        while True:
            start=port.byte(10)
            if start is None:
                retries+=1
                if retries>10: raise TimeoutError('XMODEM sender stopped')
                port.write(b'C' if blocks==0 else b'\x15'); continue
            # Skip leftover prompt CR/LF before first frame.
            if start in (10,13,32) and blocks==0: continue
            if start==4:
                wire.append(start);port.write(b'\x06');break
            if start==24: raise RuntimeError('Sender cancelled transfer')
            if start not in (1,2):
                if blocks==0: continue
                raise RuntimeError(f'Unexpected XMODEM byte {start:02x}')
            size=128 if start==1 else 1024
            frame=exact(port,2+size+2);wire.append(start);wire.extend(frame)
            number,inverse=frame[:2];data=frame[2:2+size]
            valid=(number^inverse)==255 and crc16(data)==int.from_bytes(frame[-2:],'big')
            if not valid:
                retries+=1
                if retries>20: raise RuntimeError('Too many invalid frames')
                port.write(b'\x15'); continue
            if number==((expected-1)&255) and blocks:
                port.write(b'\x06');continue
            if number!=(expected&255): raise RuntimeError(f'Unexpected block {number}, expected {expected&255}')
            payload.extend(data);expected+=1;blocks+=1;port.write(b'\x06')
            if len(payload)>0x110000: raise RuntimeError('Transfer exceeds flash capacity')
            if time.monotonic()-last_report>25:
                print(f'Received {len(payload):,} bytes in {blocks} blocks.',flush=True);last_report=time.monotonic()
        (OUT/'firmware.bin').write_bytes(payload)
        (OUT/'xmodem-frames.bin').write_bytes(wire)
        report={'device':DEVICE,'baud':19200,'bytes':len(payload),'blocks':blocks,'retries':retries,
                'sha256':hashlib.sha256(payload).hexdigest(),'integrity':'Every accepted block passed CRC16 and sequence checks; EOT acknowledged.'}
        reference=(OUT.parents[1]/'2_3_33.XMF').read_bytes()
        report['reference_bytes']=len(reference)
        report['exact_xmf_match']=payload==reference
        report['reference_offset_in_capture']=payload.find(reference)
        (OUT/'result.json').write_text(json.dumps(report,indent=2)+'\n')
        print(json.dumps(report),flush=True)
    except BaseException:
        port.write(b'\x18\x18\x18');(OUT/'partial.bin').write_bytes(payload);(OUT/'xmodem-frames.bin').write_bytes(wire)
        raise
    # Sender returns asynchronously to the firmware menu before ESC is accepted.
    completion=text_until(port,b'>',10)
    (OUT/'completion.txt').write_bytes(completion)
    port.write(b'\x1b')
    after=bytearray()
    for attempt in range(8):
        time.sleep(2)
        port.write(b'AT\r')
        try:
            after.extend(text_until(port,b'OK',4))
            break
        except TimeoutError:
            continue
    else:
        raise RuntimeError('No AT acknowledgement after menu exit reset')
    (OUT/'after.txt').write_bytes(after)
    print('Modem responds to AT after transfer.',flush=True)
