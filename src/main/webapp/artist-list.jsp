<%@ page import="java.sql.*" %>
<%@ page import="com.vibin.artist.ArtistDAO" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Artist Management</title>
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
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-3xl font-bold text-purple-400">Artist Management</h1>
            <a href="artist-form.jsp" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                <i class="fas fa-plus mr-2"></i>Add New Artist
            </a>
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
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <% 
            try {
                ArtistDAO artistDAO = new ArtistDAO();
                List<Map<String, Object>> artists = artistDAO.getAllArtists();
                
                if (artists.isEmpty()) {
                    out.println("<p class='text-gray-400 col-span-3 text-center'>No artists found. Add some artists to get started!</p>");
                } else {
                    for(Map<String, Object> artist : artists) {
            %>
                <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden hover:bg-gray-700 transition duration-200">
                    <a href="artist-detail.jsp?id=<%= artist.get("artistId") %>">
                        <div class="h-40 bg-gray-700 flex items-center justify-center">
                            <% if (artist.get("imageUrl") != null && !((String)artist.get("imageUrl")).isEmpty()) { %>
                                <img src="<%= artist.get("imageUrl") %>" alt="<%= artist.get("name") %>" class="h-full w-full object-cover">
                            <% } else { %>
                                <i class="fas fa-user-circle text-6xl text-gray-500"></i>
                            <% } %>
                        </div>
                        <div class="p-6">
                            <h2 class="text-xl font-bold text-white mb-2"><%= artist.get("name") %></h2>
                            <p class="text-gray-400 mb-2"><%= artist.get("genre") != null ? artist.get("genre") : "Unknown genre" %></p>
                            <p class="text-gray-400 mb-4 line-clamp-2"><%= artist.get("bio") != null ? artist.get("bio") : "No bio available" %></p>
                            <div class="flex justify-end">
                                <a href="artist-form.jsp?id=<%= artist.get("artistId") %>" class="text-blue-400 hover:text-blue-300 mr-3">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="deleteArtist.jsp?id=<%= artist.get("artistId") %>" class="text-red-400 hover:text-red-300" 
                                   onclick="return confirm('Are you sure you want to delete this artist?')">
                                    <i class="fas fa-trash-alt"></i>
                                </a>
                            </div>
                        </div>
                    </a>
                </div>
            <%
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
