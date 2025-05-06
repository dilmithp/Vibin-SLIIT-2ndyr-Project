package com.vibin.admin;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;

@WebServlet("/AdminLogin")
public class AdminLogin extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("adminId") != null) {
            response.sendRedirect("admin-dashboard.jsp");
        } else {
            RequestDispatcher dispatcher = request.getRequestDispatcher("admin-login.jsp");
            dispatcher.forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        HttpSession session = request.getSession();
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
            
            // Check admin credentials
            pst = conn.prepareStatement("SELECT * FROM admin WHERE username = ? AND password = ?");
            pst.setString(1, username);
            pst.setString(2, password);
            
            ResultSet rs = pst.executeQuery();
            if(rs.next()) {
                // Update last login time
                PreparedStatement updateStmt = conn.prepareStatement(
                    "UPDATE admin SET last_login = NOW() WHERE admin_id = ?");
                updateStmt.setInt(1, rs.getInt("admin_id"));
                updateStmt.executeUpdate();
                updateStmt.close();
                
                // Set session attributes
                session.setAttribute("adminId", rs.getInt("admin_id"));
                session.setAttribute("adminName", rs.getString("name"));
                session.setAttribute("adminUsername", rs.getString("username"));
                session.setAttribute("adminRole", rs.getString("role"));
                
                response.sendRedirect("admin-dashboard.jsp");
            } else {
                response.sendRedirect("admin-login.jsp?error=Invalid username or password");
            }

        } catch(Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-login.jsp?error=" + e.getMessage());
        } finally {
            try { if(pst != null) pst.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
    }
}
