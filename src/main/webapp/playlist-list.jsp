<%@ page import="java.sql.*" %>
<%@ page import="com.vibin.playlist.PlaylistDAO" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - My Playlists</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-900 text-white">
    <!-- Navigation Bar -->
    <nav class="bg-black p-4 shadow-lg">
        <div class="container mx-auto flex justify-between items-center">
            <a href="index.jsp" class="text-2xl font-bold text-purple-500">Vibin</a>
            <div class="flex items-center space-x-4">
                <a href="index.jsp" class="hover:text-purple-400"><i class="fas fa-home mr-2"></i>Home</a>
                <a href="<%=request.getContextPath()%>/songs" class="hover:text-purple-400"><i class="fas fa-music mr-2"></i>Songs</a>
                <a href="<%=request.getContextPath()%>/albums" class="hover:text-purple-400"><i class="fas fa-compact-disc mr-2"></i>Albums</a>
                <a href="playlist-list.jsp" class="text-purple-400"><i class="fas fa-list mr-2"></i>Playlists</a>
                <a href="likedSongs.jsp" class="hover:text-purple-400"><i class="fas fa-heart mr-2"></i>Liked</a>
                <a href="profile.jsp" class="hover:text-purple-400"><i class="fas fa-user mr-2"></i>Profile</a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto py-8 px-4">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-3xl font-bold text-purple-400">My Playlists</h1>
            <a href="playlist-form.jsp" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                <i class="fas fa-plus mr-2"></i>Create Playlist
            </a>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <% 
            try {
                // Get user ID from session safely
                Object userIdObj = session.getAttribute("id");
                int userId = 0;
                if (userIdObj != null) {
                    if (userIdObj instanceof Integer) {
                        userId = (Integer) userIdObj;
                    } else if (userIdObj instanceof String) {
                        userId = Integer.parseInt((String) userIdObj);
                    }
                }
                
                if (userId == 0) {
                    out.println("<p class='text-red-500 col-span-3 text-center'>Please log in to view your playlists</p>");
                } else {
                    // Get playlists
                    PlaylistDAO playlistDAO = new PlaylistDAO();
                    List<Map<String, Object>> playlists = playlistDAO.getUserPlaylists(userId);
                    
                    if (playlists.isEmpty()) {
                        out.println("<p class='text-gray-400 col-span-3 text-center'>You haven't created any playlists yet.</p>");
                    } else {
                        for(Map<String, Object> playlist : playlists) {
            %>
                <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden hover:bg-gray-700 transition duration-200">
                    <a href="playlist-detail.jsp?id=<%= playlist.get("playlistId") %>">
                        <div class="p-6">
                            <h2 class="text-xl font-bold text-white mb-2"><%= playlist.get("name") %></h2>
                            <p class="text-gray-400 mb-4"><%= playlist.get("description") != null ? playlist.get("description") : "No description" %></p>
                            <div class="flex justify-between items-center">
                                <span class="text-sm text-gray-500"><%= playlist.get("songCount") %> songs</span>
                                <div>
                                    <a href="playlist-form.jsp?id=<%= playlist.get("playlistId") %>" class="text-blue-400 hover:text-blue-300 mr-3">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="deletePlaylist.jsp?id=<%= playlist.get("playlistId") %>" class="text-red-400 hover:text-red-300" 
                                       onclick="return confirm('Are you sure you want to delete this playlist?')">
                                        <i class="fas fa-trash-alt"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </a>
                </div>
            <%
                        }
                    }
                }
            } catch(Exception e) {
                out.println("<p class='text-red-500 col-span-3'>Error: " + e.getMessage() + "</p>");
            }
            %>
        </div>
    </div>
</body>
</html>
