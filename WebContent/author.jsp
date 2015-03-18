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
	//A redirect where normally the "my page" button on the navbar would send you to the authors page
	//But if you're an admin, it'll send you to the admin control panel page
	if(session.getAttribute("admin") != null)
	{
		response.setHeader("Refresh", "0;url=/Bookstore/adminpage.jsp");
	}
	//Grab the author's id and store it
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
	}
	//Grabbing the cookie to keep the same information if a user is logged in
	if(session.getAttribute("user") == null && session.getAttribute("admin") == null){
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
	}
	else
	{
	int id = Integer.parseInt(session.getAttribute("id").toString());

	out.println("</div>");
	out.println("<div class='col-sm-4 col-sm-push-4 text-right'>");
	//If the user is the same as the id of the current author's page, then display
	//the edit page button
	if(Integer.parseInt(session.getAttribute("id").toString()) == author_id)
	{
	out.println("<form method='POST' action='editprofile.jsp'><input type='hidden' value='"+id+"' name='author_id'><button type='submit' class='btn btn-default admin-logout'>Edit this Page</button></form>");
	}
	}
	}
	}
	out.println("</div>");
	out.println("</div>");

%>

	<%-- JAVA CODE TO DISPLAY AUTHOR PAGE. --%>
	<%
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","root","2840121");
	
	//Connect to the database and grab the biography information for the author
	String getAuthor = "SELECT * FROM biography WHERE user_id = '"+author_id+"'";
	Statement s = connection.createStatement();
	ResultSet rs = s.executeQuery(getAuthor);

	Statement getBiography = connection.createStatement();
	ResultSet bioInfo = getBiography.executeQuery("SELECT * FROM biography JOIN users on biography.user_id = users.id WHERE biography.user_id = '"+author_id+"'"); 

	out.println("<div class='row'>");

	//Error checks, if the aturho doesn't exist, then no author found, but if bio doesn't exist, then no bio yet
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
			//Picture and social media buttons below the picture
			out.println("<div class='row'>");
			out.println("<div class='col-sm-4'>");
			out.println("<img src='"+bioInfo.getString(4)+"' width='75%'/>");
			%>
			<!-- Intended blank space (paragraph) so picture doesn't cover border -->
			<p> </p>
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
			//Biography text
			out.println("<div class='col-sm-8 bio-scrollable'>");
			out.println("<p>"+bioInfo.getString(3)+"</p>");
			out.println("</div>");
			out.println("</div>");
			
		}
	}
	out.println("<hr>");
	
	//Grab the works that the author created from the table
	String getWorks = "SELECT * FROM contributions JOIN users ON users.id = contributions.user_id WHERE users.id = '"+author_id+"'";
	Statement s1 = connection.createStatement();
	ResultSet rs1 = s1.executeQuery(getWorks);
	
	if(rs1 == null || !rs1.first())
	{
		out.println("This author has not had any works approved. <BR>");
	}
	else
	{
	//If the works exist, then display them using the information associated with each work	
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
	
	connection.close();
	
} catch (Exception e)
{
	
}
%>
	</div>
</body>
</html>
