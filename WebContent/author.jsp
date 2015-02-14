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

<%-- JAVA CODE TO DISPLAY AUTHOR PAGE. --%>
<%
try{
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "authorsdb","testuser","testpass");
	
	int author_id = 0;
	try{
		author_id = Integer.parseInt(request.getParameter("author_id"));
	} catch (Exception e)
	{
		out.println("Invalid Author ID");
	}
	
	String getAuthor = "SELECT * FROM users where users.id = '"+author_id+"'";
	Statement s = connection.createStatement();
	ResultSet rs = s.executeQuery(getAuthor);

	if (rs == null || !rs.first())
	{
		out.println("Author could not be found. <BR>");
	}
	else
	{
		out.println("Author Name: " + rs.getString(2) + " " + rs.getString(3) + "<BR>");
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
	while(rs1.next())
	{
		out.println("</tr>");
		out.println("<td>"+ rs1.getInt(1) + "</td>");
		out.println("<td>"+ rs1.getString(3) + "</td>");
		out.println("<td>"+ rs1.getString(4) + "</td>");
		out.println("<td>"+ rs1.getInt(5) + "</td>");
		out.println("<td>"+ rs1.getDouble(6) + "</td>");
		out.println("<td>"+ rs1.getString(7)+ "</td>");
		out.println("</tr>");
		
		//http://localhost:8080/Bookstore/author.jsp?author_id=1
	}
	
	out.println("</table>");
	
	}
} catch (Exception e)
{
	 System.out.println(e);
}
%>

</body>
</html>
