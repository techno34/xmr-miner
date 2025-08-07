#!/data/data/com.termux/files/usr/bin/bash

# --- XMRig Auto Installer for Android Termux (ARM64) ---

# --- Install dependencies ---
pkg update -y && pkg upgrade -y
pkg install -y wget proot tar git libtalloc libuuid

# --- Download latest XMRig ARM64 ---
echo "🔁 Fetching latest XMRig release URL..."
LATEST_URL=$(curl -s https://api.github.com/repos/xmrig/xmrig/releases/latest | grep browser_download_url | grep 'linux-arm64.tar.gz' | cut -d '"' -f 4)

echo "🌐 Downloading XMRig from:"
echo "$LATEST_URL"
wget -O xmrig.tar.gz "$LATEST_URL"

# --- Extract XMRig ---
echo "📦 Extracting XMRig..."
tar -xvf xmrig.tar.gz
cd xmrig-*-linux-arm64 || { echo "❌ Extraction failed!"; exit 1; }

# --- Make xmrig executable ---
chmod +x xmrig

# --- Start mining ---
echo "🚀 Starting XMRig miner..."
./xmrig -o pool.supportxmr.com:3333 -u 45WrmXjfk8m3QvvoDBFPQjMoSCUc3zgFvaD5Bqmymxbb3fVmKmDoZwR4F1MPKZ8PA82qndPobuR5HUDjV1HJvXFAJUUuYPC -p android -k --coin monero
