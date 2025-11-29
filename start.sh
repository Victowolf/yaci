#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR"

echo "[STEP] Installing Cardano binaries..."
bash scripts/install_cardano.sh

echo "[STEP] Installing Yaci DevKit..."
bash scripts/install_yaci.sh

echo "[STEP] Initializing devnet configs..."
bash scripts/init_network.sh

echo "[STEP] Starting Yaci DevKit..."
/opt/yaci/yaci-demos/bin/devkit.sh start &

sleep 5

echo "[STEP] Creating & starting node..."
/opt/yaci/yaci-demos/bin/yaci-cli create-node -o --start || true

echo "[DONE] Node is running. Streaming logs..."
tail -f /work/node.log || true
