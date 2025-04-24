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

@WebServlet("/UpdateProfile")
public class UpdateProfile extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        String name = request.getParameter("name");
        String contact = request.getParameter("contact");
        String password = request.getParameter("password");
        
        Connection conn = null;
        PreparedStatement pst = null;
        RequestDispatcher dispatcher = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
            
            // If password field is not empty, update password too
            if (password != null && !password.trim().isEmpty()) {
                pst = conn.prepareStatement("UPDATE user SET name=?, contact_no=?, password=? WHERE email=?");
                pst.setString(1, name);
                pst.setString(2, contact);
                pst.setString(3, password);
                pst.setString(4, email);
            } else {
                pst = conn.prepareStatement("UPDATE user SET name=?, contact_no=? WHERE email=?");
                pst.setString(1, name);
                pst.setString(2, contact);
                pst.setString(3, email);
            }
            
            int rowCount = pst.executeUpdate();
            
            if (rowCount > 0) {
                // Update session attributes with new values
                session.setAttribute("name", name);
                session.setAttribute("contact_no", contact);
                request.setAttribute("status", "success");
            } else {
                request.setAttribute("status", "error");
            }
            
            dispatcher = request.getRequestDispatcher("profile.jsp");
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
