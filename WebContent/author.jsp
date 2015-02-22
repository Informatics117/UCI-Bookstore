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
try{
	
	int author_id = 0;
	try{
		author_id = Integer.parseInt(request.getParameter("author_id"));
	} catch (Exception e)
	{
		out.println("Invalid Author ID");
	}
	
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
	int id = Integer.parseInt(session.getAttribute("id").toString());
	out.println("You are logged in as "+userName);
	out.println("<form method='POST' action='logout.jsp'><input type='hidden' value='true' name='logout'><button type='submit' class='btn btn-default'>Logout</button></form>");
	if(Integer.parseInt(session.getAttribute("id").toString()) == author_id)
	{
	out.println("<form method='POST' action='editprofile.jsp'><input type='hidden' value='"+id+"' name='author_id'><button type='submit' class='btn btn-default'>Edit this Page</button></form>");
	}
	}
	}
	}
%>

	<%-- JAVA CODE TO DISPLAY AUTHOR PAGE. --%>
	<%
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","testuser","testpass");
	
	String getAuthor = "SELECT * FROM biography WHERE user_id = '"+author_id+"'";
	Statement s = connection.createStatement();
	ResultSet rs = s.executeQuery(getAuthor);

	Statement getBiography = connection.createStatement();
	ResultSet bioInfo = getBiography.executeQuery("SELECT * FROM biography JOIN users on biography.user_id = users.id WHERE biography.user_id = '"+author_id+"'"); 
	
	if (rs == null || !rs.first())
	{
		out.println("Author could not be found. <BR>");
	}
	else
	{
		if(bioInfo == null || !bioInfo.first())
		{
			out.println("Author does not have a bio yet.");
		}
		else
		{
			out.println("photoURL: " + bioInfo.getString(4) + "<BR>");
			out.println("Author Name: " + bioInfo.getString(2) + "<BR>");
			out.println("Biography: " + bioInfo.getString(3) + "<BR>");
			
		}
	}
	
	String getWorks = "SELECT * FROM contributions JOIN users ON users.id = contributions.user_id WHERE users.id = '"+author_id+"'";
	Statement s1 = connection.createStatement();
	ResultSet rs1 = s1.executeQuery(getWorks);
	
	if(rs1 == null || !rs1.first())
	{
		out.println("This author has not had any works approved. <BR>");
	}
	else
	{
		
	out.println("<table><tr>");
	out.println("<tr><td>BOOK ID</td><td>BOOK Title</td><td>ISBN Number</td><td>Rating</td><td>Price</td><td>Description</td></tr>");
	do
	{
		out.println("</tr>");
		out.println("<td>"+ rs1.getInt(1) + "</td>");
		out.println("<td><a href = '/Bookstore/book.jsp?book_id="+rs1.getInt(1)+"'>"+ rs1.getString(3) + "</a></td>");
		out.println("<td>"+ rs1.getString(4) + "</td>");
		out.println("<td>"+ rs1.getInt(5) + "</td>");
		out.println("<td>"+ rs1.getDouble(6) + "</td>");
		out.println("<td>"+ rs1.getString(7)+ "</td>");
		out.println("</tr>");
		
		//http://localhost:8080/Bookstore/author.jsp?author_id=1
	} while(rs1.next());
	
	out.println("</table>");
	
	}
} catch (Exception e)
{
	 System.out.println(e);
}
%>

</body>
</html>
