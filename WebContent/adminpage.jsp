<%-- to do: check if user is an admin, otherwise redirect them to main page. --%>

<%-- REQUIRED JAVA IMPORTS --%>
<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"%>
 
 <%-- Java code to collect variables. --%>
 
 
<%-- Java code to display unapproved things. Divded with dividers. --%>
<%
try{
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","testuser","testpass");
	
	Statement s = connection.createStatement();
	ResultSet rs = s.executeQuery("SELECT * FROM pending_reviews");
	
	out.println("<BR>-------------------------<BR>");

	if(rs == null || !rs.first())
	{
		out.println("No pending reviews");
	}
	else
	{
		out.println("Poster ID: "+rs.getInt(3)+ "<BR>");
		out.println("Review: "+rs.getString(4)+ "<BR>");
		out.println("<form method='POST' action='adminpage.jsp'><input type='hidden' value='" + rs.getInt(1) + "' name='review_id'><button type='submit' class='btn btn-default'>Approve Post</button></form>");
	}
	
	//<--Divider-->
	out.println("<BR>-------------------------<BR>");
	
	Statement s1 = connection.createStatement();
	ResultSet rs1 = s1.executeQuery("SELECT * FROM pending_contributions");
	if(rs1 == null || !rs1.first())
	{
		out.println("No pending contributions");
	}
	else
	{
		out.println("Author ID: "+rs1.getInt(2)+ "<BR>");
		out.println("Contribution name: "+rs1.getString(3)+ "<BR>");
		out.println("ISBN number: "+rs1.getInt(4)+ "<BR>");
		out.println("Price: "+rs1.getDouble(5)+ "<BR>");
		out.println("Description: "+rs1.getString(6)+ "<BR>");
		out.println("<form method='POST' action='adminpage.jsp'><input type='hidden' value='" + rs1.getInt(1) + "' name='contribution_id'><button type='submit' class='btn btn-default'>Approve Contribution</button></form>");
	}
	
	//<--Divider-->
	out.println("-------------------------<BR>");

	Statement s2 = connection.createStatement();
	ResultSet rs2 = s2.executeQuery("SELECT * FROM pending_users");
	if(rs2 == null || !rs2.first())
	{
		out.println("No pending users");
	}
	else
	{
		out.println("First Name: "+rs2.getString(2)+ "<BR>");
		out.println("Last Name: "+rs2.getString(3)+ "<BR>");
		out.println("Info: "+rs2.getString(6)+ "<BR>");
		out.println("<form method='POST' action='adminpage.jsp'><input type='hidden' value='" + rs2.getInt(1) + "' name='user_id'><button type='submit' class='btn btn-default'>Approve User</button></form>");
	}
	
} catch (Exception e)
{
	 System.out.println(e);
}
%>
