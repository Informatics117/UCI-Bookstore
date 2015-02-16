<%-- REQUIRED JAVA IMPORTS --%>
<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"%>
 
 <%-- JAVA CODE HERE: WILL DISPLAY RESULTS OF USER'S QUERY --%>
<%-- 
	REQUIREMENTS: if user is not an administrator, the page will only display regular functions.
	If user is an administrator, the administrator will have the option to delete or possibly edit book information.
--%>

<%
try{
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","testuser","testpass");
	
	String book_id = request.getParameter("book_id");
	String book_title = request.getParameter("book_title");
	String isbn = request.getParameter("ISBN_num");
	String first_name = request.getParameter("first_name");
	String last_name = request.getParameter("last_name");
	
	String queryBuilder = "SELECT * FROM contributions JOIN users on users.id = contributions.user_id ";
	
	if(book_id.length() > 0)
		queryBuilder += "WHERE contributions.id LIKE '%"+book_id+"%' ";
	
	if(book_title.length() > 0)
		queryBuilder += "AND contributions.contribution_name LIKE '%"+book_title+"%' ";
	
	if(isbn.length() > 0)
		queryBuilder += "AND contributions.isbn_num LIKE '%"+isbn+"%' ";
	
	if(first_name.length() > 0)
		queryBuilder += "AND users.first_name LIKE '%"+first_name+"%' ";
	
	if(last_name.length() > 0)
		queryBuilder += "AND users.last_name LIKE '%"+last_name+"%'";
	
	Statement s1 = connection.createStatement();
	ResultSet rs1 = s1.executeQuery(queryBuilder);
	
	if(rs1 == null || !rs1.first())
	{
		out.println("No Results Found based on your query <BR>");
	}
	else
	{

	out.println("<table><tr>");
	out.println("<tr><td>BOOK ID</td><td>Author Name</td><td>BOOK Title</td><td>ISBN Number</td><td>Rating</td><td>Price</td><td>Description</td></tr>");
	while(rs1.next())
	{
		int author_id = rs1.getInt(8);
		
		
		out.println("</tr>");
		out.println("<td>"+ rs1.getInt(1) + "</td>");
		out.println("<td><a href = '/Bookstore/author.jsp?author_id="+author_id+"'>" + rs1.getString(9) + " " + rs1.getString(10) + "</a></td>");
		out.println("<td>"+ rs1.getString(3) + "</td>");
		out.println("<td>"+ rs1.getString(4) + "</td>");
		out.println("<td>"+ rs1.getInt(5) + "</td>");
		out.println("<td>"+ rs1.getDouble(6) + "</td>");
		out.println("<td>"+ rs1.getString(7)+ "</td>");
		out.println("</tr>");
	}
	
	out.println("</table>");
	}
} catch (Exception e)
{
	 System.out.println(e);
}
%>