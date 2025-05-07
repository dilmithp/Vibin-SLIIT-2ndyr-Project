<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    // Get playlist ID from request
    String playlistId = request.getParameter("id");
    
    // Validate input
    if (playlistId == null || playlistId.isEmpty()) {
        response.sendRedirect("admin-playlists.jsp?error=Invalid playlist ID");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Delete playlist
        PreparedStatement pstmt = conn.prepareStatement("DELETE FROM playlists WHERE playlist_id = ?");
        pstmt.setInt(1, Integer.parseInt(playlistId));
        
        int rowsAffected = pstmt.executeUpdate();
        pstmt.close();
        conn.close();
        
        if (rowsAffected > 0) {
            response.sendRedirect("admin-playlists.jsp?message=Playlist deleted successfully");
        } else {
            response.sendRedirect("admin-playlists.jsp?error=Failed to delete playlist");
        }
        
    } catch (Exception e) {
        response.sendRedirect("admin-playlists.jsp?error=" + e.getMessage());
    }
%>
