#!/usr/bin/env bash
set -euo pipefail

echo "[INIT] Preparing devnet config..."

mkdir -p /opt/cardano/data
mkdir -p /opt/cardano/logs

cp config/devnet-config.json /opt/cardano/devnet-config.json
cp config/topology.json /opt/cardano/topology.json
cp config/params.json /opt/cardano/params.json

echo "[INIT] Devnet initialized."
