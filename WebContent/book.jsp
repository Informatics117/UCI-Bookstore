<jsp:include page="header.jsp" flush="true">
    <jsp:param name="pageName" value="Book"/>
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

<%-- JAVA CODE TO DISPLAY AUTHOR PAGE. --%>
<%
try{
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","testuser","testpass");
	
	int book_id = 0;
	try{
		book_id = Integer.parseInt(request.getParameter("book_id"));
	} catch (Exception e)
	{
		out.println("<h2>Invalid Author ID</h2>");
	}
	
	String getBook = "SELECT * FROM contributions JOIN users on users.id = contributions.user_id where contributions.id = '"+book_id+"'";
	Statement s = connection.createStatement();
	ResultSet rs = s.executeQuery(getBook);
	
	if(rs == null || !rs.first())
	{
		out.println("<h2>Book could not be found.</h2>");
	}
	else
	{
		String imageurl = rs.getString(9);
		out.println("<div class='row'>");
		out.println("<div class='col-sm-6'>");
		out.println("<img src='"+imageurl+"'/ height = '248' width = '200'>");
		out.println("</div>");
		out.println("<div class='col-sm-6'>");
		out.println("<h2>"+rs.getString(3)+ "</h2>");
		out.println("<h4>by "+"<a href = '/Bookstore/author.jsp?author_id="+rs.getInt(2)+"'> "+ rs.getString(12) + " " + rs.getString(13) + "</a></h4>");
		out.println("<h5>ISBN number: "+rs.getInt(4)+ "</h5>");
		out.println("<h5>Price: "+rs.getDouble(6)+ "</h5>");
		out.println("</div>");
		out.println("</div>");
		out.println("<hr>");
		out.println("<h5><b>Summary: </b></h5>");
//		out.println("<div class='row'>");
		out.println(rs.getString(7));
//		out.println("</div>");
	}

	Statement s1 = connection.createStatement();
	ResultSet rs1 = s1.executeQuery("SELECT * FROM reviews JOIN contributions on contributions.id = reviews.contribution_id WHERE contributions.id = '"+book_id+"'");
	
	out.println("<hr>");
	
	if(rs1 == null || !rs1.first())
	{
		out.println("No Reviews found for this book");
	}
	else
	{
		out.println("<b> Reviews: </b>");
		do
		{
			out.println("<div class='row'>");
			out.println("<div class='col-sm-3'>");
			out.println("<p>Poster ID: "+rs1.getInt(3)+ "</p>");
			out.println("</div>");
			out.println("<div class='col-sm-9'>");
			out.println("<p>" + rs1.getString(5)+ "</p>");
			out.println("</div>");
			out.println("</div>");
		}
		while(rs1.next());
	}
	
} catch (Exception e)
{
	 System.out.println(e);
}
%>
	</div>
</body>
</html>
