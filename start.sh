#!/usr/bin/env bash
set -euo pipefail
export PATH="/opt/cardano:$PATH"

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR"

echo "[STEP] Installing Cardano binaries..."
bash scripts/install_cardano.sh

echo "[STEP] Creating genesis & keys..."
bash scripts/create_genesis.sh

echo "[STEP] Starting node..."
bash scripts/start_node.sh
