<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    // Get form parameters
    String userId = request.getParameter("userId");
    String userName = request.getParameter("userName");
    String userEmail = request.getParameter("userEmail");
    String userContact = request.getParameter("userContact");
    String userPassword = request.getParameter("userPassword");
    
    // Validate required fields
    if (userName == null || userName.trim().isEmpty() || userEmail == null || userEmail.trim().isEmpty()) {
        response.sendRedirect("admin-user-form.jsp?error=Name and email are required");
        return;
    }
    
    // For new users, password is required
    if (userId == null && (userPassword == null || userPassword.trim().isEmpty())) {
        response.sendRedirect("admin-user-form.jsp?error=Password is required for new users");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Check if email already exists (for new users or when changing email)
        String checkSql = "SELECT id FROM user WHERE email = ? AND id != ?";
        PreparedStatement checkStmt = conn.prepareStatement(checkSql);
        checkStmt.setString(1, userEmail);
        checkStmt.setString(2, userId != null ? userId : "0");
        
        ResultSet checkRs = checkStmt.executeQuery();
        if (checkRs.next()) {
            checkRs.close();
            checkStmt.close();
            conn.close();
            response.sendRedirect("admin-user-form.jsp?error=Email already exists");
            return;
        }
        checkRs.close();
        checkStmt.close();
        
        if (userId != null && !userId.isEmpty()) {
            // Update existing user
            String sql = "UPDATE user SET name = ?, email = ?, contact_no = ? WHERE id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userName);
            pstmt.setString(2, userEmail);
            pstmt.setString(3, userContact);
            pstmt.setInt(4, Integer.parseInt(userId));
            
            pstmt.executeUpdate();
            pstmt.close();
            
            conn.close();
            response.sendRedirect("admin-users.jsp?message=User updated successfully");
        } else {
            // Insert new user
            String sql = "INSERT INTO user (name, email, password, contact_no) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userName);
            pstmt.setString(2, userEmail);
            pstmt.setString(3, userPassword);
            pstmt.setString(4, userContact);
            
            pstmt.executeUpdate();
            pstmt.close();
            
            conn.close();
            response.sendRedirect("admin-users.jsp?message=User added successfully");
        }
        
    } catch (Exception e) {
        response.sendRedirect("admin-user-form.jsp?error=" + e.getMessage());
    }
%>
