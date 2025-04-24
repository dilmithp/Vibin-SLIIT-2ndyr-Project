package com.vibin.login;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

/**
 * Servlet implementation class Login
 */
@WebServlet("/Login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String email = request.getParameter("username");
        String password = request.getParameter("password");
        HttpSession session = request.getSession();
        Connection conn = null;
        PreparedStatement pst = null;
        RequestDispatcher dispatcher = null;

        
        try {
        	Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
            pst = conn.prepareStatement("SELECT *FROM user WHERE email = ? AND password = ?	");
            pst.setString(1, email);
            pst.setString(2, password);
            
            ResultSet rs = pst.executeQuery();
            if(rs.next()) {
            	session.setAttribute("name", rs.getString("name"));
            	session.setAttribute("email", rs.getString("email"));
            	session.setAttribute("contact_no", rs.getString("contact_no"));
            	dispatcher = request.getRequestDispatcher("index.jsp");
            }else {
            	request.setAttribute("status", "fail");
            	dispatcher = request.getRequestDispatcher("login.jsp");
            }
            dispatcher.forward(request, response);

        }catch(Exception e){
        	
        }
	}

}
