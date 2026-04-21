-- =============================================
-- Movie Review & Rating System — Database Schema
-- =============================================

CREATE DATABASE IF NOT EXISTS movieapp;
USE movieapp;

-- -----------------------------------------------
-- Users table
-- -----------------------------------------------
CREATE TABLE users (
    id          BIGINT          AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)     NOT NULL UNIQUE,
    email       VARCHAR(100)    NOT NULL UNIQUE,
    password    VARCHAR(255)    NOT NULL,
    role        VARCHAR(20)     NOT NULL DEFAULT 'USER',
    created_at  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_role CHECK (role IN ('USER', 'ADMIN'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------
-- Movies table
-- -----------------------------------------------
CREATE TABLE movies (
    id              BIGINT          AUTO_INCREMENT PRIMARY KEY,
    title           VARCHAR(200)    NOT NULL,
    description     TEXT,
    genre           VARCHAR(50)     NOT NULL,
    release_year    INT             NOT NULL,
    poster_url      VARCHAR(500),
    average_rating  DOUBLE          NOT NULL DEFAULT 0.0,
    review_count    INT             NOT NULL DEFAULT 0,
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_genre (genre),
    INDEX idx_release_year (release_year),
    INDEX idx_average_rating (average_rating)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------
-- Reviews table
-- -----------------------------------------------
CREATE TABLE reviews (
    id          BIGINT      AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT      NOT NULL,
    movie_id    BIGINT      NOT NULL,
    rating      INT         NOT NULL,
    comment     TEXT        NOT NULL,
    created_at  TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_review_user  FOREIGN KEY (user_id)  REFERENCES users(id)  ON DELETE CASCADE,
    CONSTRAINT fk_review_movie FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE,
    CONSTRAINT uq_user_movie   UNIQUE (user_id, movie_id),
    CONSTRAINT chk_rating      CHECK (rating BETWEEN 1 AND 5),

    INDEX idx_movie_id (movie_id),
    INDEX idx_user_id (user_id),
    INDEX idx_rating (rating)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
