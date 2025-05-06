<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    // Get form parameters
    String artistId = request.getParameter("artistId");
    String artistName = request.getParameter("artistName");
    String bio = request.getParameter("bio");
    String imageUrl = request.getParameter("imageUrl");
    String genre = request.getParameter("genre");
    String country = request.getParameter("country");
    
    // Validate required fields
    if (artistName == null || artistName.trim().isEmpty()) {
        response.sendRedirect("admin-artist-form.jsp?error=Artist name is required");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        if (artistId != null && !artistId.isEmpty()) {
            // Update existing artist
            String sql = "UPDATE artists SET artist_name = ?, bio = ?, image_url = ?, genre = ?, country = ? WHERE artist_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, artistName);
            pstmt.setString(2, bio);
            pstmt.setString(3, imageUrl);
            pstmt.setString(4, genre);
            pstmt.setString(5, country);
            pstmt.setInt(6, Integer.parseInt(artistId));
            
            pstmt.executeUpdate();
            pstmt.close();
            
            conn.close();
            response.sendRedirect("admin-artists.jsp?message=Artist updated successfully");
        } else {
            // Insert new artist
            String sql = "INSERT INTO artists (artist_name, bio, image_url, genre, country) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, artistName);
            pstmt.setString(2, bio);
            pstmt.setString(3, imageUrl);
            pstmt.setString(4, genre);
            pstmt.setString(5, country);
            
            pstmt.executeUpdate();
            pstmt.close();
            
            conn.close();
            response.sendRedirect("admin-artists.jsp?message=Artist added successfully");
        }
        
    } catch (Exception e) {
        response.sendRedirect("admin-artist-form.jsp?error=" + e.getMessage());
    }
%>
