<%@ page import="java.sql.*" %>
<%@ page import="com.vibin.playlist.PlaylistDAO" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Playlist Form</title>
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
            // Check if editing or creating new
            String playlistId = request.getParameter("id");
            String playlistName = "";
            String description = "";
            boolean isEditing = playlistId != null && !playlistId.isEmpty();
            String formTitle = isEditing ? "Edit Playlist" : "Create New Playlist";
            
            // If editing, fetch playlist details
            if (isEditing) {
                try {
                    // This would require a getPlaylistById method in your DAO
                    // For now, we'll just use placeholders
                    playlistName = "My Playlist"; // Replace with actual data fetch
                    description = "My playlist description"; // Replace with actual data fetch
                } catch (Exception e) {
                    out.println("<p class='text-red-500'>Error loading playlist: " + e.getMessage() + "</p>");
                }
            }
        %>
        
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-3xl font-bold text-purple-400"><%= formTitle %></h1>
        </div>
        
        <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
            <form action="savePlaylist.jsp" method="post" class="p-6">
                <% if (isEditing) { %>
                    <input type="hidden" name="playlistId" value="<%= playlistId %>">
                <% } %>
                
                <div class="mb-4">
                    <label for="playlistName" class="block text-sm font-medium text-gray-400 mb-2">Playlist Name</label>
                    <input type="text" id="playlistName" name="playlistName" value="<%= playlistName %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
                           required>
                </div>
                
                <div class="mb-6">
                    <label for="description" class="block text-sm font-medium text-gray-400 mb-2">Description (Optional)</label>
                    <textarea id="description" name="description" rows="4"
                              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"><%= description %></textarea>
                </div>
                
                <div class="flex justify-end">
                    <a href="playlist-list.jsp" class="px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-lg font-medium transition duration-200 mr-2">
                        Cancel
                    </a>
                    <button type="submit" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                        <%= isEditing ? "Update" : "Create" %> Playlist
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
