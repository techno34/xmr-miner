#!/bin/bash
clear
echo "=============================="
echo "🚀 XMR Mining Setup Starting..."
echo "=============================="

# Update packages
pkg update -y && pkg upgrade -y
pkg install wget tar -y

# Check architecture
ARCH=$(uname -m)
echo "Detected architecture: $ARCH"

# Install dependencies
pkg install git build-essential cmake libuv-dev libssl-dev libhwloc-dev -y

# Download ARM64 prebuilt binary if device is ARM64
if [[ "$ARCH" == "aarch64" ]]; then
    echo "Downloading prebuilt XMRig for ARM64..."
    wget https://github.com/xmrig/xmrig/releases/latest/download/xmrig-android-aarch64.tar.gz -O xmrig.tar.gz
    tar -xvzf xmrig.tar.gz
    cd xmrig-android-aarch64
else
    echo "Architecture not ARM64, compiling from source..."
    git clone https://github.com/xmrig/xmrig.git
    cd xmrig
    mkdir build && cd build
    cmake ..
    make -j$(nproc)
fi

# Create config.json
cat > config.json <<EOL
{
    "autosave": true,
    "cpu": true,
    "opencl": false,
    "cuda": false,
    "pools": [
        {
            "url": "pool.supportxmr.com:3333",
            "user": "45WrmXjfk8m3QvvoDBFPQjMoSCUc3zgFvaD5Bqmymxbb3fVmKmDoZwR4F1MPKZ8PA82qndPobuR5HUDjV1HJvXFAJUUuYPC",
            "pass": "x",
            "keepalive": true,
            "tls": false
        }
    ]
}
EOL

# Start mining
echo "Starting miner..."
./xmrig
