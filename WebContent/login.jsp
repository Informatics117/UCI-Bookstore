<%-- REQUIRED JAVA IMPORTS --%>
<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"%>

<%-- LOGIN HTML CODE --%>
<form method="POST">
            <div class="form-group">
                <label for="username">Email address</label>
                <input type="email" class="form-control" id="username" name="username">
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" class="form-control" id="password" name="password">
            </div>
            <button type="submit" class="btn btn-primary">Login</button>
</form>

<%-- TO ADD: LOGIN JAVA CODE --%>
<%
if(request.getMethod().equals("POST") && request.getParameter("username") != null && request.getParameter("password") != null)
{
try
{  
	String email = request.getParameter("username");
	String password = request.getParameter("password");
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "authorsdb","testuser","testpass");
	
	Statement s = connection.createStatement();
	out.println(email + " " + password);
	ResultSet rs = s.executeQuery("SELECT * FROM user WHERE email = '"+email+"' AND password = '"+password+"'");
	
	if(rs.next())
	{
		if(rs.getString(4).equals(email) && rs.getString(5).equals(password))
		{
			out.println("Welcome to The Hill. Redirecting.");
			response.sendRedirect("/Bookstore/search.jsp");
		}
	}
	else
	{
		throw new SQLException();
	}
} catch (Exception e)
{
	out.println("You are currently not logged in");
}
}
%>