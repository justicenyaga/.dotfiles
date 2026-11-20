#!/bin/bash

iface=$(ip route get 1.1.1.1 2>/dev/null | grep -oP 'dev \K\S+')

if [ -z "$iface" ]; then
    echo ""
    exit
fi

STATE_FILE="/tmp/waybar-net-$iface"

stats=$(awk "/^\s*${iface}:/{print \$2, \$10}" /proc/net/dev)
rx=$(echo "$stats" | cut -d' ' -f1)
tx=$(echo "$stats" | cut -d' ' -f2)
now=$(date +%s%N)

fmt() {
    local b=$1
    awk -v b="$b" 'BEGIN {
        if (b >= 1073741824)      printf "%.1f GB/s", b/1073741824
        else if (b >= 1048576)    printf "%.1f MB/s", b/1048576
        else if (b >= 1024)       printf "%.1f KB/s", b/1024
        else                      printf "%d B/s", b
    }'
}

if [ -f "$STATE_FILE" ]; then
    IFS=' ' read -r prev_rx prev_tx prev_time < "$STATE_FILE"
    elapsed_ns=$(( now - prev_time ))
    if [ "$elapsed_ns" -gt 0 ]; then
        rx_rate=$(( (rx - prev_rx) * 1000000000 / elapsed_ns ))
        tx_rate=$(( (tx - prev_tx) * 1000000000 / elapsed_ns ))
        if [ "$tx_rate" -gt "$rx_rate" ]; then
            printf '{"text": "%s", "alt": "upload"}\n' "$(fmt $tx_rate)"
        else
            printf '{"text": "%s", "alt": "download"}\n' "$(fmt $rx_rate)"
        fi
    fi
fi

echo "$rx $tx $now" > "$STATE_FILE"
