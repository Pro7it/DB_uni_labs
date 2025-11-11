DROP TABLE IF EXISTS anime_genre;
DROP TABLE IF EXISTS anime;
DROP TABLE IF EXISTS genre;

CREATE TABLE anime (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    score FLOAT,
    episodes INT,
    synopsis TEXT,
    popularity INT,
    members BIGINT,
    studious VARCHAR(255),
    year INT
);

CREATE TABLE genre (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE
);

CREATE TABLE anime_genre (
    anime_id INT REFERENCES anime(id) ON DELETE CASCADE,
    genre_id INT REFERENCES genre(id) ON DELETE CASCADE,
    PRIMARY KEY (anime_id, genre_id)
)