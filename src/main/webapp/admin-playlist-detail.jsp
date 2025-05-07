<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    // Get playlist ID from request
    String playlistId = request.getParameter("id");
    
    // Validate input
    if (playlistId == null || playlistId.isEmpty()) {
        response.sendRedirect("admin-playlists.jsp?error=Invalid playlist ID");
        return;
    }
    
    // Playlist details
    String playlistName = "";
    String userName = "";
    String description = "";
    Timestamp createdDate = null;
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Get playlist details
        PreparedStatement playlistStmt = conn.prepareStatement(
            "SELECT p.*, u.name AS user_name FROM playlists p " +
            "JOIN user u ON p.user_id = u.id " +
            "WHERE p.playlist_id = ?"
        );
        playlistStmt.setInt(1, Integer.parseInt(playlistId));
        
        ResultSet playlistRs = playlistStmt.executeQuery();
        if (playlistRs.next()) {
            playlistName = playlistRs.getString("playlist_name");
            userName = playlistRs.getString("user_name");
            description = playlistRs.getString("description");
            createdDate = playlistRs.getTimestamp("created_date");
        } else {
            playlistRs.close();
            playlistStmt.close();
            conn.close();
            response.sendRedirect("admin-playlists.jsp?error=Playlist not found");
            return;
        }
        playlistRs.close();
        playlistStmt.close();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Playlist Details</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-900 text-white">
    <!-- Admin Navigation -->
    <nav class="bg-black p-4 shadow-lg">
        <div class="container mx-auto flex justify-between items-center">
            <a href="admin-dashboard.jsp" class="text-2xl font-bold text-purple-500">Vibin Admin</a>
            <div class="flex items-center space-x-4">
                <a href="admin-dashboard.jsp" class="hover:text-purple-400"><i class="fas fa-tachometer-alt mr-2"></i>Dashboard</a>
                <a href="admin-users.jsp" class="hover:text-purple-400"><i class="fas fa-users mr-2"></i>Users</a>
                <a href="admin-songs.jsp" class="hover:text-purple-400"><i class="fas fa-music mr-2"></i>Songs</a>
                <a href="admin-albums.jsp" class="hover:text-purple-400"><i class="fas fa-compact-disc mr-2"></i>Albums</a>
                <a href="admin-artists.jsp" class="hover:text-purple-400"><i class="fas fa-user-music mr-2"></i>Artists</a>
                <a href="admin-playlists.jsp" class="text-purple-400"><i class="fas fa-list mr-2"></i>Playlists</a>
                <span class="text-gray-600">|</span>
                <span class="text-gray-400"><i class="fas fa-user mr-2"></i><%= session.getAttribute("adminName") %></span>
                <a href="<%=request.getContextPath()%>/AdminLogout" class="hover:text-purple-400"><i class="fas fa-sign-out-alt mr-2"></i>Logout</a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto py-8 px-4">
        <div class="flex justify-between items-center mb-6">
            <div>
                <h1 class="text-3xl font-bold text-purple-400"><%= playlistName %></h1>
                <p class="text-gray-400">Created by: <%= userName %> • <%= createdDate %></p>
            </div>
            <div class="flex space-x-2">
                <a href="admin-playlists.jsp" class="px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-lg font-medium transition duration-200">
                    <i class="fas fa-arrow-left mr-2"></i>Back to Playlists
                </a>
                <a href="admin-playlist-delete.jsp?id=<%= playlistId %>" 
                   onclick="return confirm('Are you sure you want to delete this playlist?')"
                   class="px-4 py-2 bg-red-600 hover:bg-red-700 rounded-lg font-medium transition duration-200">
                    <i class="fas fa-trash-alt mr-2"></i>Delete Playlist
                </a>
            </div>
        </div>
        
        <% if (description != null && !description.isEmpty()) { %>
        <div class="bg-gray-800 rounded-lg p-4 mb-6">
            <h2 class="text-xl font-bold mb-2">Description</h2>
            <p class="text-gray-400"><%= description %></p>
        </div>
        <% } %>
        
        <!-- Songs in Playlist -->
        <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-700">
                    <thead class="bg-gray-700">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">#</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Title</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Artist</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Album</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Added Date</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-700">
                        <% 
                        // Get songs in playlist
                        PreparedStatement songStmt = conn.prepareStatement(
                            "SELECT s.*, ps.added_date, a.album_name " +
                            "FROM songs s " +
                            "INNER JOIN playlist_songs ps ON s.song_id = ps.song_id " +
                            "LEFT JOIN albums a ON s.album_id = a.album_id " +
                            "WHERE ps.playlist_id = ? " +
                            "ORDER BY ps.added_date DESC"
                        );
                        songStmt.setInt(1, Integer.parseInt(playlistId));
                        
                        ResultSet songRs = songStmt.executeQuery();
                        boolean hasSongs = false;
                        int counter = 1;
                        
                        while (songRs.next()) {
                            hasSongs = true;
                        %>
                        <tr class="hover:bg-gray-700">
                            <td class="px-6 py-4 whitespace-nowrap"><%= counter++ %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= songRs.getString("song_name") %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= songRs.getString("singer") %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= songRs.getString("album_name") != null ? songRs.getString("album_name") : "-" %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= songRs.getTimestamp("added_date") %></td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <a href="admin-song-form.jsp?id=<%= songRs.getInt("song_id") %>" class="text-blue-400 hover:text-blue-300 mr-3">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="admin-playlist-remove-song.jsp?playlistId=<%= playlistId %>&songId=<%= songRs.getInt("song_id") %>" 
                                   onclick="return confirm('Are you sure you want to remove this song from the playlist?')"
                                   class="text-red-400 hover:text-red-300">
                                    <i class="fas fa-times"></i>
                                </a>
                            </td>
                        </tr>
                        <%
                        }
                        
                        if (!hasSongs) {
                        %>
                        <tr>
                            <td colspan="6" class="px-6 py-4 text-center text-gray-400">No songs in this playlist.</td>
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
        </div>
    </div>
</body>
</html>
<%
    } catch (Exception e) {
        response.sendRedirect("admin-playlists.jsp?error=" + e.getMessage());
    }
%>
