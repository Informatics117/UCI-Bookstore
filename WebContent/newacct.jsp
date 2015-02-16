<%-- REQUIRED JAVA IMPORTS --%>
<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"%>


<%-- ACCOUNT CREATION PAGE --%>
<FORM METHOD="POST">
	First Name*: <INPUT TYPE="TEXT" NAME="first_name"><BR>
	Last Name*: <INPUT TYPE="TEXT" NAME="last_name"><BR> 
	Email*: <INPUT TYPE="TEXT" NAME="email"><BR> 
	Password*: <INPUT TYPE="password" NAME="password"><BR> 
	More Info*: <textarea name="info" cols="50" rows="5">Former UCI email, graduation date, etc.</textarea><BR>
		
	<INPUT TYPE="SUBMIT" VALUE="Search" NAME="submit">
</FORM>

<%
if(request.getMethod().equals("POST") && request.getParameter("first_name") != null && request.getParameter("last_name") != null
	&& request.getParameter("email") != null && request.getParameter("password") != null && request.getParameter("info") != null)
{
	try{
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","testuser","testpass");
	
	String first_name = request.getParameter("first_name");
	String last_name = request.getParameter("last_name");
	String email = request.getParameter("email");
	String password = request.getParameter("password");
	String info = request.getParameter("info");
	
	Statement s = connection.createStatement();
	ResultSet rs = s.executeQuery("SELECT * FROM pending_users WHERE email = '"+email+"'");
	
	if(rs.first())
	{
			//redirect to redirection page
			//print message: "That email already exists, redirecting to main page"
			response.sendRedirect("/Bookstore/redirect.jsp?message='That email is already pending.'");
	}
	else
	{
		String buildQuery = "INSERT INTO pending_users (first_name, last_name, email, password, info)"
				+ " VALUES ('"+first_name+"', '"+last_name+"', '"+email+"', '"+password+"', '"+info+"')";
		Statement s1 = connection.createStatement();
		s1.executeUpdate(buildQuery);
		
		response.sendRedirect("/Bookstore/redirect.jsp?message=Account creation successful, your account is pending approval");
	}
	} catch (Exception e)
	{
		out.println(e);
	}
	
	
}




%>

