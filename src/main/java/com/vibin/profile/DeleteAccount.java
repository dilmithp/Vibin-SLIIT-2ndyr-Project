package com.vibin.profile;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;

@WebServlet("/DeleteAccount")
public class DeleteAccount extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        
        Connection conn = null;
        PreparedStatement pst = null;
        RequestDispatcher dispatcher = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
            
            // Delete user account
            pst = conn.prepareStatement("DELETE FROM user WHERE email=?");
            pst.setString(1, email);
            
            int rowCount = pst.executeUpdate();
            
            if (rowCount > 0) {
                // Invalidate session
                session.invalidate();
                
                // Redirect to login page with message
                request.setAttribute("status", "deleted");
                dispatcher = request.getRequestDispatcher("login.jsp");
            } else {
                request.setAttribute("status", "error");
                dispatcher = request.getRequestDispatcher("profile.jsp");
            }
            
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("status", "error");
            dispatcher = request.getRequestDispatcher("profile.jsp");
            dispatcher.forward(request, response);
        } finally {
            try {
                if (pst != null) pst.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
