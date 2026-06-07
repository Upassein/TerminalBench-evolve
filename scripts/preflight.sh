#!/usr/bin/env bash
set -euo pipefail

RUN_ROOT="${TBENCH_RUN_ROOT:-${HOME}/bench/tbench21-runs}"
DATASET="${TBENCH_DATASET:-terminal-bench/terminal-bench-2-1}"

failures=0

check_cmd() {
  local name="$1"
  if command -v "$name" >/dev/null 2>&1; then
    echo "[ok] command: $name"
  else
    echo "[missing] command: $name" >&2
    failures=$((failures + 1))
  fi
}

check_dir() {
  local path="$1"
  if [ -d "$path" ]; then
    echo "[ok] directory: $path"
  else
    echo "[missing] directory: $path" >&2
    failures=$((failures + 1))
  fi
}

echo "[preflight] Dataset: $DATASET"
echo "[preflight] Run root: $RUN_ROOT"

check_cmd git
check_cmd curl
check_cmd docker
check_cmd harbor

python - <<'PY'
import sys

if sys.version_info >= (3, 12):
    print("[ok] python: " + sys.version.split()[0])
else:
    print(
        "[missing] python: "
        + sys.version.split()[0]
        + " is too old; Harbor requires Python >=3.12",
        file=sys.stderr,
    )
    raise SystemExit(1)
PY

check_dir "$RUN_ROOT"
check_dir "$RUN_ROOT/jobs"
check_dir "$RUN_ROOT/logs"
check_dir "$RUN_ROOT/cache"
check_dir "$RUN_ROOT/env"

if docker info >/dev/null 2>&1; then
  echo "[ok] docker daemon reachable"
else
  echo "[missing] docker daemon not reachable" >&2
  failures=$((failures + 1))
fi

if [ -n "${OPENAI_API_KEY:-}" ] || [ -n "${ANTHROPIC_API_KEY:-}" ] || [ -n "${GOOGLE_API_KEY:-}" ]; then
  echo "[ok] at least one model API key is set"
else
  echo "[warn] no model API key found; oracle smoke tests may still work"
fi

if [ "$failures" -gt 0 ]; then
  echo "[preflight] Failed with $failures issue(s)" >&2
  exit 1
fi

echo "[preflight] Passed"
