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
 
<script type = "text/javascript">
 function confirmComplete() {
	 var answer=confirm("Are you sure you want to continue?");
	 if (answer==true)
	   {
	     return true;
	   }
	 else
	   {
	     return false;
	   }
	 }
 </script>
 
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
	out.println("</div>");
	}
	
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","testuser","testpass");

	String news = request.getParameter("news");
	if(news != null)
	{
		String query = "INSERT INTO news_feed VALUES (DEFAULT, '" + news + "', CURDATE())";
		Statement submitNews = connection.createStatement();
		submitNews.executeUpdate(query);
		out.println("<font color='red'>News has been submitted.</font>");
	}
	
	String review_id = request.getParameter("review_id");
	String contribution_id = request.getParameter("contribution_id");
	String user_id = request.getParameter("user_id");
	String reject_review = request.getParameter("reject_review");
	String reject_contribution = request.getParameter("reject_contribution");
	String reject_user = request.getParameter("reject_user");
	
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
	else if(reject_review != null && reject_review.length() > 0)
	{
		query = "DELETE FROM pending_reviews WHERE pending_reviews.id = '"+reject_review+"'";
		approval.executeUpdate(query);
		out.print("<p>Review has been rejected and removed.</p>");
	}
	else if(reject_contribution != null && reject_contribution.length() > 0)
	{
		query = "DELETE FROM pending_contributions WHERE id = '"+reject_contribution+"'";
		approval.executeUpdate(query);
		out.print("<p>Contribution has been rejected and removed.</p>");
	}
	else if(reject_user != null && reject_user.length() > 0)
	{
		query = "DELETE from pending_users WHERE id = '"+reject_user+"'";
		approval.executeUpdate(query);
		out.print("<p>User has been rejected and removed.</p>");
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
		out.println("<p class='admin-p'>Review: "+rs.getString(5)+ "</p>");
		out.println("<form method='POST' action='adminpage.jsp'><input type='hidden' value='" + rs.getInt(1) + "' name='review_id'><button type='submit' onclick='{return confirmComplete();}' class='btn btn-default'>Approve Post</button></form>");
		out.println("<form method='POST' action='adminpage.jsp'><input type='hidden' value='" + rs.getInt(1) + "' name='reject_review'><button type='submit' onclick='{return confirmComplete();}' class='btn btn-default'>Reject and Remove Post</button></form>");
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
		out.println("<p class='admin-p'>Rating: "+rs1.getInt(5)+ "</p>");
		out.println("<p class='admin-p'>Price: $"+rs1.getDouble(6)+ "</p>");
		out.println("<p class='admin-p'>Description: "+rs1.getString(7)+ "</p>");
		out.println("<form method='POST' action='adminpage.jsp'><input type='hidden' value='" + rs1.getInt(1) + "' name='contribution_id'><button type='submit' onclick='{return confirmComplete();}' class='btn btn-default'>Approve Contribution</button></form>");
		out.println("<form method='POST' action='adminpage.jsp'><input type='hidden' value='" + rs1.getInt(1) + "' name='reject_contribution'><button type='submit' onclick='{return confirmComplete();}' class='btn btn-default'>Reject and Remove Contribution</button></form>");
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
		out.println("<p class='admin-p'>Email: "+rs2.getString(4)+ "</p>");
		out.println("<p class='admin-p'>Info: "+rs2.getString(6)+ "</p>");
		out.println("<form method='POST' action='adminpage.jsp'><input type='hidden' value='" + rs2.getInt(1) + "' name='user_id'><button type='submit' onclick='{return confirmComplete();}' class='btn btn-default'>Approve User</button></form>");
		out.println("<form method='POST' action='adminpage.jsp'><input type='hidden' value='" + rs2.getInt(1) + "' name='reject_user'><button type='submit' onclick='{return confirmComplete();}' class='btn btn-default'>Reject and Remove User</button></form>");
		out.println("</div>");
		} while(rs2.next());
	}
	out.println("</div>");
	out.println("</div>");
	
	connection.close();
	
%>

<hr>
<form method="GET" action = "adminpage.jsp">
            <div class="form-group">
                <label for="news"></label>
               <textarea name="news" class="form-control" cols="50" rows="5" id="inf" placeholder="Enter news here"></textarea>
            </div>	
	
<% 
out.println("<button type='submit' class='btn btn-primary'>Submit </button>");
out.println("</form>");
	
} catch (Exception e)
{
	 System.out.println(e);
}
%>
		</div>
	</div>
</body>
