#!/bin/bash

# Update & install dependencies
pkg update -y
pkg upgrade -y
pkg install wget tar -y

# Download latest XMRig
echo "🔹 Downloading XMRig..."
wget https://github.com/xmrig/xmrig/releases/download/v6.21.0/xmrig-6.21.0-linux-arm64.tar.gz -O xmrig.tar.gz

# Extract
echo "🔹 Extracting..."
tar -xvzf xmrig.tar.gz
cd xmrig-6.21.0

# Give execute permission
chmod +x xmrig

# Create config.json
echo "🔹 Creating config.json..."
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

echo "✅ Setup complete!"
echo "💡 Start mining with: ./xmrig"
