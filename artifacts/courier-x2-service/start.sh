#!/bin/sh
set -eu
cd /root/courier-x2-service
for proc in /proc/[0-9]*; do
    [ "$(readlink "$proc/cwd" 2>/dev/null || true)" = "$PWD" ] || continue
    [ "$(cat "$proc/comm" 2>/dev/null || true)" = "sip_v90_modem" ] || continue
    kill "${proc##*/}"
done
# Wait for the old process to release its SIP socket before replacement.
for attempt in 1 2 3 4 5 6 7 8 9 10; do
    busy=0
    for proc in /proc/[0-9]*; do
        [ "$(readlink "$proc/cwd" 2>/dev/null || true)" = "$PWD" ] || continue
        [ "$(cat "$proc/comm" 2>/dev/null || true)" = "sip_v90_modem" ] || continue
        busy=1
    done
    [ "$busy" = 0 ] && break
    sleep 1
done
[ "$busy" = 0 ] || { echo "Previous service still running" >&2; exit 1; }
export COURIER_X2_ACTIVATE=1 ME_V42_T400_MS=5000 ME_JB_MS=40
export COURIER_TX_AUDIO_CAPTURE=/root/courier-x2-service/audio.tx.ulaw
export ME_G711_CAPTURE=/root/courier-x2-service/audio
export DS_RX_BIT_DUMP=/root/courier-x2-service/rx.bits
export DS_TX_BIT_DUMP=/root/courier-x2-service/tx.bits
exec ./sip_v90_modem --sip-server asterisk.net.cryan.nz --username 6012 \
    --password "$(cat sip-password)" --local-port 5072 --rtp-port 4072 \
    --mode v22-1200 --auto-answer 1 --pty-link /tmp/courier-x2-6012 \
    --verbose >> service.log 2>&1
