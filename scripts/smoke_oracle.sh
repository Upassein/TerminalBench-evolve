#!/usr/bin/env bash
set -euo pipefail

RUN_ROOT="${TBENCH_RUN_ROOT:-${HOME}/bench/tbench21-runs}"
DATASET="${TBENCH_DATASET:-terminal-bench/terminal-bench-2-1}"
TASK="${TBENCH_TASK:-}"
LOG_DIR="${RUN_ROOT}/logs"
STAMP="$(date +%Y%m%d-%H%M%S)"
LOG_FILE="${LOG_DIR}/smoke_oracle_${STAMP}.log"

mkdir -p "${RUN_ROOT}/jobs" "${LOG_DIR}"

echo "[smoke] Dataset: ${DATASET}"
echo "[smoke] Run root: ${RUN_ROOT}"
echo "[smoke] Log file: ${LOG_FILE}"

cd "${RUN_ROOT}"

cmd=(harbor run -d "${DATASET}" -a oracle)

if [ -n "${TASK}" ]; then
  cmd+=(-t "${TASK}")
  echo "[smoke] Task: ${TASK}"
else
  echo "[smoke] Task: default Harbor selection"
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

