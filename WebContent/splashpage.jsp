<%-- REQUIRED JAVA IMPORTS --%>
<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"%>

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

<%
try{
	String email = request.getParameter("username");
	String password = request.getParameter("password");
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","testuser","testpass");
	
	Statement s1 = connection.createStatement();
	ResultSet rs1 = s1.executeQuery("SELECT * from contributions JOIN users on users.id = contributions.user_id ORDER BY ts DESC LIMIT 5");
	
	out.println("Recent Contributions<BR>");
	if(rs1 == null || !rs1.first())
	{
		out.println("No recent reviews. <BR>");
	}
	else
	{
		do{
			
			out.println("Book Title: <a href = '/Bookstore/book.jsp?book_id="+rs1.getInt(1)+"'>"+ rs1.getString(3) + "</a><BR>");
			out.println("Written by: <a href = '/Bookstore/book.jsp?book_id="+rs1.getInt(2)+"'>"+rs1.getString(10) + " " + rs1.getString(11) + "</a><BR>");
			
			
			
		} while(rs1.next());
	}	
	
	out.println("----------------------------<BR>");
	Statement s = connection.createStatement();
	ResultSet rs = s.executeQuery("SELECT * from reviews JOIN contributions on contributions.id = reviews.contribution_id ORDER BY reviews.ts DESC LIMIT 5");
	
	out.println("Recent Reviews<BR>");
	if(rs == null || !rs.first())
	{
		out.println("No recent reviews. <BR>");
	}
	else
	{
		do{
			
			out.println("Book Title: <a href = '/Bookstore/book.jsp?book_id="+rs.getInt(4)+"'>"+ rs.getString(9) + "</a><BR>");
			out.println("Review: "+rs.getString(5) + "<BR>");
			
		} while(rs.next());
	}	
	
	
}
 	catch (Exception e)
{
	out.println(e);
}
%>
