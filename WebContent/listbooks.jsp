<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Lib: My Books</title>
</head>
<body>
	<%
		// Connect to the database	
		Connection conn = null;
		try {
			OracleDataSource ods = new OracleDataSource();
			ods.setURL("jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111c.cs.columbia.edu:1521/ADB");
			conn = ods.getConnection();
			Statement stmt = conn.createStatement();
			// Print out the books they own
	%>
	<h3>Below are the books that you own:</h3>
	<table border="1">
		<%
			String query = "select b.title,b.author,b.isbn,b.genre,b.numofpages AS \"NUMBER OF PAGES\",b.numoftimesborrowed AS \"NUMBER OF TIMES BORROWED\",r2.rating AS \"AVERAGE RATING\" from books b\r\n"
						+ "left outer join\r\n"
						+ "  (select r1.isbn,AVG(r1.numrating) AS rating from\r\n"
						+ "    (select b.isbn,bk.numrating from books b, bookratings bk\r\n"
						+ "      where b.isbn=bk.isbn) r1\r\n"
						+ "    group by r1.isbn) r2\r\n"
						+ "    on b.isbn=r2.isbn\r\n"
						+ "    where b.ownerid = "
						+ session.getAttribute("suid");
				ResultSet rset = stmt.executeQuery(query);

				// Print out the column headers
				out.println("<tr>");
				// Get the resultset metadata
				ResultSetMetaData md = rset.getMetaData();
				// Get the number of rows
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
					out.println("\t\t</tr>");
				}
				rset.close();
		%>
	</table>
	<h3>Below are the books that you've borrowed:</h3>
	<table border="1">
		<%
			query = "select unique r3.title,r3.author,r3.isbn,r3.genre,r3.\"NUMBER OF PAGES\",r3.\"NUMBER OF TIMES BORROWED\",r3.\"AVERAGE RATING\" from\r\n"
						+ "  (select b.bookid,b.title,b.author,b.isbn,b.genre,b.numofpages AS \"NUMBER OF PAGES\",b.numoftimesborrowed AS \"NUMBER OF TIMES BORROWED\",r2.rating AS \"AVERAGE RATING\" from books b\r\n"
						+ "  left outer join\r\n"
						+ "    (select r1.isbn,AVG(r1.numrating) AS rating from\r\n"
						+ "      (select b.isbn,bk.numrating from books b, bookratings bk\r\n"
						+ "        where b.isbn=bk.isbn) r1\r\n"
						+ "      group by r1.isbn) r2\r\n"
						+ "      on b.isbn=r2.isbn) r3\r\n"
						+ "left outer join\r\n"
						+ "  history h\r\n"
						+ "  on h.bookid=r3.bookid\r\n"
						+ "  where h.borrowerid="
						+ session.getAttribute("suid");
				rset = stmt.executeQuery(query);

				// Print out the column headers
				out.println("<tr>");
				// Get the resultset metadata
				md = rset.getMetaData();
				// Get the number of rows
				numCol = md.getColumnCount();
				for (int i = 1; i <= numCol; i++) {
					out.println("\t\t\t<td>" + md.getColumnName(i) + "</td>");
				}
				out.println("\t\t</tr>");
				// Print out each result
				while (rset.next()) {
					out.println("\t\t<tr>");
					for (int i = 1; i <= numCol; i++) {
						if (rset.getString(i) != null)
							out.println("\t\t\t<td>" + rset.getString(i)
									+ "</td>");
						else
							out.println("\t\t\t<td></td>");
					}
					out.println("\t\t</tr>");
				}
				rset.close();
		%>
	</table>
	<%
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