#!/bin/bash
clear
echo "🔹 Installing dependencies..."
pkg update -y && pkg upgrade -y
pkg install wget tar proot -y

echo "🔹 Downloading XMRig..."
# Download URL
XMRIG_URL="https://github.com/xmrig/xmrig/releases/latest/download/xmrig-6.21.3-linux-static-x64.tar.gz"
wget --tries=3 --timeout=30 -O xmrig.tar.gz "$XMRIG_URL"

# Check file size
if [ ! -s xmrig.tar.gz ]; then
    echo "❌ Download failed! File is empty."
    exit 1
fi

echo "🔹 Extracting XMRig..."
tar -xvzf xmrig.tar.gz --strip=1 || {
    echo "❌ Extraction failed!"
    exit 1
}

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

echo "🔹 Setting permissions..."
chmod +x xmrig

echo "✅ Setup complete!"
echo "💡 Start mining with: ./xmrig --config=config.json"
