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