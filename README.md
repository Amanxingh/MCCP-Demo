# Orderly

Orderly is a small command-line tool that builds a SQLite database of retail
orders and produces sales reports (monthly revenue, top customers, category
breakdowns).

<!-- TODO(T7a): complete the "Setup" section below — a new teammate must be
     able to get from zero to a passing test run using only this README. -->

## Setup


### Requirements
- Python 3.12
- Git
- Docker Desktop (optional)

### Installation

1. Create a virtual environment:
   ```bash
   python -m venv .venv
   ```

2. Activate it in Git Bash:
   ```bash
   source .venv/Scripts/activate
   ```

3. Install pytest:
   ```bash
   python -m pip install --no-index --find-links=vendor pytest
   ```

4. Check the environment:
   ```bash
   python verify_env.py
   ```



## Usage

<!-- TODO(T7b): document the two CLI commands below (seed, report) with one
     copy-pasteable example each, including what output is produced and
     where. -->

### 1. Generate Reports

Run from the `orderly` project folder using Git Bash:

```bash
bash run_report.sh
```

This creates the SQLite database, generates the monthly revenue CSV report, and archives the reports.

### 2. Run All Tests

```bash
python -m pytest -q
```

This runs the complete test suite.

### 3. Run SQL Query Tests Only

```bash
python -m pytest tests/test_queries.py -v
```

This tests the three analytical SQL queries.


> **Running the CLI:** the package lives under `src/`, so when you run CLI
> commands directly from Git Bash, prefix them with `PYTHONPATH=src`, e.g.
> `PYTHONPATH=src python -m orderly.cli seed --db out/orderly.db`.

## Project layout

| Path | Purpose |
|---|---|
| `src/orderly/` | application package (`db`, `reports`, `cli`) |
| `data/seed.sql` | deterministic seed data — do not edit |
| `tests/` | pytest suite with expected values baked in |
| `vendor/` | vendored wheels for offline installs |
| `verify_env.py` | environment self-check |
| `run_report.sh` | one-shot report runner (Task T4) |

## Troubleshooting

<!-- TODO(T7c): add at least two troubleshooting entries covering problems
     you actually hit during this exercise (symptom + cause + fix). -->


### Problem 1: Python module not found

**Error:** `ModuleNotFoundError: No module named 'orderly'`

**Cause:** The Python package is inside the `src` directory.

**Solution (Git Bash):**

```bash
export PYTHONPATH="$PWD/src"
```

Run this command from the project root, then retry the Python command.

### Problem 2: Docker Engine connection failed

**Error:** `failed to connect to the docker API`

**Cause:** Docker Desktop was not running or its engine was not ready.

**Solution:**

1. Start Docker Desktop.
2. Wait for the engine to start.
3. Verify the connection:

   ```bash
   docker info
   ```

4. Retry the image build:

   ```bash
   docker build -t orderly:l1 .
   ```

### Problem 3: GitHub Actions tests failed

**Problem:** The setup steps passed, but the test step failed.

**Solution:**

1. Open the failed `Run tests` step in GitHub Actions.
2. Read the first error message.
3. Run tests locally:

   ```bash
   python -m pytest -q
   ```

4. Fix the failing test or code, then commit and push the correction.

