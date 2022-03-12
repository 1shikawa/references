CREATE TABLE article (
    id bigserial NOT NULL
    , title varchar NOT NULL
    , author varchar NOT NULL
    , body text NOT NULL
    , CONSTRAINT article_id_pkc PRIMARY KEY (id)
);
