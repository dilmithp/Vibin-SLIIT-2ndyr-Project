<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - ${album.albumName}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-900 text-white">
    <!-- Navigation Bar -->
    <nav class="bg-black p-4 shadow-lg">
        <div class="container mx-auto flex justify-between items-center">
            <a href="<%=request.getContextPath()%>/index.jsp" class="text-2xl font-bold text-purple-500">Vibin</a>
            <div class="flex items-center space-x-4">
                <a href="<%=request.getContextPath()%>/index.jsp" class="hover:text-purple-400"><i class="fas fa-home mr-2"></i>Home</a>
                <a href="<%=request.getContextPath()%>/songs" class="hover:text-purple-400"><i class="fas fa-music mr-2"></i>Songs</a>
                <a href="<%=request.getContextPath()%>/albums" class="text-purple-400"><i class="fas fa-compact-disc mr-2"></i>Albums</a>
                <a href="<%=request.getContextPath()%>/playlist-list.jsp" class="hover:text-purple-400"><i class="fas fa-list mr-2"></i>Playlists</a>
                <a href="<%=request.getContextPath()%>/likedSongs.jsp" class="hover:text-purple-400"><i class="fas fa-heart mr-2"></i>Liked</a>
                <a href="<%=request.getContextPath()%>/profile.jsp" class="hover:text-purple-400"><i class="fas fa-user mr-2"></i>Profile</a>
                <a href="<%=request.getContextPath()%>/Logout" class="hover:text-purple-400"><i class="fas fa-sign-out-alt mr-2"></i>Logout</a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto py-8 px-4">
        <!-- Album Header -->
        <div class="flex flex-col md:flex-row items-start mb-8">
            <img src="${pageContext.request.contextPath}/images/albums/${album.albumId}.jpg" 
                 alt="${album.albumName}" 
                 class="w-48 h-48 object-cover rounded-lg shadow-lg mr-6"
                 onerror="this.src='${pageContext.request.contextPath}/images/default-album.jpg'">
            
            <div>
                <h1 class="text-3xl font-bold text-purple-400 mb-2">${album.albumName}</h1>
                <p class="text-xl text-gray-300 mb-2">Artist: ${album.artist}</p>
                <p class="text-gray-400 mb-4">Genre: ${album.genre}</p>
                <p class="text-gray-400 mb-4">Release Date: ${album.releaseDate}</p>
                
                <button class="px-6 py-2 bg-purple-600 hover:bg-purple-700 rounded-full font-medium transition duration-200">
                    <i class="fas fa-play mr-2"></i>Play All
                </button>
            </div>
        </div>
        
        <!-- Songs Table -->
        <div class="bg-gray-800 rounded-lg overflow-hidden shadow-lg">
            <table class="min-w-full divide-y divide-gray-700">
                <thead class="bg-gray-700">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">#</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Title</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Artist</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-700">
                    <c:forEach var="song" items="${albumSongs}" varStatus="status">
                        <tr class="hover:bg-gray-700">
                            <td class="px-6 py-4 whitespace-nowrap">${status.count}</td>
                            <td class="px-6 py-4 whitespace-nowrap">${song.songName}</td>
                            <td class="px-6 py-4 whitespace-nowrap">${song.singer}</td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <a href="javascript:void(0)" onclick="playSong(${song.songId})" class="text-purple-400 hover:text-purple-300 mr-3">
                                    <i class="fas fa-play"></i>
                                </a>
                                <a href="<%=request.getContextPath()%>/playlist-add-song.jsp?songId=${song.songId}" class="text-green-400 hover:text-green-300 mr-3">
                                    <i class="fas fa-plus"></i>
                                </a>
                                <a href="<%=request.getContextPath()%>/like-song.jsp?songId=${song.songId}" class="text-pink-400 hover:text-pink-300">
                                    <i class="fas fa-heart"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    
                    <c:if test="${empty albumSongs}">
                        <tr>
                            <td colspan="4" class="px-6 py-4 text-center text-gray-400">No songs found in this album</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
        
        <!-- Back Button -->
        <div class="mt-6">
            <a href="<%=request.getContextPath()%>/albums" class="inline-flex items-center px-4 py-2 bg-gray-700 hover:bg-gray-600 rounded-lg font-medium transition duration-200">
                <i class="fas fa-arrow-left mr-2"></i>Back to Albums
            </a>
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
    
    <script>
        function playSong(songId) {
            // handle song playback
            console.log("Playing song ID: " + songId);
        }
    </script>
</body>
</html>
