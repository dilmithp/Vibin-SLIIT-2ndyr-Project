<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if user is logged in
    if (session.getAttribute("id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Get user ID from session
    int userId = Integer.parseInt(String.valueOf(session.getAttribute("id")));
    
    // Get form parameters
    String playlistId = request.getParameter("playlistId");
    String songId = request.getParameter("songId");
    
    // Validate input
    if (playlistId == null || playlistId.isEmpty() || songId == null || songId.isEmpty()) {
        response.sendRedirect("songs?error=Invalid parameters");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Verify playlist belongs to user
        PreparedStatement checkStmt = conn.prepareStatement("SELECT * FROM playlists WHERE playlist_id = ? AND user_id = ?");
        checkStmt.setInt(1, Integer.parseInt(playlistId));
        checkStmt.setInt(2, userId);
        
        ResultSet checkRs = checkStmt.executeQuery();
        if (!checkRs.next()) {
            checkRs.close();
            checkStmt.close();
            conn.close();
            response.sendRedirect("playlist-list.jsp?error=Playlist not found or unauthorized access");
            return;
        }
        checkRs.close();
        checkStmt.close();
        
        // Check if song already exists in playlist
        PreparedStatement existsStmt = conn.prepareStatement("SELECT * FROM playlist_songs WHERE playlist_id = ? AND song_id = ?");
        existsStmt.setInt(1, Integer.parseInt(playlistId));
        existsStmt.setInt(2, Integer.parseInt(songId));
        
        ResultSet existsRs = existsStmt.executeQuery();
        if (existsRs.next()) {
            existsRs.close();
            existsStmt.close();
            conn.close();
            response.sendRedirect("playlist-view.jsp?id=" + playlistId + "&message=Song already exists in this playlist");
            return;
        }
        existsRs.close();
        existsStmt.close();
        
        // Add song to playlist
        PreparedStatement pstmt = conn.prepareStatement("INSERT INTO playlist_songs (playlist_id, song_id) VALUES (?, ?)");
        pstmt.setInt(1, Integer.parseInt(playlistId));
        pstmt.setInt(2, Integer.parseInt(songId));
        
        pstmt.executeUpdate();
        pstmt.close();
        conn.close();
        
        response.sendRedirect("playlist-view.jsp?id=" + playlistId + "&message=Song added to playlist successfully");
        
    } catch (Exception e) {
        response.sendRedirect("playlist-add-song.jsp?songId=" + songId + "&error=" + e.getMessage());
    }
%>
