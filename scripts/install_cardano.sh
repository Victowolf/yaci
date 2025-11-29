#!/usr/bin/env bash
set -euo pipefail

CARDANO_VERSION="10.1.4"
TARBALL="cardano-node-${CARDANO_VERSION}-linux.tar.gz"
DOWNLOAD_URL="https://github.com/IntersectMBO/cardano-node/releases/download/${CARDANO_VERSION}/${TARBALL}"

echo "[Cardano] Installing cardano-node ${CARDANO_VERSION}..."
mkdir -p /opt/cardano
cd /opt/cardano

# Download (idempotent)
if [ ! -f "$TARBALL" ]; then
  curl -L -o "$TARBALL" "$DOWNLOAD_URL"
fi

tar -xzf "$TARBALL"
# some releases unpack directly, some into bin/
if [ -f "./cardano-node" ] && [ -f "./cardano-cli" ]; then
  echo "[Cardano] Found top-level binaries."
elif [ -f "./bin/cardano-node" ] && [ -f "./bin/cardano-cli" ]; then
  echo "[Cardano] Found binaries in ./bin/, moving to /opt/cardano"
  mv ./bin/cardano-node ./
  mv ./bin/cardano-cli ./
else
  # find anywhere
  FOUND_NODE=$(find . -type f -name cardano-node | head -n 1 || true)
  FOUND_CLI=$(find . -type f -name cardano-cli | head -n 1 || true)
  if [ -n "$FOUND_NODE" ] && [ -n "$FOUND_CLI" ]; then
    cp "$FOUND_NODE" ./cardano-node
    cp "$FOUND_CLI" ./cardano-cli
  else
    echo "[ERROR] Could not find cardano-node/cardano-cli after extraction."
    ls -R .
    exit 1
  fi
fi

chmod +x ./cardano-node ./cardano-cli
echo "[Cardano] Installed to /opt/cardano"
echo "cardano-node --version: $(./cardano-node --version 2>/dev/null || true)"
echo "cardano-cli --version: $(./cardano-cli --version 2>/dev/null || true)"
