#!/usr/bin/env bash
set -euo pipefail

RUN_ROOT="${TBENCH_RUN_ROOT:-${HOME}/bench/tbench21-runs}"
HOST="${TBENCH_VIEW_HOST:-127.0.0.1}"
PORT="${TBENCH_VIEW_PORT:-8080}"

cd "${RUN_ROOT}"

echo "[view] Run root: ${RUN_ROOT}"
echo "[view] URL: http://${HOST}:${PORT}"
echo "[view] For remote servers, use: ssh -L ${PORT}:127.0.0.1:${PORT} user@server"

harbor view jobs --host "${HOST}" --port "${PORT}"

