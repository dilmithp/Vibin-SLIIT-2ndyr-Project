package com.vibin.artist;

import java.sql.*;

public class ArtistLoginDAO {
    private static final String JDBC_URL = "jdbc:mysql://localhost:8889/loginjsp";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "root";
    
    public ArtistLoginBean validate(String username, String password) throws SQLException, ClassNotFoundException {
        ArtistLoginBean artist = null;
        
        Class.forName("com.mysql.jdbc.Driver");
        
        try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD)) {
            String sql = "SELECT al.*, a.artist_name FROM artist_login al " +
                         "JOIN artists a ON al.artist_id = a.artist_id " +
                         "WHERE al.username = ? AND al.password = ?";
            
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                artist = new ArtistLoginBean();
                artist.setUsername(username);
                artist.setArtistId(rs.getInt("artist_id"));
                artist.setArtistName(rs.getString("artist_name"));
                
                // Update last login time
                PreparedStatement updateStmt = conn.prepareStatement(
                    "UPDATE artist_login SET last_login = NOW() WHERE id = ?");
                updateStmt.setInt(1, rs.getInt("id"));
                updateStmt.executeUpdate();
            }
        }
        
        return artist;
    }
}
