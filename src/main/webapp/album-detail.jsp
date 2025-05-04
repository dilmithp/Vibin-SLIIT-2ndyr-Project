<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
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
            <a href="index.jsp" class="text-2xl font-bold text-purple-500">Vibin</a>
            <div class="flex items-center space-x-4">
                <a href="index.jsp" class="hover:text-purple-400"><i class="fas fa-home mr-2"></i>Home</a>
                <a href="songs" class="hover:text-purple-400"><i class="fas fa-music mr-2"></i>Songs</a>
                <a href="albums" class="text-purple-400"><i class="fas fa-compact-disc mr-2"></i>Albums</a>
                <a href="profile.jsp" class="hover:text-purple-400"><i class="fas fa-user mr-2"></i>Profile</a>
                <a href="Logout" class="hover:text-purple-400"><i class="fas fa-sign-out-alt mr-2"></i>Logout</a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto py-8 px-4">
        <div class="flex flex-col md:flex-row gap-8">
            <!-- Album Info -->
            <div class="w-full md:w-1/3">
                <div class="bg-gray-800 p-6 rounded-lg shadow-xl">
                    <img src="${pageContext.request.contextPath}/images/albums/${album.albumId}.jpg" 
                         alt="${album.albumName}" 
                         class="w-full h-auto rounded-md shadow-lg mb-4" 
                         onerror="this.src='${pageContext.request.contextPath}/images/default-album.jpg'">
                    
                    <h1 class="text-2xl font-bold mb-2">${album.albumName}</h1>
                    <p class="text-xl text-gray-300 mb-4">${album.artist}</p>
                    
                    <div class="flex items-center text-sm text-gray-400 mb-2">
                        <i class="fas fa-calendar-alt mr-2"></i>
                        <fmt:formatDate value="${album.releaseDate}" pattern="MMMM d, yyyy" />
                    </div>
                    
                    <div class="flex items-center text-sm text-gray-400 mb-4">
                        <i class="fas fa-music mr-2"></i>
                        ${album.genre}
                    </div>
                    
                    <button class="w-full bg-purple-600 hover:bg-purple-700 text-white py-2 px-4 rounded-full flex items-center justify-center transition duration-200">
                        <i class="fas fa-play mr-2"></i> Play All
                    </button>
                </div>
            </div>
            
            <!-- Song List -->
            <div class="w-full md:w-2/3">
                <div class="flex justify-between items-center mb-4">
                    <h2 class="text-xl font-bold">Songs</h2>
                    <a href="<%=request.getContextPath()%>/songs/new?albumId=${album.albumId}" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                        <i class="fas fa-plus mr-2"></i>Add Song
                    </a>
                </div>
                
                <div class="bg-gray-800 rounded-lg overflow-hidden shadow-xl">
                    <table class="w-full">
                        <thead>
                            <tr class="bg-gray-700 text-left">
                                <th class="py-3 px-4">#</th>
                                <th class="py-3 px-4">Song Name</th>
                                <th class="py-3 px-4">Singer</th>
                                <th class="py-3 px-4">Music Director</th>
                                <th class="py-3 px-4">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="song" items="${songs}" varStatus="loop">
                                <tr class="border-b border-gray-700 hover:bg-gray-700">
                                    <td class="py-3 px-4">${loop.index + 1}</td>
                                    <td class="py-3 px-4">${song.songName}</td>
                                    <td class="py-3 px-4">${song.singer}</td>
                                    <td class="py-3 px-4">${song.musicDirector}</td>
                                    <td class="py-3 px-4">
                                        <div class="flex space-x-3">
                                            <button class="text-purple-400 hover:text-purple-300" 
                                                    onclick="playSong(${song.songId})">
                                                <i class="fas fa-play"></i>
                                            </button>
                                            <a href="<%=request.getContextPath()%>/songs/edit?id=${song.songId}" 
                                               class="text-blue-400 hover:text-blue-300">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="<%=request.getContextPath()%>/songs/delete?id=${song.songId}" 
                                               class="text-red-400 hover:text-red-300"
                                               onclick="return confirm('Are you sure you want to delete this song?')">
                                                <i class="fas fa-trash"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        function playSong(songId) {
            // Add your play song functionality here
            console.log("Playing song: " + songId);
        }
    </script>
</body>
</html>
