<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Invalidate the session
    session.removeAttribute("artistId");
    session.removeAttribute("artistName");
    session.removeAttribute("artistUsername");
    session.removeAttribute("userType");
    
    // Redirect to login page
    response.sendRedirect("artist-login.jsp?message=You have been successfully logged out");
%>
