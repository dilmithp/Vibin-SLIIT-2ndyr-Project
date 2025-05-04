<%@ page import="com.vibin.likes.LikedSongDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get parameters
    int songId = Integer.parseInt(request.getParameter("songId"));
    int userId = (Integer) session.getAttribute("userId");
    
    try {
        // Remove from liked songs
        LikedSongDAO likedSongDAO = new LikedSongDAO();
        boolean success = likedSongDAO.removeLikedSong(userId, songId);
        
        // Redirect back to liked songs page
        response.sendRedirect("likedSongs.jsp");
        
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
