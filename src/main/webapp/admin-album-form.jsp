<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    // Check if editing or creating new
    String albumId = request.getParameter("id");
    String albumName = "";
    String artist = "";
    String genre = "";
    String releaseDate = "";
    boolean isEditing = albumId != null && !albumId.isEmpty();
    String formTitle = isEditing ? "Edit Album" : "Add New Album";
    
    // If editing, fetch album details
    if (isEditing) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
            
            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM albums WHERE album_id = ?");
            pstmt.setInt(1, Integer.parseInt(albumId));
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                albumName = rs.getString("album_name");
                artist = rs.getString("artist");
                genre = rs.getString("genre") != null ? rs.getString("genre") : "";
                releaseDate = rs.getDate("release_date") != null ? rs.getDate("release_date").toString() : "";
            }
            
            rs.close();
            pstmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("<p class='text-red-500'>Error loading album: " + e.getMessage() + "</p>");
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - <%= formTitle %></title>
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
            <h1 class="text-3xl font-bold text-purple-400"><%= formTitle %></h1>
        </div>
        
        <!-- Success/Error Messages -->
        <% if (request.getParameter("error") != null) { %>
            <div class="bg-red-800 text-white px-4 py-3 rounded mb-4">
                <%= request.getParameter("error") %>
            </div>
        <% } %>
        
        <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
            <form action="admin-album-save.jsp" method="post" class="p-6">
                <% if (isEditing) { %>
                    <input type="hidden" name="albumId" value="<%= albumId %>">
                <% } %>
                
                <div class="mb-4">
                    <label for="albumName" class="block text-sm font-medium text-gray-400 mb-2">Album Name</label>
                    <input type="text" id="albumName" name="albumName" value="<%= albumName %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
                           required>
                </div>
                
                <div class="mb-4">
                    <label for="artist" class="block text-sm font-medium text-gray-400 mb-2">Artist</label>
                    <input type="text" id="artist" name="artist" value="<%= artist %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
                           required>
                </div>
                
                <div class="mb-4">
                    <label for="genre" class="block text-sm font-medium text-gray-400 mb-2">Genre</label>
                    <input type="text" id="genre" name="genre" value="<%= genre %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                
                <div class="mb-6">
                    <label for="releaseDate" class="block text-sm font-medium text-gray-400 mb-2">Release Date</label>
                    <input type="date" id="releaseDate" name="releaseDate" value="<%= releaseDate %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                
                <div class="flex justify-end">
                    <a href="admin-albums.jsp" class="px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-lg font-medium transition duration-200 mr-2">
                        Cancel
                    </a>
                    <button type="submit" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                        <%= isEditing ? "Update" : "Add" %> Album
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
