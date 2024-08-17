/*Creation*/
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

/*Insertion*/
INSERT INTO Users (user_id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

INSERT INTO Songs (song_id, title, artist, genre) VALUES
(1, 'Song A', 'Artist 1', 'Pop'),
(2, 'Song B', 'Artist 2', 'Rock'),
(3, 'Song C', 'Artist 3', 'Jazz'),
(4, 'Song D', 'Artist 4', 'Pop'),
(5, 'Song E', 'Artist 5', 'Rock');

INSERT INTO Ratings (user_id, song_id, rating) VALUES
(1, 1, 5.0),
(1, 2, 3.0),
(1, 3, 4.0),
(2, 1, 2.0),
(2, 3, 5.0),
(2, 4, 4.0),
(3, 2, 4.0),
(3, 3, 2.0),
(3, 5, 5.0);

/*Create View*/
CREATE VIEW UserAverageRatings AS
SELECT
    user_id,
    AVG(rating) AS avg_rating
FROM
    Ratings
GROUP BY
    user_id;

CREATE VIEW UserSimilarities AS
SELECT
    r1.user_id AS user1_id,
    r2.user_id AS user2_id,
    SUM((r1.rating - u1.avg_rating) * (r2.rating - u2.avg_rating)) / 
    (SQRT(SUM((r1.rating - u1.avg_rating) * (r1.rating - u1.avg_rating))) * 
     SQRT(SUM((r2.rating - u2.avg_rating) * (r2.rating - u2.avg_rating)))) AS similarity
FROM
    Ratings r1
JOIN
    Ratings r2 ON r1.song_id = r2.song_id AND r1.user_id != r2.user_id
JOIN
    UserAverageRatings u1 ON r1.user_id = u1.user_id
JOIN
    UserAverageRatings u2 ON r2.user_id = u2.user_id
GROUP BY
    r1.user_id, r2.user_id;

CREATE VIEW Recommendations AS
SELECT
    r2.song_id,
    SUM(r1.rating * us.similarity) / SUM(us.similarity) AS score
FROM
    Ratings r1
JOIN
    UserSimilarities us ON r1.user_id = us.user1_id
JOIN
    Ratings r2 ON us.user2_id = r2.user_id AND r1.song_id != r2.song_id
WHERE
    us.user1_id = 1  -- Specify the user ID for whom recommendations are being generated
GROUP BY
    r2.song_id
ORDER BY
    score DESC;

/*Final Recommendation*/
SELECT
    s.song_id,
    s.title,
    s.artist,
    s.genre,
    r.score
FROM
    Songs s
JOIN
    Recommendations r ON s.song_id = r.song_id
ORDER BY
    r.score DESC
LIMIT 10;


