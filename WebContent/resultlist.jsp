<%-- REQUIRED JAVA IMPORTS --%>
<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"%>
 
 <%-- JAVA CODE HERE: WILL DISPLAY RESULTS OF USER'S QUERY --%>
<%-- 
	REQUIREMENTS: if user is not an administrator, the page will only display regular functions.
	If user is an administrator, the administrator will have the option to delete or possibly edit book information.
--%>