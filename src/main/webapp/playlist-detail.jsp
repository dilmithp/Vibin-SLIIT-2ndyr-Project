<%@ page import="java.sql.*" %>
<%@ page import="com.vibin.playlist.PlaylistDAO" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Playlist Details</title>
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
                <a href="profile.jsp" class="hover:text-purple-400"><i class="fas fa-user mr-2"></i>Profile</a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto py-8 px-4">
        <%
            // Get playlist ID from request
            String playlistIdStr = request.getParameter("id");
            int playlistId = 0;
            
            try {
                playlistId = Integer.parseInt(playlistIdStr);
            } catch (Exception e) {
                out.println("<p class='text-red-500'>Invalid playlist ID</p>");
                return;
            }
            
            // Get user ID from session safely - FIXED: using "id" instead of "userId"
            String userIdStr = (String) session.getAttribute("id");
            
            if (userIdStr == null) {
                out.println("<p class='text-red-500'>Please log in to view playlists</p>");
                return;
            }
            
            try {
                PlaylistDAO playlistDAO = new PlaylistDAO();
                
                // Get playlist details
                Map<String, Object> playlist = playlistDAO.getPlaylistById(playlistId, userIdStr);
                
                if (playlist == null) {
                    out.println("<p class='text-red-500'>Playlist not found or you don't have permission to view it</p>");
                    return;
                }
                
                // Get songs in playlist - FIXED: Using the correct method
					List<Map<String, Object>> songs = playlistDAO.getPlaylistSongs(playlistId);
        %>
        
        <!-- Success message if any -->
        <% if (request.getParameter("message") != null) { %>
            <div class="bg-green-800 text-white px-4 py-3 rounded mb-4">
                <%= request.getParameter("message") %>
            </div>
        <% } %>
        
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-3xl font-bold text-purple-400"><%= playlist.get("name") %></h1>
            <div class="flex space-x-2">
                <a href="playlist-form.jsp?id=<%= playlistId %>" class="px-4 py-2 bg-blue-600 hover:bg-blue-700 rounded-lg font-medium transition duration-200">
                    <i class="fas fa-edit mr-2"></i>Edit
                </a>
                <a href="deletePlaylist.jsp?id=<%= playlistId %>" 
                   onclick="return confirm('Are you sure you want to delete this playlist?')"
                   class="px-4 py-2 bg-red-600 hover:bg-red-700 rounded-lg font-medium transition duration-200">
                    <i class="fas fa-trash-alt mr-2"></i>Delete
                </a>
            </div>
        </div>
        
        <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden mb-8">
            <div class="p-6">
                <p class="text-gray-400 mb-4"><%= playlist.get("description") != null ? playlist.get("description") : "No description" %></p>
                <p class="text-sm text-gray-500"><i class="far fa-calendar-alt mr-2"></i>Created: <%= playlist.get("createdDate") %></p>
                <p class="text-sm text-gray-500"><i class="fas fa-music mr-2"></i><%= songs.size() %> songs</p>
            </div>
        </div>
        
        <!-- Add song to playlist form -->
        <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden mb-8">
            <div class="p-6">
                <h2 class="text-xl font-bold text-white mb-4">Add Songs to Playlist</h2>
                <form action="addToPlaylist.jsp" method="post" class="flex items-center">
                    <input type="hidden" name="playlistId" value="<%= playlistId %>">
                    <select name="songId" class="flex-grow px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500 mr-2">
                        <option value="">Select a song</option>
                        <%
                            // Get all songs not in playlist
                            List<Map<String, Object>> availableSongs = playlistDAO.getAvailableSongs(playlistId);
                            for (Map<String, Object> song : availableSongs) {
                        %>
                            <option value="<%= song.get("songId") %>"><%= song.get("title") %> - <%= song.get("artist") %></option>
                        <% } %>
                    </select>
                    <button type="submit" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                        <i class="fas fa-plus mr-2"></i>Add
                    </button>
                </form>
            </div>
        </div>
        
        <!-- Songs in playlist -->
        <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
            <div class="p-6">
                <h2 class="text-xl font-bold text-white mb-4">Songs in Playlist</h2>
                
                <% if (songs.isEmpty()) { %>
                    <p class="text-gray-400">This playlist is empty. Add some songs!</p>
                <% } else { %>
                    <table class="min-w-full divide-y divide-gray-700">
                        <thead class="bg-gray-700">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Title</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Singer</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Music Director</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Date Added</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-700">
                        <% for (Map<String, Object> song : songs) { %>
                            <tr class="hover:bg-gray-700">
                                <td class="px-6 py-4 whitespace-nowrap"><%= song.get("title") %></td>
                                <td class="px-6 py-4 whitespace-nowrap"><%= song.get("artist") %></td>
                                <td class="px-6 py-4 whitespace-nowrap"><%= song.get("musicDirector") %></td>
                                <td class="px-6 py-4 whitespace-nowrap"><%= song.get("addedDate") %></td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <form action="removeFromPlaylist.jsp" method="post" class="inline">
                                        <input type="hidden" name="playlistId" value="<%= playlistId %>">
                                        <input type="hidden" name="songId" value="<%= song.get("songId") %>">
                                        <button type="submit" class="text-red-400 hover:text-red-300">
                                            <i class="fas fa-times"></i> Remove
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>
        </div>
        
        <% 
            } catch (Exception e) {
                out.println("<p class='text-red-500'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>
