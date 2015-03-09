<%
    String pageName = "Home";
    if (request.getParameter("pageName") != null) {
        pageName = request.getParameter("pageName");
    }
%>
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
		
		//<button type="button"><a href="yourlink.com">Link link</a></button>
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
	
	if(userName == null)
	{
		out.println("<li><form action='/Bookstore/login.jsp'><input type = 'submit' class='btn btn-default' value = 'Login'></form></li>");
	}
	else
	{
	out.println("<li><h4>"+userName+"</h4></li>");
	out.println("<li><form method='POST' action='logout.jsp'><input type='hidden' value='true' name='logout'><button type='submit' class='btn btn-default'>Logout</button></></li>");
	}
	}
	}
%>
    				</ul>
    			</div>
    			<div class="navbar-left">
    				<ul class="nav navbar-nav">
    					<!-- link this to the authors personal page -->
    					<li><a href="splashpage.jsp">Home</a></li>
    					<li><a href="author.jsp">My Page</a></li>
    					<li><a href="search.jsp">Search</a></li>
    					<li><<a href="submit.jsp">Submit Book</a></li>
    				</ul>
    			</div>
    		</div>
    	</nav>
		<div class="container">
