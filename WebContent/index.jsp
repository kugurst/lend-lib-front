<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Lib: Share</title>
</head>
<body>
	<%
		Object logout = session.getAttribute("logout");
		if (logout != null) {
			out.println("<p>Logged out successfully.</p>");
			session.setAttribute("logout", null);
		}
	%>
	<h1>Lib: Share</h1>
	<h3>The peer to peer library.</h3>
	<p>
		A new user? Click <a href="signup.jsp">here</a> to sign up.
	</p>
	<p>
		A returning user? Click <a href="login.jsp">here</a> to log in.
	</p>
</body>
</html>