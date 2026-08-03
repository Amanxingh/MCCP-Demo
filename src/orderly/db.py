"""Database helpers for Orderly.

The app uses SQLite from the Python standard library only. Seed data lives
in data/seed.sql and is fully deterministic: building the database twice
always yields identical content.
"""

from __future__ import annotations

import os
import sqlite3
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[2]
SEED_SQL = PROJECT_ROOT / "data" / "seed.sql"


def normalize_path(p: str) -> str:
    """Normalise Git Bash style paths (/c/...) for native Windows Python.

    When a script is invoked from Git Bash on Windows, path arguments may
    arrive as /c/Users/... which the native interpreter cannot open. Convert
    them to C:/Users/... form when running on Windows (os.name == 'nt').
    On Linux/macOS the path is returned unchanged.
    """
    if not p:
        return p
    if os.name == "nt" and len(p) >= 3 and p[0] == "/" and p[2] == "/" and p[1].isalpha():
        return p[1].upper() + ":/" + p[3:]
    return p


def build_db(db_path: str) -> sqlite3.Connection:
    """(Re)build the SQLite database from data/seed.sql and return a connection."""
    db_path = normalize_path(str(db_path))
    if os.path.exists(db_path):
        os.remove(db_path)
    conn = sqlite3.connect(db_path)
    with open(SEED_SQL, "r", encoding="utf-8") as fh:
        conn.executescript(fh.read())
    conn.commit()
    return conn


def connect(db_path: str) -> sqlite3.Connection:
    """Open an existing Orderly database."""
    db_path = normalize_path(str(db_path))
    if not os.path.exists(db_path):
        raise FileNotFoundError(
            f"Database not found: {db_path}. Build it first: python -m orderly.cli seed --db <path>"
        )
    return sqlite3.connect(db_path)
