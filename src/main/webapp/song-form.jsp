<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Song Form</title>
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
                <a href="songs" class="text-purple-400"><i class="fas fa-music mr-2"></i>Songs</a>
                <a href="albums" class="hover:text-purple-400"><i class="fas fa-compact-disc mr-2"></i>Albums</a>
                <a href="profile.jsp" class="hover:text-purple-400"><i class="fas fa-user mr-2"></i>Profile</a>
                <a href="Logout" class="hover:text-purple-400"><i class="fas fa-sign-out-alt mr-2"></i>Logout</a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto py-8 px-4">
        <div class="max-w-2xl mx-auto bg-gray-800 rounded-lg shadow-xl overflow-hidden">
            <div class="p-8">
                <c:if test="${song != null}">
                    <h1 class="text-3xl font-bold mb-6 text-center text-purple-400">Edit Song</h1>
                    <form action="<%=request.getContextPath()%>/songs/update" method="post">
                        <input type="hidden" name="id" value="<c:out value='${song.songId}' />" />
                </c:if>
                <c:if test="${song == null}">
                    <h1 class="text-3xl font-bold mb-6 text-center text-purple-400">Add New Song</h1>
                    <form action="<%=request.getContextPath()%>/songs/insert" method="post">
                </c:if>
                
                <div class="space-y-6">
                    <div>
                        <label for="songName" class="block text-sm font-medium text-gray-400 mb-1">Song Name</label>
                        <input type="text" id="songName" name="songName" value="<c:out value='${song.songName}' />" required
                            class="w-full px-4 py-2 rounded-lg bg-gray-700 border border-gray-600 focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                    
                    <div>
                        <label for="singer" class="block text-sm font-medium text-gray-400 mb-1">Singer</label>
                        <input type="text" id="singer" name="singer" value="<c:out value='${song.singer}' />" required
                            class="w-full px-4 py-2 rounded-lg bg-gray-700 border border-gray-600 focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                    
                    <div>
                        <label for="lyricist" class="block text-sm font-medium text-gray-400 mb-1">Lyricist</label>
                        <input type="text" id="lyricist" name="lyricist" value="<c:out value='${song.lyricist}' />" required
                            class="w-full px-4 py-2 rounded-lg bg-gray-700 border border-gray-600 focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                    
                    <div>
                        <label for="musicDirector" class="block text-sm font-medium text-gray-400 mb-1">Music Director</label>
                        <input type="text" id="musicDirector" name="musicDirector" value="<c:out value='${song.musicDirector}' />" required
                            class="w-full px-4 py-2 rounded-lg bg-gray-700 border border-gray-600 focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                    
                    <div>
                        <label for="albumId" class="block text-sm font-medium text-gray-400 mb-1">Album ID</label>
                        <input type="number" id="albumId" name="albumId" value="<c:out value='${song.albumId}' />" required
                            class="w-full px-4 py-2 rounded-lg bg-gray-700 border border-gray-600 focus:outline-none focus:ring-2 focus:ring-purple-500">
                    </div>
                    
                    <div class="flex justify-between pt-4">
                        <a href="<%=request.getContextPath()%>/songs" class="px-6 py-3 bg-gray-600 hover:bg-gray-700 rounded-lg font-medium transition duration-200">
                            <i class="fas fa-arrow-left mr-2"></i>Cancel
                        </a>
                        <button type="submit" class="px-6 py-3 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                            <i class="fas fa-save mr-2"></i>Save
                        </button>
                    </div>
                </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
