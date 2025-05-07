<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if user is logged in
    if (session.getAttribute("id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
	int userId = Integer.parseInt(String.valueOf(session.getAttribute("id")));
    String userName = (String)session.getAttribute("name");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Liked Songs</title>
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
                <a href="<%=request.getContextPath()%>/songs" class="hover:text-purple-400"><i class="fas fa-music mr-2"></i>Songs</a>
                <a href="<%=request.getContextPath()%>/albums" class="hover:text-purple-400"><i class="fas fa-compact-disc mr-2"></i>Albums</a>
                <a href="playlist-list.jsp" class="hover:text-purple-400"><i class="fas fa-list mr-2"></i>Playlists</a>
                <a href="likedSongs.jsp" class="text-purple-400"><i class="fas fa-heart mr-2"></i>Liked</a>
                <a href="profile.jsp" class="hover:text-purple-400"><i class="fas fa-user mr-2"></i>Profile</a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto py-8 px-4">
        <!-- Header -->
        <div class="flex items-start mb-8">
            <div class="w-48 h-48 bg-gradient-to-r from-pink-600 to-purple-600 flex items-center justify-center rounded-lg shadow-lg mr-6">
                <i class="fas fa-heart text-6xl text-white"></i>
            </div>
            <div class="flex-1">
                <h1 class="text-4xl font-bold text-purple-400 mb-2">Liked Songs</h1>
                <p class="text-gray-400 mb-4">Songs you've liked will appear here</p>
                
                <button class="px-6 py-2 bg-purple-600 hover:bg-purple-700 rounded-full font-medium transition duration-200">
                    <i class="fas fa-play mr-2"></i>Play All
                </button>
            </div>
        </div>
        
        <!-- Success/Error Messages -->
        <% if (request.getParameter("message") != null) { %>
            <div class="bg-green-800 text-white px-4 py-3 rounded mb-4">
                <%= request.getParameter("message") %>
            </div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="bg-red-800 text-white px-4 py-3 rounded mb-4">
                <%= request.getParameter("error") %>
            </div>
        <% } %>
        
        <!-- Songs Table -->
        <div class="bg-gray-800 rounded-lg overflow-hidden shadow-lg">
            <table class="min-w-full divide-y divide-gray-700">
                <thead class="bg-gray-700">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">#</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Title</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Artist</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Album</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-700">
                    <% 
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
                        
                        // Get liked songs
                        PreparedStatement stmt = conn.prepareStatement(
                            "SELECT s.*, a.album_name, a.artist FROM songs s " +
                            "LEFT JOIN albums a ON s.album_id = a.album_id " +
                            "INNER JOIN liked_songs ls ON s.song_id = ls.song_id " +
                            "WHERE ls.user_id = ? " +
                            "ORDER BY s.song_name"
                        );
                        stmt.setInt(1, userId);
                        ResultSet rs = stmt.executeQuery();
                        
                        boolean hasSongs = false;
                        int counter = 1;
                        
                        while (rs.next()) {
                            hasSongs = true;
                            int songId = rs.getInt("song_id");
                    %>
                    <tr class="hover:bg-gray-700">
                        <td class="px-6 py-4 whitespace-nowrap"><%= counter++ %></td>
                        <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("song_name") %></td>
                        <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("singer") %></td>
                        <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("album_name") != null ? rs.getString("album_name") : "-" %></td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <button class="text-purple-400 hover:text-purple-300 mr-3" onclick="playSong(<%= songId %>)">
                                <i class="fas fa-play"></i>
                            </button>
                            <a href="playlist-add-song.jsp?songId=<%= songId %>" class="text-blue-400 hover:text-blue-300 mr-3">
                                <i class="fas fa-plus"></i>
                            </a>
                            <a href="unlike-song.jsp?songId=<%= songId %>" 
                               class="text-red-400 hover:text-red-300"
                               onclick="return confirm('Are you sure you want to unlike this song?')">
                                <i class="fas fa-heart-broken"></i>
                            </a>
                        </td>
                    </tr>
                    <%
                        }
                        
                        if (!hasSongs) {
                    %>
                    <tr>
                        <td colspan="5" class="px-6 py-4 text-center text-gray-400">
                            <p>You haven't liked any songs yet.</p>
                            <p class="mt-2">
                                <a href="<%=request.getContextPath()%>/songs" class="text-purple-400 hover:underline">
                                    Browse songs to find music you love
                                </a>
                            </p>
                        </td>
                    </tr>
                    <%
                        }
                        
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<tr><td colspan='5' class='px-6 py-4 text-center text-red-500'>Error: " + e.getMessage() + "</td></tr>");
                    }
                    %>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Now Playing Bar -->
    <div class="fixed bottom-0 left-0 right-0 bg-gray-900 border-t border-gray-800 p-3 shadow-lg">
        <div class="container mx-auto flex justify-between items-center">
            <div class="flex items-center">
                <img src="${pageContext.request.contextPath}/images/default-album.jpg" alt="Now Playing" class="h-12 w-12 rounded mr-3">
                <div>
                    <h4 class="font-medium">Currently Playing Song</h4>
                    <p class="text-sm text-gray-400">Artist Name</p>
                </div>
            </div>
            
            <div class="flex flex-col items-center">
                <div class="flex items-center space-x-4 mb-1">
                    <button class="text-gray-400 hover:text-white"><i class="fas fa-step-backward"></i></button>
                    <button class="bg-purple-600 hover:bg-purple-700 text-white p-2 rounded-full">
                        <i class="fas fa-play"></i>
                    </button>
                    <button class="text-gray-400 hover:text-white"><i class="fas fa-step-forward"></i></button>
                </div>
                <div class="w-64 bg-gray-700 rounded-full h-1.5">
                    <div class="bg-purple-600 h-1.5 rounded-full w-1/3"></div>
                </div>
            </div>
            
            <div class="flex items-center space-x-3">
                <button class="text-gray-400 hover:text-white"><i class="fas fa-volume-up"></i></button>
                <div class="w-24 bg-gray-700 rounded-full h-1.5">
                    <div class="bg-purple-600 h-1.5 rounded-full w-2/3"></div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- JavaScript for song playback -->
    <script>
        function playSong(songId) {
            // This would be implemented to handle song playback
            console.log("Playing song ID: " + songId);
            // You could update the now playing bar or redirect to a player page
        }
    </script>
</body>
</html>
