#!/usr/bin/env bash
set -euo pipefail

echo "[YACI] Installing Yaci DevKit..."

YACI_VERSION="1.0.0"
ZIP_URL="https://github.com/bloxbean/yaci-devkit/releases/download/v${YACI_VERSION}/yaci-devkit-${YACI_VERSION}.zip"

INSTALL_DIR="/opt/yaci"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

echo "[YACI] Downloading Yaci DevKit ZIP..."
curl -L -o yaci.zip "$ZIP_URL"

echo "[YACI] Extracting ZIP..."
unzip -o yaci.zip >/dev/null
rm yaci.zip

echo "[YACI] Searching for extracted DevKit folder..."
# Detect folder that contains bin/devkit.sh
EXTRACTED_DIR=$(find . -type f -name "devkit.sh" | head -n 1 | xargs -I{} dirname {} | sed 's|/bin||')

if [ -z "$EXTRACTED_DIR" ]; then
  echo "[ERROR] Could not locate Yaci DevKit directory!"
  echo "[DEBUG] Listing /opt/yaci:"
  ls -R .
  exit 1
fi

echo "[YACI] Detected Yaci DevKit folder: $EXTRACTED_DIR"

# Normalize installation so we always have /opt/yaci/bin/*
if [ "$EXTRACTED_DIR" != "$INSTALL_DIR" ]; then
  echo "[YACI] Moving extracted files into /opt/yaci/"
  cp -r "$EXTRACTED_DIR"/* "$INSTALL_DIR"/
fi

# Ensure executable
chmod +x "$INSTALL_DIR/bin/devkit.sh"

echo "[YACI] Installed and normalized at /opt/yaci"
echo "[YACI] Adding to PATH"

export PATH="$INSTALL_DIR/bin:$PATH"
