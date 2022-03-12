CREATE TABLE accesscount (
    id bigserial NOT NULL
    , article_id bigint NOT NULL
    , uid char(256) NOT NULL
    , access_at timestamp with time zone NOT NULL
    , CONSTRAINT accesscount_id_pkc PRIMARY KEY (id)
);
