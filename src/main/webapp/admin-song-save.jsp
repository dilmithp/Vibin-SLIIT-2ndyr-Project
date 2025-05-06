<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    // Get form parameters
    String songId = request.getParameter("songId");
    String songName = request.getParameter("songName");
    String singer = request.getParameter("singer");
    String lyricist = request.getParameter("lyricist");
    String musicDirector = request.getParameter("musicDirector");
    String albumId = request.getParameter("albumId");
    
    // Validate required fields
    if (songName == null || songName.trim().isEmpty() || singer == null || singer.trim().isEmpty()) {
        response.sendRedirect("admin-song-form.jsp?error=Song name and singer are required");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        if (songId != null && !songId.isEmpty()) {
            // Update existing song
            String sql = "UPDATE songs SET song_name = ?, singer = ?, lyricist = ?, music_director = ?, album_id = ? WHERE song_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, songName);
            pstmt.setString(2, singer);
            pstmt.setString(3, lyricist);
            pstmt.setString(4, musicDirector);
            
            // Handle album ID (might be empty)
            if (albumId != null && !albumId.isEmpty()) {
                pstmt.setInt(5, Integer.parseInt(albumId));
            } else {
                pstmt.setNull(5, java.sql.Types.INTEGER);
            }
            
            pstmt.setInt(6, Integer.parseInt(songId));
            
            pstmt.executeUpdate();
            pstmt.close();
            
            conn.close();
            response.sendRedirect("admin-songs.jsp?message=Song updated successfully");
        } else {
            // Insert new song
            String sql = "INSERT INTO songs (song_name, singer, lyricist, music_director, album_id) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, songName);
            pstmt.setString(2, singer);
            pstmt.setString(3, lyricist);
            pstmt.setString(4, musicDirector);
            
            // Handle album ID (might be empty)
            if (albumId != null && !albumId.isEmpty()) {
                pstmt.setInt(5, Integer.parseInt(albumId));
            } else {
                pstmt.setNull(5, java.sql.Types.INTEGER);
            }
            
            pstmt.executeUpdate();
            pstmt.close();
            
            conn.close();
            response.sendRedirect("admin-songs.jsp?message=Song added successfully");
        }
        
    } catch (Exception e) {
        response.sendRedirect("admin-song-form.jsp?error=" + e.getMessage());
    }
%>
