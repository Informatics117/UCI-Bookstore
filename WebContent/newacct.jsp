<jsp:include page="header.jsp" flush="true">
<jsp:param name="pageName" value="New Account"/>
</jsp:include>

<%-- REQUIRED JAVA IMPORTS --%>
<%@page
import="java.sql.*,
javax.sql.*,
java.io.IOException,
javax.servlet.http.*,
javax.servlet.*"%>

<body>
	<div class="container">
		<div class="row">
			<div class="col-sm-4 col-sm-offset-4">
				<h2>Add a New Account</h2>
			</div>
		</div>
		<%-- ACCOUNT CREATION PAGE --%>
		<div class="row">
			<div class="col-sm-4 col-sm-offset-4">
				<form method="POST">
					<div class="form-group">
						<label for="first">First Name*: </label>
						<input type="text" class="form-control" name="first_name" id="first">
					</div>
					<div class="form-group">
						<label for="last">Last Name*: </label>
						<input type="text" class="form-control" name="last_name" id="last">
					</div>
					<div class="form-group">
						<label for="e_mail">Email*: </label>
						<input type="text" class="form-control" name="email" id="e_mail">
					</div>
					<div class="form-group">
						<label for="pass">Password*: </label>
						<input type="password" class="form-control" name="password" id="pass">
					</div>
					<div class="form-group">
						<label for="last">Affiliation*: </label>
						<input type="text" class="form-control" name="affiliation" id="affiliation" placeholder = "e.g. Student">
					</div>
					<div class="form-group">
						<label for="last">Department*: </label>
						<input type="text" class="form-control" name="department" id="department" placeholder = "e.g. Engineering">
					</div>
					<div class="form-group">
						<label for="last">Class*: </label>
						<input type="text" class="form-control" name="class" id="class" placeholder = "e.g. 1999">
					</div>
					<div class="form-group">
						<label for="last">School*: </label>
						<input type="text" class="form-control" name="school" id="school" placeholder = "e.g. Computer Science">
					</div>
					<div class="form-group">
						<label for="inf">More Info*: </label>
						<textarea name="info" class="form-control" cols="50" rows="5" id="inf" placeholder="Former UCI email, graduation date, etc."></textarea>
					</div>
					<button type="submit" class="btn btn-default">Submit</button>
				</form>
			</div>
		</div>
	</div>
</body>
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
	String affiliation = request.getParameter("affiliation");
	String department = request.getParameter("department");
	String classof = request.getParameter("class");
	String school = request.getParameter("school");
	
	
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
		String buildQuery = "INSERT INTO pending_users (first_name, last_name, email, password, info, affiliation, department, class, school)"
				+ " VALUES ('"+first_name+"', '"+last_name+"', '"+email+"', '"+info+"', '"+password+"', '"+affiliation+"', '"+department+"', '"+classof+"', '"+school+"')";
		Statement s1 = connection.createStatement();
		s1.executeUpdate(buildQuery);
		
		response.sendRedirect("/Bookstore/redirect.jsp?message=Account creation successful, your account is pending approval");
	}
	
	connection.close();
	
	} catch (Exception e)
	{
		out.println(e);
	}
	
	
}

%>

