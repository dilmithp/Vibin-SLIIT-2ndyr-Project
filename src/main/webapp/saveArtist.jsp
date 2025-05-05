<%@ page import="java.sql.*" %>
<%@ page import="com.vibin.artist.ArtistDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get form parameters
    String artistName = request.getParameter("artistName");
    String bio = request.getParameter("bio");
    String imageUrl = request.getParameter("imageUrl");
    String genre = request.getParameter("genre");
    String country = request.getParameter("country");
    String artistIdStr = request.getParameter("artistId");
    
    // Validate required fields
    if (artistName == null || artistName.trim().isEmpty()) {
        response.sendRedirect("artist-form.jsp?error=Artist name is required");
        return;
    }
    
    try {
        ArtistDAO artistDAO = new ArtistDAO();
        boolean success = false;
        
        // Check if we're updating or creating
        if (artistIdStr != null && !artistIdStr.isEmpty()) {
            // Update existing artist
            int artistId = Integer.parseInt(artistIdStr);
            success = artistDAO.updateArtist(artistId, artistName, bio, imageUrl, genre, country);
            
            if (success) {
                response.sendRedirect("artist-detail.jsp?id=" + artistId + "&message=Artist updated successfully");
            } else {
                response.sendRedirect("artist-form.jsp?id=" + artistId + "&error=Failed to update artist");
            }
        } else {
            // Create new artist
            int newArtistId = artistDAO.createArtist(artistName, bio, imageUrl, genre, country);
            
            if (newArtistId > 0) {
                response.sendRedirect("artist-detail.jsp?id=" + newArtistId + "&message=Artist created successfully");
            } else {
                response.sendRedirect("artist-form.jsp?error=Failed to create artist");
            }
        }
    } catch (Exception e) {
        response.sendRedirect("artist-form.jsp?error=" + e.getMessage());
    }
%>
