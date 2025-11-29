#!/usr/bin/env bash
set -euo pipefail

CARDANO_VERSION="10.1.4"
DOWNLOAD_URL="https://github.com/IntersectMBO/cardano-node/releases/download/${CARDANO_VERSION}/cardano-node-${CARDANO_VERSION}-linux.tar.gz"

echo "[Cardano] Downloading cardano-node $CARDANO_VERSION..."
mkdir -p /opt/cardano
cd /opt/cardano

curl -L -o node.tar.gz "$DOWNLOAD_URL"
tar -xzf node.tar.gz
rm node.tar.gz

# Verify binaries
if [ ! -f "./cardano-node" ] || [ ! -f "./cardano-cli" ]; then
  echo "[ERROR] cardano-node or cardano-cli not found after extraction!"
  echo "[DEBUG] Listing directory:"
  ls -al
  exit 1
fi

chmod +x ./cardano-node ./cardano-cli

echo "[Cardano] Installed successfully."
export PATH="/opt/cardano:$PATH"
