<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Lib: Pending Trades</title>
</head>
<body>
	<!-- Set the appropriate messages depending on the status -->
	<%
		Object baddrop = session.getAttribute("baddrop");
		if (baddrop != null) {
			Boolean bd = (Boolean) baddrop;
			if (bd)
				out.println("<p>Failed to drop the specified book from the table.</p>");
			session.setAttribute("baddrop", null);
		}

		Object badadd = session.getAttribute("badadd");
		if (badadd != null) {
			Boolean ba = (Boolean) badadd;
			if (ba)
				out.println("<p>Failed to confirm the trade.</p>");
			session.setAttribute("badadd", null);
		}

		Object badpenddel = session.getAttribute("badpenddel");
		if (badpenddel != null) {
			Boolean bpd = (Boolean) badpenddel;
			if (bpd)
				out.println("<p>Failed to delete the pending trade record.</p>");
			session.setAttribute("badpenddel", null);
		}

		Object handshake = session.getAttribute("handshake");
		if (handshake != null) {
			Boolean hs = (Boolean) handshake;
			if (hs)
				out.println("<p>The book trade has been confirmed.</p>");
			session.setAttribute("handshake", null);
		}
	%>
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