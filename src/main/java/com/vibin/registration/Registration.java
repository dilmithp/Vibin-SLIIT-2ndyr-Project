package com.vibin.registration;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

/**
 * Servlet implementation class Registration
 */
@WebServlet("/Registration")
public class Registration extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("pass");
        String contact_no = request.getParameter("contact");
        RequestDispatcher dispatcher = null;
        Connection conn = null;
        PreparedStatement pst = null;
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
            
            pst = conn.prepareStatement("INSERT INTO user (name, email, password, contact_no) VALUES (?, ?, ?, ?)");
            pst.setString(1, name);
            pst.setString(2, email);
            pst.setString(3, password);
            pst.setString(4, contact_no);
            
            int rowCount = pst.executeUpdate();
            dispatcher = request.getRequestDispatcher("registration.jsp");
            
            if(rowCount > 0) {
                request.setAttribute("status", "successful");
                response.sendRedirect("login.jsp");
            } else {
                request.setAttribute("status", "failed");
            }
            
            dispatcher.forward(request, response);
            
        } catch(Exception e) {
            e.printStackTrace();
            out.println("<h2>Error occurred:</h2>");
            out.println("<p>" + e.getMessage() + "</p>");
            out.println("<p>Stack trace:</p>");
            out.println("<pre>");
            e.printStackTrace(new PrintWriter(out));
            out.println("</pre>");
        } finally {
            try {
                if(pst != null) {
                    pst.close();
                }
                if(conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<h3>Error closing resources:</h3>");
                out.println("<p>" + e.getMessage() + "</p>");
            }
        }
    }
}
