import psycopg2
import pandas as pd
import os
import ast

conn = psycopg2.connect(
    host="localhost",
    database="mydb",
    user=os.environ['DB_USER_NAME'],
    password=os.environ['DB_USER_PASSWORD']
)
cur = conn.cursor()

# E
df = pd.read_csv("anime_dataset.csv")

# T
df = df.dropna()
df['studios'] = df['studios'].apply(lambda x: ast.literal_eval(x)[0] if pd.notnull(x) else None)
df['genres'] = df['genres'].apply(lambda x: ast.literal_eval(x) if pd.notnull(x) else None)
studios = sorted({s for s in df['studios']})
genres = sorted({g for sublist in df['genres'] for g in sublist})

# L
for studio in studios:
    cur.execute("INSERT INTO studio(name) VALUES (%s)",
    (studio,))

for genre in genres:
    cur.execute("INSERT INTO genre(name) VALUES (%s)",
    (genre,))

for _, row in df.iterrows():

    cur.execute("SELECT id FROM studio WHERE name = %s", (row['studios'],))
    studio_id = cur.fetchone()[0]

    cur.execute("""
        INSERT INTO anime (title, score, episodes, synopsis, popularity, members, studio_id, year)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        RETURNING id;
    """, (
        row["title"],
        row["score"],
        row["episodes"],
        row["synopsis"],
        row["popularity"],
        row["members"],
        studio_id,
        row["year"],
    ))

    anime_id = cur.fetchone()[0];

    for g in row['genres']:
        cur.execute("SELECT id FROM genre WHERE name = %s;", (g,))
        genre_id = cur.fetchone()[0]
        cur.execute(
            "INSERT INTO anime_genre (anime_id, genre_id) VALUES (%s, %s);",
            (anime_id, genre_id)
        )

conn.commit()
cur.close()
conn.close()