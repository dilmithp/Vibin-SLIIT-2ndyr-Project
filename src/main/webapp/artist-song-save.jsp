<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if artist is logged in
    if (session.getAttribute("artistId") == null) {
        response.sendRedirect("artist-login.jsp");
        return;
    }
    
    int artistId = (Integer)session.getAttribute("artistId");
    String artistName = (String)session.getAttribute("artistName");
    
    // Get form parameters
    String songId = request.getParameter("songId");
    String songName = request.getParameter("songName");
    String lyricist = request.getParameter("lyricist");
    String musicDirector = request.getParameter("musicDirector");
    String albumId = request.getParameter("albumId");
    
    // Validate required fields
    if (songName == null || songName.trim().isEmpty()) {
        response.sendRedirect("artist-song-form.jsp?error=Song name is required");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        if (songId != null && !songId.isEmpty()) {
            // Update existing song
            // First verify this song belongs to the artist
            PreparedStatement checkStmt = conn.prepareStatement("SELECT * FROM songs WHERE song_id = ? AND singer = ?");
            checkStmt.setInt(1, Integer.parseInt(songId));
            checkStmt.setString(2, artistName);
            
            ResultSet checkRs = checkStmt.executeQuery();
            if (!checkRs.next()) {
                checkRs.close();
                checkStmt.close();
                conn.close();
                response.sendRedirect("artist-songs.jsp?error=Unauthorized access");
                return;
            }
            checkRs.close();
            checkStmt.close();
            
            // Proceed with update
            String sql = "UPDATE songs SET song_name = ?, lyricist = ?, music_director = ?, album_id = ? WHERE song_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, songName);
            pstmt.setString(2, lyricist);
            pstmt.setString(3, musicDirector);
            
            // Handle album ID (might be empty)
            if (albumId != null && !albumId.isEmpty()) {
                pstmt.setInt(4, Integer.parseInt(albumId));
            } else {
                pstmt.setNull(4, java.sql.Types.INTEGER);
            }
            
            pstmt.setInt(5, Integer.parseInt(songId));
            
            pstmt.executeUpdate();
            pstmt.close();
            
            conn.close();
            response.sendRedirect("artist-songs.jsp?message=Song updated successfully");
        } else {
            // Insert new song
            String sql = "INSERT INTO songs (song_name, singer, lyricist, music_director, album_id) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, songName);
            pstmt.setString(2, artistName);
            pstmt.setString(3, lyricist);
            pstmt.setString(4, musicDirector);
            
            // Handle album ID (might be empty)
            if (albumId != null && !albumId.isEmpty()) {
                pstmt.setInt(5, Integer.parseInt(albumId));
            } else {
                pstmt.setNull(5, java.sql.Types.INTEGER);
            }
            
            pstmt.executeUpdate();
            pstmt.close();
            
            conn.close();
            response.sendRedirect("artist-songs.jsp?message=Song added successfully");
        }
        
    } catch (Exception e) {
        response.sendRedirect("artist-song-form.jsp?error=" + e.getMessage());
    }
%>
