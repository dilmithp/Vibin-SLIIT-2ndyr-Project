<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<footer class="bg-gray-900 text-white mt-auto">
  <div class="container mx-auto px-4 py-8">
    <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
      <!-- Company Info -->
      <div>
        <h3 class="text-xl font-bold mb-4">Vibin</h3>
        <p class="text-gray-400">Your favorite online music store with the best collection of songs and albums.</p>
      </div>
      
      <!-- Quick Links -->
      <div>
        <h3 class="text-lg font-bold mb-4">Quick Links</h3>
        <ul class="space-y-2">
          <li><a href="${pageContext.request.contextPath}/index.jsp" class="text-gray-400 hover:text-green-500">Home</a></li>
          <li><a href="${pageContext.request.contextPath}/albums/list" class="text-gray-400 hover:text-green-500">Albums</a></li>
          <li><a href="${pageContext.request.contextPath}/library.jsp" class="text-gray-400 hover:text-green-500">Library</a></li>
          <li><a href="${pageContext.request.contextPath}/search.jsp" class="text-gray-400 hover:text-green-500">Search</a></li>
        </ul>
      </div>
      
      <!-- Legal -->
      <div>
        <h3 class="text-lg font-bold mb-4">Legal</h3>
        <ul class="space-y-2">
          <li><a href="${pageContext.request.contextPath}/terms.jsp" class="text-gray-400 hover:text-green-500">Terms of Service</a></li>
          <li><a href="${pageContext.request.contextPath}/privacy.jsp" class="text-gray-400 hover:text-green-500">Privacy Policy</a></li>
          <li><a href="${pageContext.request.contextPath}/copyright.jsp" class="text-gray-400 hover:text-green-500">Copyright</a></li>
        </ul>
      </div>
      
      <!-- Connect -->
      <div>
        <h3 class="text-lg font-bold mb-4">Connect With Us</h3>
        <div class="flex space-x-4">
          <a href="#" class="text-gray-400 hover:text-green-500"><i class="fab fa-facebook-f"></i></a>
          <a href="#" class="text-gray-400 hover:text-green-500"><i class="fab fa-twitter"></i></a>
          <a href="#" class="text-gray-400 hover:text-green-500"><i class="fab fa-instagram"></i></a>
          <a href="#" class="text-gray-400 hover:text-green-500"><i class="fab fa-youtube"></i></a>
        </div>
      </div>
    </div>
    
    <div class="border-t border-gray-800 mt-8 pt-6 text-center text-gray-400">
      <p>&copy; 2025 Vibin Music Store. All rights reserved.</p>
    </div>
  </div>
</footer>
