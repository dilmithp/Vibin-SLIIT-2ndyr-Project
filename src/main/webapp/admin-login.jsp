<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Admin Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-900 text-white">
    <div class="min-h-screen flex items-center justify-center">
        <div class="bg-gray-800 p-8 rounded-lg shadow-xl w-full max-w-md">
            <div class="text-center mb-8">
                <h1 class="text-3xl font-bold text-purple-500">Vibin Admin</h1>
                <p class="text-gray-400 mt-2">Access the admin dashboard</p>
            </div>
            
            <% if (request.getParameter("error") != null) { %>
                <div class="bg-red-800 text-white px-4 py-3 rounded mb-4">
                    <%= request.getParameter("error") %>
                </div>
            <% } %>
            
            <form action="<%=request.getContextPath()%>/AdminLogin" method="post">
                <div class="mb-4">
                    <label for="username" class="block text-sm font-medium text-gray-400 mb-2">Username</label>
                    <input type="text" id="username" name="username" required
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                
                <div class="mb-6">
                    <label for="password" class="block text-sm font-medium text-gray-400 mb-2">Password</label>
                    <input type="password" id="password" name="password" required
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                </div>
                
                <button type="submit" class="w-full bg-purple-600 hover:bg-purple-700 text-white font-bold py-2 px-4 rounded-md transition duration-200">
                    <i class="fas fa-sign-in-alt mr-2"></i>Login
                </button>
            </form>
            
            <div class="mt-6 text-center">
                <a href="login.jsp" class="text-purple-400 hover:text-purple-300">
                    <i class="fas fa-arrow-left mr-2"></i>Back to User Login
                </a>
            </div>
        </div>
    </div>
</body>
</html>
