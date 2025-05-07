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
    <title>Vibin - My Playlists</title>
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
                <a href="playlist-list.jsp" class="text-purple-400"><i class="fas fa-list mr-2"></i>Playlists</a>
                <a href="likedSongs.jsp" class="hover:text-purple-400"><i class="fas fa-heart mr-2"></i>Liked</a>
                <a href="profile.jsp" class="hover:text-purple-400"><i class="fas fa-user mr-2"></i>Profile</a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto py-8 px-4">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-3xl font-bold text-purple-400">My Playlists</h1>
            <a href="playlist-create.jsp" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                <i class="fas fa-plus mr-2"></i>Create Playlist
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
        
        <!-- Playlists Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            <% 
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
                
                // Get user playlists
                PreparedStatement stmt = conn.prepareStatement(
                    "SELECT p.*, (SELECT COUNT(*) FROM playlist_songs WHERE playlist_id = p.playlist_id) AS song_count " +
                    "FROM playlists p WHERE p.user_id = ? ORDER BY p.created_date DESC"
                );
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                
                boolean hasPlaylists = false;
                while (rs.next()) {
                    hasPlaylists = true;
                    int playlistId = rs.getInt("playlist_id");
                    String playlistName = rs.getString("playlist_name");
                    String description = rs.getString("description");
                    int songCount = rs.getInt("song_count");
                    Timestamp createdDate = rs.getTimestamp("created_date");
            %>
            <div class="bg-gray-800 rounded-lg overflow-hidden shadow-lg hover:shadow-xl transition-shadow duration-300">
                <div class="h-40 bg-gradient-to-r from-purple-900 to-blue-900 flex items-center justify-center">
                    <i class="fas fa-music text-4xl text-gray-300"></i>
                </div>
                <div class="p-4">
                    <h2 class="text-xl font-bold mb-1 truncate"><%= playlistName %></h2>
                    <p class="text-sm text-gray-500 mb-4"><%= songCount %> songs • Created on <%= createdDate.toString().substring(0, 10) %></p>
                    
                    <div class="flex justify-between items-center">
                        <a href="playlist-view.jsp?id=<%= playlistId %>" 
                           class="text-purple-400 hover:text-purple-300">
                            <i class="fas fa-play mr-1"></i> Play
                        </a>
                        <div class="flex space-x-3">
                            <a href="playlist-edit.jsp?id=<%= playlistId %>" 
                               class="text-blue-400 hover:text-blue-300">
                                <i class="fas fa-edit"></i>
                            </a>
                            <a href="playlist-delete.jsp?id=<%= playlistId %>" 
                               class="text-red-400 hover:text-red-300"
                               onclick="return confirm('Are you sure you want to delete this playlist?')">
                                <i class="fas fa-trash"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            <%
                }
                
                if (!hasPlaylists) {
            %>
            <div class="col-span-full bg-gray-800 rounded-lg p-8 text-center">
                <i class="fas fa-music text-5xl text-gray-600 mb-4"></i>
                <p class="text-xl text-gray-400">You don't have any playlists yet</p>
                <p class="text-gray-500 mt-2 mb-4">Create your first playlist to start organizing your favorite songs</p>
                <a href="playlist-create.jsp" class="inline-flex items-center px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                    <i class="fas fa-plus mr-2"></i>Create Playlist
                </a>
            </div>
            <%
                }
                
                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                out.println("<div class='col-span-full bg-red-800 text-white px-4 py-3 rounded'>Error: " + e.getMessage() + "</div>");
            }
            %>
        </div>
    </div>
    
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
</body>
</html>
