package com.vibin.dao;

import com.vibin.model.Song;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SongDAO {
    private String jdbcURL = "jdbc:mysql://localhost:8889/loginjsp";
    private String jdbcUsername = "root";
    private String jdbcPassword = "root";

    private static final String INSERT_SONG_SQL = "INSERT INTO songs (song_name, lyricist, singer, music_director, album_id) VALUES (?, ?, ?, ?, ?)";
    private static final String SELECT_SONG_BY_ID = "SELECT * FROM songs WHERE song_id = ?";
    private static final String SELECT_ALL_SONGS = "SELECT * FROM songs";
    private static final String DELETE_SONG_SQL = "DELETE FROM songs WHERE song_id = ?";
    private static final String UPDATE_SONG_SQL = "UPDATE songs SET song_name = ?, lyricist = ?, singer = ?, music_director = ?, album_id = ? WHERE song_id = ?";

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

    // Create song
    public void insertSong(Song song) throws SQLException {
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_SONG_SQL)) {
            preparedStatement.setString(1, song.getSongName());
            preparedStatement.setString(2, song.getLyricist());
            preparedStatement.setString(3, song.getSinger());
            preparedStatement.setString(4, song.getMusicDirector());
            preparedStatement.setInt(5, song.getAlbumId());
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            printSQLException(e);
            throw e; // Rethrow to notify the servlet
        }
    }

    // Read song
    public Song selectSong(int id) {
        Song song = null;
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_SONG_BY_ID)) {
            preparedStatement.setInt(1, id);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                String songName = rs.getString("song_name");
                String lyricist = rs.getString("lyricist");
                String singer = rs.getString("singer");
                String musicDirector = rs.getString("music_director");
                int albumId = rs.getInt("album_id");
                song = new Song(id, songName, lyricist, singer, musicDirector, albumId);
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return song;
    }

    // Read all songs
    public List<Song> selectAllSongs() {
        List<Song> songs = new ArrayList<>();
        try (Connection connection = getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_SONGS)) {
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("song_id");
                String songName = rs.getString("song_name");
                String lyricist = rs.getString("lyricist");
                String singer = rs.getString("singer");
                String musicDirector = rs.getString("music_director");
                int albumId = rs.getInt("album_id");
                songs.add(new Song(id, songName, lyricist, singer, musicDirector, albumId));
            }
        } catch (SQLException e) {
            printSQLException(e);
        }
        return songs;
    }

    // Update song
    public boolean updateSong(Song song) throws SQLException {
        boolean rowUpdated;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_SONG_SQL)) {
            statement.setString(1, song.getSongName());
            statement.setString(2, song.getLyricist());
            statement.setString(3, song.getSinger());
            statement.setString(4, song.getMusicDirector());
            statement.setInt(5, song.getAlbumId());
            statement.setInt(6, song.getSongId());

            rowUpdated = statement.executeUpdate() > 0;
        }
        return rowUpdated;
    }

    // Delete song
    public boolean deleteSong(int id) throws SQLException {
        boolean rowDeleted;
        try (Connection connection = getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_SONG_SQL)) {
            statement.setInt(1, id);
            rowDeleted = statement.executeUpdate() > 0;
        }
        return rowDeleted;
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
