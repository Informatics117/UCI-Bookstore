<jsp:include page="header.jsp" flush="true">
<jsp:param name="pageName" value="Results"/>
</jsp:include>

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
<body>
	<div class="container">
	<div class="row">
		<div class="col-sm-4">
			<h4>Search Results</h4>
		</div>
	</div>
	<hr>
<%
try{
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","testuser","testpass");
	
	String book_id = request.getParameter("book_id");
	String book_title = request.getParameter("book_title");
	String isbn = request.getParameter("ISBN_num");
	String first_name = request.getParameter("first_name");
	String last_name = request.getParameter("last_name");
	
	//Builds a query based on the user's input to check against the database.
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
	
	//checks if there is an entry based on the user's query.
	if(rs1 == null || !rs1.first())
	{
		out.println("No Results Found based on your query <BR>");
	}
	else
	{
	//prints out each result with all its given information.
	do
	{
		out.println("<div class='row'>");

		String imageurl = rs1.getString(9);
		
		out.println("<div class='col-sm-4'>");
		out.println("<img src='"+imageurl+"'/ height = '248' width = '200'>");
		out.println("</div>");
		int author_id = rs1.getInt(2);

		out.println("<div class='col-sm-8'>");
		//First Row
		out.println("<div class='row'>");
		out.println("<div class='col-sm-4'>");
		out.println("<p><a href = '/Bookstore/book.jsp?book_id="+rs1.getInt(1)+"'>"+ rs1.getString(3) + "</a></p>");
		out.println("</div>");
		out.println("<div class='col-sm-4'>");
		out.println("<img src='http://www.puz.ca/images/stars-"+rs1.getInt(5)+".gif'/>");
		out.println("</div>");
		out.println("<div class='col-sm-4'>");
		out.println("<p>Publisher: "+rs1.getString(10)+"</p>");
		out.println("</div>");
		out.println("</div>");
		//Second row
		out.println("<div class='row'>");
		out.println("<div class='col-sm-4'>");
		out.println("<p>Written By:</p>");
		out.println("</div>");
		out.println("<div class='col-sm-4'>");
		out.println("<a href = '/Bookstore/author.jsp?author_id="+author_id+"'>"+ rs1.getString(12) + rs1.getString(13) + "</a>");
		out.println("</div>");
		out.println("</div>");
		//Third Row
		out.println("<div class='row'>");
		out.println("<div class='col-sm-4'>");
		out.println("<p>Paperback:</p>");
		out.println("</div>");
		out.println("<div class='col-sm-4'>");
		out.println("<p>"+rs1.getDouble(6)+"</p>");
		out.println("</div>");
		out.println("<div class='col-sm-4'>");
		out.println("<p>Buy Now</p>");
		out.println("</div>");
		out.println("</div>");
		//Fourth Row
		out.println("<div class='row'>");
		out.println("<div class='col-sm-4'>");
		out.println("<p>Hardcover:</p>");
		out.println("</div>");
		out.println("<div class='col-sm-4'>");
		out.println("<p>"+rs1.getDouble(6)+"</p>");
		out.println("</div>");
		out.println("<div class='col-sm-4'>");
		out.println("<p>Buy Now</p>");
		out.println("</div>");
		out.println("</div>");

		out.println("</div>");
		out.println("</div>");

		
		//out.println("<td><a href = '/Bookstore/author.jsp?author_id="+author_id+"'>" + rs1.getString(9) + " " + rs1.getString(10) + "</a></td>");
		out.println("<hr>");
	} while(rs1.next());
	}
	
	connection.close();
	
} catch (Exception e)
{
	 System.out.println(e);
}
out.println("</div>");

%>
	</div>
</body>
