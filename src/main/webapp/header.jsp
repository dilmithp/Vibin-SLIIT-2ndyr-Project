<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<header class="bg-gray-900 text-white">
  <nav class="container mx-auto px-4 py-3 flex items-center justify-between">
    <!-- Logo -->
    <a href="${pageContext.request.contextPath}/index.jsp" class="flex items-center">
      <span class="text-2xl font-bold text-green-500">Vibin</span>
    </a>
    
    <!-- Navigation Links -->
    <div class="hidden md:flex items-center space-x-6">
      <a href="${pageContext.request.contextPath}/index.jsp" class="hover:text-green-500">Home</a>
      <a href="${pageContext.request.contextPath}/albums/list" class="hover:text-green-500">Albums</a>
      <a href="${pageContext.request.contextPath}/library.jsp" class="hover:text-green-500">Library</a>
      <a href="${pageContext.request.contextPath}/search.jsp" class="hover:text-green-500">Search</a>
    </div>
    
    <!-- User Actions -->
    <div class="flex items-center space-x-4">
      <c:choose>
        <c:when test="${sessionScope.user != null}">
          <div class="relative">
            <button id="userDropdown" class="flex items-center space-x-1">
              <img src="${pageContext.request.contextPath}/images/avatar.png" alt="User" class="w-8 h-8 rounded-full">
              <span>${sessionScope.user.username}</span>
            </button>
            <div id="userMenu" class="hidden absolute right-0 mt-2 w-48 bg-gray-800 rounded-md shadow-lg py-1 z-50">
              <a href="${pageContext.request.contextPath}/profile.jsp" class="block px-4 py-2 hover:bg-gray-700">Profile</a>
              <a href="${pageContext.request.contextPath}/settings.jsp" class="block px-4 py-2 hover:bg-gray-700">Settings</a>
              <a href="${pageContext.request.contextPath}/logout" class="block px-4 py-2 hover:bg-gray-700">Logout</a>
            </div>
          </div>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/login.jsp" class="hover:text-green-500">Login</a>
          <a href="${pageContext.request.contextPath}/register.jsp" class="bg-green-500 hover:bg-green-600 px-4 py-2 rounded-full">Sign Up</a>
        </c:otherwise>
      </c:choose>
    </div>
    
    <!-- Mobile Menu Button -->
    <button id="mobileMenuBtn" class="md:hidden">
      <i class="fas fa-bars text-xl"></i>
    </button>
  </nav>
  
  <!-- Mobile Menu -->
  <div id="mobileMenu" class="hidden md:hidden bg-gray-800 pb-4">
    <div class="container mx-auto px-4 flex flex-col space-y-3">
      <a href="${pageContext.request.contextPath}/index.jsp" class="py-2 hover:text-green-500">Home</a>
      <a href="${pageContext.request.contextPath}/albums/list" class="py-2 hover:text-green-500">Albums</a>
      <a href="${pageContext.request.contextPath}/library.jsp" class="py-2 hover:text-green-500">Library</a>
      <a href="${pageContext.request.contextPath}/search.jsp" class="py-2 hover:text-green-500">Search</a>
    </div>
  </div>
</header>

<script>
  // Toggle mobile menu
  document.getElementById('mobileMenuBtn').addEventListener('click', function() {
    document.getElementById('mobileMenu').classList.toggle('hidden');
  });
  
  // Toggle user dropdown
  document.getElementById('userDropdown')?.addEventListener('click', function() {
    document.getElementById('userMenu').classList.toggle('hidden');
  });
</script>
