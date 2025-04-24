<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vibin - User Profile</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
</head>
<body class="bg-gray-900 text-white">
    <!-- Navigation Bar -->
    <nav class="bg-black p-4 shadow-lg">
        <div class="container mx-auto flex justify-between items-center">
            <a href="index.jsp" class="text-2xl font-bold text-purple-500">Vibin</a>
            <div class="flex items-center space-x-4">
                <a href="index.jsp" class="hover:text-purple-400"><i class="fas fa-home mr-2"></i>Home</a>
                <a href="library.jsp" class="hover:text-purple-400"><i class="fas fa-book mr-2"></i>Library</a>
                <a href="profile.jsp" class="text-purple-400"><i class="fas fa-user mr-2"></i>Profile</a>
                <a href="Logout" class="hover:text-purple-400"><i class="fas fa-sign-out-alt mr-2"></i>Logout</a>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container mx-auto py-8 px-4">
        <div class="max-w-3xl mx-auto bg-gray-800 rounded-lg shadow-xl overflow-hidden">
            <div class="p-8">
                <h1 class="text-3xl font-bold mb-6 text-center text-purple-400">User Profile</h1>
                
                <!-- Profile Information -->
                <div class="mb-8 flex items-center justify-center">
                    <div class="w-32 h-32 rounded-full bg-purple-600 flex items-center justify-center text-4xl font-bold mr-6">
                        <%= ((String)session.getAttribute("name")).charAt(0) %>
                    </div>
                    <div>
                        <h2 class="text-2xl font-bold"><%= session.getAttribute("name") %></h2>
                        <p class="text-gray-400"><%= session.getAttribute("email") %></p>
                        <p class="text-gray-400"><i class="fas fa-phone mr-2"></i><%= session.getAttribute("contact_no") %></p>
                    </div>
                </div>
                
                <!-- Edit Profile Form -->
                <form action="UpdateProfile" method="post" class="space-y-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="name" class="block text-sm font-medium text-gray-400 mb-1">Full Name</label>
                            <input type="text" id="name" name="name" value="<%= session.getAttribute("name") %>" 
                                class="w-full px-4 py-2 rounded-lg bg-gray-700 border border-gray-600 focus:outline-none focus:ring-2 focus:ring-purple-500">
                        </div>
                        <div>
                            <label for="email" class="block text-sm font-medium text-gray-400 mb-1">Email Address</label>
                            <input type="email" id="email" name="email" value="<%= session.getAttribute("email") %>" 
                                class="w-full px-4 py-2 rounded-lg bg-gray-700 border border-gray-600 focus:outline-none focus:ring-2 focus:ring-purple-500" readonly>
                        </div>
                        <div>
                            <label for="contact" class="block text-sm font-medium text-gray-400 mb-1">Contact Number</label>
                            <input type="text" id="contact" name="contact" value="<%= session.getAttribute("contact_no") %>" 
                                class="w-full px-4 py-2 rounded-lg bg-gray-700 border border-gray-600 focus:outline-none focus:ring-2 focus:ring-purple-500">
                        </div>
                        <div>
                            <label for="password" class="block text-sm font-medium text-gray-400 mb-1">New Password</label>
                            <input type="password" id="password" name="password" placeholder="Leave blank to keep current password" 
                                class="w-full px-4 py-2 rounded-lg bg-gray-700 border border-gray-600 focus:outline-none focus:ring-2 focus:ring-purple-500">
                        </div>
                    </div>
                    
                    <div class="flex justify-between pt-4">
                        <button type="submit" class="px-6 py-3 bg-purple-600 hover:bg-purple-700 rounded-lg font-medium transition duration-200">
                            <i class="fas fa-save mr-2"></i>Update Profile
                        </button>
                        <a href="#" onclick="confirmDelete()" class="px-6 py-3 bg-red-600 hover:bg-red-700 rounded-lg font-medium transition duration-200">
                            <i class="fas fa-trash-alt mr-2"></i>Delete Account
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Hidden form for delete account -->
    <form id="deleteForm" action="DeleteAccount" method="post" style="display: none;"></form>
    
    <script>
        function confirmDelete() {
            swal({
                title: "Are you sure?",
                text: "Once deleted, you will not be able to recover your account!",
                icon: "warning",
                buttons: true,
                dangerMode: true,
            })
            .then((willDelete) => {
                if (willDelete) {
                    document.getElementById("deleteForm").submit();
                }
            });
            return false;
        }
        
        // Check for status messages
        window.onload = function() {
            var status = "<%= request.getAttribute("status") %>";
            if (status === "success") {
                swal("Success", "Profile updated successfully!", "success");
            } else if (status === "error") {
                swal("Error", "Something went wrong. Please try again.", "error");
            }
        }
    </script>
</body>
</html>
