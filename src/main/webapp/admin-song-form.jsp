<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    // Check if editing or creating new
    String songId = request.getParameter("id");
    String songName = "";
    String singer = "";
    String lyricist = "";
    String musicDirector = "";
    String albumId = "";
    String albumName = "";
    boolean isEditing = songId != null && !songId.isEmpty();
    String formTitle = isEditing ? "Edit Song" : "Add New Song";
    
    // If editing, fetch song details
    if (isEditing) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
            
            String sql = "SELECT s.*, a.album_name FROM songs s LEFT JOIN albums a ON s.album_id = a.album_id WHERE s.song_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(songId));
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                songName = rs.getString("song_name");
                singer = rs.getString("singer");
                lyricist = rs.getString("lyricist");
                musicDirector = rs.getString("music_director");
                albumId = rs.getObject("album_id") != null ? rs.getString("album_id") : "";
                albumName = rs.getString("album_name");
            }
            
            rs.close();
            pstmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("<p class='text-red-500'>Error loading song: " + e.getMessage() + "</p>");
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
                <a href="admin-songs.jsp" class="text-purple-400"><i class="fas fa-music mr-2"></i>Songs</a>
                <a href="admin-albums.jsp" class="hover:text-purple-400"><i class="fas fa-compact-disc mr-2"></i>Albums</a>
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
            <form action="admin-song-save.jsp" method="post" class="p-6">
                <% if (isEditing) { %>
                    <input type="hidden" name="songId" value="<%= songId %>">
                <% } %>
                
                <div class="mb-4">
                    <label for="songName" class="block text-sm font-medium text-gray-400 mb-2">Song Title</label>
                    <input type="text" id="songName" name="songName" value="<%= songName %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
                           required>
                </div>
                
                <div class="mb-4">
                    <label for="singer" class="block text-sm font-medium text-gray-400 mb-2">Singer</label>
                    <input type="text" id="singer" name="singer" value="<%= singer %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
                           required>
                </div>
                
                <div class="mb-4">
                    <label for="lyricist" class="block text-sm font-medium text-gray-400 mb-2">Lyricist</label>
                    <input type="text" id="lyricist" name="lyricist" value="<%= lyricist %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                
                <div class="mb-4">
                    <label for="musicDirector" class="block text-sm font-medium text-gray-400 mb-2">Music Director</label>
                    <input type="text" id="musicDirector" name="musicDirector" value="<%= musicDirector %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                
                <div class="mb-6">
                    <label for="albumId" class="block text-sm font-medium text-gray-400 mb-2">Album</label>
                    <select id="albumId" name="albumId" 
                            class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                        <option value="">-- Select Album --</option>
                        <% 
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
                            
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT album_id, album_name FROM albums ORDER BY album_name");
                            
                            while (rs.next()) {
                                String id = rs.getString("album_id");
                                String selected = id.equals(albumId) ? "selected" : "";
                        %>
                            <option value="<%= id %>" <%= selected %>><%= rs.getString("album_name") %></option>
                        <% 
                            }
                            rs.close();
                            stmt.close();
                            conn.close();
                        } catch (Exception e) {
                            out.println("<option value=''>Error loading albums</option>");
                        }
                        %>
                    </select>
                </div>
                
                <div class="flex justify-end">
                    <a href="admin-songs.jsp" class="px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-lg font-medium transition duration-200 mr-2">
                        Cancel
                    </a>
                    <button type="submit" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                        <%= isEditing ? "Update" : "Add" %> Song
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
