<%@ page import="java.sql.*" %>
<%@ page import="com.vibin.artist.ArtistDAO" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vibin - Artist Details</title>
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
                <a href="artist-list.jsp" class="text-purple-400"><i class="fas fa-user-music mr-2"></i>Artists</a>
                <a href="playlist-list.jsp" class="hover:text-purple-400"><i class="fas fa-list mr-2"></i>Playlists</a>
                <a href="profile.jsp" class="hover:text-purple-400"><i class="fas fa-user mr-2"></i>Profile</a>
            </div>
        </div>
    </nav>

    <div class="container mx-auto py-8 px-4">
        <%
            // Get artist ID from request
            String artistIdStr = request.getParameter("id");
            int artistId = 0;
            
            try {
                artistId = Integer.parseInt(artistIdStr);
            } catch (Exception e) {
                out.println("<p class='text-red-500'>Invalid artist ID</p>");
                return;
            }
            
            try {
                ArtistDAO artistDAO = new ArtistDAO();
                Map<String, Object> artist = artistDAO.getArtistById(artistId);
                
                if (artist == null) {
                    out.println("<p class='text-red-500'>Artist not found</p>");
                    return;
                }
                
                // Get songs by this artist
                List<Map<String, Object>> songs = artistDAO.getSongsByArtist(artistId);
        %>
        
        <!-- Success message if any -->
        <% if (request.getParameter("message") != null) { %>
            <div class="bg-green-800 text-white px-4 py-3 rounded mb-4">
                <%= request.getParameter("message") %>
            </div>
        <% } %>
        
        <!-- Error message if any -->
        <% if (request.getParameter("error") != null) { %>
            <div class="bg-red-800 text-white px-4 py-3 rounded mb-4">
                <%= request.getParameter("error") %>
            </div>
        <% } %>
        
        <div class="flex flex-col md:flex-row gap-8">
            <!-- Artist Info -->
            <div class="md:w-1/3">
                <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
                    <div class="h-64 bg-gray-700 flex items-center justify-center">
                        <% if (artist.get("imageUrl") != null && !((String)artist.get("imageUrl")).isEmpty()) { %>
                            <img src="<%= artist.get("imageUrl") %>" alt="<%= artist.get("name") %>" class="h-full w-full object-cover">
                        <% } else { %>
                            <i class="fas fa-user-circle text-8xl text-gray-500"></i>
                        <% } %>
                    </div>
                    <div class="p-6">
                        <div class="flex justify-between items-center mb-4">
                            <h1 class="text-3xl font-bold text-purple-400"><%= artist.get("name") %></h1>
                            <div class="flex space-x-2">
                                <a href="artist-form.jsp?id=<%= artistId %>" class="text-blue-400 hover:text-blue-300">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="deleteArtist.jsp?id=<%= artistId %>" 
                                   onclick="return confirm('Are you sure you want to delete this artist?')"
                                   class="text-red-400 hover:text-red-300">
                                    <i class="fas fa-trash-alt"></i>
                                </a>
                            </div>
                        </div>
                        
                        <% if (artist.get("genre") != null && !((String)artist.get("genre")).isEmpty()) { %>
                            <p class="text-gray-400 mb-2"><span class="font-medium">Genre:</span> <%= artist.get("genre") %></p>
                        <% } %>
                        
                        <% if (artist.get("country") != null && !((String)artist.get("country")).isEmpty()) { %>
                            <p class="text-gray-400 mb-4"><span class="font-medium">Country:</span> <%= artist.get("country") %></p>
                        <% } %>
                        
                        <% if (artist.get("bio") != null && !((String)artist.get("bio")).isEmpty()) { %>
                            <div class="mt-4">
                                <h3 class="text-lg font-medium text-white mb-2">Biography</h3>
                                <p class="text-gray-400"><%= artist.get("bio") %></p>
                            </div>
                        <% } %>
                    </div>
                </div>
                
                <!-- Add Song Form -->
                <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden mt-6">
                    <div class="p-6">
                        <h2 class="text-xl font-bold text-white mb-4">Add New Song for <%= artist.get("name") %></h2>
                        <form action="addSongForArtist.jsp" method="post" class="space-y-4">
                            <input type="hidden" name="artistId" value="<%= artistId %>">
                            <input type="hidden" name="artistName" value="<%= artist.get("name") %>">
                            
                            <div>
                                <label for="songName" class="block text-sm font-medium text-gray-400 mb-2">Song Title</label>
                                <input type="text" id="songName" name="songName" required
                                       class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            </div>
                            
                            <div>
                                <label for="lyricist" class="block text-sm font-medium text-gray-400 mb-2">Lyricist</label>
                                <input type="text" id="lyricist" name="lyricist"
                                       class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            </div>
                            
                            <div>
                                <label for="musicDirector" class="block text-sm font-medium text-gray-400 mb-2">Music Director</label>
                                <input type="text" id="musicDirector" name="musicDirector"
                                       class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                            </div>
                            
                            <div>
                                <label for="albumId" class="block text-sm font-medium text-gray-400 mb-2">Album (Optional)</label>
                                <select id="albumId" name="albumId" 
                                        class="w-full px-3 py-2 bg-gray-700 border border-gray-600 rounded-md text-white focus:outline-none focus:ring-2 focus:ring-purple-500">
                                    <option value="">-- Select Album --</option>
                                    <% 
                                    try {
                                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:8889/loginjsp", "root", "root");
                                        Statement stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery("SELECT album_id, album_name FROM albums ORDER BY album_name");
                                        
                                        while (rs.next()) {
                                            out.println("<option value='" + rs.getInt("album_id") + "'>" + rs.getString("album_name") + "</option>");
                                        }
                                        
                                        rs.close();
                                        stmt.close();
                                        conn.close();
                                    } catch (Exception e) {
                                        out.println("<option value=''>Error loading albums</option>");
                                    }
                                    %>
                                </select>
                            </div>
                            
                            <div class="flex justify-end">
                                <button type="submit" class="px-4 py-2 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                                    <i class="fas fa-plus mr-2"></i>Add Song
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <!-- Songs by Artist -->
            <div class="md:w-2/3">
                <div class="bg-gray-800 rounded-lg shadow-xl overflow-hidden">
                    <div class="p-6">
                        <h2 class="text-xl font-bold text-white mb-4">Songs by <%= artist.get("name") %></h2>
                        
                        <% if (songs.isEmpty()) { %>
                            <p class="text-gray-400">No songs found for this artist.</p>
                        <% } else { %>
                            <table class="min-w-full divide-y divide-gray-700">
                                <thead class="bg-gray-700">
                                    <tr>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Title</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Lyricist</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Music Director</th>
                                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-300 uppercase tracking-wider">Actions</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-700">
                                <% for (Map<String, Object> song : songs) { %>
                                    <tr class="hover:bg-gray-700">
                                        <td class="px-6 py-4 whitespace-nowrap"><%= song.get("title") %></td>
                                        <td class="px-6 py-4 whitespace-nowrap"><%= song.get("lyricist") %></td>
                                        <td class="px-6 py-4 whitespace-nowrap"><%= song.get("musicDirector") %></td>
                                        <td class="px-6 py-4 whitespace-nowrap">
                                            <a href="<%=request.getContextPath()%>/songs/edit?id=<%= song.get("songId") %>" class="text-blue-400 hover:text-blue-300 mr-3">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                        </td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
        
        <% 
            } catch (Exception e) {
                out.println("<p class='text-red-500'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>
