#!/usr/bin/env bash
set -euo pipefail

echo "[YACI] Installing Yaci DevKit..."

YACI_VERSION="1.0.0"
ZIP_URL="https://github.com/bloxbean/yaci-devkit/releases/download/v${YACI_VERSION}/yaci-devkit-${YACI_VERSION}.zip"

mkdir -p yaci
cd yaci

curl -L -o yaci.zip "$ZIP_URL"
unzip yaci.zip
rm yaci.zip

chmod +x bin/devkit.sh

echo "[YACI] Installed."
export PATH="$PWD/bin:$PATH"
