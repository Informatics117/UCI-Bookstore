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

<%
	if(session.getAttribute("user") == null && session.getAttribute("admin") == null){
		out.println("You are not logged in<BR>");
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
		out.println("You are not logged in<BR>");
	}
	else
	{
	out.println("You are logged in as "+userName);
	out.println("<form method='POST' action='logout.jsp'><input type='hidden' value='true' name='logout'><button type='submit' class='btn btn-default'>Logout</button></form>");
	}
	}
	}
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
		out.println("Invalid Author ID");
	}
	
	String getBook = "SELECT * FROM contributions JOIN users on users.id = contributions.user_id where contributions.id = '"+book_id+"'";
	Statement s = connection.createStatement();
	ResultSet rs = s.executeQuery(getBook);
	
	if(rs == null || !rs.first())
	{
		out.println("Book could not be found.");
	}
	else
	{
		out.println("Book Title: "+rs.getString(3)+ "<BR>");
		out.println("Author: "+"<a href = '/Bookstore/author.jsp?author_id="+rs.getInt(2)+"'>"+ rs.getString(9) + rs.getString(10) + "</a><BR>");
		out.println("ISBN number: "+rs.getInt(4)+ "<BR>");
		out.println("Price: "+rs.getDouble(6)+ "<BR>");
		out.println("Description: "+rs.getString(7)+ "<BR>");
	}

	Statement s1 = connection.createStatement();
	ResultSet rs1 = s1.executeQuery("SELECT * FROM reviews JOIN contributions on contributions.id = reviews.contribution_id WHERE contributions.id = '"+book_id+"'");
	
	out.println("-------------------------<BR>");
	
	if(rs1 == null || !rs1.first())
	{
		out.println("No Reviews found for this book");
	}
	else
	{
		out.println("Poster ID: "+rs1.getInt(3)+ "<BR>");
		out.println("Review: "+rs1.getString(4)+ "<BR>");
	}
	
} catch (Exception e)
{
	 System.out.println(e);
}
%>

</body>
</html>
