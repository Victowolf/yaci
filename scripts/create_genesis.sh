#!/usr/bin/env bash
set -euo pipefail
set -x

WORKDIR="/work"
GENESIS_DIR="$WORKDIR/genesis"
mkdir -p "$GENESIS_DIR"
cd "$GENESIS_DIR"

echo "[GENESIS] Generating genesis & keys in $GENESIS_DIR"

# Copy template (config/genesis-template.json in repo)
cp "$(pwd)/../../config/genesis-template.json" "$GENESIS_DIR/genesis.spec.json" || true
# If the template wasn't copied above because of path, try alternative
if [ ! -f "$GENESIS_DIR/genesis.spec.json" ]; then
  cp ../../config/genesis-template.json genesis.spec.json
fi

# Set system start to a few seconds in future (UTC ISO8601)
SYSTEM_START=$(date -u -d "+10 seconds" +"%Y-%m-%dT%H:%M:%SZ")
jq --arg ss "$SYSTEM_START" '.systemStart = $ss' genesis.spec.json > genesis.spec.withtime.json
mv genesis.spec.withtime.json genesis.spec.json

# Use cardano-cli genesis create (legacy interface)
echo "[GENESIS] Running cardano-cli genesis create ..."
# many cardano-cli versions have 'genesis create' or 'genesis create-cardano'. We try a couple.
if cardano-cli genesis create --help >/dev/null 2>&1; then
  cardano-cli genesis create --genesis-dir "$GENESIS_DIR" --genesis-spec-file genesis.spec.json
elif cardano-cli genesis create-cardano --help >/dev/null 2>&1; then
  cardano-cli genesis create-cardano --genesis-dir "$GENESIS_DIR" --genesis-spec-file genesis.spec.json
else
  echo "[WARN] cardano-cli does not have 'genesis create' subcommand on this version."
  echo "[INFO] Attempting legacy key-gen & create flow..."

  # generate genesis keys & file using older commands (best-effort)
  mkdir -p keys
  cardano-cli genesis key-gen-genesis --verification-key-file keys/genesis.vkey --signing-key-file keys/genesis.skey || true
  cardano-cli genesis create --genesis-dir "$GENESIS_DIR" --genesis-template ../../config/genesis-template.json || true
fi

echo "[GENESIS] Genesis dir contents:"
ls -al "$GENESIS_DIR" || true

# Place topology (single node)
cat > "$WORKDIR/topology.json" <<'EOF'
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

# produce a simple node config (copy sample config if included)
if [ -f ../../config/config.json ]; then
  cp ../../config/config.json "$WORKDIR/config.json"
else
  cat > "$WORKDIR/config.json" <<'EOF'
{
  "Protocol": "Cardano",
  "NetworkMagic": 42
}
EOF
fi

echo "[GENESIS] Done."
