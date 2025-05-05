<%@ page import="java.sql.*" %>
<%@ page import="com.vibin.playlist.PlaylistDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get parameters
    String playlistIdStr = request.getParameter("playlistId");
    String songIdStr = request.getParameter("songId");
    
    // Validate input
    if (playlistIdStr == null || playlistIdStr.isEmpty() || songIdStr == null || songIdStr.isEmpty()) {
        response.sendRedirect("playlist-list.jsp?error=Invalid parameters");
        return;
    }
    
    try {
        int playlistId = Integer.parseInt(playlistIdStr);
        int songId = Integer.parseInt(songIdStr);
        
        // Get user ID from session
        String userIdStr = (String) session.getAttribute("id");
        
        if (userIdStr == null) {
            response.sendRedirect("login.jsp?error=Please log in to add songs to playlists");
            return;
        }
        
        // Add song to playlist
        PlaylistDAO playlistDAO = new PlaylistDAO();
        boolean success = playlistDAO.addSongToPlaylist(playlistId, songId);
        
        if (success) {
            response.sendRedirect("playlist-detail.jsp?id=" + playlistId + "&message=Song added to playlist successfully");
        } else {
            response.sendRedirect("playlist-detail.jsp?id=" + playlistId + "&error=Failed to add song to playlist");
        }
        
    } catch (NumberFormatException e) {
        response.sendRedirect("playlist-list.jsp?error=Invalid ID format");
    } catch (Exception e) {
        response.sendRedirect("playlist-detail.jsp?id=" + playlistIdStr + "&error=" + e.getMessage());
    }
%>
