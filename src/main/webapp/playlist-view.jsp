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
    
    // Get playlist ID from request
    String playlistId = request.getParameter("id");
    
    // Validate input
    if (playlistId == null || playlistId.isEmpty()) {
        response.sendRedirect("playlist-list.jsp?error=Invalid playlist ID");
        return;
    }
    
    // Playlist details
    String playlistName = "";
    String description = "";
    Timestamp createdDate = null;
    int playlistOwnerId = 0;
    
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
        
        // Get playlist details
        PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM playlists WHERE playlist_id = ?");
        pstmt.setInt(1, Integer.parseInt(playlistId));
        
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            playlistName = rs.getString("playlist_name");
            description = rs.getString("description") != null ? rs.getString("description") : "";
            createdDate = rs.getTimestamp("created_date");
            playlistOwnerId = rs.getInt("user_id");
            
            // Check if user has access to this playlist
            if (playlistOwnerId != userId) {
                rs.close();
                pstmt.close();
                conn.close();
                response.sendRedirect("playlist-list.jsp?error=You don't have access to this playlist");
                return;
            }
        } else {
            rs.close();
            pstmt.close();
            conn.close();
            response.sendRedirect("playlist-list.jsp?error=Playlist not found");
            return;
        }
        rs.close();
        pstmt.close();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - <%= playlistName %></title>
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
        <!-- Playlist Header -->
        <div class="flex items-start mb-8">
            <div class="w-48 h-48 bg-gradient-to-r from-purple-900 to-blue-900 flex items-center justify-center rounded-lg shadow-lg mr-6">
                <i class="fas fa-music text-6xl text-gray-300"></i>
            </div>
            <div class="flex-1">
                <h1 class="text-4xl font-bold text-purple-400 mb-2"><%= playlistName %></h1>
                <% if (!description.isEmpty()) { %>
                    <p class="text-gray-400 mb-4"><%= description %></p>
                <% } %>
                <p class="text-sm text-gray-500 mb-4">Created on <%= createdDate.toString().substring(0, 10) %></p>
                
                <div class="flex space-x-3">
                    <button class="px-6 py-2 bg-purple-600 hover:bg-purple-700 rounded-full font-medium transition duration-200">
                        <i class="fas fa-play mr-2"></i>Play All
                    </button>
                    <a href="playlist-edit.jsp?id=<%= playlistId %>" class="px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-full font-medium transition duration-200">
                        <i class="fas fa-edit mr-2"></i>Edit
                    </a>
                    <a href="playlist-delete.jsp?id=<%= playlistId %>" 
                       class="px-4 py-2 bg-red-700 hover:bg-red-600 rounded-full font-medium transition duration-200"
                       onclick="return confirm('Are you sure you want to delete this playlist?')">
                        <i class="fas fa-trash mr-2"></i>Delete
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
        
        <!-- Songs Table -->
        <div class="bg-gray-800 rounded-lg overflow-hidden shadow-lg">
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
                        "SELECT s.*, ps.added_date, a.album_name, a.artist " +
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
                        int songId = songRs.getInt("song_id");
                    %>
                    <tr class="hover:bg-gray-700">
                        <td class="px-6 py-4 whitespace-nowrap"><%= counter++ %></td>
                        <td class="px-6 py-4 whitespace-nowrap"><%= songRs.getString("song_name") %></td>
                        <td class="px-6 py-4 whitespace-nowrap"><%= songRs.getString("singer") %></td>
                        <td class="px-6 py-4 whitespace-nowrap"><%= songRs.getString("album_name") != null ? songRs.getString("album_name") : "-" %></td>
                        <td class="px-6 py-4 whitespace-nowrap"><%= songRs.getTimestamp("added_date").toString().substring(0, 10) %></td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <button class="text-purple-400 hover:text-purple-300 mr-3" onclick="playSong(<%= songId %>)">
                                <i class="fas fa-play"></i>
                            </button>
                            <a href="playlist-remove-song.jsp?playlistId=<%= playlistId %>&songId=<%= songId %>" 
                               class="text-red-400 hover:text-red-300"
                               onclick="return confirm('Are you sure you want to remove this song from the playlist?')">
                                <i class="fas fa-times"></i>
                            </a>
                        </td>
                    </tr>
                    <%
                    }
                    
                    if (!hasSongs) {
                    %>
                    <tr>
                        <td colspan="6" class="px-6 py-4 text-center text-gray-400">
                            <p>This playlist is empty.</p>
                            <p class="mt-2">
                                <a href="<%=request.getContextPath()%>/songs" class="text-purple-400 hover:underline">
                                    Browse songs to add to this playlist
                                </a>
                            </p>
                        </td>
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
            <a href="playlist-list.jsp" class="inline-flex items-center px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-lg font-medium transition duration-200">
                <i class="fas fa-arrow-left mr-2"></i>Back to Playlists
            </a>
        </div>
    </div>
    
    <!-- Now Playing Bar -->
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
    
    <!-- JavaScript for song playback -->
    <script>
        function playSong(songId) {
            // handle song playback
            console.log("Playing song ID: " + songId);
        }
    </script>
</body>
</html>
<%
    } catch (Exception e) {
        response.sendRedirect("playlist-list.jsp?error=" + e.getMessage());
    }
%>
