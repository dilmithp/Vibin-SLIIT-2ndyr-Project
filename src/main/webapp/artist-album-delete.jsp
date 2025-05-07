<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if artist is logged in
    if (session.getAttribute("artistId") == null) {
        response.sendRedirect("artist-login.jsp");
        return;
    }
    
    int artistId = (Integer)session.getAttribute("artistId");
    String artistName = (String)session.getAttribute("artistName");
    
    // Get album ID from request
    String albumId = request.getParameter("id");
    
    // Validate input
    if (albumId == null || albumId.isEmpty()) {
        response.sendRedirect("artist-albums.jsp?error=Invalid album ID");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Verify album belongs to artist
        PreparedStatement checkStmt = conn.prepareStatement("SELECT * FROM albums WHERE album_id = ? AND artist = ?");
        checkStmt.setInt(1, Integer.parseInt(albumId));
        checkStmt.setString(2, artistName);
        
        ResultSet checkRs = checkStmt.executeQuery();
        if (!checkRs.next()) {
            checkRs.close();
            checkStmt.close();
            conn.close();
            response.sendRedirect("artist-albums.jsp?error=Album not found or unauthorized access");
            return;
        }
        checkRs.close();
        checkStmt.close();
        
        // Delete album
        PreparedStatement pstmt = conn.prepareStatement("DELETE FROM albums WHERE album_id = ?");
        pstmt.setInt(1, Integer.parseInt(albumId));
        
        int rowsAffected = pstmt.executeUpdate();
        pstmt.close();
        conn.close();
        
        if (rowsAffected > 0) {
            response.sendRedirect("artist-albums.jsp?message=Album deleted successfully");
        } else {
            response.sendRedirect("artist-albums.jsp?error=Failed to delete album");
        }
        
    } catch (Exception e) {
        response.sendRedirect("artist-albums.jsp?error=" + e.getMessage());
    }
%>
