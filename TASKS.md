# Orderly — L1 hands-on tasks

Work through the tasks in order. Commit early and often with meaningful
messages. You may use AI tools — you are expected to understand and be able
to explain every line you keep. Tests are the ground truth:

    python -m pytest -q

Some tests fail at the start. That is deliberate.

## T0 — Environment & repository setup
1. Run `python verify_env.py` and resolve every `FAIL`. (`WARN` for pytest
   means: `pip install --no-index --find-links=vendor pytest`.)
2. This laptop has no git identity configured. Set `user.name` and
   `user.email` (global), then verify `verify_env.py` reports PASS.
3. Make sure the working tree is clean before you start coding
   (`git status`). If `verify_env.py` output or the environment check left
   anything untracked that should not be committed, handle it.

## T1 — Bug fix on a branch + merge
1. The test `test_monthly_revenue_counts_completed_only` fails: revenue is
   overstated. Find the planted bug marked `TODO(T1)` in
   `src/orderly/reports.py` and fix it so the test passes.
2. Do the work on a new branch named `fix/monthly-revenue`, with at least
   one well-written commit.
3. Merge `fix/monthly-revenue` back into `main`.
4. Then merge the existing branch `feature/top-customers` into `main`.
   It will conflict with your fix — resolve the conflict so that
   **both** the corrected revenue logic and the branch's changes survive,
   then complete the merge with a merge commit. All tests must pass after
   the merge.

## T2 — Python gaps (src/orderly/reports.py)
Implement every `TODO(T2x)` in `reports.py`. Each function's docstring is
its specification; the tests encode the expected values. Keep the code
modular, handle the documented error case, and use the `logging` module
(not `print`) where the docstring asks for logging.

## T3 — SQL gaps (src/orderly/queries.sql)
Replace the three placeholder queries marked `TODO(T3-Q1..Q3)`. Follow the
marker comments exactly (column names matter — the tests read them). Run
`python -m pytest tests/test_queries.py -q` to check.

## T4 — Shell runner (run_report.sh)
Complete the four `TODO(T4x)` steps in `run_report.sh` so it runs end to
end from Git Bash. It must detect the Python interpreter itself (try
`python3`, then `python`, then `py` — never hard-code one) and must archive
the reports with `tar`. Run it and keep the output it prints.

## T5 — Container image (Dockerfile)
Complete `Dockerfile` following the hints in the file. If Docker Desktop is
available, build the image (`docker build -t orderly:l1 .`) and run it; if
it is not available, make sure the Dockerfile is complete and correct on
paper — the evaluator has a static grading path with identical points.

## T6 — CI workflow (.github/workflows/ci.yml)
The workflow file has deliberate defects (marked FIXME). Rewrite it into a
sane CI pipeline: correct trigger, checkout, a current Python 3.12 setup,
dependencies installed from `vendor/` (offline), and the test suite as a
gate. You cannot push to a remote here — correctness of the YAML is what
counts, and `python -m pytest -q` locally is your proxy for the pipeline.

## T7 — Documentation (README.md)
Fill in the three `TODO(T7x)` sections of `README.md`: setup from zero,
usage examples for both CLI commands, and at least two real troubleshooting
entries (problems you actually hit today).

## Submission
When you are done (or time is called):
1. Make sure all your work is committed (`git status` clean).
2. From Git Bash in the project root, create the submission archive:
   `tar -czf orderly-submission.tar.gz .`
   (Windows' built-in bsdtar handles `.tar.gz` fine.)
3. Hand `orderly-submission.tar.gz` to the evaluator as instructed.
