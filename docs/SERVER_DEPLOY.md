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
docker compose version
```

Harbor uses Docker Compose v2. If `docker compose version` fails, install the
Compose plugin:

```bash
sudo apt-get update
sudo apt-get install -y docker-compose-plugin
docker compose version
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
bash scripts/smoke_oracle.sh
```

Results should appear under:

```text
~/bench/tbench21-runs/jobs/
```

## 7. Terminus-2 With Local Model

After oracle smoke passes, test Harbor's reference agent against your local
OpenAI-compatible model endpoint:

```bash
cd ~/bench/TerminalBench-evolve
conda activate tbench21
source ~/bench/tbench21-runs/env/tbench21.env

export TBENCH_MODEL="openai/<served-model-name>"
export TBENCH_API_BASE="http://127.0.0.1:8000/v1"
export OPENAI_API_KEY="${OPENAI_API_KEY:-dummy}"

bash scripts/smoke_terminus2.sh
```

`TBENCH_MODEL` should match the model name exposed by your vLLM/SGLang/llama.cpp
server. Keep the `openai/` prefix because Terminus-2 uses LiteLLM provider
routing.
