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
    
    // Get artist stats
    int totalAlbums = 0;
    int totalSongs = 0;
    int totalPlays = 0;
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Get album count
        PreparedStatement albumStmt = conn.prepareStatement(
            "SELECT COUNT(*) FROM albums WHERE artist = ?"
        );
        albumStmt.setString(1, artistName);
        ResultSet albumRs = albumStmt.executeQuery();
        if (albumRs.next()) {
            totalAlbums = albumRs.getInt(1);
        }
        
        // Get song count
        PreparedStatement songStmt = conn.prepareStatement(
            "SELECT COUNT(*) FROM songs WHERE singer = ?"
        );
        songStmt.setString(1, artistName);
        ResultSet songRs = songStmt.executeQuery();
        if (songRs.next()) {
            totalSongs = songRs.getInt(1);
        }
        
        // Close resources
        albumRs.close();
        albumStmt.close();
        songRs.close();
        songStmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Artist Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .gradient-bg { background: linear-gradient(to right, #4b0082, #9400d3); }
    </style>
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
                <a href="artist-dashboard.jsp" class="flex items-center text-purple-400 p-2 rounded-lg bg-gray-800">
                    <i class="fas fa-tachometer-alt w-6"></i>
                    <span>Dashboard</span>
                </a>
                <a href="artist-albums.jsp" class="flex items-center text-gray-300 hover:text-purple-400 p-2 rounded-lg hover:bg-gray-800">
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
                <h1 class="text-xl font-bold">Dashboard</h1>
                <div class="flex items-center">
                    <span class="mr-4"><%= artistName %></span>
                    <div class="h-10 w-10 rounded-full bg-purple-600 flex items-center justify-center">
                        <i class="fas fa-user"></i>
                    </div>
                </div>
            </div>
            
            <!-- Content -->
            <div class="p-6">
                <!-- Welcome Banner -->
                <div class="gradient-bg rounded-xl p-6 mb-8 shadow-lg">
                    <h1 class="text-3xl font-bold mb-2">Welcome, <%= artistName %>!</h1>
                    <p class="text-gray-200">Manage your music and connect with your audience</p>
                </div>
                
                <!-- Stats -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                    <div class="bg-gray-800 rounded-lg p-6 shadow-md">
                        <div class="flex justify-between items-center">
                            <div>
                                <p class="text-gray-400 text-sm">Total Albums</p>
                                <h2 class="text-3xl font-bold"><%= totalAlbums %></h2>
                            </div>
                            <div class="h-12 w-12 rounded-full bg-purple-900 flex items-center justify-center text-2xl">
                                <i class="fas fa-compact-disc"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-gray-800 rounded-lg p-6 shadow-md">
                        <div class="flex justify-between items-center">
                            <div>
                                <p class="text-gray-400 text-sm">Total Songs</p>
                                <h2 class="text-3xl font-bold"><%= totalSongs %></h2>
                            </div>
                            <div class="h-12 w-12 rounded-full bg-blue-900 flex items-center justify-center text-2xl">
                                <i class="fas fa-music"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="bg-gray-800 rounded-lg p-6 shadow-md">
                        <div class="flex justify-between items-center">
                            <div>
                                <p class="text-gray-400 text-sm">Total Plays</p>
                                <h2 class="text-3xl font-bold"><%= totalPlays %></h2>
                            </div>
                            <div class="h-12 w-12 rounded-full bg-green-900 flex items-center justify-center text-2xl">
                                <i class="fas fa-play"></i>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="mb-8">
                    <h2 class="text-xl font-bold mb-4">Quick Actions</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <a href="artist-album-form.jsp" class="bg-purple-700 hover:bg-purple-600 rounded-lg p-4 flex items-center">
                            <div class="h-10 w-10 rounded-full bg-purple-900 flex items-center justify-center mr-4">
                                <i class="fas fa-plus"></i>
                            </div>
                            <div>
                                <h3 class="font-bold">Add New Album</h3>
                                <p class="text-sm text-purple-200">Create a new album for your fans</p>
                            </div>
                        </a>
                        
                        <a href="artist-song-form.jsp" class="bg-blue-700 hover:bg-blue-600 rounded-lg p-4 flex items-center">
                            <div class="h-10 w-10 rounded-full bg-blue-900 flex items-center justify-center mr-4">
                                <i class="fas fa-plus"></i>
                            </div>
                            <div>
                                <h3 class="font-bold">Add New Song</h3>
                                <p class="text-sm text-blue-200">Upload your latest tracks</p>
                            </div>
                        </a>
                    </div>
                </div>
                
                <!-- Recent Albums -->
                <div class="mb-8">
                    <div class="flex justify-between items-center mb-4">
                        <h2 class="text-xl font-bold">Recent Albums</h2>
                        <a href="artist-albums.jsp" class="text-sm text-purple-400 hover:underline">View All</a>
                    </div>
                    
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <% 
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
                            
                            PreparedStatement stmt = conn.prepareStatement(
                                "SELECT * FROM albums WHERE artist = ? ORDER BY release_date DESC LIMIT 3"
                            );
                            stmt.setString(1, artistName);
                            ResultSet rs = stmt.executeQuery();
                            
                            boolean hasAlbums = false;
                            while (rs.next()) {
                                hasAlbums = true;
                        %>
                        <div class="bg-gray-800 rounded-lg overflow-hidden shadow-md">
                            <div class="h-32 bg-gray-700 flex items-center justify-center">
                                <i class="fas fa-compact-disc text-4xl text-gray-500"></i>
                            </div>
                            <div class="p-4">
                                <h3 class="font-bold mb-1"><%= rs.getString("album_name") %></h3>
                                <p class="text-sm text-gray-400 mb-2"><%= rs.getString("genre") != null ? rs.getString("genre") : "No genre" %></p>
                                <div class="flex justify-end">
                                    <a href="artist-album-edit.jsp?id=<%= rs.getInt("album_id") %>" class="text-blue-400 hover:text-blue-300">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <% 
                            }
                            
                            if (!hasAlbums) {
                        %>
                        <div class="col-span-3 bg-gray-800 rounded-lg p-6 text-center">
                            <p class="text-gray-400">You haven't created any albums yet.</p>
                            <a href="artist-album-form.jsp" class="inline-block mt-2 text-purple-400 hover:underline">Create your first album</a>
                        </div>
                        <% 
                            }
                            
                            rs.close();
                            stmt.close();
                            conn.close();
                        } catch (Exception e) {
                            out.println("<div class='col-span-3 bg-red-800 rounded-lg p-4'>Error: " + e.getMessage() + "</div>");
                        }
                        %>
                    </div>
                </div>
                
                <!-- Recent Songs -->
                <div>
                    <div class="flex justify-between items-center mb-4">
                        <h2 class="text-xl font-bold">Recent Songs</h2>
                        <a href="artist-songs.jsp" class="text-sm text-purple-400 hover:underline">View All</a>
                    </div>
                    
                    <div class="bg-gray-800 rounded-lg overflow-hidden shadow-md">
                        <table class="min-w-full divide-y divide-gray-700">
                            <thead class="bg-gray-700">
                                <tr>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Title</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Album</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Genre</th>
                                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-700">
                                <% 
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
                                    
                                    PreparedStatement stmt = conn.prepareStatement(
                                        "SELECT s.*, a.album_name, a.genre FROM songs s " +
                                        "LEFT JOIN albums a ON s.album_id = a.album_id " +
                                        "WHERE s.singer = ? " +
                                        "ORDER BY s.song_id DESC LIMIT 5"
                                    );
                                    stmt.setString(1, artistName);
                                    ResultSet rs = stmt.executeQuery();
                                    
                                    boolean hasSongs = false;
                                    while (rs.next()) {
                                        hasSongs = true;
                                %>
                                <tr class="hover:bg-gray-700">
                                    <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("song_name") %></td>
                                    <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("album_name") != null ? rs.getString("album_name") : "-" %></td>
                                    <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("genre") != null ? rs.getString("genre") : "-" %></td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <a href="artist-song-edit.jsp?id=<%= rs.getInt("song_id") %>" class="text-blue-400 hover:text-blue-300 mr-3">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                    </td>
                                </tr>
                                <% 
                                    }
                                    
                                    if (!hasSongs) {
                                %>
                                <tr>
                                    <td colspan="4" class="px-6 py-4 text-center text-gray-400">You haven't uploaded any songs yet.</td>
                                </tr>
                                <% 
                                    }
                                    
                                    rs.close();
                                    stmt.close();
                                    conn.close();
                                } catch (Exception e) {
                                    out.println("<tr><td colspan='4' class='px-6 py-4 text-center text-red-500'>Error: " + e.getMessage() + "</td></tr>");
                                }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
