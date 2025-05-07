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
        response.sendRedirect("songs?error=Invalid song ID");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Check if song is already liked
        PreparedStatement checkStmt = conn.prepareStatement("SELECT * FROM liked_songs WHERE user_id = ? AND song_id = ?");
        checkStmt.setInt(1, userId);
        checkStmt.setInt(2, Integer.parseInt(songId));
        
        ResultSet checkRs = checkStmt.executeQuery();
        if (checkRs.next()) {
            // Song is already liked, unlike it
            PreparedStatement unlikeStmt = conn.prepareStatement("DELETE FROM liked_songs WHERE user_id = ? AND song_id = ?");
            unlikeStmt.setInt(1, userId);
            unlikeStmt.setInt(2, Integer.parseInt(songId));
            
            unlikeStmt.executeUpdate();
            unlikeStmt.close();
            
            checkRs.close();
            checkStmt.close();
            conn.close();
            
            response.sendRedirect("songs?message=Song removed from your liked songs");
        } else {
            // Song is not liked, like it
            PreparedStatement likeStmt = conn.prepareStatement("INSERT INTO liked_songs (user_id, song_id) VALUES (?, ?)");
            likeStmt.setInt(1, userId);
            likeStmt.setInt(2, Integer.parseInt(songId));
            
            likeStmt.executeUpdate();
            likeStmt.close();
            
            checkRs.close();
            checkStmt.close();
            conn.close();
            
            response.sendRedirect("songs?message=Song added to your liked songs");
        }
        
    } catch (Exception e) {
        response.sendRedirect("songs?error=" + e.getMessage());
    }
%>
