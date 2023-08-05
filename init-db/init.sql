CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS language (
    id INT PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    code VARCHAR(10) NOT NULL
);

CREATE TABLE IF NOT EXISTS text_content (
    id INT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    orig_text TEXT NOT NULL,
    orig_lang_id INTEGER references language (id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS translation (
    content_id INT references text_content (id) ON DELETE CASCADE ON UPDATE CASCADE,
    lang_id INT references language (id) ON DELETE CASCADE ON UPDATE CASCADE,
    text TEXT NOT NULL,
    PRIMARY KEY (content_id, lang_id)
);

CREATE INDEX translation_idx ON translation (content_id, lang_id);

CREATE TABLE IF NOT EXISTS category (
    id INT PRIMARY KEY,
    name_id INT references text_content (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS sub_category (
    id INT PRIMARY KEY,
    category_id INT references category (id) ON DELETE SET NULL ON UPDATE CASCADE,
    name_id INT references text_content (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS form (
    id INT PRIMARY KEY,
    category_id INT references category (id) ON DELETE SET NULL ON UPDATE CASCADE,
    name_id INT references text_content (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS artwork (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    name_id INT references text_content (id),
    description_id INT references text_content (id),
    release_date DATE,
    category_id INT references category (id) ON DELETE SET NULL ON UPDATE CASCADE,
    sub_category_id INT references category (id) ON DELETE SET NULL ON UPDATE CASCADE,
    form_id INT references category (id) ON DELETE SET NULL ON UPDATE CASCADE,
    duration TIME,
    country VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS genre (
    id INT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    category_id INT references category (id) ON DELETE SET NULL ON UPDATE CASCADE,
    name_id INT references text_content (id) ON UPDATE CASCADE,
    description_id INT references text_content (id) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS artwork_genre(
    genre_id INT references genre (id) ON UPDATE CASCADE,
    artwork_id uuid references artwork (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (genre_id, artwork_id)
);

CREATE TABLE IF NOT EXISTS person (
    id INT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    first_name_id INT references text_content (id),
    last_name_id INT references text_content (id),
    bio_id INT references text_content (id),
    birth_place_id INT references text_content (id),
    birth_date DATE
);


CREATE TABLE IF NOT EXISTS role (
    id INT PRIMARY KEY,
    name VARCHAR (50) NOT NULL
);

CREATE TABLE IF NOT EXISTS character (
    id INT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(150) NOT NULL
);

CREATE TABLE IF NOT EXISTS participant (
    id INT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    person_id INT references person (id),
    artwork_id uuid references artwork (id) ON UPDATE CASCADE NOT NULL,
    role_id INT references role (id) NOT NULL,
    character_id INT references character (id)
);

CREATE TABLE IF NOT EXISTS playlist (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    creator_id VARCHAR(100) NOT NULL,
    name VARCHAR(100) NOT NULL,
    description VARCHAR (250),
    public BOOLEAN DEFAULT FALSE NOT NULL
);

CREATE TABLE IF NOT EXISTS playlist_item (
    playlist_id uuid references playlist (id) ON DELETE CASCADE NOT NULL,
    artwork_id uuid references artwork (id) ON DELETE CASCADE NOT NULL,
    PRIMARY KEY (playlist_id, artwork_id)
);

CREATE TABLE IF NOT EXISTS user_playlist (
    playlist_id uuid references playlist (id) ON DELETE CASCADE NOT NULL,
    user_id VARCHAR(100) NOT NULL,
    PRIMARY KEY (playlist_id, user_id)
);

CREATE TABLE IF NOT EXISTS rating (
    id INT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    artwork_id uuid references artwork (id) ON DELETE CASCADE NOT NULL,
    user_id VARCHAR(100) NOT NULL,
    score INT NOT NULL,
    date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS review (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id VARCHAR(100) NOT NULL,
    artwork_id uuid references artwork (id) ON DELETE SET NULL,
    content TEXT NOT NULL,
    lang_id INT references language (id)
);

CREATE TABLE IF NOT EXISTS note (
    id INT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    user_id VARCHAR(100) NOT NULL,
    artwork_id uuid references artwork (id) ON DELETE SET NULL,
    name VARCHAR(100),
    description TEXT
);

CREATE TABLE IF NOT EXISTS tag (
    id INT PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    user_id VARCHAR(100) NOT NULL,
    name VARCHAR(80) NOT NULL
);

CREATE TABLE IF NOT EXISTS note_tag (
    tag_id INT references tag (id) ON DELETE CASCADE NOT NULL,
    note_id INT references note (id) ON DELETE CASCADE NOT NULL,
    PRIMARY KEY (tag_id, note_id)
);


