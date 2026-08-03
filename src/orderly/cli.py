"""Orderly command line interface.

Usage examples (from the project root):
    python -m orderly.cli seed --db out/orderly.db
    python -m orderly.cli report --db out/orderly.db --out out/reports
"""

from __future__ import annotations

import argparse
import logging
import os
import sys

from . import db as dbmod
from . import reports


def main(argv=None) -> int:
    logging.basicConfig(level=logging.INFO, format="%(levelname)s %(name)s: %(message)s")
    parser = argparse.ArgumentParser(prog="orderly", description="Retail order analytics")
    sub = parser.add_subparsers(dest="command", required=True)

    p_seed = sub.add_parser("seed", help="build the SQLite database from data/seed.sql")
    p_seed.add_argument("--db", required=True, help="path of the database file to create")

    p_report = sub.add_parser("report", help="write monthly revenue report CSVs")
    p_report.add_argument("--db", required=True, help="path of the database file")
    p_report.add_argument(
        "--out",
        default=os.environ.get("ORDERLY_OUT", "out/reports"),
        help="output directory (env ORDERLY_OUT overrides the default)",
    )

    args = parser.parse_args(argv)

    if args.command == "seed":
        path = dbmod.build_db(args.db)
        print(f"database built at {dbmod.normalize_path(args.db)}")
        return 0

    if args.command == "report":
        conn = dbmod.connect(args.db)
        rows = reports.monthly_revenue(conn)
        out = dbmod.normalize_path(args.out)
        path = reports.write_report(
            rows, os.path.join(out, "monthly_revenue.csv"), ("month", "revenue")
        )
        print(f"wrote {path}")
        return 0

    return 1


if __name__ == "__main__":
    sys.exit(main())
