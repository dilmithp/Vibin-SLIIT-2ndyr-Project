<%
	if(session.getAttribute("name")==null){
		response.sendRedirect("login.jsp");
	}
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Your Music Universe</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; }
        .gradient-bg { background: linear-gradient(to right, #4b0082, #9400d3); }
        .album-card:hover { transform: translateY(-5px); }
    </style>
</head>
<body class="bg-gray-900 text-white">
    <!-- Navigation Bar -->
    <nav class="bg-black p-4 shadow-lg sticky top-0 z-50">
        <div class="container mx-auto flex justify-between items-center">
            <a href="index.jsp" class="text-2xl font-bold text-purple-500">Vibin</a>
            <div class="flex items-center space-x-6">
                <a href="index.jsp" class="text-purple-400"><i class="fas fa-home mr-2"></i>Home</a>
                <a href="<%=request.getContextPath()%>/songs" class="hover:text-purple-400"><i class="fas fa-music mr-2"></i>Songs</a>
                <a href="<%=request.getContextPath()%>/albums" class="hover:text-purple-400"><i class="fas fa-compact-disc mr-2"></i>Albums</a>
                <a href="playlist-list.jsp" class="hover:text-purple-400"><i class="fas fa-list mr-2"></i>Playlists</a>
                <a href="likedSongs.jsp" class="hover:text-purple-400"><i class="fas fa-heart mr-2"></i>Liked</a>
                <a href="profile.jsp" class="hover:text-purple-400"><i class="fas fa-user mr-2"></i>Profile</a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto py-8 px-4">
        <!-- Welcome Banner -->
        <div class="gradient-bg rounded-xl p-8 mb-10 shadow-lg">
            <h1 class="text-4xl font-bold mb-2">Welcome back, ${sessionScope.name}!</h1>
            <p class="text-xl text-gray-200">Discover new music and enjoy your favorites</p>
        </div>
        
        <!-- Featured Section -->
        <section class="mb-12">
            <div class="flex justify-between items-center mb-6">
                <h2 class="text-2xl font-bold text-purple-400">Featured Albums</h2>
                <a href="<%=request.getContextPath()%>/albums" class="text-sm text-purple-400 hover:underline">View All</a>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <!-- Featured Albums (would be populated from database) -->
                <c:forEach var="i" begin="1" end="4">
                    <div class="bg-gray-800 rounded-lg overflow-hidden shadow-lg hover:shadow-xl transition-all duration-300 album-card">
                        <img src="${pageContext.request.contextPath}/images/album${i}.jpg" 
                             alt="Album Cover" 
                             class="w-full h-48 object-cover"
                             onerror="this.src='${pageContext.request.contextPath}/images/default-album.jpg'">
                        <div class="p-4">
                            <h3 class="text-lg font-bold mb-1">Featured Album ${i}</h3>
                            <p class="text-gray-400 mb-3">Artist Name</p>
                            <a href="#" class="text-purple-400 hover:text-purple-300 text-sm">
                                <i class="fas fa-play mr-1"></i> Play Now
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
        
        <!-- Recently Played -->
        <section class="mb-12">
            <h2 class="text-2xl font-bold text-purple-400 mb-6">Recently Played</h2>
            <div class="bg-gray-800 rounded-lg overflow-hidden shadow-lg">
                <table class="min-w-full">
                    <thead class="bg-gray-700">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">#</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Title</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Artist</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Album</th>
                            <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-700">
                        <c:forEach var="i" begin="1" end="5">
                            <tr class="hover:bg-gray-700">
                                <td class="px-6 py-4 whitespace-nowrap">${i}</td>
                                <td class="px-6 py-4 whitespace-nowrap">Song Title ${i}</td>
                                <td class="px-6 py-4 whitespace-nowrap">Artist Name</td>
                                <td class="px-6 py-4 whitespace-nowrap">Album Name</td>
                                <td class="px-6 py-4 whitespace-nowrap">
                                    <button class="text-purple-400 hover:text-purple-300 mr-3"><i class="fas fa-play"></i></button>
                                    <button class="text-red-400 hover:text-red-300 mr-3"><i class="fas fa-heart"></i></button>
                                    <button class="text-green-400 hover:text-green-300"><i class="fas fa-plus"></i></button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </section>
        
        <!-- Made For You -->
        <section>
            <h2 class="text-2xl font-bold text-purple-400 mb-6">Made For You</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <div class="bg-gradient-to-r from-blue-900 to-purple-900 rounded-lg p-6 shadow-lg">
                    <h3 class="text-xl font-bold mb-3">Daily Mix 1</h3>
                    <p class="text-gray-300 mb-4">Based on your recent listening</p>
                    <button class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-full">
                        <i class="fas fa-play mr-2"></i>Play
                    </button>
                </div>
                
                <div class="bg-gradient-to-r from-pink-900 to-red-900 rounded-lg p-6 shadow-lg">
                    <h3 class="text-xl font-bold mb-3">Discover Weekly</h3>
                    <p class="text-gray-300 mb-4">New discoveries and deep cuts</p>
                    <button class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-full">
                        <i class="fas fa-play mr-2"></i>Play
                    </button>
                </div>
                
                <div class="bg-gradient-to-r from-green-900 to-teal-900 rounded-lg p-6 shadow-lg">
                    <h3 class="text-xl font-bold mb-3">Your Top 2025</h3>
                    <p class="text-gray-300 mb-4">Your most played tracks</p>
                    <button class="bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-full">
                        <i class="fas fa-play mr-2"></i>Play
                    </button>
                </div>
            </div>
        </section>
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
