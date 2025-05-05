package com.vibin.artist;

import java.sql.*;
import java.util.*;

public class ArtistDAO {
    private static final String JDBC_URL = "jdbc:mysql://localhost:8889/loginjsp";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "root";
    
    // Create a new artist
    public int createArtist(String name, String bio, String imageUrl, String genre, String country) throws SQLException {
        String sql = "INSERT INTO artists (artist_name, bio, image_url, genre, country) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, name);
            pstmt.setString(2, bio);
            pstmt.setString(3, imageUrl);
            pstmt.setString(4, genre);
            pstmt.setString(5, country);
            
            pstmt.executeUpdate();
            
            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        }
        return 0;
    }
    
    // Get all artists
    public List<Map<String, Object>> getAllArtists() throws SQLException {
        List<Map<String, Object>> artists = new ArrayList<>();
        
        String sql = "SELECT * FROM artists ORDER BY artist_name";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Map<String, Object> artist = new HashMap<>();
                artist.put("artistId", rs.getInt("artist_id"));
                artist.put("name", rs.getString("artist_name"));
                artist.put("bio", rs.getString("bio"));
                artist.put("imageUrl", rs.getString("image_url"));
                artist.put("genre", rs.getString("genre"));
                artist.put("country", rs.getString("country"));
                artist.put("createdDate", rs.getTimestamp("created_date"));
                artists.add(artist);
            }
        }
        
        return artists;
    }
    
    // Get artist by ID
    public Map<String, Object> getArtistById(int artistId) throws SQLException {
        String sql = "SELECT * FROM artists WHERE artist_id = ?";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, artistId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> artist = new HashMap<>();
                    artist.put("artistId", rs.getInt("artist_id"));
                    artist.put("name", rs.getString("artist_name"));
                    artist.put("bio", rs.getString("bio"));
                    artist.put("imageUrl", rs.getString("image_url"));
                    artist.put("genre", rs.getString("genre"));
                    artist.put("country", rs.getString("country"));
                    artist.put("createdDate", rs.getTimestamp("created_date"));
                    return artist;
                }
            }
        }
        return null;
    }
    
    // Update artist
    public boolean updateArtist(int artistId, String name, String bio, String imageUrl, String genre, String country) throws SQLException {
        String sql = "UPDATE artists SET artist_name = ?, bio = ?, image_url = ?, genre = ?, country = ? WHERE artist_id = ?";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, name);
            pstmt.setString(2, bio);
            pstmt.setString(3, imageUrl);
            pstmt.setString(4, genre);
            pstmt.setString(5, country);
            pstmt.setInt(6, artistId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    // Delete artist
    public boolean deleteArtist(int artistId) throws SQLException {
        String sql = "DELETE FROM artists WHERE artist_id = ?";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, artistId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
    
    // Get songs by artist
    public List<Map<String, Object>> getSongsByArtist(int artistId) throws SQLException {
        List<Map<String, Object>> songs = new ArrayList<>();
        
        String sql = "SELECT * FROM songs WHERE singer = (SELECT artist_name FROM artists WHERE artist_id = ?)";
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, artistId);
            
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
}
