<%@ page import="java.sql.*" %>
<%@ page import="com.vibin.playlist.PlaylistDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get form parameters
    String playlistName = request.getParameter("playlistName");
    String description = request.getParameter("description");
    String playlistIdStr = request.getParameter("playlistId");
    
    // Get user ID from session safely
    Object userIdObj = session.getAttribute("id");
    int userId = 0;
    if (userIdObj != null) {
        if (userIdObj instanceof Integer) {
            userId = (Integer) userIdObj;
        } else if (userIdObj instanceof String) {
            userId = Integer.parseInt((String) userIdObj);
        }
    }
    
    // Check if user is logged in
    if (userId == 0) {
        response.sendRedirect("login.jsp?error=Please log in to create playlists");
        return;
    }
    
    try {
        PlaylistDAO playlistDAO = new PlaylistDAO();
        boolean success = false;
        
        // Check if we're updating or creating
        if (playlistIdStr != null && !playlistIdStr.isEmpty()) {
            // Update existing playlist
            int playlistId = Integer.parseInt(playlistIdStr);
            success = playlistDAO.updatePlaylist(playlistId, playlistName, description, userId);
            
            if (success) {
                response.sendRedirect("playlist-detail.jsp?id=" + playlistId + "&message=Playlist updated successfully");
            } else {
                response.sendRedirect("playlist-form.jsp?id=" + playlistId + "&error=Failed to update playlist");
            }
        } else {
            // Create new playlist
            int newPlaylistId = playlistDAO.createPlaylist(playlistName, userId, description);
            
            if (newPlaylistId > 0) {
                response.sendRedirect("playlist-detail.jsp?id=" + newPlaylistId + "&message=Playlist created successfully");
            } else {
                response.sendRedirect("playlist-form.jsp?error=Failed to create playlist");
            }
        }
    } catch (Exception e) {
        response.sendRedirect("playlist-form.jsp?error=" + e.getMessage());
    }
%>
