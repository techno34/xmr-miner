#!/data/data/com.termux/files/usr/bin/bash

echo "Installing dependencies..."
pkg update -y && pkg upgrade -y
pkg install -y wget tar git proot

echo "Downloading XMRig for ARM64..."
wget https://github.com/xmrig/xmrig/releases/latest/download/xmrig-6.21.3-linux-arm64.tar.gz -O xmrig.tar.gz

echo "Extracting XMRig..."
tar -xvzf xmrig.tar.gz
cd xmrig-6.21.3

echo "Making xmrig executable..."
chmod +x xmrig

echo "Starting XMRig miner..."
./xmrig -a rx -o pool.supportxmr.com:3333 -u 45WrmXjfk8m3QvvoDBFPQjMoSCUc3zgFvaD5Bqmymxbb3fVmKmDoZwR4F1MPKZ8PA82qndPobuR5HUDjV1HJvXFAJUUuYPC -p x -k
