# Runbook

Operational notes for the Terminal-Bench 2.1 server.

## Update Code

```bash
cd ~/bench/TerminalBench-evolve
git pull
```

## Load Environment

```bash
conda activate tbench21
source ~/bench/tbench21-runs/env/tbench21.env
```

## Run Preflight

```bash
cd ~/bench/TerminalBench-evolve
bash scripts/preflight.sh
```

## Run Oracle Smoke Test

```bash
cd ~/bench/TerminalBench-evolve
source ~/bench/tbench21-runs/env/tbench21.env
bash scripts/smoke_oracle.sh
```

By default, this runs only one task using Harbor's `-l 1` / `--n-tasks 1`
limit.

To include a specific task name or glob:

```bash
TBENCH_TASK_ARGS='-i <task-name-or-glob>' bash scripts/smoke_oracle.sh
```

To run one task from the registry directly:

```bash
TBENCH_TASK_ARGS='-t <org/name>' bash scripts/smoke_oracle.sh
```

To intentionally run the full dataset with the oracle agent:

```bash
TBENCH_ALLOW_FULL=1 bash scripts/smoke_oracle.sh
```

## Run Terminus-2 Model Smoke Test

Use this after oracle smoke passes and your local/open-source model server is
available through an OpenAI-compatible API.

```bash
cd ~/bench/TerminalBench-evolve
conda activate tbench21
source ~/bench/tbench21-runs/env/tbench21.env

export TBENCH_MODEL="openai/<served-model-name>"
export TBENCH_API_BASE="http://127.0.0.1:8000/v1"
export OPENAI_API_KEY="${OPENAI_API_KEY:-dummy}"

bash scripts/smoke_terminus2.sh
```

By default this runs one task with `-l 1`. To select a task:

```bash
TBENCH_TASK_ARGS='-i <task-name-or-glob>' bash scripts/smoke_terminus2.sh
```

Useful tuning knobs:

```bash
export TBENCH_MAX_TURNS=30
export TBENCH_EXTRA_ARGS='--debug'
```

## View Jobs

```bash
cd ~/bench/TerminalBench-evolve
bash scripts/view_jobs.sh
```

For remote access, prefer SSH tunneling:

```bash
ssh -L 8080:127.0.0.1:8080 user@server
```

Then open:

```text
http://127.0.0.1:8080
```

## Common Issues

### Docker Permission Denied

Run:

```bash
sudo usermod -aG docker $USER
```

Then log out and log back in.

### Docker Compose Missing

Harbor uses Docker Compose v2. If a run fails with `unknown flag:
--project-name` or `docker compose version` fails, install the Compose plugin:

```bash
sudo apt-get update
sudo apt-get install -y docker-compose-plugin
docker compose version
```

### Harbor Not Found

Check that `uv tool` binaries are on PATH:

```bash
echo "$PATH"
uv tool dir
```

Reload shell config:

```bash
source ~/.bashrc
```

### No Result Files

Confirm the command was run from the runtime directory or by using the provided
scripts. Harbor writes `jobs/` in the current working directory unless another
output location is configured.
