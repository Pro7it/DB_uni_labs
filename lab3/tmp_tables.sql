CREATE TABLE consil (
    lector_id INTEGER REFERENCES lector(id),
    PRIMARY KEY (lector_id)
);

