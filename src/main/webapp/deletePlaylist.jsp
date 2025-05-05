<%@ page import="java.sql.*" %>
<%@ page import="com.vibin.playlist.PlaylistDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get playlist ID from request
    String playlistIdStr = request.getParameter("id");
    
    // Validate input
    if (playlistIdStr == null || playlistIdStr.isEmpty()) {
        response.sendRedirect("playlist-list.jsp?error=Invalid playlist ID");
        return;
    }
    
    try {
        int playlistId = Integer.parseInt(playlistIdStr);
        
        // Get user ID from session
        String userIdStr = (String) session.getAttribute("id");
        
        if (userIdStr == null) {
            response.sendRedirect("login.jsp?error=Please log in to delete playlists");
            return;
        }
        
        // Delete playlist
        PlaylistDAO playlistDAO = new PlaylistDAO();
        boolean success = playlistDAO.deletePlaylist(playlistId, userIdStr);
        
        if (success) {
            response.sendRedirect("playlist-list.jsp?message=Playlist deleted successfully");
        } else {
            response.sendRedirect("playlist-list.jsp?error=Failed to delete playlist");
        }
        
    } catch (NumberFormatException e) {
        response.sendRedirect("playlist-list.jsp?error=Invalid playlist ID format");
    } catch (Exception e) {
        response.sendRedirect("playlist-list.jsp?error=" + e.getMessage());
    }
%>
