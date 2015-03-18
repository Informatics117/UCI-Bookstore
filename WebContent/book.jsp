<%--Page that displays a book's information --%>
<jsp:include page="header.jsp" flush="true">
    <jsp:param name="pageName" value="Book"/>
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

<%-- JAVA CODE TO DISPLAY BOOK PAGE. --%>
<%
try{
	//Connects to the database, and looks for the book in the table
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","testuser","testpass");
	
	int book_id = 0;
	try{
		book_id = Integer.parseInt(request.getParameter("book_id"));
	} catch (Exception e)
	{
		out.println("<h2>Invalid Author ID</h2>");
	}
	
	//Grabs relevant information to the book
	String rating = request.getParameter("rating");
	String review = request.getParameter("review");

	int user_id = 0;
	try{
		user_id = Integer.parseInt(session.getAttribute("id").toString());
	} catch (Exception e)
	{
		out.println("");
	}
	//Checkers to see if the user isn't logged in
	//If the account isn't logged in then one message is displayed, if it's an admin then the message
	//Says to login as a user, otherwise it'll submit the review to the pending-reviews table
	if(rating != null && review != null)
	{
		if(session.getAttribute("user") == null && session.getAttribute("admin") == null)
		{
			out.println("<p> <font color = 'red'> Please login to write a review. </font> </p>");
		}
		else if(session.getAttribute("admin") != null)
		{
			out.println("<p> <font color = 'red'> An admin cannot write a review. Please login as a user. </font> </p>");
		}
		else
		{
			String query = "INSERT INTO pending_reviews VALUES (DEFAULT, '"+book_id+"', '"+user_id+"', '"+rating+"', '"+review+"')";
			Statement submitreview = connection.createStatement();
			submitreview.executeUpdate(query);
			out.println("<font color='red'>Review has been submitted and is pending approval.</font>");	
		}
	}
	
	//Grab additional information about the book, the image and display social media links below the book
	String getBook = "SELECT * FROM contributions JOIN users on users.id = contributions.user_id where contributions.id = '"+book_id+"'";
	Statement s = connection.createStatement();
	ResultSet rs = s.executeQuery(getBook);
	
	if(rs == null || !rs.first())
	{
		out.println("<h2>Book could not be found.</h2>");
	}
	else
	{
		String imageurl = rs.getString(9);
		out.println("<div class='row'>");
		out.println("<div class='col-sm-6'>");
		out.println("<img src='"+imageurl+"'/ height = '248' width = '200'>");
		
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
		//Html code to display the book info
		out.println("</div>");
		out.println("<div class='col-sm-6'>");
		out.println("<h2>"+rs.getString(3)+ "</h2>");
		out.println("<h4>by "+"<a href = '/Bookstore/author.jsp?author_id="+rs.getInt(2)+"'> "+ rs.getString(12) + " " + rs.getString(13) + "</a></h4>");
		out.println("<h5>ISBN number: "+rs.getString(4)+ "</h5>");
		out.println("<h5>Price: "+rs.getDouble(6)+ "</h5>");
		out.println("</div>");
		out.println("</div>");
		out.println("<hr>");
		out.println("<h5><b>Summary: </b></h5>");
//		out.println("<div class='row'>");
		out.println(rs.getString(7));
//		out.println("</div>");
	}

	Statement s1 = connection.createStatement();
	ResultSet rs1 = s1.executeQuery("SELECT * FROM reviews JOIN contributions on contributions.id = reviews.contribution_id WHERE contributions.id = '"+book_id+"'");
	
	out.println("<hr>");
	
	if(rs1 == null || !rs1.first())
	{
		out.println("No Reviews found for this book<BR><BR>");
	}
	else
	{
		//Prints out reviews, if they exist, below the book and below shows the form that allows
		//A user to review the book and send it to the pending_reviews table
		out.println("<b> Reviews: </b>");
		do
		{
			out.println("<div class='row'>");
			out.println("<div class='col-sm-3'>");
			out.println("<p>Poster ID: "+rs1.getInt(3)+ "<BR> Rating: "+rs1.getInt(4)+"</p>");
			out.println("</div>");
			out.println("<div class='col-sm-9'>");
			out.println("<p>" + rs1.getString(5)+ "</p>");
			out.println("</div>");
			out.println("</div>");
		}
		while(rs1.next());
	}
	

	connection.close();
%>
	//Book rating section for users to rate the book and send it to the pending reviews table
	<p> Rate the book </p>
	<form method="GET" action = "book.jsp">
            <div class="form-group">
               <select name="rating">
    <option value="1">1</option>
    <option value="2">2</option>
    <option value="3">3</option>
    <option value="4">4</option>
    <option value="5">5</option>
  			</select>
            </div>
            <div class="form-group">
                <label for="review"></label>
               <textarea name="review" class="form-control" cols="50" rows="5" id="inf" placeholder="Write a review here"></textarea>
            </div>
     
	

<% 
	out.println("<input type='hidden' name='book_id' value='"+book_id+"'>");
	out.println(" <button type='submit' class='btn btn-primary'>Submit Review</button>");
	out.println("</form>");
	out.println("</form>");
} catch (Exception e)
{
	 System.out.println(e);
}
%>
	</div>
</body>
</html>
