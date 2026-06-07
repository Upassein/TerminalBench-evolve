# Server Deploy Guide

This guide deploys a clean Terminal-Bench 2.1 runtime on a Linux server.

## 1. Create Directories

```bash
mkdir -p ~/bench
cd ~/bench
git clone <repo-url> TerminalBench-evolve

mkdir -p ~/bench/tbench21-runs/jobs
mkdir -p ~/bench/tbench21-runs/logs
mkdir -p ~/bench/tbench21-runs/cache
mkdir -p ~/bench/tbench21-runs/env
```

Keep these roles separate:

```text
TerminalBench-evolve = git-managed code, docs, scripts
tbench21-runs        = local outputs, logs, caches, secrets
```

## 2. Install System Dependencies

Ubuntu example:

```bash
sudo apt-get update
sudo apt-get install -y git curl ca-certificates tmux jq docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
```

Log out and log back in so the Docker group change takes effect.

Verify Docker:

```bash
docker run hello-world
docker info
```

## 3. Create Conda Environment

```bash
cd ~/bench/TerminalBench-evolve
conda env create -f environment.yml
conda activate tbench21
python -V

harbor --help
```

If you prefer not to use `environment.yml`, create the environment manually:

```bash
conda create -n tbench21 python=3.12 -y
conda activate tbench21
python -V
python -m pip install --upgrade pip
python -m pip install --upgrade harbor
```

`uv` is also supported, but it is optional:

```bash
TBENCH_INSTALL_METHOD=uv bash scripts/install_tools.sh
harbor --help
```

## 4. Configure Secrets

```bash
cp ~/bench/TerminalBench-evolve/configs/tbench21.env.example \
   ~/bench/tbench21-runs/env/tbench21.env

vim ~/bench/tbench21-runs/env/tbench21.env
source ~/bench/tbench21-runs/env/tbench21.env
```

Do not commit real API keys.

## 5. Preflight

```bash
cd ~/bench/TerminalBench-evolve
conda activate tbench21
bash scripts/preflight.sh
```

Expected checks:

- Docker works.
- `harbor` is installed.
- `tb` or `terminal-bench` is installed.
- Runtime directories exist.
- At least one model API key is present when running non-oracle agents.

## 6. Smoke Test

```bash
cd ~/bench/TerminalBench-evolve
conda activate tbench21
source ~/bench/tbench21-runs/env/tbench21.env
harbor run --help
TBENCH_TASK_ARGS='--task-name <task-id>' bash scripts/smoke_oracle.sh
```

Results should appear under:

```text
~/bench/tbench21-runs/jobs/
```
