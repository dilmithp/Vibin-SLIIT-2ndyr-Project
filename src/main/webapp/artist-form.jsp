<%@ page import="java.sql.*" %>
<%@ page import="com.vibin.artist.ArtistDAO" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Artist Form</title>
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
                <a href="artist-list.jsp" class="text-purple-400"><i class="fas fa-user-music mr-2"></i>Artists</a>
                <a href="playlist-list.jsp" class="hover:text-purple-400"><i class="fas fa-list mr-2"></i>Playlists</a>
                <a href="profile.jsp" class="hover:text-purple-400"><i class="fas fa-user mr-2"></i>Profile</a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto py-8 px-4">
        <%
            // Check if editing or creating new
            String artistId = request.getParameter("id");
            String artistName = "";
            String bio = "";
            String imageUrl = "";
            String genre = "";
            String country = "";
            boolean isEditing = artistId != null && !artistId.isEmpty();
            String formTitle = isEditing ? "Edit Artist" : "Add New Artist";
            
            // If editing, fetch artist details
            if (isEditing) {
                try {
                    ArtistDAO artistDAO = new ArtistDAO();
                    Map<String, Object> artist = artistDAO.getArtistById(Integer.parseInt(artistId));
                    
                    if (artist != null) {
                        artistName = (String) artist.get("name");
                        bio = (String) artist.get("bio");
                        imageUrl = (String) artist.get("imageUrl");
                        genre = (String) artist.get("genre");
                        country = (String) artist.get("country");
                    }
                } catch (Exception e) {
                    out.println("<p class='text-red-500'>Error loading artist: " + e.getMessage() + "</p>");
                }
            }
        %>
        
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-3xl font-bold text-purple-400"><%= formTitle %></h1>
        </div>
        
        <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
            <form action="saveArtist.jsp" method="post" class="p-6">
                <% if (isEditing) { %>
                    <input type="hidden" name="artistId" value="<%= artistId %>">
                <% } %>
                
                <div class="mb-4">
                    <label for="artistName" class="block text-sm font-medium text-gray-400 mb-2">Artist Name</label>
                    <input type="text" id="artistName" name="artistName" value="<%= artistName %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
                           required>
                </div>
                
                <div class="mb-4">
                    <label for="genre" class="block text-sm font-medium text-gray-400 mb-2">Genre</label>
                    <input type="text" id="genre" name="genre" value="<%= genre %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                
                <div class="mb-4">
                    <label for="country" class="block text-sm font-medium text-gray-400 mb-2">Country</label>
                    <input type="text" id="country" name="country" value="<%= country %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                
                <div class="mb-4">
                    <label for="imageUrl" class="block text-sm font-medium text-gray-400 mb-2">Image URL</label>
                    <input type="text" id="imageUrl" name="imageUrl" value="<%= imageUrl %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                
                <div class="mb-6">
                    <label for="bio" class="block text-sm font-medium text-gray-400 mb-2">Biography</label>
                    <textarea id="bio" name="bio" rows="6"
                              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"><%= bio %></textarea>
                </div>
                
                <div class="flex justify-end">
                    <a href="artist-list.jsp" class="px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-lg font-medium transition duration-200 mr-2">
                        Cancel
                    </a>
                    <button type="submit" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                        <%= isEditing ? "Update" : "Add" %> Artist
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
