package com.vibin.dao;

import com.vibin.model.Album;
import com.vibin.model.Song;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AlbumDAO {
    private String jdbcURL = "jdbc:mysql://localhost:8889/loginjsp";
    private String jdbcUsername = "root";
    private String jdbcPassword = "root";

    private static final String INSERT_ALBUM_SQL = "INSERT INTO albums (album_name, artist, release_date, genre) VALUES (?, ?, ?, ?)";
    private static final String SELECT_ALBUM_BY_ID = "SELECT * FROM albums WHERE album_id = ?";
    private static final String SELECT_ALL_ALBUMS = "SELECT * FROM albums";
    private static final String DELETE_ALBUM_SQL = "DELETE FROM albums WHERE album_id = ?";
    private static final String UPDATE_ALBUM_SQL = "UPDATE albums SET album_name = ?, artist = ?, release_date = ?, genre = ? WHERE album_id = ?";
    private static final String SELECT_SONGS_BY_ALBUM_ID = "SELECT * FROM songs WHERE album_id = ?";

    protected Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        return connection;
    }

    // Create album
    public void insertAlbum(Album album) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_ALBUM_SQL, Statement.RETURN_GENERATED_KEYS)) {
            preparedStatement.setString(1, album.getAlbumName());
            preparedStatement.setString(2, album.getArtist());
            preparedStatement.setDate(3, new java.sql.Date(album.getReleaseDate().getTime()));
            preparedStatement.setString(4, album.getGenre());
            preparedStatement.executeUpdate();
            
            ResultSet rs = preparedStatement.getGeneratedKeys();
            if (rs.next()) {
                album.setAlbumId(rs.getInt(1));
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
    }

    // Read album
    public Album selectAlbum(int id) {
        Album album = null;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALBUM_BY_ID)) {
            preparedStatement.setInt(1, id);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                String albumName = rs.getString("album_name");
                String artist = rs.getString("artist");
                Date releaseDate = rs.getDate("release_date");
                String genre = rs.getString("genre");
                album = new Album(id, albumName, artist, releaseDate, genre);
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return album;
    }

    // Read all albums
    public List<Album> selectAllAlbums() {
        List<Album> albums = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_ALBUMS)) {
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("album_id");
                String albumName = rs.getString("album_name");
                String artist = rs.getString("artist");
                Date releaseDate = rs.getDate("release_date");
                String genre = rs.getString("genre");
                albums.add(new Album(id, albumName, artist, releaseDate, genre));
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return albums;
    }

    // Update album
    public boolean updateAlbum(Album album) throws SQLException {
        boolean rowUpdated;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_ALBUM_SQL)) {
            statement.setString(1, album.getAlbumName());
            statement.setString(2, album.getArtist());
            statement.setDate(3, new java.sql.Date(album.getReleaseDate().getTime()));
            statement.setString(4, album.getGenre());
            statement.setInt(5, album.getAlbumId());

            rowUpdated = statement.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    // Delete album
    public boolean deleteAlbum(int id) throws SQLException {
        boolean rowDeleted;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_ALBUM_SQL)) {
            statement.setInt(1, id);
            rowDeleted = statement.executeUpdate() > 0;
        }
        return rowDeleted;
    }
    
    // Get songs by album ID
    public List<Song> getSongsByAlbumId(int albumId) {
        List<Song> songs = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_SONGS_BY_ALBUM_ID)) {
            preparedStatement.setInt(1, albumId);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("song_id");
                String songName = rs.getString("song_name");
                String lyricist = rs.getString("lyricist");
                String singer = rs.getString("singer");
                String musicDirector = rs.getString("music_director");
                songs.add(new Song(id, songName, lyricist, singer, musicDirector, albumId));
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return songs;
    }

    private void printSQLException(SQLException ex) {
        for (Throwable e : ex) {
            if (e instanceof SQLException) {
                e.printStackTrace(System.err);
                System.err.println("SQLState: " + ((SQLException) e).getSQLState());
                System.err.println("Error Code: " + ((SQLException) e).getErrorCode());
                System.err.println("Message: " + e.getMessage());
                Throwable t = ex.getCause();
                while (t != null) {
                    System.out.println("Cause: " + t);
                    t = t.getCause();
                }
            }
        }
    }
}
