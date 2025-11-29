#!/usr/bin/env bash
set -euo pipefail

echo "[YACI] Downloading Yaci DevKit (runnable demo version)..."

INSTALL_DIR="/opt/yaci"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Clone official runnable version
git clone https://github.com/bloxbean/yaci-devkit-demos.git yaci-demos

cd yaci-demos

chmod +x bin/devkit.sh

echo "[YACI] Yaci DevKit installed."
export PATH="$INSTALL_DIR/yaci-demos/bin:$PATH"
