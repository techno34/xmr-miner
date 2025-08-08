#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
# ----------------------------
# Robust installer for XMRig on Termux (ARM64)
# It finds the latest linux-arm64 release asset and downloads it.
# Edit WALLET below if you want to change address.
# ----------------------------

WALLET="45WrmXjfk8m3QvvoDBFPQjMoSCUc3zgFvaD5Bqmymxbb3fVmKmDoZwR4F1MPKZ8PA82qndPobuR5HUDjV1HJvXFAJUUuYPC"
POOL="pool.supportxmr.com:3333"
THREADS=""   # optional: e.g. "-t 2"

echo "==> Installing required packages (curl, wget, tar, jq)..."
pkg update -y || true
pkg install -y curl wget tar proot || true
# install jq if available fast-parse, otherwise script will use grep/sed
pkg install -y jq || echo "jq not installed, will use grep fallback"

# detect architecture and choose pattern
ARCH=$(uname -m || echo "unknown")
echo "arch: $ARCH"
PATTERN="linux-arm64"
# some releases might name assets differently; we try a few patterns
CANDIDATES=("linux-arm64" "arm64" "armv8" "android-arm64")

API_URL="https://api.github.com/repos/xmrig/xmrig/releases/latest"

echo "==> Finding latest XMRig release asset..."
LATEST_URL=""

# try with jq first (reliable)
if command -v jq >/dev/null 2>&1; then
  for p in "${CANDIDATES[@]}"; do
    LATEST_URL=$(curl -s -H "Accept: application/vnd.github.v3+json" -A "curl/termux" "$API_URL" \
      | jq -r --arg pat "$p" '.assets[].browser_download_url | select(test($pat))' | head -n1 || true)
    if [ -n "$LATEST_URL" ] && [ "$LATEST_URL" != "null" ]; then break; fi
  done
fi

# fallback to grep/sed if jq not available or returned nothing
if [ -z "${LATEST_URL:-}" ]; then
  echo "jq not used or no result — using grep fallback..."
  JSON=$(curl -s -H "Accept: application/vnd.github.v3+json" -A "curl/termux" "$API_URL")
  for p in "${CANDIDATES[@]}"; do
    LATEST_URL=$(printf "%s\n" "$JSON" | grep -Eo 'https://[^"]+'"$p"'[^"]*' | head -n1 || true)
    if [ -n "$LATEST_URL" ]; then break; fi
  done
fi

if [ -z "${LATEST_URL:-}" ]; then
  echo "❌ Could not find a linux-arm64 asset on GitHub releases. Aborting."
  echo "You can run this to debug:"
  echo "curl -s $API_URL | grep browser_download_url | sed -n '1,50p'"
  exit 1
fi

echo "Found asset URL:"
echo "$LATEST_URL"

# download file (use curl with -L -f to follow redirects and fail on HTTP errors)
echo "==> Downloading XMRig..."
rm -f xmrig.tar.gz
if ! curl -L --fail -A "curl/termux" -o xmrig.tar.gz "$LATEST_URL"; then
  echo "❌ Download failed (curl). URL was: $LATEST_URL"
  exit 1
fi

# quick sanity check on file size
SIZE=$(stat -c%s xmrig.tar.gz 2>/dev/null || echo 0)
if [ "$SIZE" -lt 1024 ]; then
  echo "❌ Downloaded file is too small ($SIZE bytes). Probably invalid download."
  exit 1
fi

# test tar integrity
echo "==> Testing tar archive..."
if ! tar -tzf xmrig.tar.gz >/dev/null 2>&1; then
  echo "❌ Archive does not look valid or is corrupted."
  ls -lh xmrig.tar.gz
  exit 1
fi

# extract and find top-level dir
echo "==> Extracting XMRig..."
tar -xzf xmrig.tar.gz
TOPDIR=$(tar -tzf xmrig.tar.gz | head -n1 | cut -f1 -d"/")
if [ -z "$TOPDIR" ]; then
  echo "❌ Can't determine extracted directory."
  exit 1
fi

cd "$TOPDIR" || { echo "❌ Extracted dir $TOPDIR not found"; exit 1; }

# make executable
chmod +x xmrig || true

echo "==> Starting miner (ctrl+C to stop)."
# run xmrig with wallet & pool - replace args as you prefer
./xmrig -o "$POOL" -u "$WALLET" -p x -k $THREADS
