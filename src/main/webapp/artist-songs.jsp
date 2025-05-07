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
    <title>Vibin - Artist Songs</title>
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
                <h1 class="text-xl font-bold">My Songs</h1>
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
                
                <!-- Add Song Button -->
                <div class="mb-6 flex space-x-4">
                    <a href="artist-song-form.jsp" class="inline-flex items-center px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                        <i class="fas fa-plus mr-2"></i>Add New Song
                    </a>
                    
                    <!-- Search Form -->
                    <form action="artist-songs.jsp" method="get" class="flex-1 flex">
                        <input type="text" name="search" placeholder="Search your songs..." 
                               class="flex-1 px-3 py-2 bg-gray-700 border border-gray-600 rounded-l-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
                               value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                        <button type="submit" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-r-lg font-medium transition duration-200">
                            <i class="fas fa-search"></i>
                        </button>
                    </form>
                </div>
                
                <!-- Songs Table -->
                <div class="bg-gray-800 rounded-lg overflow-hidden shadow-lg">
                    <table class="min-w-full divide-y divide-gray-700">
                        <thead class="bg-gray-700">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Title</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Album</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Lyricist</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Music Director</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-700">
                            <% 
                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
                                
                                String sql = "SELECT s.*, a.album_name FROM songs s " +
                                            "LEFT JOIN albums a ON s.album_id = a.album_id " +
                                            "WHERE s.singer = ?";
                                
                                // Add search functionality
                                String searchTerm = request.getParameter("search");
                                if (searchTerm != null && !searchTerm.isEmpty()) {
                                    sql += " AND (s.song_name LIKE ? OR a.album_name LIKE ?)";
                                }
                                
                                sql += " ORDER BY s.song_id DESC";
                                
                                PreparedStatement stmt = conn.prepareStatement(sql);
                                stmt.setString(1, artistName);
                                
                                if (searchTerm != null && !searchTerm.isEmpty()) {
                                    stmt.setString(2, "%" + searchTerm + "%");
                                    stmt.setString(3, "%" + searchTerm + "%");
                                }
                                
                                ResultSet rs = stmt.executeQuery();
                                
                                boolean hasSongs = false;
                                while (rs.next()) {
                                    hasSongs = true;
                            %>
                            <tr class="hover:bg-gray-700">
                                <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("song_name") %></td>
                                <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("album_name") != null ? rs.getString("album_name") : "-" %></td>
                                <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("lyricist") != null ? rs.getString("lyricist") : "-" %></td>
                                <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("music_director") != null ? rs.getString("music_director") : "-" %></td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <a href="artist-song-edit.jsp?id=<%= rs.getInt("song_id") %>" class="text-blue-400 hover:text-blue-300 mr-3">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <a href="artist-song-delete.jsp?id=<%= rs.getInt("song_id") %>" 
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
                                <td colspan="5" class="px-6 py-4 text-center text-gray-400">
                                    <% if (searchTerm != null && !searchTerm.isEmpty()) { %>
                                        No songs found matching your search criteria.
                                    <% } else { %>
                                        You haven't uploaded any songs yet.
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                }
                                
                                rs.close();
                                stmt.close();
                                conn.close();
                            } catch (Exception e) {
                                out.println("<tr><td colspan='5' class='px-6 py-4 text-center text-red-500'>Error: " + e.getMessage() + "</td></tr>");
                            }
                            %>
                        </tbody>
                    </table>
                </div>
                
                <!-- Empty State -->
                <% 
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
                    
                    PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM songs WHERE singer = ?");
                    stmt.setString(1, artistName);
                    ResultSet rs = stmt.executeQuery();
                    
                    if (rs.next() && rs.getInt(1) == 0 && (request.getParameter("search") == null || request.getParameter("search").isEmpty())) {
                %>
                <div class="mt-6 bg-gray-800 rounded-lg p-8 text-center">
                    <i class="fas fa-music text-5xl text-gray-600 mb-4"></i>
                    <p class="text-xl text-gray-400">No songs found</p>
                    <p class="text-gray-500 mt-2 mb-4">Start by adding a new song to your collection</p>
                    <a href="artist-song-form.jsp" class="inline-flex items-center px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                        <i class="fas fa-plus mr-2"></i>Add New Song
                    </a>
                </div>
                <%
                    }
                    
                    rs.close();
                    stmt.close();
                    conn.close();
                } catch (Exception e) {
                    // Silently handle error
                }
                %>
            </div>
        </div>
    </div>
</body>
</html>
