#!/data/data/com.termux/files/usr/bin/bash
set -e

WALLET="45WrmXjfk8m3QvvoDBFPQjMoSCUc3zgFvaD5Bqmymxbb3fVmKmDoZwR4F1MPKZ8PA82qndPobuR5HUDjV1HJvXFAJUUuYPC"
POOL="pool.supportxmr.com:3333"

echo "1. Installing dependencies..."
pkg update -y || true
pkg install -y wget tar proot

echo "2. Downloading XMRig (linux-arm64)..."
wget -O xmrig.tar.gz \
https://github.com/xmrig/xmrig/releases/download/v6.23.0/xmrig-6.23.0-linux-arm64.tar.gz

echo "3. Extracting..."
tar -xzf xmrig.tar.gz
cd xmrig-*

echo "4. Running miner..."
./xmrig -o "$POOL" -u "$WALLET" -p x -k
