#!/usr/bin/env bash
set -euo pipefail

echo "[install] Installing uv if needed"
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="${HOME}/.local/bin:${PATH}"
fi

echo "[install] Installing Harbor"
uv tool install harbor

echo "[install] Installing Terminal-Bench CLI"
uv tool install terminal-bench

echo "[install] Done"
harbor --help >/dev/null
if command -v tb >/dev/null 2>&1; then
  tb --help >/dev/null
elif command -v terminal-bench >/dev/null 2>&1; then
  terminal-bench --help >/dev/null
else
  echo "[install] terminal-bench command was not found after installation" >&2
  exit 1
fi

