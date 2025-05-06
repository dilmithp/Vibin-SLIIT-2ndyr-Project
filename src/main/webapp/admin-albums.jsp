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
    <title>Vibin - Album Management</title>
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
            <h1 class="text-3xl font-bold text-purple-400">Album Management</h1>
            <a href="admin-album-form.jsp" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                <i class="fas fa-plus mr-2"></i>Add New Album
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
        
        <!-- Album Search -->
        <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden mb-6">
            <div class="p-4">
                <form action="admin-albums.jsp" method="get" class="flex items-center">
                    <input type="text" name="search" placeholder="Search by album name or artist" 
                           class="flex-grow px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500 mr-2"
                           value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                    <button type="submit" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                        <i class="fas fa-search mr-2"></i>Search
                    </button>
                </form>
            </div>
        </div>
        
        <!-- Albums Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <% 
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
                
                String sql = "SELECT a.*, (SELECT COUNT(*) FROM songs WHERE album_id = a.album_id) AS song_count FROM albums a";
                
                // Add search functionality
                if (request.getParameter("search") != null && !request.getParameter("search").isEmpty()) {
                    String searchTerm = "%" + request.getParameter("search") + "%";
                    sql += " WHERE a.album_name LIKE ? OR a.artist LIKE ?";
                    
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, searchTerm);
                    pstmt.setString(2, searchTerm);
                    
                    ResultSet rs = pstmt.executeQuery();
                    
                    while (rs.next()) {
            %>
                <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden hover:bg-gray-700 transition duration-200">
                    <div class="p-6">
                        <div class="flex justify-between items-center mb-4">
                            <h2 class="text-xl font-bold text-white"><%= rs.getString("album_name") %></h2>
                            <span class="bg-green-600 text-white px-3 py-1 rounded-full text-sm"><%= rs.getInt("song_count") %> songs</span>
                        </div>
                        <p class="text-gray-400 mb-2"><span class="font-medium">Artist:</span> <%= rs.getString("artist") %></p>
                        <p class="text-gray-400 mb-2"><span class="font-medium">Genre:</span> <%= rs.getString("genre") != null ? rs.getString("genre") : "-" %></p>
                        <p class="text-gray-400 mb-4"><span class="font-medium">Release Date:</span> <%= rs.getDate("release_date") != null ? rs.getDate("release_date") : "-" %></p>
                        
                        <div class="flex justify-end space-x-2">
                            <a href="admin-album-songs.jsp?id=<%= rs.getInt("album_id") %>" class="text-purple-400 hover:text-purple-300">
                                <i class="fas fa-music mr-1"></i> View Songs
                            </a>
                            <a href="admin-album-form.jsp?id=<%= rs.getInt("album_id") %>" class="text-blue-400 hover:text-blue-300">
                                <i class="fas fa-edit"></i>
                            </a>
                            <a href="admin-album-delete.jsp?id=<%= rs.getInt("album_id") %>" 
                               onclick="return confirm('Are you sure you want to delete this album?')"
                               class="text-red-400 hover:text-red-300">
                                <i class="fas fa-trash-alt"></i>
                            </a>
                        </div>
                    </div>
                </div>
            <%
                    }
                    rs.close();
                    pstmt.close();
                } else {
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(sql);
                    
                    while (rs.next()) {
            %>
                <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden hover:bg-gray-700 transition duration-200">
                    <div class="p-6">
                        <div class="flex justify-between items-center mb-4">
                            <h2 class="text-xl font-bold text-white"><%= rs.getString("album_name") %></h2>
                            <span class="bg-green-600 text-white px-3 py-1 rounded-full text-sm"><%= rs.getInt("song_count") %> songs</span>
                        </div>
                        <p class="text-gray-400 mb-2"><span class="font-medium">Artist:</span> <%= rs.getString("artist") %></p>
                        <p class="text-gray-400 mb-2"><span class="font-medium">Genre:</span> <%= rs.getString("genre") != null ? rs.getString("genre") : "-" %></p>
                        <p class="text-gray-400 mb-4"><span class="font-medium">Release Date:</span> <%= rs.getDate("release_date") != null ? rs.getDate("release_date") : "-" %></p>
                        
                        <div class="flex justify-end space-x-2">
                            <a href="admin-album-songs.jsp?id=<%= rs.getInt("album_id") %>" class="text-purple-400 hover:text-purple-300">
                                <i class="fas fa-music mr-1"></i> View Songs
                            </a>
                            <a href="admin-album-form.jsp?id=<%= rs.getInt("album_id") %>" class="text-blue-400 hover:text-blue-300">
                                <i class="fas fa-edit"></i>
                            </a>
                            <a href="admin-album-delete.jsp?id=<%= rs.getInt("album_id") %>" 
                               onclick="return confirm('Are you sure you want to delete this album?')"
                               class="text-red-400 hover:text-red-300">
                                <i class="fas fa-trash-alt"></i>
                            </a>
                        </div>
                    </div>
                </div>
            <%
                    }
                    rs.close();
                    stmt.close();
                }
                
                conn.close();
            } catch(Exception e) {
                out.println("<div class='col-span-3 text-center text-red-500'>Error: " + e.getMessage() + "</div>");
            }
            %>
        </div>
    </div>
</body>
</html>
