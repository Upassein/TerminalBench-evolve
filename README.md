# TerminalBench-evolve

Deployment and operations scaffold for Terminal-Bench 2.1.

This repository is intentionally separate from TravelPlanner-evolve. It stores
versioned deployment notes, scripts, configuration templates, and future
Terminal-Bench-specific agent code. Benchmark outputs, logs, caches, and secrets
belong in a separate server-side run directory.

## Layout

Recommended local layout:

```text
D:\PROJECT\
  TravelPlanner-evolve\
  TerminalBench-evolve\
```

Recommended server layout:

```text
~/bench/
  TerminalBench-evolve/     # git clone of this repository
  tbench21-runs/            # non-git runtime directory
    jobs/
    logs/
    cache/
    env/
      tbench21.env
```

## Quick Start On Server

```bash
mkdir -p ~/bench
cd ~/bench
git clone <repo-url> TerminalBench-evolve

mkdir -p ~/bench/tbench21-runs/{jobs,logs,cache,env}
cp ~/bench/TerminalBench-evolve/configs/tbench21.env.example \
   ~/bench/tbench21-runs/env/tbench21.env

vim ~/bench/tbench21-runs/env/tbench21.env
source ~/bench/tbench21-runs/env/tbench21.env

cd ~/bench/TerminalBench-evolve
bash scripts/preflight.sh
bash scripts/smoke_oracle.sh
```

## Official References

- Terminal-Bench 2.1 announcement: https://www.tbench.ai/news/terminal-bench-2-1
- Terminal-Bench installation: https://www.tbench.ai/docs/installation
- Harbor dataset: https://hub.harborframework.com/datasets/terminal-bench/terminal-bench-2-1/6
- Harbor run evals: https://www.harborframework.com/docs/run-jobs/run-evals

