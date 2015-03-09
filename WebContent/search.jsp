<jsp:include page="header.jsp" flush="true">
<jsp:param name="pageName" value="Search"/>
</jsp:include>

<%-- REQUIRED JAVA IMPORTS --%>
<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"%>
 
<%-- SEARCH QUERY PAGE, NO JAVA NEEDED: RESULTS WILL REDIRECT TO ANOTHER PAGE. --%>
<body>
	<div class="container">
		<div class="row">
			<div class="col-sm-4 col-sm-offset-4">
				<h2>Search</h2>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-4 col-sm-offset-4">
				<form action = "/Bookstore/resultlist.jsp" method="GET">
					<div class="form-group">
						<label for="id">Book ID: </label>
						<input class="form-control" type="TEXT" name="book_id" id="id">
					</div>
					<div class="form-group">
						<label for="title">Book Title: </label>
						<input class="form-control" type="TEXT" name="book_title" id="title">
					</div>
					<div class="form-group">
						<label for="isbn">ISBN Number: </label>
						<input class="form-control" type="TEXT" name="ISBN_num" id="isbn">
					</div>
					<div class="form-group">
						<label for="first">Author's First Name: </label>
						<input class="form-control" type="TEXT" name="first_name" id="first">
					</div>
					<div class="form-group">
						<label for="last">Author's Last Name: </label>
						<input class="form-control" type="TEXT" name="last_name" id="last">
					</div>
					<button type="SUBMIT" class="btn btn-primary">Submit</button>
				</form>
			</div>
		</div>
	</div>
</body>