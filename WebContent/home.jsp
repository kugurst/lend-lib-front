<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<!-- Getting the username and the password that was submitted -->
<%
	// Get the user info
	Object sname = session.getAttribute("sname");
	String name = null;
	if (sname == null) {
		name = request.getParameter("username");
		String pass = request.getParameter("password");

		// Check to see if their credentials align with a user in person	
		Connection conn = null;
		ResultSet rset = null;
		try {
			OracleDataSource ods = new OracleDataSource();
			ods.setURL("jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111b.cs.columbia.edu:1521/ADB");
			conn = ods.getConnection();
			Statement stmt = conn.createStatement();
			rset = stmt
					.executeQuery("select USERID from PERSON P where P.UNAME='"
							+ name + "' and P.PASSWORD='" + pass + "'");
			// If there is no result, then this user is not registered
			if (rset.next()) {
				session.setAttribute("sname", name);
				session.setAttribute("suid", rset.getInt("USERID"));
			} else
				session.setAttribute("sname", null);
		} catch (SQLException e) {
			System.out.print(e.getMessage());
			if (conn != null) {
				conn.close();
			}
		} finally {
			if (conn != null)
				conn.close();
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Lib: Home</title>
</head>
<body>
	<p>
		Successfully logged in:
		<%
		sname = session.getAttribute("sname");
		if (sname != null)
			out.print(sname);
		else
			response.sendRedirect(request.getHeader("referer"));
	%>
	</p>
	<p>
		Click <a href="logout">here</a> to logout.
	</p>
</body>
</html>