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
    String currentPassword = request.getParameter("currentPassword");
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");
    
    // Validate input
    if (currentPassword == null || newPassword == null || confirmPassword == null ||
        currentPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
        response.sendRedirect("artist-profile.jsp?error=All fields are required");
        return;
    }
    
    if (!newPassword.equals(confirmPassword)) {
        response.sendRedirect("artist-profile.jsp?error=New passwords do not match");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Verify current password
        PreparedStatement checkStmt = conn.prepareStatement("SELECT * FROM artist_login WHERE artist_id = ? AND password = ?");
        checkStmt.setInt(1, artistId);
        checkStmt.setString(2, currentPassword);
        
        ResultSet checkRs = checkStmt.executeQuery();
        if (!checkRs.next()) {
            checkRs.close();
            checkStmt.close();
            conn.close();
            response.sendRedirect("artist-profile.jsp?error=Current password is incorrect");
            return;
        }
        checkRs.close();
        checkStmt.close();
        
        // Update password
        PreparedStatement pstmt = conn.prepareStatement("UPDATE artist_login SET password = ? WHERE artist_id = ?");
        pstmt.setString(1, newPassword);
        pstmt.setInt(2, artistId);
        
        int rowsAffected = pstmt.executeUpdate();
        pstmt.close();
        conn.close();
        
        if (rowsAffected > 0) {
            response.sendRedirect("artist-profile.jsp?message=Password updated successfully");
        } else {
            response.sendRedirect("artist-profile.jsp?error=Failed to update password");
        }
        
    } catch (Exception e) {
        response.sendRedirect("artist-profile.jsp?error=" + e.getMessage());
    }
%>
