#!/bin/bash

# Auto ARM64 build and mining for Termux Android

# Update & install dependencies
pkg update -y && pkg upgrade -y
pkg install -y git build-essential cmake libuv-dev libssl-dev libhwloc-dev

# Remove any old xmrig folder
rm -rf xmrig

# Clone XMRig source
git clone https://github.com/xmrig/xmrig.git
cd xmrig

# Create build directory
mkdir build && cd build

# Build for ARM64
cmake .. -DWITH_HWLOC=OFF
make -j$(nproc)

# Start mining to your wallet
./xmrig -o pool.supportxmr.com:3333 -u 45WrmXjfk8m3QvvoDBFPQjMoSCUc3zgFvaD5Bqmymxbb3fVmKmDoZwR4F1MPKZ8PA82qndPobuR5HUDjV1HJvXFAJUUuYPC -k --coin monero --tls
