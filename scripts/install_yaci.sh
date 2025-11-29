#!/usr/bin/env bash
set -euo pipefail

echo "[YACI] Installing Yaci DevKit via npm..."

# Install Node + npm
apt-get update && apt-get install -y nodejs npm

# Install Yaci DevKit CLI globally
npm install -g @bloxbean/yaci-devkit

# Ensure PATH
echo "[YACI] Yaci DevKit installed."
which devkit || echo "[WARN] devkit not found in PATH"
which yaci-cli || echo "[WARN] yaci-cli not found in PATH"

export PATH="/usr/local/bin:$PATH"
