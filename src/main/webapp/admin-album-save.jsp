<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    // Get form parameters
    String albumId = request.getParameter("albumId");
    String albumName = request.getParameter("albumName");
    String artist = request.getParameter("artist");
    String genre = request.getParameter("genre");
    String releaseDate = request.getParameter("releaseDate");
    
    // Validate required fields
    if (albumName == null || albumName.trim().isEmpty() || artist == null || artist.trim().isEmpty()) {
        response.sendRedirect("admin-album-form.jsp?error=Album name and artist are required");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        if (albumId != null && !albumId.isEmpty()) {
            // Update existing album
            String sql = "UPDATE albums SET album_name = ?, artist = ?, genre = ?, release_date = ? WHERE album_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, albumName);
            pstmt.setString(2, artist);
            pstmt.setString(3, genre);
            
            // Handle release date (might be empty)
            if (releaseDate != null && !releaseDate.isEmpty()) {
                pstmt.setDate(4, Date.valueOf(releaseDate));
            } else {
                pstmt.setNull(4, java.sql.Types.DATE);
            }
            
            pstmt.setInt(5, Integer.parseInt(albumId));
            
            pstmt.executeUpdate();
            pstmt.close();
            
            conn.close();
            response.sendRedirect("admin-albums.jsp?message=Album updated successfully");
        } else {
            // Insert new album
            String sql = "INSERT INTO albums (album_name, artist, genre, release_date) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, albumName);
            pstmt.setString(2, artist);
            pstmt.setString(3, genre);
            
            // Handle release date (might be empty)
            if (releaseDate != null && !releaseDate.isEmpty()) {
                pstmt.setDate(4, Date.valueOf(releaseDate));
            } else {
                pstmt.setNull(4, java.sql.Types.DATE);
            }
            
            pstmt.executeUpdate();
            pstmt.close();
            
            conn.close();
            response.sendRedirect("admin-albums.jsp?message=Album added successfully");
        }
        
    } catch (Exception e) {
        response.sendRedirect("admin-album-form.jsp?error=" + e.getMessage());
    }
%>
