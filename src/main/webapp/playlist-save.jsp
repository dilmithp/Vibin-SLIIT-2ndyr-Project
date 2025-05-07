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
    String playlistName = request.getParameter("playlistName");
    String description = request.getParameter("description");
    
    // Validate required fields
    if (playlistName == null || playlistName.trim().isEmpty()) {
        response.sendRedirect("playlist-create.jsp?error=Playlist name is required");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Insert new playlist
        String sql = "INSERT INTO playlists (playlist_name, user_id, description) VALUES (?, ?, ?)";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, playlistName);
        pstmt.setInt(2, userId);
        pstmt.setString(3, description);
        
        pstmt.executeUpdate();
        pstmt.close();
        conn.close();
        
        response.sendRedirect("playlist-list.jsp?message=Playlist created successfully");
        
    } catch (Exception e) {
        response.sendRedirect("playlist-create.jsp?error=" + e.getMessage());
    }
%>
