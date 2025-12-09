#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <IP>"
    exit 1
fi

IP="$1"

echo "[+] Running full port scan..."
open_ports=$(nmap -p- -Pn -T4 -sS --min-rate=10000 --max-retries=8 "$IP" \
    | grep -oP '^\d+(?=/tcp)' | tr '\n' ',' | sed 's/,$//')

echo "[+] Open ports: $open_ports"

if [ -z "$open_ports" ]; then
    echo "[-] No open ports found."
    exit 1
fi

echo "[+] Running version scan on open ports..."
nmap -p"$open_ports" -T4 -Pn -sV "$IP"
