"""Orderly environment self-check.

Run this FIRST (see TASKS.md, Task T0):
    python verify_env.py

Exit code 0 = environment is usable. Warnings are printed for things you
are expected to fix as part of the tasks (e.g. git identity).
"""

from __future__ import annotations

import os
import shutil
import sqlite3
import subprocess
import sys

PASS, WARN, FAIL = "PASS", "WARN", "FAIL"
results = []


def report(status, label, detail=""):
    results.append((status, label, detail))
    print(f"[{status}] {label}" + (f" — {detail}" if detail else ""))


def normalize_path(p: str) -> str:
    """Convert Git Bash /c/... paths to C:/... on Windows (os.name == 'nt')."""
    if not p:
        return p
    if os.name == "nt" and len(p) >= 3 and p[0] == "/" and p[2] == "/" and p[1].isalpha():
        return p[1].upper() + ":/" + p[3:]
    return p


def check_python():
    v = sys.version_info
    if v >= (3, 10):
        report(PASS, "Python version", f"{v.major}.{v.minor}.{v.micro}")
    else:
        report(FAIL, "Python version", f"{v.major}.{v.minor}.{v.micro} — need >= 3.10")


def check_sqlite():
    try:
        conn = sqlite3.connect(":memory:")
        conn.execute("SELECT sqlite_version()")
        report(PASS, "sqlite3 module", sqlite3.sqlite_version)
    except Exception as exc:  # pragma: no cover
        report(FAIL, "sqlite3 module", str(exc))


def check_git():
    git = shutil.which("git")
    if not git:
        report(FAIL, "git on PATH", "git executable not found")
        return
    out = subprocess.run(["git", "--version"], capture_output=True, text=True)
    report(PASS, "git on PATH", out.stdout.strip())
    name = subprocess.run(["git", "config", "--get", "user.name"],
                          capture_output=True, text=True).stdout.strip()
    email = subprocess.run(["git", "config", "--get", "user.email"],
                           capture_output=True, text=True).stdout.strip()
    if name and email:
        report(PASS, "git identity", f"{name} <{email}>")
    else:
        report(WARN, "git identity",
               "user.name / user.email not set — set them as part of Task T0")


def check_pytest():
    try:
        import pytest  # noqa: F401
        report(PASS, "pytest importable", pytest.__version__)
    except ImportError:
        report(WARN, "pytest importable",
               "run: pip install --no-index --find-links=vendor pytest")


def check_layout():
    here = os.path.dirname(os.path.abspath(__file__))
    expected = ["src/orderly", "tests", "data/seed.sql", "TASKS.md", "README.md"]
    missing = [e for e in expected if not os.path.exists(os.path.join(here, e))]
    if missing:
        report(FAIL, "project layout", "missing: " + ", ".join(missing))
    else:
        report(PASS, "project layout", "all expected paths present")


def check_path_norm():
    sample = normalize_path("/c/Users/example/orderly")
    if os.name == "nt":
        ok = sample == "C:/Users/example/orderly"
        report(PASS if ok else FAIL, "Git Bash path normalisation",
               f"/c/Users/example/orderly -> {sample}")
    else:
        report(PASS, "Git Bash path normalisation", "no-op on this OS (correct)")


def main():
    print("Orderly environment self-check")
    print("=" * 40)
    check_python()
    check_sqlite()
    check_git()
    check_pytest()
    check_layout()
    check_path_norm()
    print("=" * 40)
    fails = sum(1 for s, _, _ in results if s == FAIL)
    warns = sum(1 for s, _, _ in results if s == WARN)
    print(f"{len(results)} checks: {len(results)-fails-warns} pass, {warns} warn, {fails} fail")
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
