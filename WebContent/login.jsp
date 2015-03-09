<jsp:include page="header.jsp" flush="true">
    <jsp:param name="pageName" value="Login"/>
</jsp:include>

<%-- REQUIRED JAVA IMPORTS --%>
<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"%>

<%-- LOGIN HTML CODE --%>
<body>
	<div class="container">
	<div class="row">
		<div class ="col-sm-4 col-sm-offset-4">
			<h2>Login</h2>
		</div>
	</div>
	<div class="row">
	<div class="col-sm-4 col-sm-offset-4">
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
	</div>
	</div>
</body>
<%-- TO ADD: LOGIN JAVA CODE --%>
<%
if(request.getMethod().equals("POST") && request.getParameter("username") != null && request.getParameter("password") != null)
{
try
{  
	String email = request.getParameter("username");
	String password = request.getParameter("password");
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","testuser","testpass");
	
	Statement s = connection.createStatement();
	out.println(email + " " + password);
	ResultSet rs = s.executeQuery("SELECT * FROM users WHERE email = '"+email+"' AND password = '"+password+"'");
	
	Statement s1 = connection.createStatement();
	ResultSet rs1 = s1.executeQuery("SELECT * FROM administrators WHERE email = '"+email+"' AND password = '"+password+"'");
	
	if(rs1.next())
	{
		if(rs1.getString(4).equals(email) && rs1.getString(5).equals(password))
		{
			Cookie loginCookie = new Cookie("admin", email);
			session.setAttribute("admin", email);
			loginCookie.setMaxAge(30*60);
		 	response.addCookie(loginCookie);
			out.println("Welcome to The Hill. Redirecting to admin page.");
			response.sendRedirect("/Bookstore/adminpage.jsp");
		}
	}
	else if(rs.next())
	{
		if(rs.getString(4).equals(email) && rs.getString(5).equals(password))
		{
			Cookie loginCookie = new Cookie("user", email);
			loginCookie.setMaxAge(30*60);
			session.setAttribute("user", email);
			session.setAttribute("id", rs.getInt(1));
		 	response.addCookie(loginCookie);
			out.println("Welcome to The Hill. Redirecting.");
			response.sendRedirect("/Bookstore/search.jsp");
		}
	}
	else
	{
		throw new SQLException();
	}
	
	connection.close();
	
} catch (Exception e)
{
	out.println(e);
}
}
%>
