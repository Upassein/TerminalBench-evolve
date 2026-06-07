# Runbook

Operational notes for the Terminal-Bench 2.1 server.

## Update Code

```bash
cd ~/bench/TerminalBench-evolve
git pull
```

## Load Environment

```bash
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

Optional single task:

```bash
TBENCH_TASK="<task-id>" bash scripts/smoke_oracle.sh
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

