<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!-- Getting the username and the password that was submitted -->
<%
	String name = request.getParameter("username");
	String pass = request.getParameter("password");
	session.setAttribute("sname", name);
	session.setAttribute("spass", pass);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Redirecting...</title>
</head>
<body>
	<a href="NextPage.jsp">Continue</a>
</body>
</html>