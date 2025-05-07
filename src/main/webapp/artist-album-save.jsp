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
    String albumId = request.getParameter("albumId");
    String albumName = request.getParameter("albumName");
    String genre = request.getParameter("genre");
    String releaseDate = request.getParameter("releaseDate");
    
    // Validate required fields
    if (albumName == null || albumName.trim().isEmpty()) {
        response.sendRedirect("artist-album-form.jsp?error=Album name is required");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        if (albumId != null && !albumId.isEmpty()) {
            // Update existing album
            // First verify this album belongs to the artist
            PreparedStatement checkStmt = conn.prepareStatement("SELECT * FROM albums WHERE album_id = ? AND artist = ?");
            checkStmt.setInt(1, Integer.parseInt(albumId));
            checkStmt.setString(2, artistName);
            
            ResultSet checkRs = checkStmt.executeQuery();
            if (!checkRs.next()) {
                checkRs.close();
                checkStmt.close();
                conn.close();
                response.sendRedirect("artist-albums.jsp?error=Unauthorized access");
                return;
            }
            checkRs.close();
            checkStmt.close();
            
            // Proceed with update
            String sql = "UPDATE albums SET album_name = ?, genre = ?, release_date = ? WHERE album_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, albumName);
            pstmt.setString(2, genre);
            
            // Handle release date (might be empty)
            if (releaseDate != null && !releaseDate.isEmpty()) {
                pstmt.setDate(3, Date.valueOf(releaseDate));
            } else {
                pstmt.setNull(3, java.sql.Types.DATE);
            }
            
            pstmt.setInt(4, Integer.parseInt(albumId));
            
            pstmt.executeUpdate();
            pstmt.close();
            
            conn.close();
            response.sendRedirect("artist-albums.jsp?message=Album updated successfully");
        } else {
            // Insert new album
            String sql = "INSERT INTO albums (album_name, artist, genre, release_date) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, albumName);
            pstmt.setString(2, artistName);
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
            response.sendRedirect("artist-albums.jsp?message=Album added successfully");
        }
        
    } catch (Exception e) {
        response.sendRedirect("artist-album-form.jsp?error=" + e.getMessage());
    }
%>
