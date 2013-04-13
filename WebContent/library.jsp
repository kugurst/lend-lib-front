<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Lib: Library</title>
</head>
<body>
	<!-- Make a connection -->
	<%
		// Connect to the database to get the library	
		Connection conn = null;
		ResultSet rset = null;
		try {
			OracleDataSource ods = new OracleDataSource();
			ods.setURL("jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111g.cs.columbia.edu:1521/ADB");
			conn = ods.getConnection();
			Statement stmt = conn.createStatement();
			rset = stmt
					.executeQuery("select r2.lenderid,r2.bookid,r2.title,r2.isbn,r2.author,r2.genre,r2.name AS owner,r2.currentavail AS availability,p1.name AS borrower,r2.dateborrowed AS \"DATE BORROWED\"\n"
							+ "from\n"
							+ "(select r1.lenderid,r1.bookid,r1.title,r1.isbn,r1.author,r1.genre,p.name,r1.borrowerid,r1.currentavail,r1.dateborrowed\n"
							+ "from PERSON p,\n"
							+ "(select l.bookid,b.title,b.isbn,b.author,b.genre,l.lenderid,l.borrowerid,l.currentavail,l.dateborrowed\n"
							+ "from LIBRARY l, BOOKS b\n"
							+ "where l.bookid = b.bookid) r1\n"
							+ "where r1.lenderid=p.userid) r2\n"
							+ "left outer join\n"
							+ "PERSON p1\n"
							+ "on r2.borrowerid=p1.userid");
			// Get the resultset metadata
			ResultSetMetaData md = rset.getMetaData();
			// Get the number of rows
			int columns = md.getColumnCount();
			// Print out the start of the table
			out.println("<table border=1>");
			// Print the column headers
			int currentColumn = 1;
			int dontPrint = 0;
			int dontPrint2 = 0;
			out.println("\t<tr>");
			while (currentColumn <= columns) {
				String columnName = md.getColumnName(currentColumn++);
				if (columnName.equalsIgnoreCase("bookid"))
					dontPrint = currentColumn - 1;
				else if (columnName.equalsIgnoreCase("lenderid"))
					dontPrint2 = currentColumn - 1;
				else
					out.println("\t\t<td>" + columnName + "</td>");
			}
			out.println("\t</tr>");
			// Go through each result row
			while (rset.next()) {
				// Print out the row header
				out.println("\t<tr>");
				currentColumn = 1;
				boolean avail = false;
				while (currentColumn <= columns) {
					if (currentColumn == dontPrint
							|| currentColumn == dontPrint2) {
						currentColumn++;
						continue;
					}
					String columnValue = rset.getString(currentColumn++);
					if (columnValue != null)
						out.println("\t\t<td>" + columnValue + "</td>");
					else {
						out.println("\t\t<td></td>");
						avail = true;
					}
				}
				if (avail)
					out.println("\t\t<td><a href=\"trade=?b="
							+ rset.getString(dontPrint) + "&o="
							+ rset.getString(dontPrint2)
							+ "\">Borrow This Book</a></td>");
				out.println("\t</tr>");
			}
			// Print out the end of the table
			out.println("</table>");
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