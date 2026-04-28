"""
国土地理院 指定緊急避難場所・指定避難所 CSV → SQLite インポートスクリプト

使い方:
  pip install sqlite3 (標準ライブラリ)
  python import_shelter_csv.py --csv shelter.csv --db shelters.db

CSV フォーマット: 国土地理院公開フォーマット準拠
  lat,lng,name,address,disaster_types,capacity
"""
import argparse
import csv
import sqlite3
import sys
from pathlib import Path


def create_tables(conn: sqlite3.Connection) -> None:
    conn.executescript("""
        CREATE TABLE IF NOT EXISTS shelters (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            lat REAL NOT NULL,
            lng REAL NOT NULL,
            address TEXT,
            disaster_types TEXT,
            capacity INTEGER
        );
        CREATE VIRTUAL TABLE IF NOT EXISTS shelters_rtree USING rtree(
            id,
            min_lat, max_lat,
            min_lng, max_lng
        );
    """)


def import_csv(conn: sqlite3.Connection, csv_path: Path) -> int:
    count = 0
    with csv_path.open(encoding="utf-8-sig") as f:
        reader = csv.DictReader(f)
        for row in reader:
            try:
                lat = float(row["lat"])
                lng = float(row["lng"])
            except (KeyError, ValueError):
                print(f"Skipping row with invalid lat/lng: {row}", file=sys.stderr)
                continue

            conn.execute(
                """
                INSERT OR REPLACE INTO shelters
                    (name, lat, lng, address, disaster_types, capacity)
                VALUES (?, ?, ?, ?, ?, ?)
                """,
                [
                    row.get("name", ""),
                    lat,
                    lng,
                    row.get("address"),
                    row.get("disaster_types", ""),
                    int(row["capacity"]) if row.get("capacity") else None,
                ],
            )
            shelter_id = conn.execute("SELECT last_insert_rowid()").fetchone()[0]
            conn.execute(
                """
                INSERT OR REPLACE INTO shelters_rtree
                    (id, min_lat, max_lat, min_lng, max_lng)
                VALUES (?, ?, ?, ?, ?)
                """,
                [shelter_id, lat, lat, lng, lng],
            )
            count += 1

    return count


def main() -> None:
    parser = argparse.ArgumentParser(description="Import shelter CSV into SQLite")
    parser.add_argument("--csv", required=True, help="Path to CSV file")
    parser.add_argument("--db", required=True, help="Path to SQLite DB file")
    args = parser.parse_args()

    csv_path = Path(args.csv)
    if not csv_path.exists():
        print(f"CSV file not found: {csv_path}", file=sys.stderr)
        sys.exit(1)

    with sqlite3.connect(args.db) as conn:
        create_tables(conn)
        count = import_csv(conn, csv_path)
        conn.commit()

    print(f"Imported {count} shelters into {args.db}")


if __name__ == "__main__":
    main()
