package com.vibin.artist;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/ArtistSignupServlet")
public class ArtistSignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String artistName = request.getParameter("artistName");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String genre = request.getParameter("genre");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate input
        if (!password.equals(confirmPassword)) {
            response.sendRedirect("artist-signup.jsp?error=Passwords do not match");
            return;
        }
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
            
            // Check if username or email already exists
            PreparedStatement checkStmt = conn.prepareStatement(
                "SELECT * FROM artist_login WHERE username = ? OR EXISTS (SELECT 1 FROM artists WHERE email = ?)");
            checkStmt.setString(1, username);
            checkStmt.setString(2, email);
            
            ResultSet checkRs = checkStmt.executeQuery();
            if (checkRs.next()) {
                checkRs.close();
                checkStmt.close();
                conn.close();
                response.sendRedirect("artist-signup.jsp?error=Username or email already exists");
                return;
            }
            
            // Insert artist record
            conn.setAutoCommit(false);
            try {
                // Create artist entry
                PreparedStatement artistStmt = conn.prepareStatement(
                    "INSERT INTO artists (artist_name, email, genre) VALUES (?, ?, ?)",
                    Statement.RETURN_GENERATED_KEYS);
                artistStmt.setString(1, artistName);
                artistStmt.setString(2, email);
                artistStmt.setString(3, genre);
                
                artistStmt.executeUpdate();
                
                // Get generated artist ID
                ResultSet generatedKeys = artistStmt.getGeneratedKeys();
                int artistId = 0;
                if (generatedKeys.next()) {
                    artistId = generatedKeys.getInt(1);
                }
                
                // Create login entry
                PreparedStatement loginStmt = conn.prepareStatement(
                    "INSERT INTO artist_login (username, password, artist_id) VALUES (?, ?, ?)");
                loginStmt.setString(1, username);
                loginStmt.setString(2, password);
                loginStmt.setInt(3, artistId);
                
                loginStmt.executeUpdate();
                
                conn.commit();
                
                response.sendRedirect("artist-login.jsp?message=Registration successful. Please login.");
                
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
                conn.close();
            }
            
        } catch (Exception e) {
            response.sendRedirect("artist-signup.jsp?error=" + e.getMessage());
        }
    }
}
