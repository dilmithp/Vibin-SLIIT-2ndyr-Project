<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    // Get album ID from request
    String albumId = request.getParameter("id");
    
    // Validate input
    if (albumId == null || albumId.isEmpty()) {
        response.sendRedirect("admin-albums.jsp?error=Invalid album ID");
        return;
    }
    
    // Album details
    String albumName = "";
    String artist = "";
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Get album details
        PreparedStatement albumStmt = conn.prepareStatement("SELECT * FROM albums WHERE album_id = ?");
        albumStmt.setInt(1, Integer.parseInt(albumId));
        
        ResultSet albumRs = albumStmt.executeQuery();
        if (albumRs.next()) {
            albumName = albumRs.getString("album_name");
            artist = albumRs.getString("artist");
        } else {
            albumRs.close();
            albumStmt.close();
            conn.close();
            response.sendRedirect("admin-albums.jsp?error=Album not found");
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
    <!-- Admin Navigation -->
    <nav class="bg-black p-4 shadow-lg">
        <div class="container mx-auto flex justify-between items-center">
            <a href="admin-dashboard.jsp" class="text-2xl font-bold text-purple-500">Vibin Admin</a>
            <div class="flex items-center space-x-4">
                <a href="admin-dashboard.jsp" class="hover:text-purple-400"><i class="fas fa-tachometer-alt mr-2"></i>Dashboard</a>
                <a href="admin-users.jsp" class="hover:text-purple-400"><i class="fas fa-users mr-2"></i>Users</a>
                <a href="admin-songs.jsp" class="hover:text-purple-400"><i class="fas fa-music mr-2"></i>Songs</a>
                <a href="admin-albums.jsp" class="text-purple-400"><i class="fas fa-compact-disc mr-2"></i>Albums</a>
                <a href="admin-artists.jsp" class="hover:text-purple-400"><i class="fas fa-user-music mr-2"></i>Artists</a>
                <span class="text-gray-600">|</span>
                <span class="text-gray-400"><i class="fas fa-user mr-2"></i><%= session.getAttribute("adminName") %></span>
                <a href="<%=request.getContextPath()%>/AdminLogout" class="hover:text-purple-400"><i class="fas fa-sign-out-alt mr-2"></i>Logout</a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto py-8 px-4">
        <div class="flex justify-between items-center mb-6">
            <div>
                <h1 class="text-3xl font-bold text-purple-400"><%= albumName %></h1>
                <p class="text-gray-400">Artist: <%= artist %></p>
            </div>
            <div class="flex space-x-2">
                <a href="admin-song-form.jsp?albumId=<%= albumId %>" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                    <i class="fas fa-plus mr-2"></i>Add Song to Album
                </a>
                <a href="admin-albums.jsp" class="px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-lg font-medium transition duration-200">
                    <i class="fas fa-arrow-left mr-2"></i>Back to Albums
                </a>
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
        <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-700">
                    <thead class="bg-gray-700">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">ID</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Title</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Singer</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Lyricist</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Music Director</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-700">
                        <% 
                        // Get songs in album
                        PreparedStatement songStmt = conn.prepareStatement("SELECT * FROM songs WHERE album_id = ?");
                        songStmt.setInt(1, Integer.parseInt(albumId));
                        
                        ResultSet songRs = songStmt.executeQuery();
                        boolean hasSongs = false;
                        
                        while (songRs.next()) {
                            hasSongs = true;
                        %>
                        <tr class="hover:bg-gray-700">
                            <td class="px-6 py-4 whitespace-nowrap"><%= songRs.getInt("song_id") %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= songRs.getString("song_name") %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= songRs.getString("singer") %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= songRs.getString("lyricist") != null ? songRs.getString("lyricist") : "-" %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= songRs.getString("music_director") != null ? songRs.getString("music_director") : "-" %></td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <a href="admin-song-form.jsp?id=<%= songRs.getInt("song_id") %>" class="text-blue-400 hover:text-blue-300 mr-3">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="admin-song-delete.jsp?id=<%= songRs.getInt("song_id") %>&returnTo=album&albumId=<%= albumId %>" 
                                   onclick="return confirm('Are you sure you want to delete this song?')"
                                   class="text-red-400 hover:text-red-300">
                                    <i class="fas fa-trash-alt"></i>
                                </a>
                            </td>
                        </tr>
                        <%
                        }
                        
                        if (!hasSongs) {
                        %>
                        <tr>
                            <td colspan="6" class="px-6 py-4 text-center text-gray-400">No songs found in this album.</td>
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
        response.sendRedirect("admin-albums.jsp?error=" + e.getMessage());
    }
%>
