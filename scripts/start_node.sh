#!/usr/bin/env bash
set -euo pipefail
set -x

WORKDIR="/work"
GENESIS_DIR="$WORKDIR/genesis"
NODE_DB="$WORKDIR/node-db"
mkdir -p "$NODE_DB"
cd "$WORKDIR"

CARDANO_NODE="/opt/cardano/cardano-node"
CARDANO_CLI="/opt/cardano/cardano-cli"

if [ ! -x "$CARDANO_NODE" ]; then
  echo "[ERROR] cardano-node binary not found at $CARDANO_NODE"
  ls -al /opt/cardano || true
  exit 1
fi

# choose a config file - if one in repo config/ exists, prefer it
if [ -f ../../config/config.json ]; then
  NODE_CONFIG="../../config/config.json"
else
  NODE_CONFIG="$WORKDIR/config.json"
fi

echo "[NODE] Launching cardano-node with node-db: $NODE_DB"

# minimal node launch flags (may require more flags depending on release)
$CARDANO_NODE run \
  --topology "$WORKDIR/topology.json" \
  --database-path "$NODE_DB" \
  --socket-path "$NODE_DB/node.socket" \
  --port 3001 \
  --config "$NODE_CONFIG" \
  --shelley-kes-key "$GENESIS_DIR/kes.skey" \
  --shelley-operational-certificate "$GENESIS_DIR/opcert.cert" \
  > "$WORKDIR/node.stdout.log" 2> "$WORKDIR/node.stderr.log" &
NODE_PID=$!

echo "[NODE] cardano-node started (pid $NODE_PID). Streaming logs..."
sleep 3
tail -n +1 -f "$WORKDIR/node.stdout.log" "$WORKDIR/node.stderr.log"
