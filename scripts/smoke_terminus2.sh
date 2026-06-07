#!/usr/bin/env bash
set -euo pipefail

RUN_ROOT="${TBENCH_RUN_ROOT:-${HOME}/bench/tbench21-runs}"
DATASET="${TBENCH_DATASET:-terminal-bench/terminal-bench-2-1}"
AGENT="${TBENCH_AGENT:-terminus-2}"
MODEL="${TBENCH_MODEL:-}"
API_BASE="${TBENCH_API_BASE:-}"
TASK_ARGS="${TBENCH_TASK_ARGS:-}"
DEFAULT_SMOKE_ARGS="${TBENCH_DEFAULT_SMOKE_ARGS:--l 1}"
LOG_DIR="${RUN_ROOT}/logs"
STAMP="$(date +%Y%m%d-%H%M%S)"
LOG_FILE="${LOG_DIR}/smoke_${AGENT}_${STAMP}.log"

mkdir -p "${RUN_ROOT}/jobs" "${LOG_DIR}"

if [ -z "${MODEL}" ]; then
  echo "[smoke] TBENCH_MODEL is required, for example: openai/Qwen2.5-Coder-32B-Instruct" >&2
  exit 2
fi

if [ -z "${API_BASE}" ]; then
  echo "[smoke] TBENCH_API_BASE is required, for example: http://127.0.0.1:8000/v1" >&2
  exit 2
fi

if [ -z "${OPENAI_API_KEY:-}" ]; then
  echo "[smoke] OPENAI_API_KEY is not set; using dummy for OpenAI-compatible local endpoints"
  export OPENAI_API_KEY="dummy"
fi

if [ -z "${TASK_ARGS}" ]; then
  TASK_ARGS="${DEFAULT_SMOKE_ARGS}"
  echo "[smoke] No task args provided; using default smoke args: ${TASK_ARGS}"
fi

echo "[smoke] Dataset: ${DATASET}"
echo "[smoke] Agent: ${AGENT}"
echo "[smoke] Model: ${MODEL}"
echo "[smoke] API base: ${API_BASE}"
echo "[smoke] Run root: ${RUN_ROOT}"
echo "[smoke] Log file: ${LOG_FILE}"

cd "${RUN_ROOT}"

cmd=(
  harbor run
  -d "${DATASET}"
  -a "${AGENT}"
  -m "${MODEL}"
  --ak "api_base=${API_BASE}"
  -y
)

if [ -n "${TBENCH_MAX_TURNS:-}" ]; then
  cmd+=(--ak "max_turns=${TBENCH_MAX_TURNS}")
fi

# shellcheck disable=SC2206
task_args=(${TASK_ARGS})
cmd+=("${task_args[@]}")

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
