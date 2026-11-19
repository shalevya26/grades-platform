"""grades-report: reads a CSV of grades and prints a one-line summary.

    python report.py data/grades.csv
"""

import csv
import os
import sys

PASS_MARK = 60
APP_VERSION = os.getenv("APP_VERSION", "dev")


def load(path: str) -> list[float]:
    with open(path, newline="") as f:
        return [float(row["grade"]) for row in csv.DictReader(f)]


def summary(grades: list[float]) -> dict:
    if not grades:
        raise ValueError("no grades")
    passed = sum(1 for g in grades if g >= PASS_MARK)
    return {
        "count": len(grades),
        "average": round(sum(grades) / len(grades), 1),
        "pass_rate": round(100 * passed / len(grades), 1),
    }


def main(argv: list[str]) -> int:
    path = argv[1] if len(argv) > 1 else "data/grades.csv"
    s = summary(load(path))
    print(
        f"grades-report {APP_VERSION}: count={s['count']} "
        f"average={s['average']} pass_rate={s['pass_rate']}%"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
