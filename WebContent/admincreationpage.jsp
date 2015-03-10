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

<%
if(session.getAttribute("admin") == null)
{
	response.sendRedirect("/Bookstore/redirect.jsp?message=You are not an admin!");
}
%>

 <form action = "/Bookstore/admincreationpage.jsp" METHOD="POST">
	ALL FIELDS CANNOT BE EMPTY. <BR>
 	First Name: <INPUT TYPE="TEXT" NAME="first_name" id="first_name"><BR> 
 	Last Name: <INPUT TYPE="TEXT" NAME="last_name" id="last_name"><BR>
 	Email:  <INPUT TYPE="TEXT" NAME="email" id="email"><BR>
 	Password:  <INPUT TYPE="password" NAME="pass" id="pass"><BR>
 	<INPUT TYPE="SUBMIT" VALUE="Add Administrator" NAME="Add Administrator">
 </FORM>

<%
try{
	
	
	
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection connection = DriverManager.getConnection("jdbc:mysql:///" + "bookstoredb","testuser","testpass");

	
	String first_name = request.getParameter("first_name");
	String last_name = request.getParameter("last_name");
	String email = request.getParameter("email");
	String pass = request.getParameter("pass");
	
	if(first_name != null && last_name != null && email != null && pass != null)
	{
		Statement s = connection.createStatement();
		String query = "INSERT INTO administrators VALUES (DEFAULT, '"+first_name+"', '"+last_name+"', '"+email+"', '"+pass+"', 0, 0)";
		s.executeUpdate(query);
		System.out.println(query);
		out.println("Administrator has been added into the system");
	}
	
	connection.close();
} catch (Exception e)
 {
	out.println("There is an error with your input");
 }

%>

