<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    // Get artist ID from request
    String artistId = request.getParameter("id");
    
    // Validate input
    if (artistId == null || artistId.isEmpty()) {
        response.sendRedirect("admin-artists.jsp?error=Invalid artist ID");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Delete artist
        PreparedStatement pstmt = conn.prepareStatement("DELETE FROM artists WHERE artist_id = ?");
        pstmt.setInt(1, Integer.parseInt(artistId));
        
        int rowsAffected = pstmt.executeUpdate();
        pstmt.close();
        conn.close();
        
        if (rowsAffected > 0) {
            response.sendRedirect("admin-artists.jsp?message=Artist deleted successfully");
        } else {
            response.sendRedirect("admin-artists.jsp?error=Failed to delete artist");
        }
        
    } catch (Exception e) {
        response.sendRedirect("admin-artists.jsp?error=" + e.getMessage());
    }
%>
