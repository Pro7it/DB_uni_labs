CREATE TABLE tmp (
  id SERIAL PRIMARY KEY,
  value INTEGER
);

INSERT INTO tmp (value)
SELECT (random() * 1000)::int
FROM generate_series(1, 10000);
