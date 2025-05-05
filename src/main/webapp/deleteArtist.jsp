<%@ page import="java.sql.*" %>
<%@ page import="com.vibin.artist.ArtistDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get artist ID from request
    String artistIdStr = request.getParameter("id");
    
    // Validate input
    if (artistIdStr == null || artistIdStr.isEmpty()) {
        response.sendRedirect("artist-list.jsp?error=Invalid artist ID");
        return;
    }
    
    try {
        int artistId = Integer.parseInt(artistIdStr);
        
        // Delete artist
        ArtistDAO artistDAO = new ArtistDAO();
        boolean success = artistDAO.deleteArtist(artistId);
        
        if (success) {
            response.sendRedirect("artist-list.jsp?message=Artist deleted successfully");
        } else {
            response.sendRedirect("artist-list.jsp?error=Failed to delete artist");
        }
        
    } catch (NumberFormatException e) {
        response.sendRedirect("artist-list.jsp?error=Invalid artist ID format");
    } catch (Exception e) {
        response.sendRedirect("artist-list.jsp?error=" + e.getMessage());
    }
%>
