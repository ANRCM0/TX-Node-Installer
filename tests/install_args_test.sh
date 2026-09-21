#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "${BASH_SOURCE[0]%/*}/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

INSTALL_DIR="$TMP/txnode" \
APP_NAME="tx-node-test" \
CLI_LINK="$TMP/txnode-cli" \
bash -c '
  set -euo pipefail
  source "$1"

  parse_install_args \
    --mode machine \
    --panel-url "https://panel.example.com/" \
    --machine-id 42 \
    --token "machine-token-123" \
    --kernel singbox \
    --log-level info

  [ "$NONINTERACTIVE_INSTALL" = "1" ]
  [ "$MODE_STR" = "machine" ]
  [ "$PANEL_URL" = "https://panel.example.com" ]
  [ "$MACHINE_ID" = "42" ]
  [ "$MACHINE_TOKEN" = "machine-token-123" ]
  [ "$AUDIT_ENABLED" = "false" ]

  write_config_files

  grep -Fxq "  url: \"https://panel.example.com\"" "$CONFIG_FILE"
  grep -Fxq "machine:" "$CONFIG_FILE"
  grep -Fxq "  machine_id: 42" "$CONFIG_FILE"
  grep -Fxq "  token: \"machine-token-123\"" "$CONFIG_FILE"
  grep -Fxq "  type: \"singbox\"" "$CONFIG_FILE"
  grep -Fxq "  enabled: false" "$CONFIG_FILE"

  grep -Fxq "    image: ghcr.io/paimoncai/tx-node:latest" "$COMPOSE_FILE"
  grep -Fxq "    network_mode: host" "$COMPOSE_FILE"
' _ "$ROOT/deploy.sh"

echo "non-interactive machine install config: ok"
