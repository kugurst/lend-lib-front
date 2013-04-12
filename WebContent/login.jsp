<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!-- First, check to see if there's already a session -->
<%
	Object sname = session.getAttribute("sname");
	// There is a session currently in process, redirect to home.jsp
	if (sname != null) {
		response.sendRedirect("home.jsp");
		return;
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Lib: Login</title>
</head>
<body>
	<form method=post action="home.jsp">
		<p>
			Your username: <input type="text" name="username" size="20"
				maxlength="30" required>
		</p>
		<p>
			Your password: <input type="password" name="password" size="20"
				maxlength="50" required>
		</p>
		<input type=submit>
	</form>
</body>
</html>
