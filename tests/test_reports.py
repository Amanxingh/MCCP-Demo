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


# --------------------------------------------------------------------------
# Sanity — these pass on the untouched starter kit
# --------------------------------------------------------------------------
def test_seed_is_deterministic(conn, tmp_path):
    other = dbmod.build_db(str(tmp_path / "test2.db"))
    a = conn.execute("SELECT COUNT(*) FROM order_items").fetchone()[0]
    b = other.execute("SELECT COUNT(*) FROM order_items").fetchone()[0]
    assert a == b == 91


def test_revenue_by_category_sanity(conn):
    rows = reports.revenue_by_category(conn)
    cats = [c for c, _ in rows]
    assert cats == sorted(cats, key=lambda c: -dict(rows)[c])
    assert set(cats) == {"electronics", "lifestyle", "stationery"}


# --------------------------------------------------------------------------
# T1 — planted bug
# --------------------------------------------------------------------------
def test_monthly_revenue_counts_completed_only(conn):
    assert reports.monthly_revenue(conn) == [('2026-01', 26780.0), ('2026-02', 34779.5), ('2026-03', 32197.0), ('2026-04', 36489.0)]


# --------------------------------------------------------------------------
# T2 — Python gaps
# --------------------------------------------------------------------------
def test_monthly_running_total(conn):
    assert reports.monthly_running_total(conn) == [('2026-01', 26780.0, 26780.0), ('2026-02', 34779.5, 61559.5), ('2026-03', 32197.0, 93756.5), ('2026-04', 36489.0, 130245.5)]


def test_top_customers(conn):
    assert reports.top_customers(conn, 5) == [('Rohan Iyer', 'Bengaluru', 30378.5), ('Sana Qureshi', 'Delhi', 29863.0), ('Vikram Bose', 'Kolkata', 27445.0), ('Meera Nair', 'Kochi', 19341.0), ('Kabir Shah', 'Mumbai', 14383.0)]
    assert len(reports.top_customers(conn, 3)) == 3


def test_iter_completed_items_is_generator(conn):
    import types
    gen = reports.iter_completed_items(conn)
    assert isinstance(gen, types.GeneratorType)
    items = list(gen)
    assert len(items) == 69
    assert items[0] == {'order_id': 1, 'month': '2026-01', 'product': 'Desk Lamp', 'category': 'electronics', 'qty': 2, 'unit_price': 899.0, 'amount': 1798.0}
    assert all(set(it) == {"order_id", "month", "product", "category",
                           "qty", "unit_price", "amount"} for it in items)


def test_sales_summary_class(conn):
    rows = reports.monthly_revenue(conn)
    s = reports.SalesSummary(rows)
    assert len(s) == 4
    assert repr(s) == "SalesSummary(months=4, total=130245.50)"
    assert s.total_revenue == 130245.5
    assert s.best_month() == ('2026-04', 36489.0)


def test_timed_decorator_logs(conn, caplog):
    import logging
    wrapped = reports.timed(reports.revenue_by_category)
    with caplog.at_level(logging.INFO, logger="orderly.reports"):
        result = wrapped(conn)
    assert result == reports.revenue_by_category(conn)
    assert any("revenue_by_category" in r.message and "ms" in r.message
               for r in caplog.records)


def test_write_report_roundtrip(conn, tmp_path):
    rows = reports.monthly_revenue(conn)
    out = tmp_path / "nested" / "monthly.csv"
    path = reports.write_report(rows, out, ("month", "revenue"))
    with open(path, newline="", encoding="utf-8") as fh:
        lines = fh.read().strip().splitlines()
    assert lines[0] == "month,revenue"
    assert len(lines) == 1 + len(rows)
    assert lines[1] == "2026-01,26780.0"


def test_write_report_empty_raises(tmp_path):
    with pytest.raises(ValueError):
        reports.write_report([], tmp_path / "empty.csv", ("a", "b"))
