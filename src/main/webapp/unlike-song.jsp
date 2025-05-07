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
    
    // Get song ID from request
    String songId = request.getParameter("songId");
    
    // Validate input
    if (songId == null || songId.isEmpty()) {
        response.sendRedirect("likedSongs.jsp?error=Invalid song ID");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Remove song from liked songs
        PreparedStatement pstmt = conn.prepareStatement("DELETE FROM liked_songs WHERE user_id = ? AND song_id = ?");
        pstmt.setInt(1, userId);
        pstmt.setInt(2, Integer.parseInt(songId));
        
        int rowsAffected = pstmt.executeUpdate();
        pstmt.close();
        conn.close();
        
        if (rowsAffected > 0) {
            response.sendRedirect("likedSongs.jsp?message=Song removed from your liked songs");
        } else {
            response.sendRedirect("likedSongs.jsp?error=Failed to unlike song");
        }
        
    } catch (Exception e) {
        response.sendRedirect("likedSongs.jsp?error=" + e.getMessage());
    }
%>
