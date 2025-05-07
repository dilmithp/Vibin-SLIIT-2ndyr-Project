<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Check if user is logged in
    if (session.getAttribute("id") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
	int userId = Integer.parseInt(String.valueOf(session.getAttribute("id")));
    String userName = (String)session.getAttribute("name");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Create Playlist</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-900 text-white">
    <!-- Navigation Bar -->
    <nav class="bg-black p-4 shadow-lg sticky top-0 z-50">
        <div class="container mx-auto flex justify-between items-center">
            <a href="index.jsp" class="text-2xl font-bold text-purple-500">Vibin</a>
            <div class="flex items-center space-x-6">
                <a href="index.jsp" class="hover:text-purple-400"><i class="fas fa-home mr-2"></i>Home</a>
                <a href="<%=request.getContextPath()%>/songs" class="hover:text-purple-400"><i class="fas fa-music mr-2"></i>Songs</a>
                <a href="<%=request.getContextPath()%>/albums" class="hover:text-purple-400"><i class="fas fa-compact-disc mr-2"></i>Albums</a>
                <a href="playlist-list.jsp" class="text-purple-400"><i class="fas fa-list mr-2"></i>Playlists</a>
                <a href="likedSongs.jsp" class="hover:text-purple-400"><i class="fas fa-heart mr-2"></i>Liked</a>
                <a href="profile.jsp" class="hover:text-purple-400"><i class="fas fa-user mr-2"></i>Profile</a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto py-8 px-4">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-3xl font-bold text-purple-400">Create New Playlist</h1>
        </div>
        
        <!-- Error Message -->
        <% if (request.getParameter("error") != null) { %>
            <div class="bg-red-800 text-white px-4 py-3 rounded mb-4">
                <%= request.getParameter("error") %>
            </div>
        <% } %>
        
        <!-- Create Playlist Form -->
        <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
            <form action="playlist-save.jsp" method="post" class="p-6">
                <div class="mb-4">
                    <label for="playlistName" class="block text-sm font-medium text-gray-400 mb-2">Playlist Name</label>
                    <input type="text" id="playlistName" name="playlistName" 
                           class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"
                           required>
                </div>
                
                <div class="mb-6">
                    <label for="description" class="block text-sm font-medium text-gray-400 mb-2">Description (Optional)</label>
                    <textarea id="description" name="description" rows="4"
                              class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500"></textarea>
                </div>
                
                <div class="flex justify-end">
                    <a href="playlist-list.jsp" class="px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-lg font-medium transition duration-200 mr-2">
                        Cancel
                    </a>
                    <button type="submit" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                        Create Playlist
                    </button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Now Playing Bar -->
    <div class="fixed bottom-0 left-0 right-0 bg-gray-900 border-t border-gray-800 p-3 shadow-lg">
        <div class="container mx-auto flex justify-between items-center">
            <div class="flex items-center">
                <img src="${pageContext.request.contextPath}/images/default-album.jpg" alt="Now Playing" class="h-12 w-12 rounded mr-3">
                <div>
                    <h4 class="font-medium">Currently Playing Song</h4>
                    <p class="text-sm text-gray-400">Artist Name</p>
                </div>
            </div>
            
            <div class="flex flex-col items-center">
                <div class="flex items-center space-x-4 mb-1">
                    <button class="text-gray-400 hover:text-white"><i class="fas fa-step-backward"></i></button>
                    <button class="bg-purple-600 hover:bg-purple-700 text-white p-2 rounded-full">
                        <i class="fas fa-play"></i>
                    </button>
                    <button class="text-gray-400 hover:text-white"><i class="fas fa-step-forward"></i></button>
                </div>
                <div class="w-64 bg-gray-700 rounded-full h-1.5">
                    <div class="bg-purple-600 h-1.5 rounded-full w-1/3"></div>
                </div>
            </div>
            
            <div class="flex items-center space-x-3">
                <button class="text-gray-400 hover:text-white"><i class="fas fa-volume-up"></i></button>
                <div class="w-24 bg-gray-700 rounded-full h-1.5">
                    <div class="bg-purple-600 h-1.5 rounded-full w-2/3"></div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
