package com.vibin.artist;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/ArtistLoginServlet")
public class ArtistLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ArtistLoginDAO artistLoginDAO;
    
    public void init() {
        artistLoginDAO = new ArtistLoginDAO();
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        try {
            ArtistLoginBean artist = artistLoginDAO.validate(username, password);
            
            if (artist != null) {
                // Set session attributes
                HttpSession session = request.getSession();
                session.setAttribute("artistId", artist.getArtistId());
                session.setAttribute("artistName", artist.getArtistName());
                session.setAttribute("artistUsername", artist.getUsername());
                session.setAttribute("userType", "artist");
                
                // Redirect to album list
                response.sendRedirect("artist-dashboard.jsp");
            } else {
                response.sendRedirect("artist-login.jsp?error=Invalid username or password");
            }
        } catch (ClassNotFoundException | SQLException e) {
            response.sendRedirect("artist-login.jsp?error=" + e.getMessage());
        }
    }
}
