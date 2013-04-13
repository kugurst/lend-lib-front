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
			ods.setURL("jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111c.cs.columbia.edu:1521/ADB");
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
	<%
		Boolean madeBook = (Boolean) session.getAttribute("badbook");
		if (madeBook != null) {
			if (madeBook)
				out.println("<p>Failed to make the book.</p>");
			else
				out.println("<p>Succeeded in making the book.</p>");
			session.setAttribute("badbook", null);
		}
	%>
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
	<p>
		Click <a href="addbook.jsp">here</a> to add a book you own to your
		collection.
	</p>
	<p>
		Click <a href="library.jsp">here</a> to view the library.
	</p>
	<p>
		Click <a href="pendingtrade.jsp">here</a> to view any pending trades.
	</p>
	<p>
		Click <a href="returnbooks.jsp">here</a> to return any books you've
		borrowed.
	</p>
	<p>
		Click <a href="listbooks.jsp">here</a> to see the books you own and
		the books you've borrowed.
	</p>

</body>
</html>