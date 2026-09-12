"""A SIP endpoint that answers a call and records the RTP it is sent.

The smallest far end that lets `--bri-sip` be run end to end: it answers any
INVITE with 200 OK and an SDP pointing at its own RTP port, then writes every
payload octet it receives to a file. It is a test fixture, not a softphone -
it sends no audio of its own and speaks no authentication.

    .venv/bin/python tools/sip_answer_sink.py answer.g711 150

    .venv/bin/python -m courier_emu isdn-run Ie030002.nac --with-dsp \
        --bri-network --bri-establish terminal --bri-call-at 20000000 \
        --bri-call-to 7349195 --bri-bearer audio \
        --bri-sip 127.0.0.1:5060 --bri-sip-target 5551234 \
        --send ATA --send-after 30000000

leaves the modem's answer tone in answer.g711, as mu-law at 8 kHz.
"""
import re, socket, sys, time

sip = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sip.bind(("127.0.0.1", 5060)); sip.settimeout(0.2)
rtp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
rtp.bind(("127.0.0.1", 0)); rtp.settimeout(0.2)
rtp_port = rtp.getsockname()[1]
out = open(sys.argv[1], "wb")
deadline = time.time() + float(sys.argv[2])
packets = 0
print(f"sip sink on 5060, rtp on {rtp_port}", flush=True)
while time.time() < deadline:
    try:
        data, source = sip.recvfrom(65535)
    except socket.timeout:
        data = None
    if data and data.startswith(b"INVITE"):
        text = data.decode("latin-1")
        head = {}
        for line in text.split("\r\n"):
            if ":" in line:
                k, v = line.split(":", 1)
                head.setdefault(k.strip().lower(), v.strip())
        body = (f"v=0\r\no=- 1 1 IN IP4 127.0.0.1\r\ns=-\r\n"
                f"c=IN IP4 127.0.0.1\r\nt=0 0\r\n"
                f"m=audio {rtp_port} RTP/AVP 0\r\na=rtpmap:0 PCMU/8000\r\n")
        resp = ("SIP/2.0 200 OK\r\n"
                f"Via: {head.get('via','')}\r\n"
                f"From: {head.get('from','')}\r\n"
                f"To: {head.get('to','')};tag=sink\r\n"
                f"Call-ID: {head.get('call-id','')}\r\n"
                f"CSeq: {head.get('cseq','')}\r\n"
                f"Contact: <sip:sink@127.0.0.1:5060>\r\n"
                "Content-Type: application/sdp\r\n"
                f"Content-Length: {len(body)}\r\n\r\n{body}")
        sip.sendto(resp.encode(), source)
        print("answered INVITE", flush=True)
    try:
        packet, _ = rtp.recvfrom(2048)
        out.write(packet[12:]); packets += 1
    except socket.timeout:
        pass
out.close()
print(f"rtp packets received: {packets}", flush=True)
