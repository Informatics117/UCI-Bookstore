<jsp:include page="header.jsp" flush="true">
<jsp:param name="pageName" value="Search"/>
</jsp:include>

<%-- REQUIRED JAVA IMPORTS --%>
<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"%>



<%-- CONTRIBUTION SUBMISSION PAGE --%>
<form action = "/Bookstore/submit.jsp" METHOD="POST">

<%
if(session.getAttribute("admin") != null)
{
	out.println("AUTHOR's ID*: <INPUT TYPE='TEXT' NAME='user_id' id='user_id'><BR>");
}
%>

	Book Title*: <INPUT TYPE="TEXT" NAME="book_title" id="book_title"><BR> 
	ISBN Number*: <INPUT TYPE="TEXT" NAME="ISBN_num" id="ISBN_num"><BR> 
	Book Price (must be a valid price e.g. 11.99)*: <INPUT TYPE="TEXT" NAME="book_price" id="book_price"><BR>
	Photo URL*:  <INPUT TYPE="TEXT" NAME="photo_url" id="photo_url"><BR>
	Publisher*: <INPUT TYPE="TEXT" NAME="publisher" id="publisher"><BR>
	Description*: <textarea class="form-control" cols="50" rows="5" NAME = "description" id="description"></textarea><BR>
	
	<INPUT TYPE="SUBMIT" VALUE="submit contribution" NAME="contribution">
</FORM>

<%-- CONTRIBUTION SUBMISSION PAGE --%>

<%
if(request.getParameter("contribution") != null)
{
	String user_id = "";
	int id = 0;
	try{
		if(session.getAttribute("admin") != null)
		{
			user_id = request.getParameter("user_id");
		}
		else if(session.getAttribute("id") != null)
		{
			id = Integer.parseInt(session.getAttribute("id").toString());
		}
		else
		{
			response.sendRedirect("/Bookstore/redirect.jsp?message=You need to login before you can make a contribution.");
		}
		String book_title = request.getParameter("book_title");
		String ISBN_num = request.getParameter("ISBN_num");
		String book_price = request.getParameter("book_price");
		String photo_url = request.getParameter("photo_url");
		String publisher = request.getParameter("publisher");
		String description = request.getParameter("description");
		
		description = description.replaceAll("'", "''");
		
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","testuser","testpass");

	
		Statement s = connection.createStatement();
		
		
		if(session.getAttribute("admin") != null)
		{
			String query = "CALL submit_and_approve('"+user_id+"', '"+book_title+"', '"+ISBN_num+"', '"+book_price+"', '"+description+"', '"+photo_url+"', '"+publisher+"')";
			System.out.println(query);
			s.executeUpdate(query);
			out.println("Contribution has been added and approved.");
		}
		else
		{
			String query = "CALL submit_contribution('"+id+"', '"+book_title+"', '"+ISBN_num+"', '"+book_price+"', '"+description+"', '"+photo_url+"', '"+publisher+"')";
			System.out.println(query);
			s.executeUpdate(query);
			out.println("Contribution has been added and is pending approval");
		}
		
		connection.close();
	} catch (Exception e)
	{
		//out.println(e.toString());
		out.println("Check your submission: You either have an invalid price, or have entered an empty field.");
	}
}
%>