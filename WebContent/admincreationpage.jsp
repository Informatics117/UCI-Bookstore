<%-- Header imported from header.jsp --%>
<jsp:include page="header.jsp" flush="true">
    <jsp:param name="pageName" value="Front Page"/>
</jsp:include>

<%-- Page for creation for mini admins --%>
<%-- REQUIRED JAVA IMPORTS --%>
<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"%>

<%--Checks if the current user is an admin, if not then redirects back to home --%>
<%
if(session.getAttribute("admin") == null)
{
	response.sendRedirect("/Bookstore/redirect.jsp?message=You are not an admin!");
}
%>

<!-- Standard bootstrap form group, each field is given a NAME which is used later by the jsp file -->
<div class="container">
<div class="row">
	<h2>Submit a Contribution</h2>
</div>
<div class="row">
	<div class="col-sm-4 col-sm-offset-4">
 		<form action = "/Bookstore/admincreationpage.jsp" METHOD="POST">
 			<h4>ALL FIELDS CANNOT BE EMPTY. </h4>
 			<div class="form-group">
 				<label for="first_name">First Name: </label>
 				<INPUT class="form-control" TYPE="TEXT" NAME="first_name" id="first_name">
 			</div>
 			<div class="form-group">
 				<label for="last_name">Last Name: </label>
 				<INPUT class="form-control" TYPE="TEXT" NAME="last_name" id="last_name">
 			</div>
 			<div class="form-group">
 				<label for="email">Email: </label>
 				<INPUT class="form-control" TYPE="TEXT" NAME="email" id="email">
 			</div>
 			<div class="form-group">
 				<label for="pass">Password: </label>
 				<INPUT class="form-control" TYPE="password" NAME="pass" id="pass">
 			</div>
			<Button TYPE="SUBMIT" class="btn btn-primary" NAME="Add Administrator">Add Administrator</Button>
 		</form>

<%
try{
	
	
	//Connects to the database
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","testuser","testpass");

	//Grabs the information that was submitted by the form
	//Strings are grabbed based on the field corresponding to the NAME that's passed in
	String first_name = request.getParameter("first_name");
	String last_name = request.getParameter("last_name");
	String email = request.getParameter("email");
	String pass = request.getParameter("pass");
	
	//As long as none are empty, create a new entry into the administrators list and print a message saying success
	if(first_name != null && last_name != null && email != null && pass != null)
	{
		Statement s = connection.createStatement();
		String query = "INSERT INTO administrators VALUES (DEFAULT, '"+first_name+"', '"+last_name+"', '"+email+"', '"+pass+"', 0, 0)";
		s.executeUpdate(query);
		System.out.println(query);
		out.println("Administrator has been added into the system");
	}
	
	connection.close();
	//If anything wrong happens print an error message
} catch (Exception e)
 {
	out.println("There is an error with your input");
 }

%>

