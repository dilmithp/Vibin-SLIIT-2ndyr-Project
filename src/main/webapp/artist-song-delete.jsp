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
    
    // Get song ID from request
    String songId = request.getParameter("id");
    String albumId = request.getParameter("albumId"); // Optional, for redirecting back to album page
    
    // Validate input
    if (songId == null || songId.isEmpty()) {
        response.sendRedirect("artist-songs.jsp?error=Invalid song ID");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Verify song belongs to artist
        PreparedStatement checkStmt = conn.prepareStatement("SELECT * FROM songs WHERE song_id = ? AND singer = ?");
        checkStmt.setInt(1, Integer.parseInt(songId));
        checkStmt.setString(2, artistName);
        
        ResultSet checkRs = checkStmt.executeQuery();
        if (!checkRs.next()) {
            checkRs.close();
            checkStmt.close();
            conn.close();
            response.sendRedirect("artist-songs.jsp?error=Song not found or unauthorized access");
            return;
        }
        checkRs.close();
        checkStmt.close();
        
        // Delete song
        PreparedStatement pstmt = conn.prepareStatement("DELETE FROM songs WHERE song_id = ?");
        pstmt.setInt(1, Integer.parseInt(songId));
        
        int rowsAffected = pstmt.executeUpdate();
        pstmt.close();
        conn.close();
        
        if (rowsAffected > 0) {
            // If albumId is provided, redirect back to album songs page
            if (albumId != null && !albumId.isEmpty()) {
                response.sendRedirect("artist-album-songs.jsp?id=" + albumId + "&message=Song deleted successfully");
            } else {
                response.sendRedirect("artist-songs.jsp?message=Song deleted successfully");
            }
        } else {
            response.sendRedirect("artist-songs.jsp?error=Failed to delete song");
        }
        
    } catch (Exception e) {
        response.sendRedirect("artist-songs.jsp?error=" + e.getMessage());
    }
%>
