<%@ page import="java.sql.*" %>
<%@ page import="com.vibin.likes.LikedSongDAO" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - My Liked Songs</title>
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
                <a href="<%=request.getContextPath()%>/albums" class="hover:text-purple-400"><i class="fas fa-compact-disc mr-2"></i>Albums</a>
                <a href="likedSongs.jsp" class="text-purple-400"><i class="fas fa-heart mr-2"></i>Liked Songs</a>
                <a href="profile.jsp" class="hover:text-purple-400"><i class="fas fa-user mr-2"></i>Profile</a>
                <a href="<%=request.getContextPath()%>/Logout" class="hover:text-purple-400"><i class="fas fa-sign-out-alt mr-2"></i>Logout</a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto py-8 px-4">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-3xl font-bold text-purple-400">My Liked Songs</h1>
        </div>
        
        <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
            <% 
            try {
                // Get user ID from session safely
                Object userIdObj = session.getAttribute("id");
                int userId = 0;
                if (userIdObj != null) {
                    if (userIdObj instanceof Integer) {
                        userId = (Integer) userIdObj;
                    } else if (userIdObj instanceof String) {
                        userId = Integer.parseInt((String) userIdObj);
                    }
                }
                
                if (userId == 0) {
                    out.println("<p class='text-red-500 p-4'>Error: User not logged in</p>");
                } else {
                    // Get liked songs
                    LikedSongDAO likedSongDAO = new LikedSongDAO();
                    List<Map<String, Object>> likedSongs = likedSongDAO.getLikedSongs(userId);
                    
                    if (likedSongs.isEmpty()) {
                        out.println("<p class='text-gray-400 p-6 text-center'>You haven't liked any songs yet.</p>");
                    } else {
            %>
            
            <table class="min-w-full divide-y divide-gray-700">
                <thead class="bg-gray-700">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Title</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Singer</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Album</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Music Director</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-700">
                <% for(Map<String, Object> song : likedSongs) { %>
                    <tr class="hover:bg-gray-700">
                        <td class="px-6 py-4 whitespace-nowrap"><%= song.get("title") %></td>
                        <td class="px-6 py-4 whitespace-nowrap"><%= song.get("artist") %></td>
                        <td class="px-6 py-4 whitespace-nowrap"><%= song.get("album") != null ? song.get("album") : "-" %></td>
                        <td class="px-6 py-4 whitespace-nowrap"><%= song.get("musicDirector") %></td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <form action="unlikeSong.jsp" method="post">
                                <input type="hidden" name="songId" value="<%= song.get("songId") %>">
                                <button type="submit" class="text-red-400 hover:text-red-300">
                                    <i class="fas fa-heart-broken"></i> Unlike
                                </button>
                            </form>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
            
            <% 
                    }
                }
            } catch(Exception e) {
                out.println("<p class='text-red-500 p-4'>Error: " + e.getMessage() + "</p>");
            }
            %>
        </div>
    </div>
</body>
</html>
