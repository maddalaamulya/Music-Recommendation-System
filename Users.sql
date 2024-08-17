CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE Songs (
    song_id INT PRIMARY KEY,
    title VARCHAR(100),
    artist VARCHAR(100),
    genre VARCHAR(50)
);

CREATE TABLE Ratings (
    user_id INT,
    song_id INT,
    rating FLOAT,
    PRIMARY KEY (user_id, song_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (song_id) REFERENCES Songs(song_id)
);
