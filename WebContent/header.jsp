<%-- Header import that sets the title of the page when the header is imported from the parameter --%>
<%
    String pageName = "Home";
    if (request.getParameter("pageName") != null) {
        pageName = request.getParameter("pageName");
    }
%>
<%-- Header used in every file, imports bootstrap and constructs the navbar --%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title><%= pageName %> - Bookstore</title>
        <link href="css/bootstrap.css" rel="stylesheet">
        <link href="css/bookstore.css" rel="stylesheet">

    </head>
    <body>
    	<nav class="navbar navbar-default navbar-static-top">
    		<div class="container">
    			<div class="navbar-right">
    				<ul class="nav navbar-nav">
    					
<%
	if(session.getAttribute("user") == null && session.getAttribute("admin") == null){
		
		//Buttons that appear when a user isn't logged in
        out.println("<li><form action='/Bookstore/newacct.jsp'><input type = 'submit' class='btn btn-default' value = 'Create an Account'></form></li>");
		out.println("<li><form action='/Bookstore/login.jsp'><input type = 'submit' class='btn btn-default' value = 'Login'></form></li>");
	}
	else
	{
	String userName = null;
	String sessionID = null;
	Cookie[] cookies = request.getCookies();

	if(cookies !=null){
	for(Cookie cookie : cookies){
	    if(cookie.getName().equals("user") || cookie.getName().equals("admin")) userName = cookie.getValue();
	}
	//If the user is logged in, then depending on the type of account, they can get a button for admin creation
    //Buttons telling them that theyre not logged in or a logout button
    if (session.getAttribute("admin") != null)
    {
        out.println("<li><form action='/Bookstore/admincreationpage.jsp'><input type = 'submit' class='btn btn-default' value = 'Create an Admin Account'></form></li>");
    }
	if(userName == null)
	{
        out.println("<li><form action='/Bookstore/newacct.jsp'><input type = 'submit' class='btn btn-default' value = 'Create an Account'></form></li>");
		out.println("<li><form action='/Bookstore/login.jsp'><input type = 'submit' class='btn btn-default' value = 'Login'></form></li>");
	}
	else
	{
	out.println("<li><h4>"+userName+"</h4></li>");
	out.println("<li><form method='POST' action='logout.jsp'><input type='hidden' value='true' name='logout'><button type='submit' class='btn btn-default'>Logout</button></form></></li>");
	}
	}
	}
%>
    				</ul>
    			</div>
    			<div class="navbar-left">
    				<ul class="nav navbar-nav">
    					<!-- link this to the authors personal page -->
                        <!-- Links to the other pages if youre a regular user -->
    					<li> <h4>The Authors</h4><li>
    					<li><a href="splashpage.jsp">Home</a></li>
    					<li><a href="author.jsp">My Page</a></li>
    					<li><a href="search.jsp">Search</a></li>
    					<li><a href="submit.jsp">Submit Book</a></li>
    				</ul>
    			</div>
    		</div>
    	</nav>