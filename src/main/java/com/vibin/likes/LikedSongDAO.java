package com.vibin.likes;

import java.sql.*;
import java.util.*;

public class LikedSongDAO {
    private static final String JDBC_URL = "jdbc:mysql://localhost:8889/loginjsp";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "root";
    
    // Add a song to user's liked songs
    public boolean addLikedSong(int userId, int songId) throws SQLException {
        String sql = "INSERT INTO liked_songs (user_id, song_id) VALUES (?, ?)";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, songId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    // Remove a song from user's liked songs
    public boolean removeLikedSong(int userId, int songId) throws SQLException {
        String sql = "DELETE FROM liked_songs WHERE user_id = ? AND song_id = ?";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, songId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    // Check if a song is liked by a user
    public boolean isLikedBySong(int userId, int songId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM liked_songs WHERE user_id = ? AND song_id = ?";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, songId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
    
    public List<Map<String, Object>> getLikedSongs(int userId) throws SQLException {
        List<Map<String, Object>> likedSongs = new ArrayList<>();
        
        String sql = "SELECT s.song_id, s.song_name, s.singer, s.lyricist, s.music_director, a.album_name " +
                     "FROM songs s LEFT JOIN albums a ON s.album_id = a.album_id " +
                     "INNER JOIN liked_songs ls ON s.song_id = ls.song_id " +
                     "WHERE ls.user_id = ?";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> song = new HashMap<>();
                    song.put("songId", rs.getInt("song_id"));
                    song.put("title", rs.getString("song_name"));
                    song.put("artist", rs.getString("singer"));
                    song.put("album", rs.getString("album_name"));
                    song.put("lyricist", rs.getString("lyricist"));
                    song.put("musicDirector", rs.getString("music_director"));
                    likedSongs.add(song);
                }
            }
        }
        
        return likedSongs;
    }

}
