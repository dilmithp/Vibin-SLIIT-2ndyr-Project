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
    <title>Vibin - Admin Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-900 text-white">
    <!-- Admin Navigation -->
    <nav class="bg-black p-4 shadow-lg">
        <div class="container mx-auto flex justify-between items-center">
            <a href="admin-dashboard.jsp" class="text-2xl font-bold text-purple-500">Vibin Admin</a>
            <div class="flex items-center space-x-4">
                <a href="admin-dashboard.jsp" class="text-purple-400"><i class="fas fa-tachometer-alt mr-2"></i>Dashboard</a>
                <a href="admin-users.jsp" class="hover:text-purple-400"><i class="fas fa-users mr-2"></i>Users</a>
                <a href="admin-songs.jsp" class="hover:text-purple-400"><i class="fas fa-music mr-2"></i>Songs</a>
                <a href="admin-albums.jsp" class="hover:text-purple-400"><i class="fas fa-compact-disc mr-2"></i>Albums</a>
                <a href="admin-artists.jsp" class="hover:text-purple-400"><i class="fas fa-user-music mr-2"></i>Artists</a>
                <span class="text-gray-600">|</span>
                <span class="text-gray-400"><i class="fas fa-user mr-2"></i><%= session.getAttribute("adminName") %></span>
                <a href="<%=request.getContextPath()%>/AdminLogout" class="hover:text-purple-400"><i class="fas fa-sign-out-alt mr-2"></i>Logout</a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto py-8 px-4">
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-3xl font-bold text-purple-400">Admin Dashboard</h1>
            <p class="text-gray-400">Welcome, <%= session.getAttribute("adminName") %></p>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <!-- Users Management -->
            <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden hover:bg-gray-700 transition duration-200">
                <a href="admin-users.jsp">
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-4">
                            <h2 class="text-xl font-bold text-white">User Management</h2>
                            <i class="fas fa-users text-3xl text-purple-400"></i>
                        </div>
                        <p class="text-gray-400 mb-4">Manage user accounts, roles, and permissions</p>
                        <div class="flex justify-end">
                            <span class="bg-purple-600 text-white px-3 py-1 rounded-full text-sm">
                                <% 
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM user");
                                    if(rs.next()) {
                                        out.print(rs.getInt(1) + " Users");
                                    }
                                    rs.close();
                                    stmt.close();
                                    conn.close();
                                } catch(Exception e) {
                                    out.print("Error");
                                }
                                %>
                            </span>
                        </div>
                    </div>
                </a>
            </div>
            
            <!-- Songs Management -->
            <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden hover:bg-gray-700 transition duration-200">
                <a href="admin-songs.jsp">
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-4">
                            <h2 class="text-xl font-bold text-white">Song Management</h2>
                            <i class="fas fa-music text-3xl text-blue-400"></i>
                        </div>
                        <p class="text-gray-400 mb-4">Add, edit, and delete songs in the database</p>
                        <div class="flex justify-end">
                            <span class="bg-blue-600 text-white px-3 py-1 rounded-full text-sm">
                                <% 
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM songs");
                                    if(rs.next()) {
                                        out.print(rs.getInt(1) + " Songs");
                                    }
                                    rs.close();
                                    stmt.close();
                                    conn.close();
                                } catch(Exception e) {
                                    out.print("Error");
                                }
                                %>
                            </span>
                        </div>
                    </div>
                </a>
            </div>
            
            <!-- Albums Management -->
            <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden hover:bg-gray-700 transition duration-200">
                <a href="admin-albums.jsp">
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-4">
                            <h2 class="text-xl font-bold text-white">Album Management</h2>
                            <i class="fas fa-compact-disc text-3xl text-green-400"></i>
                        </div>
                        <p class="text-gray-400 mb-4">Manage albums and their associated songs</p>
                        <div class="flex justify-end">
                            <span class="bg-green-600 text-white px-3 py-1 rounded-full text-sm">
                                <% 
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM albums");
                                    if(rs.next()) {
                                        out.print(rs.getInt(1) + " Albums");
                                    }
                                    rs.close();
                                    stmt.close();
                                    conn.close();
                                } catch(Exception e) {
                                    out.print("Error");
                                }
                                %>
                            </span>
                        </div>
                    </div>
                </a>
            </div>
            
            <!-- Artists Management -->
            <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden hover:bg-gray-700 transition duration-200">
                <a href="admin-artists.jsp">
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-4">
                            <h2 class="text-xl font-bold text-white">Artist Management</h2>
                            <i class="fas fa-user-music text-3xl text-pink-400"></i>
                        </div>
                        <p class="text-gray-400 mb-4">Manage artist profiles and their songs</p>
                        <div class="flex justify-end">
                            <span class="bg-pink-600 text-white px-3 py-1 rounded-full text-sm">
                                <% 
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM artists");
                                    if(rs.next()) {
                                        out.print(rs.getInt(1) + " Artists");
                                    }
                                    rs.close();
                                    stmt.close();
                                    conn.close();
                                } catch(Exception e) {
                                    out.print("Error");
                                }
                                %>
                            </span>
                        </div>
                    </div>
                </a>
            </div>
            
            <!-- Playlists Management -->
            <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden hover:bg-gray-700 transition duration-200">
                <a href="admin-playlists.jsp">
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-4">
                            <h2 class="text-xl font-bold text-white">Playlist Management</h2>
                            <i class="fas fa-list text-3xl text-yellow-400"></i>
                        </div>
                        <p class="text-gray-400 mb-4">View and manage user playlists</p>
                        <div class="flex justify-end">
                            <span class="bg-yellow-600 text-white px-3 py-1 rounded-full text-sm">
                                <% 
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM playlists");
                                    if(rs.next()) {
                                        out.print(rs.getInt(1) + " Playlists");
                                    }
                                    rs.close();
                                    stmt.close();
                                    conn.close();
                                } catch(Exception e) {
                                    out.print("Error");
                                }
                                %>
                            </span>
                        </div>
                    </div>
                </a>
            </div>
            
            <!-- Admin Management -->
            <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden hover:bg-gray-700 transition duration-200">
                <a href="admin-admins.jsp">
                    <div class="p-6">
                        <div class="flex items-center justify-between mb-4">
                            <h2 class="text-xl font-bold text-white">Admin Management</h2>
                            <i class="fas fa-user-shield text-3xl text-red-400"></i>
                        </div>
                        <p class="text-gray-400 mb-4">Manage admin accounts and permissions</p>
                        <div class="flex justify-end">
                            <span class="bg-red-600 text-white px-3 py-1 rounded-full text-sm">
                                <% 
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
                                    Statement stmt = conn.createStatement();
                                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM admin");
                                    if(rs.next()) {
                                        out.print(rs.getInt(1) + " Admins");
                                    }
                                    rs.close();
                                    stmt.close();
                                    conn.close();
                                } catch(Exception e) {
                                    out.print("Error");
                                }
                                %>
                            </span>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
</body>
</html>
