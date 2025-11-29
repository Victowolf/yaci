#!/usr/bin/env bash
set -euo pipefail

echo "[YACI] Downloading Yaci DevKit (runnable demo version ZIP)..."

INSTALL_DIR="/opt/yaci"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

ZIP_URL="https://codeload.github.com/bloxbean/yaci-devkit-demos/zip/refs/heads/master"

curl -L -o yaci.zip "$ZIP_URL"
unzip yaci.zip
rm yaci.zip

# auto-detect the extracted folder
EXTRACTED_DIR=$(find . -maxdepth 1 -type d -name "yaci-devkit-demos*" | head -n 1)

if [ -z "$EXTRACTED_DIR" ]; then
  echo "[ERROR] Could not find extracted Yaci DevKit demos folder!"
  ls -al
  exit 1
fi

echo "[YACI] Found folder: $EXTRACTED_DIR"

# Move to standard location
mv "$EXTRACTED_DIR" yaci-demos

chmod +x yaci-demos/bin/devkit.sh
chmod +x yaci-demos/bin/yaci-cli

echo "[YACI] Installed DevKit at /opt/yaci/yaci-demos"
export PATH="/opt/yaci/yaci-demos/bin:$PATH"
