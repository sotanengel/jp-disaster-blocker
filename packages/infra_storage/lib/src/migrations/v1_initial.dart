const String v1Initial = '''
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

CREATE TABLE IF NOT EXISTS route_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  shelter_id INTEGER NOT NULL,
  visited_at INTEGER NOT NULL,
  FOREIGN KEY(shelter_id) REFERENCES shelters(id)
);
''';
