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
    
    // Get form parameters
    String email = request.getParameter("email");
    String genre = request.getParameter("genre");
    String country = request.getParameter("country");
    String bio = request.getParameter("bio");
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Update artist profile
        String sql = "UPDATE artists SET genre = ?, country = ?, bio = ? WHERE artist_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, genre);
        pstmt.setString(2, country);
        pstmt.setString(3, bio);
        pstmt.setInt(4, artistId);
        
        pstmt.executeUpdate();
        pstmt.close();
        
        // Update email in artist_login table if provided
        if (email != null && !email.trim().isEmpty()) {
            PreparedStatement emailStmt = conn.prepareStatement("UPDATE artist_login SET email = ? WHERE artist_id = ?");
            emailStmt.setString(1, email);
            emailStmt.setInt(2, artistId);
            emailStmt.executeUpdate();
            emailStmt.close();
        }
        
        conn.close();
        response.sendRedirect("artist-profile.jsp?message=Profile updated successfully");
        
    } catch (Exception e) {
        response.sendRedirect("artist-profile.jsp?error=" + e.getMessage());
    }
%>
