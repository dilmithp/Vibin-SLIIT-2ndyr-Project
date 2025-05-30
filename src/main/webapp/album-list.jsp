<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Albums</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-900 text-white">
    <!-- Navigation Bar -->
    <nav class="bg-black p-4 shadow-lg">
        <div class="container mx-auto flex justify-between items-center">
            <a href="index.jsp" class="text-2xl font-bold text-purple-500">Vibin</a>
            <div class="flex items-center space-x-4">
                <a href="index.jsp" class="hover:text-purple-400"><i class="fas fa-home mr-2"></i>Home</a>
                <a href="<%=request.getContextPath()%>/songs" class="hover:text-purple-400"><i class="fas fa-music mr-2"></i>Songs</a>
                <a href="<%=request.getContextPath()%>/albums" class="text-purple-400"><i class="fas fa-compact-disc mr-2"></i>Albums</a>
                <a href="playlist-list.jsp" class="hover:text-purple-400"><i class="fas fa-list mr-2"></i>Playlists</a>
                <a href="likedSongs.jsp" class="hover:text-purple-400"><i class="fas fa-heart mr-2"></i>Liked</a>
                <a href="profile.jsp" class="hover:text-purple-400"><i class="fas fa-user mr-2"></i>Profile</a>
                <a href="<%=request.getContextPath()%>/Logout" class="hover:text-purple-400"><i class="fas fa-sign-out-alt mr-2"></i>Logout</a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto py-8 px-4">
        <div class="mb-6">
            <h1 class="text-3xl font-bold text-purple-400">Albums</h1>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            <c:forEach var="album" items="${listAlbum}">
                <div class="bg-gray-800 rounded-lg overflow-hidden shadow-lg hover:shadow-xl transition-shadow duration-300">
                    <img src="${pageContext.request.contextPath}/images/albums/${album.albumId}.jpg" 
                         alt="${album.albumName}" 
                         class="w-full h-48 object-cover"
                         onerror="this.src='${pageContext.request.contextPath}/images/default-album.jpg'">
                    
                    <div class="p-4">
                        <h2 class="text-xl font-bold mb-1 truncate">${album.albumName}</h2>
                        <p class="text-gray-400 mb-2">${album.artist}</p>
                        <p class="text-sm text-gray-500 mb-4">${album.genre}</p>
                        
                        <div class="flex justify-center">
                            <a href="<%=request.getContextPath()%>/albums/view?id=${album.albumId}" 
                               class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                                <i class="fas fa-eye mr-1"></i> View Songs
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        
        <c:if test="${empty listAlbum}">
            <div class="bg-gray-800 rounded-lg p-8 text-center">
                <i class="fas fa-compact-disc text-5xl text-gray-600 mb-4"></i>
                <p class="text-xl text-gray-400">No albums found</p>
                <p class="text-gray-500 mt-2">Check back later for new albums</p>
            </div>
        </c:if>
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
