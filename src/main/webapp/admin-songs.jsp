<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Song Management</title>
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
            <h1 class="text-3xl font-bold text-purple-400">Song Management</h1>
            <a href="admin-song-form.jsp" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                <i class="fas fa-plus mr-2"></i>Add New Song
            </a>
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
        
        <!-- Song Search -->
        <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden mb-6">
            <div class="p-4">
                <form action="admin-songs.jsp" method="get" class="flex items-center">
                    <input type="text" name="search" placeholder="Search by title, artist, or album" 
                           class="flex-grow px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500 mr-2"
                           value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                    <button type="submit" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                        <i class="fas fa-search mr-2"></i>Search
                    </button>
                </form>
            </div>
        </div>
        
        <!-- Songs Table -->
        <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-700">
                    <thead class="bg-gray-700">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">ID</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Title</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Artist</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Album</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Music Director</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-700">
                        <% 
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
                            
                            String sql = "SELECT s.song_id, s.song_name, s.singer, s.lyricist, s.music_director, a.album_name " +
                                         "FROM songs s LEFT JOIN albums a ON s.album_id = a.album_id";
                            
                            // Add search functionality
                            if (request.getParameter("search") != null && !request.getParameter("search").isEmpty()) {
                                String searchTerm = "%" + request.getParameter("search") + "%";
                                sql += " WHERE s.song_name LIKE ? OR s.singer LIKE ? OR a.album_name LIKE ?";
                                
                                PreparedStatement pstmt = conn.prepareStatement(sql);
                                pstmt.setString(1, searchTerm);
                                pstmt.setString(2, searchTerm);
                                pstmt.setString(3, searchTerm);
                                
                                ResultSet rs = pstmt.executeQuery();
                                
                                while (rs.next()) {
                        %>
                        <tr class="hover:bg-gray-700">
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getInt("song_id") %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("song_name") %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("singer") %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("album_name") != null ? rs.getString("album_name") : "-" %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("music_director") %></td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <a href="admin-song-form.jsp?id=<%= rs.getInt("song_id") %>" class="text-blue-400 hover:text-blue-300 mr-3">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="admin-song-delete.jsp?id=<%= rs.getInt("song_id") %>" 
                                   onclick="return confirm('Are you sure you want to delete this song?')"
                                   class="text-red-400 hover:text-red-300">
                                    <i class="fas fa-trash-alt"></i>
                                </a>
                            </td>
                        </tr>
                        <%
                                }
                                rs.close();
                                pstmt.close();
                            } else {
                                Statement stmt = conn.createStatement();
                                ResultSet rs = stmt.executeQuery(sql);
                                
                                while (rs.next()) {
                        %>
                        <tr class="hover:bg-gray-700">
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getInt("song_id") %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("song_name") %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("singer") %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("album_name") != null ? rs.getString("album_name") : "-" %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("music_director") %></td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <a href="admin-song-form.jsp?id=<%= rs.getInt("song_id") %>" class="text-blue-400 hover:text-blue-300 mr-3">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="admin-song-delete.jsp?id=<%= rs.getInt("song_id") %>" 
                                   onclick="return confirm('Are you sure you want to delete this song?')"
                                   class="text-red-400 hover:text-red-300">
                                    <i class="fas fa-trash-alt"></i>
                                </a>
                            </td>
                        </tr>
                        <%
                                }
                                rs.close();
                                stmt.close();
                            }
                            
                            conn.close();
                        } catch(Exception e) {
                            out.println("<tr><td colspan='6' class='px-6 py-4 text-center text-red-500'>Error: " + e.getMessage() + "</td></tr>");
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
