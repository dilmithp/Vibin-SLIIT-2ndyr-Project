<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    // Get form parameters
    String adminId = request.getParameter("adminId");
    String username = request.getParameter("username");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String role = request.getParameter("role");
    String password = request.getParameter("password");
    
    // Validate required fields
    if (username == null || username.trim().isEmpty() || name == null || name.trim().isEmpty()) {
        response.sendRedirect("admin-admin-form.jsp?error=Username and name are required");
        return;
    }
    
    // For new admins, password is required
    if (adminId == null && (password == null || password.trim().isEmpty())) {
        response.sendRedirect("admin-admin-form.jsp?error=Password is required for new admins");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Check if username already exists (for new admins or when changing username)
        String checkSql = "SELECT admin_id FROM admin WHERE username = ? AND admin_id != ?";
        PreparedStatement checkStmt = conn.prepareStatement(checkSql);
        checkStmt.setString(1, username);
        checkStmt.setString(2, adminId != null ? adminId : "0");
        
        ResultSet checkRs = checkStmt.executeQuery();
        if (checkRs.next()) {
            checkRs.close();
            checkStmt.close();
            conn.close();
            response.sendRedirect("admin-admin-form.jsp?error=Username already exists");
            return;
        }
        checkRs.close();
        checkStmt.close();
        
        if (adminId != null && !adminId.isEmpty()) {
            // Update existing admin
            String sql = "UPDATE admin SET username = ?, name = ?, email = ?, role = ? WHERE admin_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, name);
            pstmt.setString(3, email);
            pstmt.setString(4, role);
            pstmt.setInt(5, Integer.parseInt(adminId));
            
            pstmt.executeUpdate();
            pstmt.close();
            
            conn.close();
            response.sendRedirect("admin-admins.jsp?message=Admin updated successfully");
        } else {
            // Insert new admin
            String sql = "INSERT INTO admin (username, password, name, email, role) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            pstmt.setString(3, name);
            pstmt.setString(4, email);
            pstmt.setString(5, role);
            
            pstmt.executeUpdate();
            pstmt.close();
            
            conn.close();
            response.sendRedirect("admin-admins.jsp?message=Admin added successfully");
        }
        
    } catch (Exception e) {
        response.sendRedirect("admin-admin-form.jsp?error=" + e.getMessage());
    }
%>
