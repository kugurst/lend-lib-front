<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<%
		// Check to see if their credentials align with a user in person	
		Connection conn = null;
		ResultSet rset = null;
		try {
			OracleDataSource ods = new OracleDataSource();
			ods.setURL("jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111c.cs.columbia.edu:1521/ADB");
			conn = ods.getConnection();
			Statement stmt = conn.createStatement();
			// Get the current userid
			Integer userid = (Integer) session.getAttribute("suid");

			// The following are the books they own
			out.println("<h3>Pending Trades for Books You Own:</h3>");
			String query = "SELECT r2.bookid,r2.title,r2.author,r2.isbn,p2.name AS borrower,p2.uname AS \"BORROWER USER NAME\",r2.name AS owner,r2.uname AS \"OWNER USER NAME\" FROM person p2,\r\n"
					+ "  (SELECT b.bookid,b.title,b.author,b.isbn,r1.borrowerid,r1.uname,r1.name FROM books b,\r\n"
					+ "    (SELECT pt.*,p1.name,p1.uname FROM pendingtrade pt, person p1\r\n"
					+ "      WHERE pt.OWNERID = p1.USERID AND p1.USERID = "
					+ userid
					+ ") r1\r\n"
					+ "      WHERE b.bookid = r1.bookid) r2\r\n"
					+ "      WHERE p2.userid = r2.borrowerid";
			rset = stmt.executeQuery(query);
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
				// Ask if they want to confirm
				out.println("\t\t\t<td><a href=\"confirm?bid="
						+ rset.getString(1) + "&ouname="
						+ rset.getString(8) + "&buname="
						+ rset.getString(6) + "\">Confirm?</a></td>");
				out.println("\t\t</tr>");
			}
			out.println("\t</table>");
			rset.close();

			// The following are the books they borrowed
			out.println("<h3>Pending Trades for Books You Want to Borrow:</h3>");
			query = "SELECT r2.title,r2.author,r2.isbn,p2.name AS borrower,p2.uname AS \"BORROWER USER NAME\",r2.name AS owner,r2.uname AS \"OWNER USER NAME\" FROM person p2,\r\n"
					+ "  (SELECT b.title,b.author,b.isbn,r1.borrowerid,r1.uname,r1.name FROM books b,\r\n"
					+ "    (SELECT pt.*,p1.name,p1.uname FROM pendingtrade pt, person p1\r\n"
					+ "      WHERE pt.OWNERID = p1.USERID) r1\r\n"
					+ "      WHERE b.bookid = r1.bookid) r2\r\n"
					+ "      WHERE p2.userid = r2.borrowerid AND r2.borrowerid = "
					+ userid;
			rset = stmt.executeQuery(query);
			// Print out a table
			out.println("\t<table border=\"1\">");
			//Print out the header
			out.println("\t\t<tr>");
			md = rset.getMetaData();
			numCol = md.getColumnCount();
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