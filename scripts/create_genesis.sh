#!/usr/bin/env bash
set -euo pipefail
set -x

WORKDIR="/work"
GENESIS_DIR="$WORKDIR/genesis"
CONFIG_DIR="/app/config"

mkdir -p "$GENESIS_DIR"
cd "$GENESIS_DIR"

echo "[GENESIS] Creating genesis from $CONFIG_DIR/genesis-template.json"

# Copy template from repo correctly
cp "$CONFIG_DIR/genesis-template.json" genesis.spec.json

# Set system start a few seconds in the future
SYSTEM_START=$(date -u -d "+10 seconds" +"%Y-%m-%dT%H:%M:%SZ")
jq --arg ss "$SYSTEM_START" '.systemStart = $ss' genesis.spec.json > genesis.spec.json.tmp
mv genesis.spec.json.tmp genesis.spec.json

# Run genesis creation
if cardano-cli genesis create --help >/dev/null 2>&1; then
    cardano-cli genesis create --genesis-dir "$GENESIS_DIR" --genesis-spec-file genesis.spec.json
elif cardano-cli genesis create-cardano --help >/dev/null 2>&1; then
    cardano-cli genesis create-cardano --genesis-dir "$GENESIS_DIR" --genesis-spec-file genesis.spec.json
else
    echo "[ERROR] cardano-cli does not support genesis creation commands on this version."
    exit 1
fi

echo "[GENESIS] Writing topology.json"
cat > "$WORKDIR/topology.json" <<EOF
{
  "Producers": [
    {
      "addr": "127.0.0.1",
      "port": 3001,
      "valency": 1
    }
  ]
}
EOF

echo "[GENESIS] Writing node config"
cp "$CONFIG_DIR/config.json" "$WORKDIR/config.json"

echo "[GENESIS] DONE"
