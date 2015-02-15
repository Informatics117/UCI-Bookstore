<%-- REQUIRED JAVA IMPORTS --%>
<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"%>


<%-- CONTRIBUTION SUBMISSION PAGE --%>
<FORM METHOD="GET">
	Book ID: <INPUT TYPE="TEXT" NAME="book_id"><BR>
	Book Title: <INPUT TYPE="TEXT" NAME="book_title"><BR> 
	ISBN Number: <INPUT TYPE="TEXT" NAME="ISBN_num"><BR> 
		
	<INPUT TYPE="SUBMIT"VALUE="Search" NAME="submit">
</FORM>

<%-- CONTRIBUTION SUBMISSION PAGE --%>