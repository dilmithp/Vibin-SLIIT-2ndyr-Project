<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    // Check if editing or creating new
    String adminId = request.getParameter("id");
    String username = "";
    String name = "";
    String email = "";
    String role = "admin";
    boolean isEditing = adminId != null && !adminId.isEmpty();
    String formTitle = isEditing ? "Edit Admin" : "Add New Admin";
    
    // If editing, fetch admin details
    if (isEditing) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
            
            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM admin WHERE admin_id = ?");
            pstmt.setInt(1, Integer.parseInt(adminId));
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                username = rs.getString("username");
                name = rs.getString("name");
                email = rs.getString("email") != null ? rs.getString("email") : "";
                role = rs.getString("role");
            }
            
            rs.close();
            pstmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("<p class='text-red-500'>Error loading admin: " + e.getMessage() + "</p>");
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
            <h1 class="text-3xl font-bold text-purple-400"><%= formTitle %></h1>
        </div>
        
        <!-- Success/Error Messages -->
        <% if (request.getParameter("error") != null) { %>
            <div class="bg-red-800 text-white px-4 py-3 rounded mb-4">
                <%= request.getParameter("error") %>
            </div>
        <% } %>
        
        <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
            <form action="admin-admin-save.jsp" method="post" class="p-6">
                <% if (isEditing) { %>
                    <input type="hidden" name="adminId" value="<%= adminId %>">
                <% } %>
                
                <div class="mb-4">
                    <label for="username" class="block text-sm font-medium text-gray-400 mb-2">Username</label>
                    <input type="text" id="username" name="username" value="<%= username %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
                           required>
                </div>
                
                <div class="mb-4">
                    <label for="name" class="block text-sm font-medium text-gray-400 mb-2">Full Name</label>
                    <input type="text" id="name" name="name" value="<%= name %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
                           required>
                </div>
                
                <div class="mb-4">
                    <label for="email" class="block text-sm font-medium text-gray-400 mb-2">Email</label>
                    <input type="email" id="email" name="email" value="<%= email %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                
                <div class="mb-4">
                    <label for="role" class="block text-sm font-medium text-gray-400 mb-2">Role</label>
                    <select id="role" name="role" 
                            class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                        <option value="admin" <%= role.equals("admin") ? "selected" : "" %>>Admin</option>
                        <option value="super_admin" <%= role.equals("super_admin") ? "selected" : "" %>>Super Admin</option>
                    </select>
                </div>
                
                <% if (!isEditing) { %>
                <div class="mb-6">
                    <label for="password" class="block text-sm font-medium text-gray-400 mb-2">Password</label>
                    <input type="password" id="password" name="password" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
                           required>
                </div>
                <% } %>
                
                <div class="flex justify-end">
                    <a href="admin-admins.jsp" class="px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-lg font-medium transition duration-200 mr-2">
                        Cancel
                    </a>
                    <button type="submit" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                        <%= isEditing ? "Update" : "Add" %> Admin
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
