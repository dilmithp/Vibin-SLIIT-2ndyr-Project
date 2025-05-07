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
    
    // Get playlist ID from request
    String playlistId = request.getParameter("id");
    
    // Validate input
    if (playlistId == null || playlistId.isEmpty()) {
        response.sendRedirect("playlist-list.jsp?error=Invalid playlist ID");
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
        
        // Delete playlist
        PreparedStatement pstmt = conn.prepareStatement("DELETE FROM playlists WHERE playlist_id = ?");
        pstmt.setInt(1, Integer.parseInt(playlistId));
        
        int rowsAffected = pstmt.executeUpdate();
        pstmt.close();
        conn.close();
        
        if (rowsAffected > 0) {
            response.sendRedirect("playlist-list.jsp?message=Playlist deleted successfully");
        } else {
            response.sendRedirect("playlist-list.jsp?error=Failed to delete playlist");
        }
        
    } catch (Exception e) {
        response.sendRedirect("playlist-list.jsp?error=" + e.getMessage());
    }
%>
