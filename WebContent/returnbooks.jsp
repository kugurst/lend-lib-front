<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Lib: Return Books</title>
</head>
<body>
	<!-- Set the appropriate messages depending on the status -->
	<%
		Object badpendadd = session.getAttribute("badpendadd");
		if (badpendadd != null) {
			Boolean bpd = (Boolean) badpendadd;
			if (bpd)
				out.println("<p>Failed to initiate the book return. Have you already started one for this book?</p>");
			session.setAttribute("badpendadd", null);
		}

		Object goodReturn = session.getAttribute("goodReturn");
		if (goodReturn != null) {
			Boolean gr = (Boolean) goodReturn;
			if (gr)
				out.println("<p>The owner has been notified of your intent to return the book. Contact the owner to complete the return.</p>");
			session.setAttribute("goodReturn", null);
		}
	%>
	<%
		// Connect to the database	
		Connection conn = null;
		try {
			OracleDataSource ods = new OracleDataSource();
			ods.setURL("jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111c.cs.columbia.edu:1521/ADB");
			conn = ods.getConnection();
			Statement stmt = conn.createStatement();
			// Format the query
			String query = "Select r2.title,r2.author,r2.isbn,p.name AS owner,p.uname AS \"OWNER USER NAME\",r2.dateborrowed AS \"DATE BORROWED\",r2.bookid from person p,\r\n"
					+ "  (select b.title,b.author,b.isbn,r1.* from books b,\r\n"
					+ "    (Select * From Lends L Where L.Borrowerid = "
					+ session.getAttribute("suid")
					+ ") R1\r\n"
					+ "    Where B.Bookid = R1.Bookid) R2\r\n"
					+ "    where p.userid = r2.lenderid";
			ResultSet rset = stmt.executeQuery(query);
			// Print out the queries
			out.println("<h3>Books that you have borrowed:</h3>");
			// Print out a table
			out.println("\t<table border=\"1\">");
			//Print out the header
			out.println("\t\t<tr>");
			ResultSetMetaData md = rset.getMetaData();
			int numCol = md.getColumnCount();
			for (int i = 1; i <= numCol; i++) {
				out.println("\t\t\t<td>" + md.getColumnName(i) + "</td>");
			}
			out.println("\t\t</tr>");
			// Print out each result
			while (rset.next()) {
				out.println("\t\t<tr>");
				for (int i = 1; i <= numCol; i++) {
					out.println("\t\t\t<td>" + rset.getString(i) + "</td>");
				}
				// Ask if they want to return it
				out.println("\t\t\t<td><a href=\"return?bid="
						+ rset.getString(7) + "&borruid="
						+ session.getAttribute("suid") + "&ouname="
						+ rset.getString(5) + "\">Return?</a></td>");
				out.println("\t\t</tr>");
			}
			out.println("\t</table>");
			rset.close();
		} catch (SQLException e) {
			System.out.print(e.getMessage());
			if (conn != null) {
				conn.close();
			}
		} finally {
			if (conn != null)
				conn.close();
		}
	%>
</body>
</html>