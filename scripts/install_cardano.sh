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

# Find the extracted directory (they change names sometimes)
EXTRACTED_DIR=$(find . -maxdepth 1 -type d -name "cardano-node*" | head -n 1)

if [ -z "$EXTRACTED_DIR" ]; then
  echo "[ERROR] Could not find extracted cardano-node directory!"
  exit 1
fi

echo "[Cardano] Moving binaries to /opt/cardano"
mv "$EXTRACTED_DIR"/cardano-node ./
mv "$EXTRACTED_DIR"/cardano-cli ./

chmod +x cardano-node cardano-cli

echo "[Cardano] Successfully installed."
export PATH="/opt/cardano:$PATH"
