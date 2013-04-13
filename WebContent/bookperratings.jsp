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

			// The following are all the ratings for people
			out.println("<h3>People Ratings:</h3>");
			String query = "select r1.rater,p1.name as ratee,r1.numrating as \"RATING\",r1.txtrating as \"COMMENT\"\r\n" + 
					"  from person p1, (select p.name AS rater,pr.rateeid,pr.numrating,pr.txtrating\r\n" + 
					"    from person p, personratings pr\r\n" + 
					"    where p.userid=pr.raterid) r1\r\n" + 
					"    where p1.userid=r1.rateeid";
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
				out.println("\t\t</tr>");
			}
			out.println("\t</table>");
			rset.close();

			// The following are all the ratings for books
			out.println("<h3>Book Ratings:</h3>");
			query = "select p.name,r1.title,r1.author,r1.isbn,r1.genre,r1.numrating,r1.txtrating\r\n" + 
					"  from person p,\r\n" + 
					"  (select br.userid,b.title,b.author,b.isbn,b.genre,br.numrating,br.txtrating\r\n" + 
					"    from bookratings br, books b\r\n" + 
					"    where b.bookid=br.bookid) r1\r\n" + 
					"    where p.userid=r1.userid";
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