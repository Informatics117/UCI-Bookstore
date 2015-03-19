<%@ page
	import="java.sql.*,
         javax.sql.*,
         java.io.IOException,
         javax.servlet.http.*,
         javax.servlet.*,
         java.util.*,
         javax.naming.InitialContext"%>

<%
//Deletes the cookies regardless of the user and redirects back to the splash page.
	String logout = request.getParameter("logout");

	if (logout.equals("true")) {
		//logs the user out

		session.removeAttribute("admin");
		session.removeAttribute("user");
		session.removeAttribute("id");
		
		Cookie[] cookies = request.getCookies();
		if (cookies != null)
			for (int i = 0; i < cookies.length; i++) {
		        cookies[i].setValue("");
	            cookies[i].setPath("/");
	            cookies[i].setMaxAge(0);
			}

		response.sendRedirect("/Bookstore/redirect.jsp?message=You have been logged out.");
	}
%>