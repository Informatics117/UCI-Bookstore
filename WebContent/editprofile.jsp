<%-- REQUIRED JAVA IMPORTS --%>
<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"%>

<%
try{
	
	int id = 0;
	try
	{
		id = Integer.parseInt(session.getAttribute("id").toString());
	} catch (Exception e)
	{
		out.println("You are not logged in<BR>");
		response.sendRedirect("/Bookstore/redirect.jsp?message=You do not have access to this page!");
	}
	
	if((session.getAttribute("user") == null && session.getAttribute("admin") == null) || id != Integer.parseInt(request.getParameter("author_id")) ){
		response.sendRedirect("/Bookstore/redirect.jsp?message=You do not have access to this page!");
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
	out.println("You are logged in as "+userName+"<BR>");
	out.println("<a href = '/Bookstore/author.jsp?author_id="+id+"'>Return to Profile</a>");
	out.println("<form method='POST' action='logout.jsp'><input type='hidden' value='true' name='logout'><button type='submit' class='btn btn-default'>Logout</button></form>");
	}
	}
	}
%>

<%
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","testuser","testpass");
	
	String edit = request.getParameter("edit");

	if(edit!=null)
	{
	String query;
	Statement edits = connection.createStatement();
	
	String photo_url = request.getParameter("photo_url");
	String display_name = request.getParameter("display_name");
	String info = request.getParameter("info");
	
	if(edit.length() > 0)
	{
		query = "CALL edit_bio('"+id+"','"+photo_url+"','"+display_name+"','"+info+"')";
		edits.executeUpdate(query);
		out.println("Changes have been made.");
	}
	}
	
	int author_id = 0;
	try{
		author_id = Integer.parseInt(request.getParameter("author_id"));
	} catch (Exception e)
	{
		out.println("Invalid Author ID");
	}
	
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
			out.println("<form method='POST'>");
			//photo url
			out.println("<div class='form-group'>");
			out.println("<label for='last'>Photo URL*: </label>");
			out.println("<input type='text' class='form-control' name='photo_url' id='photo_url' value = '"+bioInfo.getString(4)+"'>");
			out.println("</div>");
		
			//name
			out.println("<div class='form-group'>");
			out.println("<label for='last'>Display Name*: </label>");
			out.println("<input type='text' class='form-control' name='display_name' id='display_name' value = '"+bioInfo.getString(2)+"' >");
			out.println("</div>");
			
			out.println("<input type='hidden' name='author_id' value='"+author_id+"'>");
			
			//biography
			out.println("<div class='form-group'>");
			out.println("<label for='inf'>More Info*: </label>");
			out.println("<textarea name='info' class='form-control' cols='50' rows='5' id='info' placeholder='No text'>"+bioInfo.getString(3)+"</textarea>");
			out.println("</div>");
			out.println("<button type='submit' value = 'true' name = 'edit' class='btn btn-default'>Make Changes</button>");
			out.println("</form>");
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