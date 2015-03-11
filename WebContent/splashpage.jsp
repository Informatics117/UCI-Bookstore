<jsp:include page="header.jsp" flush="true">
    <jsp:param name="pageName" value="Front Page"/>
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
<head>

  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
  <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
  <style>
  .carousel-inner { 
  	padding-bottom: 120px; 
  }
  .carousel-caption { 
	bottom:-100px; 
  }
  .carousel-inner > .item > img,
  .carousel-inner > .item > a > img {
      width: 25%;
      margin: auto;
      height: 350px;
  }
  .carousel-indicator {
  	padding-top: 100px;
  }
  .carousel-indicators li {
  	background-color: black;
  }
  .carousel-control.left {
  	background-image: none;
  }
  .carousel-control.right {
  	background-image: none;
  }
  td:nth-child(2) {
    padding-right: 20px;
}​​
  </style>

</head>
<body>
	<div class="container">
		<br>

		<div id="myCarousel" class="carousel slide" data-ride="carousel">
			<!-- Indicators -->
			<ol class="carousel-indicators">
				<li data-target="#myCarousel" data-slide-to="0" class="active"></li>
				<li data-target="#myCarousel" data-slide-to="1"></li>
				<li data-target="#myCarousel" data-slide-to="2"></li>
				<li data-target="#myCarousel" data-slide-to="3"></li>
				<li data-target="#myCarousel" data-slide-to="4"></li>
			</ol>

			<!-- Wrapper for slides -->
			<div class="carousel-inner" role="listbox">
				<div class="item active">

					<%
try{
	String email = request.getParameter("username");
	String password = request.getParameter("password");
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","testuser","testpass");
	
	Statement s1 = connection.createStatement();
	ResultSet rs1 = s1.executeQuery("SELECT * from contributions JOIN users on users.id = contributions.user_id ORDER BY ts DESC LIMIT 5");
	
	if(rs1 == null || !rs1.first())
	{
		out.println("<h4>No recent contributions. </h4>");
	}
	else
	{
			out.println("<a href = '/Bookstore/book.jsp?book_id="+rs1.getInt(1)+"'>");
			out.println("<img src='"+rs1.getString(9)+"' height = '248' width = '300'> </a>");
			out.println("<div class='carousel-caption'>");
			out.println("<h3> <font color = 'black'>" + rs1.getString(3) + " </font></h3>");
			out.println("<p> <font color = 'black'> By: " + rs1.getString(12) + " " + rs1.getString(13) 
					+ "</font></p>");
			out.println("</div>");
			out.println("</div>");
			
			while(rs1.next())
			{
				//change the div from item active to item
				out.println("<div class='item'>");
				out.println("<a href = '/Bookstore/book.jsp?book_id="+rs1.getInt(1)+"'>");
				out.println("<img src='"+rs1.getString(9)+"' height = '248' width = '300'></a>");
				out.println("<div class='carousel-caption'>");
				out.println("<h3> <font color = 'black'>" + rs1.getString(3) + " </font></h3>");
				out.println("<p> <font color = 'black'> By: " + rs1.getString(12) + " " + rs1.getString(13) 
						+ "</font></p>");
				out.println("</div>");
				out.println("</div>");
			}
	}	
	out.println("</div>");
	
%>
</div>
</div>
</div>
</div>
<hr>
<div class = "container">
<div class='row'>
<div class="col-sm-6">
	<h3>Recent Reviews</h3>
<div id="myCarousel1" class="carousel slide" data-interval="false">
	<div class="carousel-inner">
		<div class="item active">

<%	
	Statement s = connection.createStatement();
	ResultSet rs = s.executeQuery("SELECT * from reviews JOIN contributions on contributions.id = reviews.contribution_id ORDER BY reviews.ts DESC LIMIT 5");
	
	if(rs == null || !rs.first())
	{
		out.println("<h4>No recent reviews. </h4>");
	}
	else
	{
			out.println("<p class='admin-p text-center carousel-review-link'><a href = '/Bookstore/book.jsp?book_id="+rs.getInt(4)+"'>"+ rs.getString(9) + "</a></p>");
			out.println("<p class='admin-p carousel-text'>"+rs.getString(5) + "</p>");
			out.println("</div>");
		while(rs.next()) {
			out.println("<div class='item'>");
			out.println("<p class='admin-p  text-center carousel-review-link'><a href = '/Bookstore/book.jsp?book_id="+rs.getInt(4)+"'>"+ rs.getString(9) + "</a></p>");
			out.println("<p class='admin-p carousel-text'>"+rs.getString(5) + "</p>");
			out.println("</div>");
		} 
	}	
%>
	</div>
	<!-- Controls -->
	<a class="left carousel-control" href="#myCarousel1" role="button" data-slide="prev">
			<span class="glyphicon glyphicon-circle-arrow-left"></span>
	</a>

	<a class="right carousel-control" href="#myCarousel1" role="button" data-slide="next">
			<span class="glyphicon glyphicon-circle-arrow-right"></span>
	</a>
</div>
</div>
<div class="col-sm-6">
<h3>News Feed</h3>
<%
	Statement statement = connection.createStatement();
	ResultSet result = statement.executeQuery("SELECT * from news_feed ORDER BY id DESC LIMIT 3");

	if (result == null || !result.first()) {
			out.println("<h4> There are no news to show right now. </h4>");
	} else {
			out.println("<table>");
			do {
				out.println("<tr>");
				out.println("<td>" + result.getString(3) + "</td>"); 
				out.println("<td></td>");
				out.println("<td>" + result.getString(2) + "</td>");
				out.println("<tr>");
			}while(result.next());
			
			out.println("</table>");
	}
} catch (Exception e) {
		out.println(e);
}
%>
</div>
</div>
</div>

<br>
<br>
<br>

<hr>
</body>