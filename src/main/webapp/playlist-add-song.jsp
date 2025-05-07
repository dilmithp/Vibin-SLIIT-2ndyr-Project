<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if user is logged in
    if (session.getAttribute("id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
	int userId = Integer.parseInt(String.valueOf(session.getAttribute("id")));
    
    // Get song ID from request
    String songId = request.getParameter("songId");
    
    // Validate input
    if (songId == null || songId.isEmpty()) {
        response.sendRedirect("songs?error=Invalid song ID");
        return;
    }
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Get user playlists
        PreparedStatement playlistStmt = conn.prepareStatement(
            "SELECT * FROM playlists WHERE user_id = ? ORDER BY playlist_name"
        );
        playlistStmt.setInt(1, userId);
        ResultSet playlistRs = playlistStmt.executeQuery();
        
        // Get song details
        PreparedStatement songStmt = conn.prepareStatement(
            "SELECT s.*, a.album_name, a.artist FROM songs s " +
            "LEFT JOIN albums a ON s.album_id = a.album_id " +
            "WHERE s.song_id = ?"
        );
        songStmt.setInt(1, Integer.parseInt(songId));
        ResultSet songRs = songStmt.executeQuery();
        
        if (!songRs.next()) {
            songRs.close();
            songStmt.close();
            playlistRs.close();
            playlistStmt.close();
            conn.close();
            response.sendRedirect("songs?error=Song not found");
            return;
        }
        
        String songName = songRs.getString("song_name");
        String artist = songRs.getString("singer");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Add to Playlist</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-900 text-white">
    <!-- Navigation Bar -->
    <nav class="bg-black p-4 shadow-lg sticky top-0 z-50">
        <div class="container mx-auto flex justify-between items-center">
            <a href="index.jsp" class="text-2xl font-bold text-purple-500">Vibin</a>
            <div class="flex items-center space-x-6">
                <a href="index.jsp" class="hover:text-purple-400"><i class="fas fa-home mr-2"></i>Home</a>
                <a href="<%=request.getContextPath()%>/songs" class="text-purple-400"><i class="fas fa-music mr-2"></i>Songs</a>
                <a href="<%=request.getContextPath()%>/albums" class="hover:text-purple-400"><i class="fas fa-compact-disc mr-2"></i>Albums</a>
                <a href="playlist-list.jsp" class="hover:text-purple-400"><i class="fas fa-list mr-2"></i>Playlists</a>
                <a href="likedSongs.jsp" class="hover:text-purple-400"><i class="fas fa-heart mr-2"></i>Liked</a>
                <a href="profile.jsp" class="hover:text-purple-400"><i class="fas fa-user mr-2"></i>Profile</a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto py-8 px-4">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-3xl font-bold text-purple-400">Add to Playlist</h1>
        </div>
        
        <!-- Song Info -->
        <div class="bg-gray-800 rounded-lg p-4 mb-6">
            <h2 class="text-xl font-bold mb-2">Song: <%= songName %></h2>
            <p class="text-gray-400">Artist: <%= artist %></p>
        </div>
        
        <!-- Error Message -->
        <% if (request.getParameter("error") != null) { %>
            <div class="bg-red-800 text-white px-4 py-3 rounded mb-4">
                <%= request.getParameter("error") %>
            </div>
        <% } %>
        
        <!-- Playlists -->
        <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
            <div class="p-6">
                <h2 class="text-xl font-bold mb-4">Select a Playlist</h2>
                
                <% 
                boolean hasPlaylists = false;
                while (playlistRs.next()) {
                    hasPlaylists = true;
                    int playlistId = playlistRs.getInt("playlist_id");
                    String playlistName = playlistRs.getString("playlist_name");
                %>
                <div class="mb-3 border border-gray-700 rounded-lg p-4 hover:bg-gray-700 transition duration-200">
                    <div class="flex justify-between items-center">
                        <div>
                            <h3 class="font-bold"><%= playlistName %></h3>
                        </div>
                        <form action="playlist-add-song-process.jsp" method="post">
                            <input type="hidden" name="playlistId" value="<%= playlistId %>">
                            <input type="hidden" name="songId" value="<%= songId %>">
                            <button type="submit" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                                Add
                            </button>
                        </form>
                    </div>
                </div>
                <% 
                }
                
                if (!hasPlaylists) {
                %>
                <div class="text-center py-6">
                    <p class="text-gray-400 mb-4">You don't have any playlists yet.</p>
                    <a href="playlist-create.jsp" class="inline-flex items-center px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                        <i class="fas fa-plus mr-2"></i>Create Playlist
                    </a>
                </div>
                <% } %>
            </div>
        </div>
        
        <!-- Back Button -->
        <div class="mt-6">
            <a href="<%=request.getContextPath()%>/songs" class="inline-flex items-center px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-lg font-medium transition duration-200">
                <i class="fas fa-arrow-left mr-2"></i>Back to Songs
            </a>
        </div>
    </div>
    
    <% 
    songRs.close();
    songStmt.close();
    playlistRs.close();
    playlistStmt.close();
    conn.close();
    %>
</body>
</html>
<%
    } catch (Exception e) {
        response.sendRedirect("songs?error=" + e.getMessage());
    }
%>
