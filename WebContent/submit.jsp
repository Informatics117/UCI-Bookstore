<jsp:include page="header.jsp" flush="true">
<jsp:param name="pageName" value="Search"/>
</jsp:include>

<%-- REQUIRED JAVA IMPORTS --%>
<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.net.*,
 java.io.*,
 com.google.gson.*"%>
 

<%-- CONTRIBUTION SUBMISSION PAGE --%>
<form action = "/Bookstore/submit.jsp" METHOD="POST">

<%

if(session.getAttribute("id") == null && session.getAttribute("admin") == null)
{
	out.println("You must be logged in to use this feature");
}
else
{
%>

<%
if(session.getAttribute("admin") != null)
{
	out.println("AUTHOR's ID*: <INPUT TYPE='TEXT' NAME='user_id' id='user_id'><BR>");
}
%>

	ISBN Number*: <INPUT TYPE="TEXT" NAME="ISBN_num" id="ISBN_num"><BR> 
	Book Price (must be a valid price e.g. 11.99)*: <INPUT TYPE="TEXT" NAME="book_price" id="book_price"><BR>
	Photo URL*:  <INPUT TYPE="TEXT" NAME="photo_url" id="photo_url"><BR>
	
	<INPUT TYPE="SUBMIT" VALUE="submit contribution" NAME="contribution">
</FORM>

<%-- CONTRIBUTION SUBMISSION PAGE --%>

<%
if(request.getParameter("contribution") != null)
{
	String user_id = "";
	int id = 0;
	try{
		if(session.getAttribute("admin") != null)
		{
			user_id = request.getParameter("user_id");
		}
		else if(session.getAttribute("id") != null)
		{
			id = Integer.parseInt(session.getAttribute("id").toString());
		}
		else
		{
			response.sendRedirect("/Bookstore/redirect.jsp?message=You need to login before you can make a contribution.");
		}
		//String book_title = request.getParameter("book_title");
		String ISBN_num = request.getParameter("ISBN_num");
		String book_price = request.getParameter("book_price");
		String photo_url = request.getParameter("photo_url");
		//String publisher = request.getParameter("publisher");
		//String description = request.getParameter("description");
		
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","testuser","testpass");

		try{
		URL url = new URL("https://www.googleapis.com/books/v1/volumes?q=isbn:"+ISBN_num+"");
		URLConnection conn = url.openConnection();

		BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
		StringBuilder sb = new StringBuilder();
		String inputLine;
		while((inputLine = br.readLine()) != null)
		{
			sb.append(inputLine);
		}
		
		JsonParser parser = new JsonParser();
		JsonObject json = (JsonObject) parser.parse(sb.toString());
		
		String book_title = (((JsonObject) ((JsonObject) ((JsonArray) json.get("items")).get(0)).get("volumeInfo")).get("title")).toString().replaceAll("\"", "");
		String description = (((JsonObject) ((JsonObject) ((JsonArray) json.get("items")).get(0)).get("volumeInfo")).get("description")).toString().replaceAll("\"", "");
		String publisher =  (((JsonObject) ((JsonObject) ((JsonArray) json.get("items")).get(0)).get("volumeInfo")).get("publisher")).toString().replaceAll("\"", "");
		String rating = (((JsonObject) ((JsonObject) ((JsonArray) json.get("items")).get(0)).get("volumeInfo")).get("averageRating")).toString().replaceAll("\"", "");
		
		Statement s = connection.createStatement();
		
		
		if(session.getAttribute("admin") != null)
		{
			String query = "CALL submit_and_approve('"+user_id+"', '"+book_title+"', '"+ISBN_num+"', '"+book_price+"', '"+description+"', '"+photo_url+"', '"+publisher+"', '"+rating+"')";
			s.executeUpdate(query);
			out.println("Contribution has been added and approved.");
		}
		else
		{
			String query = "CALL submit_contribution('"+id+"', '"+book_title+"', '"+ISBN_num+"', '"+book_price+"', '"+description+"', '"+photo_url+"', '"+publisher+"', '"+rating+"')";
			s.executeUpdate(query);
			out.println("Contribution has been added and is pending approval");
		}
		} catch (Exception e)
		{
			System.out.println(e.toString());
			out.println("That is not a valid ISBN number");
		}
		connection.close();
	} catch (Exception e)
	{
		System.out.println(e.toString());
		out.println("Check your submission: You either have an invalid price, or have entered an empty field.");
	}
}
}
%>
