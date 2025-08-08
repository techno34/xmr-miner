#!/bin/bash

# Colors for messages
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔹 Installing dependencies...${NC}"
pkg update -y && pkg upgrade -y
pkg install -y git wget tar proot-distro

echo -e "${GREEN}🔹 Creating mining folder...${NC}"
mkdir -p ~/xmr-miner
cd ~/xmr-miner || exit

echo -e "${GREEN}🔹 Downloading latest XMRig...${NC}"
# Download latest xmrig prebuilt binary (Linux x64)
wget https://github.com/xmrig/xmrig/releases/latest/download/xmrig-6.21.3-linux-static-x64.tar.gz -O xmrig.tar.gz

echo -e "${GREEN}🔹 Extracting files...${NC}"
tar -xvf xmrig.tar.gz --strip-components=1
rm xmrig.tar.gz

echo -e "${GREEN}🔹 Creating config.json...${NC}"
cat > config.json <<EOL
{
    "api": { "id": null, "worker-id": "termux-miner" },
    "autosave": true,
    "background": false,
    "colors": true,
    "randomx": { "1gb-pages": false },
    "donate-level": 1,
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

chmod +x xmrig

echo -e "${GREEN}✅ Setup complete!${NC}"
echo -e "${GREEN}💡 Start mining with: ./xmrig${NC}"
