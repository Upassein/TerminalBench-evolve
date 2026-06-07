#!/usr/bin/env bash
set -euo pipefail

RUN_ROOT="${TBENCH_RUN_ROOT:-${HOME}/bench/tbench21-runs}"
DATASET="${TBENCH_DATASET:-terminal-bench/terminal-bench-2-1}"
TASK_ARGS="${TBENCH_TASK_ARGS:-}"
ALLOW_FULL="${TBENCH_ALLOW_FULL:-0}"
DEFAULT_SMOKE_ARGS="${TBENCH_DEFAULT_SMOKE_ARGS:--l 1}"
LOG_DIR="${RUN_ROOT}/logs"
STAMP="$(date +%Y%m%d-%H%M%S)"
LOG_FILE="${LOG_DIR}/smoke_oracle_${STAMP}.log"

mkdir -p "${RUN_ROOT}/jobs" "${LOG_DIR}"

echo "[smoke] Dataset: ${DATASET}"
echo "[smoke] Run root: ${RUN_ROOT}"
echo "[smoke] Log file: ${LOG_FILE}"

if [ -z "${TASK_ARGS}" ] && [ "${ALLOW_FULL}" != "1" ]; then
  TASK_ARGS="${DEFAULT_SMOKE_ARGS}"
  echo "[smoke] No task args provided; using default smoke args: ${TASK_ARGS}"
fi

cd "${RUN_ROOT}"

cmd=(harbor run -d "${DATASET}" -a oracle)

if [ -n "${TASK_ARGS}" ]; then
  echo "[smoke] Task args: ${TASK_ARGS}"
  # shellcheck disable=SC2206
  task_args=(${TASK_ARGS})
  cmd+=("${task_args[@]}")
else
  echo "[smoke] Full dataset run explicitly allowed"
fi

if [ -n "${TBENCH_EXTRA_ARGS:-}" ]; then
  echo "[smoke] Extra args: ${TBENCH_EXTRA_ARGS}"
  # shellcheck disable=SC2206
  extra_args=(${TBENCH_EXTRA_ARGS})
  cmd+=("${extra_args[@]}")
fi

echo "[smoke] Running: ${cmd[*]}"
"${cmd[@]}" 2>&1 | tee "${LOG_FILE}"

echo "[smoke] Done"
echo "[smoke] Check results under: ${RUN_ROOT}/jobs"
