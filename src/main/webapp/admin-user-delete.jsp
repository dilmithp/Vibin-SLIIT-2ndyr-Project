<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    // Get user ID from request
    String userId = request.getParameter("id");
    
    // Validate input
    if (userId == null || userId.isEmpty()) {
        response.sendRedirect("admin-users.jsp?error=Invalid user ID");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Delete user
        PreparedStatement pstmt = conn.prepareStatement("DELETE FROM user WHERE id = ?");
        pstmt.setInt(1, Integer.parseInt(userId));
        
        int rowsAffected = pstmt.executeUpdate();
        pstmt.close();
        conn.close();
        
        if (rowsAffected > 0) {
            response.sendRedirect("admin-users.jsp?message=User deleted successfully");
        } else {
            response.sendRedirect("admin-users.jsp?error=Failed to delete user");
        }
        
    } catch (Exception e) {
        response.sendRedirect("admin-users.jsp?error=" + e.getMessage());
    }
%>
