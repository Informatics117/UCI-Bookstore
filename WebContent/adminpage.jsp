<jsp:include page="header.jsp" flush="true">
    <jsp:param name="pageName" value="Admin"/>
</jsp:include>

<%-- to do: check if user is an admin, otherwise redirect them to main page. --%>

<%-- REQUIRED JAVA IMPORTS --%>
<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"%>
 
 <%-- Java code to collect variables. --%>
<body>
	<div class="container">
<%
try{
	
	if(session.getAttribute("admin") == null){
		response.sendRedirect("/Bookstore/redirect.jsp?message=You are not an admin!");
	}
	String userName = null;
	String sessionID = null;
	Cookie[] cookies = request.getCookies();
	if(cookies !=null){
	for(Cookie cookie : cookies){
	    if(cookie.getName().equals("admin")) userName = cookie.getValue();
	}
	out.println("<div class='row'>");
	out.println("<div class='col-sm-4'>");
	out.println("Welcome, "+userName);
	out.println("<form method='POST' action='logout.jsp'><input type='hidden' value='true' name='logout'><button type='submit' class='btn btn-default'>Logout</button></form>");
	out.println("</div>");
	}
	
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","testuser","testpass");

	
	String review_id = request.getParameter("review_id");
	String contribution_id = request.getParameter("contribution_id");
	String user_id = request.getParameter("user_id");
	
	String query;
	Statement approval = connection.createStatement();
	
	out.println("<div class='col-sm-4'>");
	if(review_id != null && review_id.length() > 0)
	{
		query = "CALL approve_review("+review_id+")";
		approval.executeUpdate(query);
		out.print("<p>Review has been approved.</p>");
	}
	else if(contribution_id != null && contribution_id.length() > 0)
	{
		query = "CALL approve_contribution("+contribution_id+")";
		approval.executeUpdate(query);
		out.print("<p>Contribution has been approved.</p>");
	}
	else if(user_id != null && user_id.length() > 0)
	{
		query = "CALL approve_user("+user_id+")";
		approval.executeUpdate(query);
		out.print("<p>User has been approved.</p>");
	}
	out.println("</div>");
	out.println("</div>");
	out.println("<hr>");
	out.println("<div class='col-sm-12'>");
//-- Java code to display unapproved things. Divded with dividers. --
	
	Statement s = connection.createStatement();
	ResultSet rs = s.executeQuery("SELECT * FROM pending_reviews");
	out.println("<div class='row'>");
	out.println("<div class='col-sm-4 scrollable'>");
	out.println("<p>Pending Reviews</p>");
	if(rs == null || !rs.first())
	{
		out.println("<div class='row'>");
		out.println("<p>No pending reviews</p>");
		out.println("</div>");
	}
	else
	{
		do
		{
		out.println("<div class='row admin-row'>");
		out.println("<p class='admin-p'>Poster ID: "+rs.getInt(3)+ "</p>");
		out.println("<p class='admin-p'>Review: "+rs.getString(4)+ "</p>");
		out.println("<form method='POST' action='adminpage.jsp'><input type='hidden' value='" + rs.getInt(1) + "' name='review_id'><button type='submit' class='btn btn-default'>Approve Post</button></form>");
		out.println("</div>");
		} while(rs.next());
	}
	out.println("</div>");
	//<--Divider-->
	out.println("<div class='row'>");
	out.println("<div class='col-sm-4 scrollable'>");
	out.println("<p>Pending Contributions</p>");
	
	Statement s1 = connection.createStatement();
	ResultSet rs1 = s1.executeQuery("SELECT * FROM pending_contributions");
	if(rs1 == null || !rs1.first())
	{
		out.println("<div class='row'>");
		out.println("<p>No pending contributions</p>");
		out.println("</div>");
	}
	else
	{
		do
		{
		out.println("<div class='row admin-row'>");
		out.println("<p class='admin-p'>Author ID: "+rs1.getInt(2)+ "</p>");
		out.println("<p class='admin-p'>Contribution name: "+rs1.getString(3)+ "</p>");
		out.println("<p class='admin-p'>ISBN number: "+rs1.getInt(4)+ "</p>");
		out.println("<p class='admin-p'>Price: "+rs1.getDouble(5)+ "</p>");
		out.println("<p class='admin-p'>Description: "+rs1.getString(6)+ "</p>");
		out.println("<form method='POST' action='adminpage.jsp'><input type='hidden' value='" + rs1.getInt(1) + "' name='contribution_id'><button type='submit' class='btn btn-default'>Approve Contribution</button></form>");
		out.println("</div>");
		} while(rs1.next());
		
	}
	out.println("</div>");
	//<--Divider-->
	out.println("<div class='row'>");
	out.println("<div class='col-sm-4 scrollable'>");
	out.println("<p>Pending Users</p>");

	Statement s2 = connection.createStatement();
	ResultSet rs2 = s2.executeQuery("SELECT * FROM pending_users");
	if(rs2 == null || !rs2.first())
	{
		out.println("<div class='row'>");
		out.println("No pending users");
		out.println("</div>");
	}
	else
	{
		do
		{
		out.println("<div class='row'>");
		out.println("<p class='admin-p'>First Name: "+rs2.getString(2)+ "</p>");
		out.println("<p class='admin-p'>Last Name: "+rs2.getString(3)+ "</p>");
		out.println("<p class='admin-p'>Info: "+rs2.getString(6)+ "</p>");
		out.println("<form method='POST' action='adminpage.jsp'><input type='hidden' value='" + rs2.getInt(1) + "' name='user_id'><button type='submit' class='btn btn-default'>Approve User</button></form>");
		out.println("</div>");
		} while(rs2.next());
	}
	out.println("</div>");
	out.println("</div>");
	
} catch (Exception e)
{
	 System.out.println(e);
}
%>
		</div>
	</div>
</body>