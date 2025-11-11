import psycopg2
import os
from pathlib import Path

conn = psycopg2.connect(
    host="localhost",
    database="mydb",
    user=os.environ['DB_USER_NAME'],
    password=os.environ['DB_USER_PASSWORD']
)

cur = conn.cursor()

migration_path = Path(__file__).parent / "migrations"
sql_files = sorted(migration_path.glob("*.sql"))
print(sql_files)

for file in sql_files:
    with open(file, "r") as f:
        sql = f.read()
        try:
            cur.execute(sql)
            conn.commit()
        except:
            conn.rollback()
            break

cur.close()
conn.close()