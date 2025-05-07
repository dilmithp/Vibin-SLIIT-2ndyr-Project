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
    
    // Get album ID from request
    String albumId = request.getParameter("id");
    
    // Validate input
    if (albumId == null || albumId.isEmpty()) {
        response.sendRedirect("artist-albums.jsp?error=Invalid album ID");
        return;
    }
    
    // Album details
    String albumName = "";
    String genre = "";
    String releaseDate = "";
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Verify album belongs to artist
        PreparedStatement albumStmt = conn.prepareStatement(
            "SELECT * FROM albums WHERE album_id = ? AND artist = ?"
        );
        albumStmt.setInt(1, Integer.parseInt(albumId));
        albumStmt.setString(2, artistName);
        
        ResultSet albumRs = albumStmt.executeQuery();
        if (albumRs.next()) {
            albumName = albumRs.getString("album_name");
            genre = albumRs.getString("genre") != null ? albumRs.getString("genre") : "";
            releaseDate = albumRs.getDate("release_date") != null ? albumRs.getDate("release_date").toString() : "";
        } else {
            albumRs.close();
            albumStmt.close();
            conn.close();
            response.sendRedirect("artist-albums.jsp?error=Album not found or unauthorized access");
            return;
        }
        albumRs.close();
        albumStmt.close();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Album Songs</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-900 text-white">
    <div class="flex h-screen">
        <!-- Sidebar -->
        <div class="w-64 bg-black p-6 flex flex-col">
            <div class="mb-8">
                <a href="artist-dashboard.jsp" class="text-2xl font-bold text-purple-500">Vibin</a>
                <p class="text-sm text-gray-400">Artist Portal</p>
            </div>
            
            <nav class="flex-1 space-y-4">
                <a href="artist-dashboard.jsp" class="flex items-center text-gray-300 hover:text-purple-400 p-2 rounded-lg hover:bg-gray-800">
                    <i class="fas fa-tachometer-alt w-6"></i>
                    <span>Dashboard</span>
                </a>
                <a href="artist-albums.jsp" class="flex items-center text-purple-400 p-2 rounded-lg bg-gray-800">
                    <i class="fas fa-compact-disc w-6"></i>
                    <span>Albums</span>
                </a>
                <a href="artist-songs.jsp" class="flex items-center text-gray-300 hover:text-purple-400 p-2 rounded-lg hover:bg-gray-800">
                    <i class="fas fa-music w-6"></i>
                    <span>Songs</span>
                </a>
                <a href="artist-profile.jsp" class="flex items-center text-gray-300 hover:text-purple-400 p-2 rounded-lg hover:bg-gray-800">
                    <i class="fas fa-user w-6"></i>
                    <span>Profile</span>
                </a>
            </nav>
            
            <div class="mt-auto">
                <a href="artist-logout.jsp" class="flex items-center text-gray-300 hover:text-purple-400 p-2 rounded-lg hover:bg-gray-800">
                    <i class="fas fa-sign-out-alt w-6"></i>
                    <span>Logout</span>
                </a>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="flex-1 overflow-y-auto">
            <!-- Top Bar -->
            <div class="bg-gray-800 p-4 shadow-md flex justify-between items-center">
                <h1 class="text-xl font-bold">Album Songs</h1>
                <div class="flex items-center">
                    <span class="mr-4"><%= artistName %></span>
                    <div class="h-10 w-10 rounded-full bg-purple-600 flex items-center justify-center">
                        <i class="fas fa-user"></i>
                    </div>
                </div>
            </div>
            
            <!-- Content -->
            <div class="p-6">
                <!-- Album Info -->
                <div class="bg-gray-800 rounded-lg p-6 shadow-lg mb-6">
                    <div class="flex justify-between items-start">
                        <div>
                            <h2 class="text-2xl font-bold text-purple-400 mb-2"><%= albumName %></h2>
                            <p class="text-gray-400"><span class="font-medium">Genre:</span> <%= genre.isEmpty() ? "Not specified" : genre %></p>
                            <p class="text-gray-400"><span class="font-medium">Release Date:</span> <%= releaseDate.isEmpty() ? "Not specified" : releaseDate %></p>
                        </div>
                        <div>
                            <a href="artist-album-edit.jsp?id=<%= albumId %>" class="px-4 py-2 bg-blue-600 hover:bg-blue-700 rounded-lg font-medium transition duration-200">
                                <i class="fas fa-edit mr-2"></i>Edit Album
                            </a>
                        </div>
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
                
                <!-- Add Song Button -->
                <div class="mb-6">
                    <a href="artist-song-form.jsp?albumId=<%= albumId %>" class="inline-flex items-center px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                        <i class="fas fa-plus mr-2"></i>Add New Song to Album
                    </a>
                </div>
                
                <!-- Songs Table -->
                <div class="bg-gray-800 rounded-lg overflow-hidden shadow-lg">
                    <table class="min-w-full divide-y divide-gray-700">
                        <thead class="bg-gray-700">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Title</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Lyricist</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Music Director</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-700">
                            <% 
                            // Get songs in album
                            PreparedStatement songStmt = conn.prepareStatement(
                                "SELECT * FROM songs WHERE album_id = ? AND singer = ? ORDER BY song_id"
                            );
                            songStmt.setInt(1, Integer.parseInt(albumId));
                            songStmt.setString(2, artistName);
                            
                            ResultSet songRs = songStmt.executeQuery();
                            boolean hasSongs = false;
                            
                            while (songRs.next()) {
                                hasSongs = true;
                            %>
                            <tr class="hover:bg-gray-700">
                                <td class="px-6 py-4 whitespace-nowrap"><%= songRs.getString("song_name") %></td>
                                <td class="px-6 py-4 whitespace-nowrap"><%= songRs.getString("lyricist") != null ? songRs.getString("lyricist") : "-" %></td>
                                <td class="px-6 py-4 whitespace-nowrap"><%= songRs.getString("music_director") != null ? songRs.getString("music_director") : "-" %></td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <a href="artist-song-edit.jsp?id=<%= songRs.getInt("song_id") %>" class="text-blue-400 hover:text-blue-300 mr-3">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="artist-song-delete.jsp?id=<%= songRs.getInt("song_id") %>&albumId=<%= albumId %>" 
                                       class="text-red-400 hover:text-red-300"
                                       onclick="return confirm('Are you sure you want to delete this song?')">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <%
                            }
                            
                            if (!hasSongs) {
                            %>
                            <tr>
                                <td colspan="4" class="px-6 py-4 text-center text-gray-400">No songs in this album yet.</td>
                            </tr>
                            <%
                            }
                            
                            songRs.close();
                            songStmt.close();
                            conn.close();
                            %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Back Button -->
                <div class="mt-6">
                    <a href="artist-albums.jsp" class="inline-flex items-center px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-lg font-medium transition duration-200">
                        <i class="fas fa-arrow-left mr-2"></i>Back to Albums
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
<%
    } catch (Exception e) {
        response.sendRedirect("artist-albums.jsp?error=" + e.getMessage());
    }
%>
