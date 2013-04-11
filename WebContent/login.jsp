<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!-- First, check to see if there's already a session -->
<%
	Object sname = session.getAttribute("sname");
	// There is a session currently in process, redirect to home.jsp
	if (sname != null)
		response.sendRedirect("home.jsp");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="ISO-8859-1">
<title>Lib: Login</title>
</head>
<body>
	<form method=post action="home.jsp">
		What's your name? <input type="text" name="username" size=20><br />
		Password <input type="password" name="password" size=20> <br />
		<input type=submit>
	</form>
</body>

</html>
