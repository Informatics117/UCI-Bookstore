<%-- REQUIRED JAVA IMPORTS --%>
<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"%>

<%-- THIS PAGE SERVES AS A REDIRECTION PAGE. --%>
 <%
 	//message displayed for why it is redirecting.
 	String message = request.getParameter("message");
 	out.println(message+"<BR>");
 	//url to be changed to /index.jsp when splash page is finished.
	response.setHeader("Refresh", "5;url=/Bookstore/login.jsp");
 %>