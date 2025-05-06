<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if admin is logged in
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }
    
    // Check if editing or creating new
    String userId = request.getParameter("id");
    String userName = "";
    String userEmail = "";
    String userContact = "";
    boolean isEditing = userId != null && !userId.isEmpty();
    String formTitle = isEditing ? "Edit User" : "Add New User";
    
    // If editing, fetch user details
    if (isEditing) {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
            
            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM user WHERE id = ?");
            pstmt.setInt(1, Integer.parseInt(userId));
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                userName = rs.getString("name");
                userEmail = rs.getString("email");
                userContact = rs.getString("contact_no") != null ? rs.getString("contact_no") : "";
            }
            
            rs.close();
            pstmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("<p class='text-red-500'>Error loading user: " + e.getMessage() + "</p>");
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
                <a href="admin-users.jsp" class="text-purple-400"><i class="fas fa-users mr-2"></i>Users</a>
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
            <form action="admin-user-save.jsp" method="post" class="p-6">
                <% if (isEditing) { %>
                    <input type="hidden" name="userId" value="<%= userId %>">
                <% } %>
                
                <div class="mb-4">
                    <label for="userName" class="block text-sm font-medium text-gray-400 mb-2">Name</label>
                    <input type="text" id="userName" name="userName" value="<%= userName %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
                           required>
                </div>
                
                <div class="mb-4">
                    <label for="userEmail" class="block text-sm font-medium text-gray-400 mb-2">Email</label>
                    <input type="email" id="userEmail" name="userEmail" value="<%= userEmail %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
                           required>
                </div>
                
                <div class="mb-4">
                    <label for="userContact" class="block text-sm font-medium text-gray-400 mb-2">Contact Number</label>
                    <input type="text" id="userContact" name="userContact" value="<%= userContact %>" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                
                <% if (!isEditing) { %>
                <div class="mb-6">
                    <label for="userPassword" class="block text-sm font-medium text-gray-400 mb-2">Password</label>
                    <input type="password" id="userPassword" name="userPassword" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
                           required>
                </div>
                <% } %>
                
                <div class="flex justify-end">
                    <a href="admin-users.jsp" class="px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-lg font-medium transition duration-200 mr-2">
                        Cancel
                    </a>
                    <button type="submit" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                        <%= isEditing ? "Update" : "Add" %> User
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
