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
    <title>Vibin - Admin Management</title>
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
                <a href="admin-albums.jsp" class="hover:text-purple-400"><i class="fas fa-compact-disc mr-2"></i>Albums</a>
                <a href="admin-artists.jsp" class="hover:text-purple-400"><i class="fas fa-user-music mr-2"></i>Artists</a>
                <a href="admin-admins.jsp" class="text-purple-400"><i class="fas fa-user-shield mr-2"></i>Admins</a>
                <span class="text-gray-600">|</span>
                <span class="text-gray-400"><i class="fas fa-user mr-2"></i><%= session.getAttribute("adminName") %></span>
                <a href="<%=request.getContextPath()%>/AdminLogout" class="hover:text-purple-400"><i class="fas fa-sign-out-alt mr-2"></i>Logout</a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto py-8 px-4">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-3xl font-bold text-purple-400">Admin Management</h1>
            <a href="admin-admin-form.jsp" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                <i class="fas fa-plus mr-2"></i>Add New Admin
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
        
        <!-- Admins Table -->
        <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-700">
                    <thead class="bg-gray-700">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">ID</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Username</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Name</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Email</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Last Login</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-700">
                        <% 
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
                            
                            Statement stmt = conn.createStatement();
                            ResultSet rs = stmt.executeQuery("SELECT * FROM admin ORDER BY admin_id");
                            
                            while (rs.next()) {
                                // Don't allow deleting your own account
                                boolean isSelf = rs.getInt("admin_id") == ((Integer)session.getAttribute("adminId")).intValue();
                        %>
                        <tr class="hover:bg-gray-700">
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getInt("admin_id") %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("username") %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("name") %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getString("email") != null ? rs.getString("email") : "-" %></td>
                            <td class="px-6 py-4 whitespace-nowrap"><%= rs.getTimestamp("last_login") != null ? rs.getTimestamp("last_login") : "Never" %></td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <a href="admin-admin-form.jsp?id=<%= rs.getInt("admin_id") %>" class="text-blue-400 hover:text-blue-300 mr-3">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <% if (!isSelf) { %>
                                <a href="admin-admin-delete.jsp?id=<%= rs.getInt("admin_id") %>" 
                                   onclick="return confirm('Are you sure you want to delete this admin account?')"
                                   class="text-red-400 hover:text-red-300">
                                    <i class="fas fa-trash-alt"></i>
                                </a>
                                <% } %>
                            </td>
                        </tr>
                        <%
                            }
                            rs.close();
                            stmt.close();
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
