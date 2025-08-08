#!/bin/bash

# Clean old files
rm -rf xmrig xmrig.tar.gz xmrig-*

# Update & install dependencies
pkg update -y && pkg upgrade -y
pkg install wget tar -y

# Latest ARM64 XMRig link (tested)
XMRIG_URL="https://github.com/xmrig/xmrig/releases/download/v6.21.0/xmrig-6.21.0-linux-arm64.tar.gz"

echo "🔹 Downloading XMRig for ARM64..."
wget -O xmrig.tar.gz "$XMRIG_URL"

# Check file size
if [ ! -s xmrig.tar.gz ]; then
    echo "❌ Download failed! File is empty."
    exit 1
fi

# Extract
echo "🔹 Extracting XMRig..."
tar -xvzf xmrig.tar.gz || { echo "❌ Extraction failed!"; exit 1; }

# Move into extracted folder
cd xmrig-6.21.0 || { echo "❌ Directory not found after extraction!"; exit 1; }

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
            "user": "YOUR_WALLET_ADDRESS",
            "pass": "x",
            "keepalive": true,
            "tls": false
        }
    ]
}
EOL

echo "✅ Setup complete!"
echo "💡 Start mining with:"
echo "./xmrig --config=config.json"
