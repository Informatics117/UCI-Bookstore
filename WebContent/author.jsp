<jsp:include page="header.jsp" flush="true">
    <jsp:param name="pageName" value="Author"/>
</jsp:include>
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
	<div class="container">
	<%
try{
	
	int author_id = -1;
	out.println("<div class='row'>");
	out.println("<div class='col-sm-4'>");
	try{
		if(request.getParameter("author_id") == null)
		{
			author_id = Integer.parseInt(session.getAttribute("id").toString());
		}
		else
		{
			author_id = Integer.parseInt(request.getParameter("author_id"));
		}
	} catch (Exception e)
	{
		out.println("<label>Invalid Author ID</label>");
	}
	
	if(session.getAttribute("user") == null && session.getAttribute("admin") == null){
		out.println("<label>You are not logged in</label>");
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
		out.println("<label>You are not logged in</label>");
	}
	else
	{
	int id = Integer.parseInt(session.getAttribute("id").toString());
	out.println("<label>You are logged in as "+userName+"</label>");

	out.println("<form method='POST' action='logout.jsp'><input type='hidden' value='true' name='logout'><button type='submit' class='btn btn-default'>Logout</button></form>");
	out.println("</div>");
	out.println("<div class='col-sm-4 col-sm-push-4 text-right'>");
	if(Integer.parseInt(session.getAttribute("id").toString()) == author_id)
	{
	out.println("<form method='POST' action='editprofile.jsp'><input type='hidden' value='"+id+"' name='author_id'><button type='submit' class='btn btn-default admin-logout'>Edit this Page</button></form>");
	}
	}
	}
	}
	out.println("</div>");
	out.println("</div>");
	out.println("<hr>");

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

	out.println("<div class='row'>");

	if (rs == null || !rs.first())
	{
		out.println("<h3>Author could not be found. <h3>");
	}
	else
	{
		if(bioInfo == null || !bioInfo.first())
		{
			out.println("<h3>Author does not have a bio yet.<h3>");
		}
		else
		{
			//Author name
			out.println("<div class='col-sm-4'>");
			out.println("<h2>"+bioInfo.getString(2)+"</h2>");
			out.println("</div>");
			out.println("<div class='col-sm-8'>");
			out.println("<h2>Biography</h2>");
			out.println("</div>");
			out.println("</div>");
			//Picture
			out.println("<div class='row'>");
			out.println("<div class='col-sm-4'>");
			out.println("<img src='"+bioInfo.getString(4)+"' width='75%'/>");
			%>
			
		  <div class="btn-group" role="group" style="width:100%">
		  <a class="twitter-share-button, btn btn-default" href="https://twitter.com/share" type="button" style="width:50%"> Tweet</a>
		  <script>
			window.twttr=(function(d,s,id){
					var js,fjs=d.getElementsByTagName(s)[0],t=window.twttr||{};
					if(d.getElementById(id))return;
					js=d.createElement(s);
					js.id=id;
					js.src="https://platform.twitter.com/widgets.js";
					fjs.parentNode.insertBefore(js,fjs);
					t._e=[];
					t.ready=function(f){
							t._e.push(f);
						};
					return t;
					}(document,"script","twitter-wjs"));
		  </script>
		  
		 <a class="btn btn-default" href="javascript:fbshareCurrentPage()" target="_blank" alt="Share on Facebook" type="button" style="width:50%">Share</a>

		<script language="javascript">
		function fbshareCurrentPage()
		{window.open("https://www.facebook.com/sharer/sharer.php?u="+escape(window.location.href)+"&t="+document.title, '', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=300,width=600');return false; }
		</script>
		</div>
		
		<%
			out.println("</div>");
			//Biography
			out.println("<div class='col-sm-8 bio-scrollable'>");
			out.println("<p>"+bioInfo.getString(3)+"</p>");
			out.println("</div>");
			out.println("</div>");
			
		}
	}
	out.println("<hr>");
	
	String getWorks = "SELECT * FROM contributions JOIN users ON users.id = contributions.user_id WHERE users.id = '"+author_id+"'";
	Statement s1 = connection.createStatement();
	ResultSet rs1 = s1.executeQuery(getWorks);
	
	if(rs1 == null || !rs1.first())
	{
		out.println("This author has not had any works approved. <BR>");
	}
	else
	{
		
	out.println("<div class='row'>");
	out.println("<h2>Works</h2>");
	out.println("</div>");
	out.println("<div class='row'>");
	out.println("<div class='col-sm-3'>");
	out.println("<h3 class='author-header'>Title</h3>");
	out.println("</div>");
	out.println("<div class='col-sm-3'>");
	out.println("<h3 class='author-header'>ISBN</h3>");
	out.println("</div>");
	out.println("<div class='col-sm-3'>");
	out.println("<h3 class='author-header'>Rating</h3>");
	out.println("</div>");
	out.println("<div class='col-sm-3'>");
	out.println("<h3 class='author-header'>Price</h3>");
	out.println("</div>");
	out.println("</div>");
	do
	{
		out.println("<div class='row'>");
		out.println("<div class='col-sm-3'>");
		out.println("<a href = '/Bookstore/book.jsp?book_id="+rs1.getInt(1)+"'>"+ rs1.getString(3) + "</a></td>");
		out.println("</div>");
		out.println("<div class='col-sm-3'>");
		out.println("<p>"+ rs1.getString(4) + "</p>");
		out.println("</div>");
		out.println("<div class='col-sm-3'>");
		out.println("<p>"+ rs1.getInt(5) + "</p>");
		out.println("</div>");
		out.println("<div class='col-sm-3'>");
		out.println("<p>"+ rs1.getDouble(6) + "</p>");
		out.println("</div>");
		out.println("</div>");
		//http://localhost:8080/Bookstore/author.jsp?author_id=1
	} while(rs1.next());
	}
} catch (Exception e)
{
	 System.out.println(e);
}
%>
	</div>
</body>
</html>
