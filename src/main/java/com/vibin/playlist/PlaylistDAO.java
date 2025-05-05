package com.vibin.playlist;

import java.sql.*;
import java.util.*;

public class PlaylistDAO {
    private static final String JDBC_URL = "jdbc:mysql://localhost:8889/loginjsp";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "root";
    
    // Create a new playlist
    public int createPlaylist(String name, int userId, String description) throws SQLException {
        String sql = "INSERT INTO playlists (playlist_name, user_id, description) VALUES (?, ?, ?)";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, name);
            pstmt.setInt(2, userId);
            pstmt.setString(3, description);
            
            pstmt.executeUpdate();
            
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        }
        return 0;
    }
    
    // Get all playlists for a user - modified to work with string ID from session
    public List<Map<String, Object>> getUserPlaylists(String userIdStr) throws SQLException {
        List<Map<String, Object>> playlists = new ArrayList<>();
        int userId = Integer.parseInt(userIdStr);
        
        String sql = "SELECT p.*, COUNT(ps.song_id) as song_count " +
                     "FROM playlists p LEFT JOIN playlist_songs ps " +
                     "ON p.playlist_id = ps.playlist_id " +
                     "WHERE p.user_id = ? " +
                     "GROUP BY p.playlist_id";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> playlist = new HashMap<>();
                    playlist.put("playlistId", rs.getInt("playlist_id"));
                    playlist.put("name", rs.getString("playlist_name"));
                    playlist.put("description", rs.getString("description"));
                    playlist.put("createdDate", rs.getTimestamp("created_date"));
                    playlist.put("songCount", rs.getInt("song_count"));
                    playlists.add(playlist);
                }
            }
        }
        
        return playlists;
    }
    
    // Get a specific playlist by ID - modified to work with string ID from session
    public Map<String, Object> getPlaylistById(int playlistId, String userIdStr) throws SQLException {
        int userId = Integer.parseInt(userIdStr);
        String sql = "SELECT * FROM playlists WHERE playlist_id = ? AND user_id = ?";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, playlistId);
            pstmt.setInt(2, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> playlist = new HashMap<>();
                    playlist.put("playlistId", rs.getInt("playlist_id"));
                    playlist.put("name", rs.getString("playlist_name"));
                    playlist.put("description", rs.getString("description"));
                    playlist.put("createdDate", rs.getTimestamp("created_date"));
                    playlist.put("userId", rs.getInt("user_id"));
                    return playlist;
                }
            }
        }
        return null;
    }
    
    // Other methods remain the same
    
    // Delete a playlist - modified to work with string ID from session
    public boolean deletePlaylist(int playlistId, String userIdStr) throws SQLException {
        int userId = Integer.parseInt(userIdStr);
        String sql = "DELETE FROM playlists WHERE playlist_id = ? AND user_id = ?";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, playlistId);
            pstmt.setInt(2, userId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    // Update playlist details - modified to work with string ID from session
    public boolean updatePlaylist(int playlistId, String name, String description, String userIdStr) throws SQLException {
        int userId = Integer.parseInt(userIdStr);
        String sql = "UPDATE playlists SET playlist_name = ?, description = ? WHERE playlist_id = ? AND user_id = ?";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, name);
            pstmt.setString(2, description);
            pstmt.setInt(3, playlistId);
            pstmt.setInt(4, userId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    // Get songs not already in a playlist
    public List<Map<String, Object>> getAvailableSongs(int playlistId) throws SQLException {
        List<Map<String, Object>> songs = new ArrayList<>();
        
        String sql = "SELECT * FROM songs WHERE song_id NOT IN " +
                     "(SELECT song_id FROM playlist_songs WHERE playlist_id = ?)";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, playlistId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> song = new HashMap<>();
                    song.put("songId", rs.getInt("song_id"));
                    song.put("title", rs.getString("song_name"));
                    song.put("artist", rs.getString("singer"));
                    song.put("lyricist", rs.getString("lyricist"));
                    song.put("musicDirector", rs.getString("music_director"));
                    songs.add(song);
                }
            }
        }
        
        return songs;
    }
 // Get songs in a playlist
    public List<Map<String, Object>> getPlaylistSongs(int playlistId) throws SQLException {
        List<Map<String, Object>> songs = new ArrayList<>();
        
        String sql = "SELECT s.*, ps.added_date " +
                     "FROM songs s INNER JOIN playlist_songs ps " +
                     "ON s.song_id = ps.song_id " +
                     "WHERE ps.playlist_id = ?";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, playlistId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> song = new HashMap<>();
                    song.put("songId", rs.getInt("song_id"));
                    song.put("title", rs.getString("song_name"));
                    song.put("artist", rs.getString("singer"));
                    song.put("lyricist", rs.getString("lyricist"));
                    song.put("musicDirector", rs.getString("music_director"));
                    song.put("addedDate", rs.getTimestamp("added_date"));
                    songs.add(song);
                }
            }
        }
        
        return songs;
    }
 // Add song to playlist
    public boolean addSongToPlaylist(int playlistId, int songId) throws SQLException {
        String sql = "INSERT INTO playlist_songs (playlist_id, song_id) VALUES (?, ?)";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, playlistId);
            pstmt.setInt(2, songId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    // Remove song from playlist
    public boolean removeSongFromPlaylist(int playlistId, int songId) throws SQLException {
        String sql = "DELETE FROM playlist_songs WHERE playlist_id = ? AND song_id = ?";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, playlistId);
            pstmt.setInt(2, songId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }


    
}
