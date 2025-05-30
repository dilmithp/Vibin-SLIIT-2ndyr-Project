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
    
    // Check if editing or creating new
    String songId = request.getParameter("id");
    String songName = "";
    String lyricist = "";
    String musicDirector = "";
    String albumId = "";
    boolean isEditing = songId != null && !songId.isEmpty();
    String formTitle = isEditing ? "Edit Song" : "Add New Song";
    
    // If editing, fetch song details
    if (isEditing) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
            
            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM songs WHERE song_id = ? AND singer = ?");
            pstmt.setInt(1, Integer.parseInt(songId));
            pstmt.setString(2, artistName);
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                songName = rs.getString("song_name");
                lyricist = rs.getString("lyricist") != null ? rs.getString("lyricist") : "";
                musicDirector = rs.getString("music_director") != null ? rs.getString("music_director") : "";
                albumId = rs.getObject("album_id") != null ? rs.getString("album_id") : "";
            } else {
                // Song not found or doesn't belong to this artist
                response.sendRedirect("artist-songs.jsp?error=Song not found or unauthorized access");
                return;
            }
            
            rs.close();
            pstmt.close();
            conn.close();
        } catch (Exception e) {
            response.sendRedirect("artist-songs.jsp?error=" + e.getMessage());
            return;
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
                <a href="artist-albums.jsp" class="flex items-center text-gray-300 hover:text-purple-400 p-2 rounded-lg hover:bg-gray-800">
                    <i class="fas fa-compact-disc w-6"></i>
                    <span>Albums</span>
                </a>
                <a href="artist-songs.jsp" class="flex items-center text-purple-400 p-2 rounded-lg bg-gray-800">
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
                <h1 class="text-xl font-bold"><%= formTitle %></h1>
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
                <% if (request.getParameter("error") != null) { %>
                    <div class="bg-red-800 text-white px-4 py-3 rounded mb-4">
                        <%= request.getParameter("error") %>
                    </div>
                <% } %>
                
                <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
                    <form action="artist-song-save.jsp" method="post" class="p-6">
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
                                    
                                    PreparedStatement stmt = conn.prepareStatement("SELECT album_id, album_name FROM albums WHERE artist = ? ORDER BY album_name");
                                    stmt.setString(1, artistName);
                                    ResultSet rs = stmt.executeQuery();
                                    
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
                            <a href="artist-songs.jsp" class="px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-lg font-medium transition duration-200 mr-2">
                                Cancel
                            </a>
                            <button type="submit" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                                <%= isEditing ? "Update" : "Add" %> Song
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
