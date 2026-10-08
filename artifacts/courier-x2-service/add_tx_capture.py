from pathlib import Path
p=Path('/root/courier-x2-service/sip_modem.c')
s=p.read_text()
needle='''    if (me_tx_g711(port->tx_payload, (int)count) != (int)count)
        return PJ_EBUG;
'''
addition='''
    /* Diagnostic only: actual outgoing codewords, before RTP packing.
       Preserves every sample and never changes the payload. */
    {
        static FILE *capture;
        static int tried;
        if (!tried) {
            const char *path = getenv("COURIER_TX_AUDIO_CAPTURE");
            tried = 1;
            if (path && *path) capture = fopen(path, "wb");
        }
        if (capture) {
            fwrite(port->tx_payload, 1, count, capture);
            fflush(capture);
        }
    }
'''
if 'COURIER_TX_AUDIO_CAPTURE' not in s:
 if needle not in s: raise SystemExit('capture insertion point absent')
 p.write_text(s.replace(needle,needle+addition,1))
