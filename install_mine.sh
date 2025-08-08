#!/bin/bash

echo "🔹 Updating packages..."
pkg update -y && pkg upgrade -y

echo "🔹 Installing dependencies..."
pkg install -y git wget proot tar

echo "🔹 Downloading XMRig prebuilt binary for ARM64..."
mkdir -p xmrig
cd xmrig
wget https://github.com/xmrig/xmrig/releases/download/v6.21.0/xmrig-6.21.0-linux-arm64.tar.gz -O xmrig.tar.gz
tar -xvzf xmrig.tar.gz --strip-components=1
rm xmrig.tar.gz

echo "🔹 Creating config.json..."
cat > config.json <<EOL
{
    "autosave": true,
    "cpu": true,
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

echo "✅ Setup complete!"
echo "💡 Start mining with: ./xmrig"
