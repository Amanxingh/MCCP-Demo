"""Orderly test suite — expected values are baked in from the deterministic
seed data (data/seed.sql). Do not edit expected values to make tests pass."""

import os
import sqlite3
import sys

import pytest

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "src"))

from orderly import db as dbmod          # noqa: E402
from orderly import reports              # noqa: E402


@pytest.fixture()
def conn(tmp_path):
    c = dbmod.build_db(str(tmp_path / "test.db"))
    yield c
    c.close()


def load_query(name):
    path = os.path.join(os.path.dirname(__file__), "..", "src", "orderly", "queries.sql")
    with open(path, "r", encoding="utf-8") as fh:
        text = fh.read()
    import re
    parts = re.split(r"^-- @query: (\w+)\s*$", text, flags=re.M)
    for i in range(1, len(parts), 2):
        if parts[i] == name:
            return parts[i + 1]
    raise KeyError(f"query not found: {name}")


def _run(conn, name):
    return conn.execute(load_query(name)).fetchall()


def test_q1_monthly_revenue(conn):
    rows = [(m, round(r, 2), c) for m, r, c in _run(conn, "monthly_revenue")]
    assert rows == [('2026-01', 26780.0, 5), ('2026-02', 34779.5, 8), ('2026-03', 32197.0, 8), ('2026-04', 36489.0, 6)]


def test_q2_top_products_per_month(conn):
    rows = [(m, p, int(q), int(r)) for m, p, q, r in _run(conn, "top_products_per_month")]
    assert rows == [('2026-01', 'Water Bottle 750ml', 9, 1), ('2026-01', 'Desk Lamp', 6, 2), ('2026-02', 'Sticky Notes', 12, 1), ('2026-02', 'USB-C Cable 1m', 12, 2), ('2026-03', 'USB-C Cable 1m', 12, 1), ('2026-03', 'Notebook A5', 11, 2), ('2026-04', 'Keyboard Compact', 10, 1), ('2026-04', 'Travel Mug', 9, 2)]


def test_q3_customers_without_orders(conn):
    rows = [(n, c) for n, c in _run(conn, "customers_without_orders")]
    assert rows == [('Arjun Pillai', 'Bengaluru'), ('Priya Kulkarni', 'Pune')]
