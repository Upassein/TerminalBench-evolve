#!/usr/bin/env bash
set -euo pipefail

INSTALL_METHOD="${TBENCH_INSTALL_METHOD:-pip}"

echo "[install] Method: ${INSTALL_METHOD}"

python - <<'PY'
import sys

required = (3, 12)
if sys.version_info < required:
    found = ".".join(map(str, sys.version_info[:3]))
    raise SystemExit(
        f"[install] Python {found} is too old. Harbor requires Python >=3.12. "
        "Create the conda env with: conda create -n tbench21 python=3.12 -y"
    )
PY

if [ "${INSTALL_METHOD}" = "pip" ]; then
  echo "[install] Installing into the active Python environment"
  python -m pip install --upgrade pip
  python -m pip install --upgrade harbor
elif [ "${INSTALL_METHOD}" = "uv" ]; then
  echo "[install] Installing uv if needed"
  if ! command -v uv >/dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="${HOME}/.local/bin:${PATH}"
  fi

  echo "[install] Installing Harbor"
  uv tool install harbor
else
  echo "[install] Unknown TBENCH_INSTALL_METHOD: ${INSTALL_METHOD}" >&2
  echo "[install] Use 'pip' or 'uv'." >&2
  exit 1
fi

echo "[install] Done"
harbor --help >/dev/null
echo "[install] Harbor is ready"
