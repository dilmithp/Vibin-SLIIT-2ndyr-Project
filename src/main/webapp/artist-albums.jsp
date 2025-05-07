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
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Artist Albums</title>
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
                <h1 class="text-xl font-bold">My Albums</h1>
                <div class="flex items-center">
                    <span class="mr-4"><%= artistName %></span>
                    <div class="h-10 w-10 rounded-full bg-purple-600 flex items-center justify-center">
                        <i class="fas fa-user"></i>
                    </div>
                </div>
            </div>
            
            <!-- Content -->
            <div class="p-6">
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
                
                <!-- Add Album Button -->
                <div class="mb-6">
                    <a href="artist-album-form.jsp" class="inline-flex items-center px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                        <i class="fas fa-plus mr-2"></i>Add New Album
                    </a>
                </div>
                
                <!-- Albums Grid -->
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <% 
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
                        
                        // Get albums by this artist
                        PreparedStatement stmt = conn.prepareStatement(
                            "SELECT a.*, (SELECT COUNT(*) FROM songs WHERE album_id = a.album_id) AS song_count " +
                            "FROM albums a WHERE a.artist = ? ORDER BY a.release_date DESC"
                        );
                        stmt.setString(1, artistName);
                        ResultSet rs = stmt.executeQuery();
                        
                        boolean hasAlbums = false;
                        while (rs.next()) {
                            hasAlbums = true;
                    %>
                    <div class="bg-gray-800 rounded-lg overflow-hidden shadow-lg hover:shadow-xl transition-shadow duration-300">
                        <div class="h-40 bg-gray-700 flex items-center justify-center">
                            <i class="fas fa-compact-disc text-4xl text-gray-500"></i>
                        </div>
                        <div class="p-4">
                            <h2 class="text-xl font-bold mb-1"><%= rs.getString("album_name") %></h2>
                            <p class="text-gray-400 mb-2"><%= rs.getString("genre") != null ? rs.getString("genre") : "No genre" %></p>
                            <p class="text-sm text-gray-500 mb-4">
                                <%= rs.getDate("release_date") != null ? rs.getDate("release_date") : "No release date" %> • 
                                <%= rs.getInt("song_count") %> songs
                            </p>
                            
                            <div class="flex justify-between items-center">
                                <a href="artist-album-songs.jsp?id=<%= rs.getInt("album_id") %>" 
                                   class="text-purple-400 hover:text-purple-300">
                                    <i class="fas fa-eye mr-1"></i> View Songs
                                </a>
                                <div class="flex space-x-3">
                                    <a href="artist-album-edit.jsp?id=<%= rs.getInt("album_id") %>" 
                                       class="text-blue-400 hover:text-blue-300">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="artist-album-delete.jsp?id=<%= rs.getInt("album_id") %>" 
                                       class="text-red-400 hover:text-red-300"
                                       onclick="return confirm('Are you sure you want to delete this album?')">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                        }
                        
                        if (!hasAlbums) {
                    %>
                    <div class="col-span-3 bg-gray-800 rounded-lg p-8 text-center">
                        <i class="fas fa-compact-disc text-5xl text-gray-600 mb-4"></i>
                        <p class="text-xl text-gray-400">No albums found</p>
                        <p class="text-gray-500 mt-2 mb-4">Start by adding a new album to your collection</p>
                        <a href="artist-album-form.jsp" class="inline-flex items-center px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                            <i class="fas fa-plus mr-2"></i>Add New Album
                        </a>
                    </div>
                    <%
                        }
                        
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<div class='col-span-3 bg-red-800 text-white px-4 py-3 rounded'>Error: " + e.getMessage() + "</div>");
                    }
                    %>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
