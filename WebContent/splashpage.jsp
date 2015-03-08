<jsp:include page="header.jsp" flush="true">
    <jsp:param name="pageName" value="Front Page"/>
</jsp:include>

<%-- REQUIRED JAVA IMPORTS --%>
<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"%>

<!DOCTYPE html>
<html>
<body>
	<div class="container">
<%
	out.println("<div class='row'>");
	out.println("<div class='col-sm-4'>");
	if(session.getAttribute("user") == null && session.getAttribute("admin") == null){
		out.println("<h4>You are not logged in</h4>");
	}
	else
	{
	String userName = null;
	String sessionID = null;
	Cookie[] cookies = request.getCookies();
	if(cookies !=null){
	for(Cookie cookie : cookies){
	    if(cookie.getName().equals("user") || cookie.getName().equals("admin")) userName = cookie.getValue();
	}
	
	if(userName == null)
	{
		out.println("<h4>You are not logged in</h4>");
	}
	else
	{
	out.println("<h5>You are logged in as "+userName+"</h5>");
	out.println("<form method='POST' action='logout.jsp'><input type='hidden' value='true' name='logout'><button type='submit' class='btn btn-default'>Logout</button></form>");
	}
	}
	}
	out.println("</div>");
	out.println("</div>");
	out.println("<hr>");
%>

<%
try{
	String email = request.getParameter("username");
	String password = request.getParameter("password");
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","testuser","testpass");
	
	Statement s1 = connection.createStatement();
	ResultSet rs1 = s1.executeQuery("SELECT * from contributions JOIN users on users.id = contributions.user_id ORDER BY ts DESC LIMIT 5");
	
	out.println("<div class='row'>");
	out.println("<div class='col-sm-6 scrollable'>");
	out.println("<h5>Recent Contributions</h5>");
	if(rs1 == null || !rs1.first())
	{
		out.println("<h4>No recent contributions. </h4>");
	}
	else
	{
		do{
			out.println("<div class='row admin-row'>");
			out.println("<img src='"+rs1.getString(9)+"'/ height = '248' width = '200'>");
			out.println("<p class='admin-p'>Book Title: <a href = '/Bookstore/book.jsp?book_id="+rs1.getInt(1)+"'>"+ rs1.getString(3) + "</a></p>");
			out.println("<p class='admin-p'>Written by: <a href = '/Bookstore/book.jsp?book_id="+rs1.getInt(2)+"'>"+rs1.getString(12) + " " + rs1.getString(13) + "</a></p>");
			out.println("</div>");
			
			
		} while(rs1.next());
	}	
	out.println("</div>");
	Statement s = connection.createStatement();
	ResultSet rs = s.executeQuery("SELECT * from reviews JOIN contributions on contributions.id = reviews.contribution_id ORDER BY reviews.ts DESC LIMIT 5");
	
	out.println("<div class='col-sm-6'>");
	out.println("<h5>Recent Reviews</h5>");
	if(rs == null || !rs.first())
	{
		out.println("<4>No recent reviews. </h4>");
	}
	else
	{
		do{
			out.println("<div class='row admin-row'>");
			out.println("<p class='admin-p'>Book Title: <a href = '/Bookstore/book.jsp?book_id="+rs.getInt(4)+"'>"+ rs.getString(9) + "</a></p>");
			out.println("<p class='admin-p'>Review: "+rs.getString(5) + "</p>");
			out.println("</div>");
		} while(rs.next());
	}	
	out.println("</div>");
	
}
 	catch (Exception e)
{
	out.println(e);
}
%>
</div>
</body>
