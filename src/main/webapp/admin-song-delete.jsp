<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    // Get song ID from request
    String songId = request.getParameter("id");
    
    // Validate input
    if (songId == null || songId.isEmpty()) {
        response.sendRedirect("admin-songs.jsp?error=Invalid song ID");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Delete song
        PreparedStatement pstmt = conn.prepareStatement("DELETE FROM songs WHERE song_id = ?");
        pstmt.setInt(1, Integer.parseInt(songId));
        
        int rowsAffected = pstmt.executeUpdate();
        pstmt.close();
        conn.close();
        
        if (rowsAffected > 0) {
            response.sendRedirect("admin-songs.jsp?message=Song deleted successfully");
        } else {
            response.sendRedirect("admin-songs.jsp?error=Failed to delete song");
        }
        
    } catch (Exception e) {
        response.sendRedirect("admin-songs.jsp?error=" + e.getMessage());
    }
%>
