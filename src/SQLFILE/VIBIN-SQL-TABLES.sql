CREATE DATABASE loginjsp;
use loginjsp;

CREATE TABLE user (
                      id INT AUTO_INCREMENT PRIMARY KEY,
                      name VARCHAR(100) NOT NULL,
                      email VARCHAR(100) NOT NULL UNIQUE,
                      password VARCHAR(255) NOT NULL,
                      contact_no VARCHAR(20)
);

CREATE TABLE albums (
                        album_id INT AUTO_INCREMENT PRIMARY KEY,
                        album_name VARCHAR(150) NOT NULL,
                        artist VARCHAR(100),
                        release_date DATE,
                        genre VARCHAR(50)
);

CREATE TABLE songs (
                       song_id INT AUTO_INCREMENT PRIMARY KEY,
                       song_name VARCHAR(150) NOT NULL,
                       lyricist VARCHAR(100),
                       singer VARCHAR(100),
                       music_director VARCHAR(100),
                       album_id INT,
                       FOREIGN KEY (album_id) REFERENCES albums(album_id) ON DELETE SET NULL
);
CREATE TABLE liked_songs (
                             user_id INT,
                             song_id INT,
                             PRIMARY KEY (user_id, song_id),
                             FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
                             FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE
);
insert into liked_songs
values (1,2);
DESCRIBE user;

SELECT * FROM songs;
SELECT * FROM albums;
SELECT * FROM user;


-- Insert sample data into albums table
INSERT INTO albums (album_name, artist, release_date, genre) VALUES
                                                                 ('Ash', 'Ashwin Indeewara', '2025-04-30', 'Sake');

CREATE TABLE playlists (
                           playlist_id INT AUTO_INCREMENT PRIMARY KEY,
                           playlist_name VARCHAR(150) NOT NULL,
                           user_id INT,
                           created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
                           description TEXT,
                           FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
);

CREATE TABLE playlist_songs (
                                playlist_id INT,
                                song_id INT,
                                added_date DATETIME DEFAULT CURRENT_TIMESTAMP,
                                PRIMARY KEY (playlist_id, song_id),
                                FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id) ON DELETE CASCADE,
                                FOREIGN KEY (song_id) REFERENCES songs(song_id) ON DELETE CASCADE
);

SELECT *from playlists;

CREATE TABLE artists (
                         artist_id INT AUTO_INCREMENT PRIMARY KEY,
                         artist_name VARCHAR(150) NOT NULL,
                         bio TEXT,
                         image_url VARCHAR(255),
                         genre VARCHAR(100),
                         country VARCHAR(100),
                         created_date DATETIME DEFAULT CURRENT_TIMESTAMP
);
SELECT *FROM songs;

CREATE TABLE admin (
                       admin_id INT AUTO_INCREMENT PRIMARY KEY,
                       username VARCHAR(100) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       name VARCHAR(100) NOT NULL,
                       email VARCHAR(100) UNIQUE,
                       role VARCHAR(20) DEFAULT 'admin',
                       last_login DATETIME
);

-- Insert default admin user
INSERT INTO admin (username, password, name, email, role)
VALUES ('admin', '123', 'System Administrator', 'admin@vibin.com', 'admin');


CREATE TABLE artist_login (
                              id INT AUTO_INCREMENT PRIMARY KEY,
                              username VARCHAR(100) NOT NULL UNIQUE,
                              password VARCHAR(255) NOT NULL,
                              artist_id INT NOT NULL,
                              last_login DATETIME,
                              FOREIGN KEY (artist_id) REFERENCES artists(artist_id) ON DELETE CASCADE
);
ALTER TABLE artist_login ADD email VARCHAR(100) UNIQUE;
select *from artist_login;

CREATE TRIGGER after_artist_signup AFTER INSERT ON artist_login
    FOR EACH ROW
BEGIN
    INSERT INTO artists (artist_name, genre, created_date)
    VALUES ((SELECT name FROM user WHERE id = NEW.artist_id),
            'Unknown', NOW());
END;
ALTER TABLE artists ADD COLUMN email VARCHAR(100) UNIQUE;