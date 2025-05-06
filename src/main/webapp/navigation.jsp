<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Navigation Hub</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-900 text-white">
    <div class="container mx-auto px-4 py-8">
        <div class="text-center mb-10">
            <h1 class="text-4xl font-bold text-purple-500 mb-2">Vibin Navigation Hub</h1>
            <p class="text-gray-400">Testing access to all pages</p>
        </div>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <!-- Main Pages -->
            <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
                <div class="bg-purple-600 px-4 py-3">
                    <h2 class="text-xl font-bold"><i class="fas fa-home mr-2"></i>Main Pages</h2>
                </div>
                <div class="p-4 space-y-2">
                    <a href="index.jsp" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-house-user mr-2"></i>Home Page
                    </a>
                    <a href="login.jsp" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-sign-in-alt mr-2"></i>Login
                    </a>
                    <a href="registration.jsp" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-user-plus mr-2"></i>Registration
                    </a>
                    <a href="profile.jsp" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-user-circle mr-2"></i>Profile
                    </a>
                </div>
            </div>
            
            <!-- Song Management -->
            <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
                <div class="bg-blue-600 px-4 py-3">
                    <h2 class="text-xl font-bold"><i class="fas fa-music mr-2"></i>Song Management</h2>
                </div>
                <div class="p-4 space-y-2">
                    <a href="<%=request.getContextPath()%>/songs" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-list mr-2"></i>Song List
                    </a>
                    <a href="<%=request.getContextPath()%>/songs/new" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-plus-circle mr-2"></i>Add Song
                    </a>
                    <a href="likedSongs.jsp" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-heart mr-2"></i>Liked Songs
                    </a>
                </div>
            </div>
            
            <!-- Album Management -->
            <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
                <div class="bg-green-600 px-4 py-3">
                    <h2 class="text-xl font-bold"><i class="fas fa-compact-disc mr-2"></i>Album Management</h2>
                </div>
                <div class="p-4 space-y-2">
                    <a href="<%=request.getContextPath()%>/albums" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-list mr-2"></i>Album List
                    </a>
                    <a href="<%=request.getContextPath()%>/albums/new" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-plus-circle mr-2"></i>Add Album
                    </a>
                </div>
            </div>
            
            <!-- Playlist Management -->
            <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
                <div class="bg-yellow-600 px-4 py-3">
                    <h2 class="text-xl font-bold"><i class="fas fa-list mr-2"></i>Playlist Management</h2>
                </div>
                <div class="p-4 space-y-2">
                    <a href="playlist-list.jsp" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-list mr-2"></i>My Playlists
                    </a>
                    <a href="playlist-form.jsp" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-plus-circle mr-2"></i>Create Playlist
                    </a>
                </div>
            </div>
            
            <!-- Artist Management -->
            <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
                <div class="bg-pink-600 px-4 py-3">
                    <h2 class="text-xl font-bold"><i class="fas fa-user-music mr-2"></i>Artist Management</h2>
                </div>
                <div class="p-4 space-y-2">
                    <a href="artist-list.jsp" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-list mr-2"></i>Artist List
                    </a>
                    <a href="artist-form.jsp" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-plus-circle mr-2"></i>Add Artist
                    </a>
                </div>
            </div>
            
            <!-- User Management -->
            <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
                <div class="bg-red-600 px-4 py-3">
                    <h2 class="text-xl font-bold"><i class="fas fa-users mr-2"></i>User Management</h2>
                </div>
                <div class="p-4 space-y-2">
                    <a href="<%=request.getContextPath()%>/users" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-list mr-2"></i>User List
                    </a>
                    <a href="<%=request.getContextPath()%>/users/new" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-plus-circle mr-2"></i>Add User
                    </a>
                </div>
            </div>
        </div>
        
        <div class="mt-8 text-center text-gray-500">
            <p>Vibin Music Store - Testing Navigation Hub</p>
            <p class="text-sm mt-2">Created on: May 6, 2025</p>
        </div>
    </div>
</body>
</html>
