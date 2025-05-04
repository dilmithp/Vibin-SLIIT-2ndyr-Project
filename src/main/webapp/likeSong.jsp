<%@ page import="com.vibin.likes.LikedSongDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get parameters
    int songId = Integer.parseInt(request.getParameter("songId"));
    int userId = (Integer) session.getAttribute("userId");
    
    try {
        // Add to liked songs
        LikedSongDAO likedSongDAO = new LikedSongDAO();
        boolean success = likedSongDAO.addLikedSong(userId, songId);
        
        // Redirect back to the previous page
        response.sendRedirect(request.getHeader("Referer"));
        
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
