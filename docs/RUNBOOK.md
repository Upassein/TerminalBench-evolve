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
```

First inspect the task-filter flags supported by the installed Harbor version:

```bash
harbor run --help
```

Then run one task by passing the matching filter through `TBENCH_TASK_ARGS`.
For example, if your Harbor version supports `--task-name`:

```bash
TBENCH_TASK_ARGS='--task-name <task-id>' bash scripts/smoke_oracle.sh
```

To intentionally run the full dataset with the oracle agent:

```bash
TBENCH_ALLOW_FULL=1 bash scripts/smoke_oracle.sh
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
