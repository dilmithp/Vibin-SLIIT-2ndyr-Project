<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get form parameters
    String songName = request.getParameter("songName");
    String lyricist = request.getParameter("lyricist");
    String musicDirector = request.getParameter("musicDirector");
    String albumIdStr = request.getParameter("albumId");
    String artistName = request.getParameter("artistName");
    String artistIdStr = request.getParameter("artistId");
    
    // Validate required fields
    if (songName == null || songName.trim().isEmpty()) {
        response.sendRedirect("artist-detail.jsp?id=" + artistIdStr + "&error=Song name is required");
        return;
    }
    
    try {
        // Database connection
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Prepare SQL statement
        String sql = "INSERT INTO songs (song_name, singer, lyricist, music_director, album_id) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        
        pstmt.setString(1, songName);
        pstmt.setString(2, artistName);
        pstmt.setString(3, lyricist);
        pstmt.setString(4, musicDirector);
        
        // Handle album ID (might be empty)
        if (albumIdStr != null && !albumIdStr.isEmpty()) {
            pstmt.setInt(5, Integer.parseInt(albumIdStr));
        } else {
            pstmt.setNull(5, java.sql.Types.INTEGER);
        }
        
        // Execute the insert
        int rowsAffected = pstmt.executeUpdate();
        
        // Close resources
        pstmt.close();
        conn.close();
        
        if (rowsAffected > 0) {
            response.sendRedirect("artist-detail.jsp?id=" + artistIdStr + "&message=Song added successfully");
        } else {
            response.sendRedirect("artist-detail.jsp?id=" + artistIdStr + "&error=Failed to add song");
        }
        
    } catch (Exception e) {
        response.sendRedirect("artist-detail.jsp?id=" + artistIdStr + "&error=" + e.getMessage());
    }
%>
