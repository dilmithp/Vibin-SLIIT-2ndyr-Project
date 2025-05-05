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
                    <a href="song-list.jsp" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-list mr-2"></i>Song List
                    </a>
                    <a href="song-form.jsp" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-plus-circle mr-2"></i>Add Song
                    </a>
                    <a href="likedSongs.jsp" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-heart mr-2"></i>Liked Songs
                    </a>
                    <a href="likeSong.jsp" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-thumbs-up mr-2"></i>Like Song (Action)
                    </a>
                    <a href="unlikeSong.jsp" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-thumbs-down mr-2"></i>Unlike Song (Action)
                    </a>
                </div>
            </div>
            
            <!-- Album Management -->
            <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
                <div class="bg-green-600 px-4 py-3">
                    <h2 class="text-xl font-bold"><i class="fas fa-compact-disc mr-2"></i>Album Management</h2>
                </div>
                <div class="p-4 space-y-2">
                    <a href="album-list.jsp" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-list mr-2"></i>Album List
                    </a>
                    <a href="album-form.jsp" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-plus-circle mr-2"></i>Add Album
                    </a>
                    <a href="album-detail.jsp" class="block px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-md">
                        <i class="fas fa-info-circle mr-2"></i>Album Details
                    </a>
                </div>
            </div>
        </div>
        
        <div class="mt-8 text-center text-gray-500">
            <p>Vibin Music Store - Testing Navigation Hub</p>
            <p class="text-sm mt-2">Created on: May 5, 2025</p>
        </div>
    </div>
</body>
</html>
