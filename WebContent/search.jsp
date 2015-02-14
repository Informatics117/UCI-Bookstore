
<%-- SEARCH QUERY PAGE, NO JAVA NEEDED: RESULTS WILL REDIRECT TO ANOTHER PAGE. --%>
<FORM ACTION = "/Bookstore/resultlist.jsp" METHOD="GET">
	Book ID: <INPUT TYPE="TEXT" NAME="book_id"><BR>
	Book Title: <INPUT TYPE="TEXT" NAME="book_title"><BR> 
	ISBN Number: <INPUT TYPE="TEXT" NAME="ISBN_num"><BR> 
	Author's First Name: <INPUT TYPE="TEXT" NAME="first_name"><BR> 
	Author's Last Name: <INPUT TYPE="TEXT" NAME="last_name"><BR>
		
	<INPUT TYPE="SUBMIT"VALUE="Search" NAME="submit">
</FORM>
