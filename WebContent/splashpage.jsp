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
  .carousel-inner > .item > img,
  .carousel-inner > .item > a > img {
      width: 25%;
      margin: auto;
      height: 350px;
  }
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

<hr>
<div class='row'>
	<h4>Recent Reviews</h4>
</div>
<div class="container">
<div id="myCarousel1" class="carousel slide" data-interval="false">
	<div class="carousel-inner">
		<div class="item active">

<%	
	Statement s = connection.createStatement();
	ResultSet rs = s.executeQuery("SELECT * from reviews JOIN contributions on contributions.id = reviews.contribution_id ORDER BY reviews.ts DESC LIMIT 5");
	
	//out.println("<div class='row'>");
	//out.println("<h4>Recent Reviews</h4>");
	if(rs == null || !rs.first())
	{
		out.println("<h4>No recent reviews. </h4>");
	}
	else
	{
			//out.println("<div class='row admin-row'>");
			out.println("<p class='admin-p text-center carousel-review-link'><a href = '/Bookstore/book.jsp?book_id="+rs.getInt(4)+"'>"+ rs.getString(9) + "</a></p>");
			out.println("<p class='admin-p carousel-text'>"+rs.getString(5) + "</p>");
			out.println("</div>");
		while(rs.next()) {
			out.println("<div class='item'>");
			//out.println("<div class='row admin-row'>");
			out.println("<p class='admin-p  text-center carousel-review-link'><a href = '/Bookstore/book.jsp?book_id="+rs.getInt(4)+"'>"+ rs.getString(9) + "</a></p>");
			out.println("<p class='admin-p carousel-text'>"+rs.getString(5) + "</p>");
			out.println("</div>");
			} 
	}	
	
}
 	catch (Exception e)
{
	out.println(e);
}
%>
	</div>
		<!-- Controls -->
	<a class="left carousel-control" href="#myCarousel1" role="button" data-slide="prev">
			<span class="glyphicon glyphicon-chevron-left"></span>
	</a>

	<a class="right carousel-control" href="#myCarousel1" role="button" data-slide="next">
			<span class="glyphicon glyphicon-chevron-right"></span>
	</a>

</div>
</div>
<hr>
</div>
</div>
</body>