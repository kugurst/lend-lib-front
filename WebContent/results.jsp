<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<!-- Getting the title and author of the book -->

String title = null; 
String author = null; 

title = request.getParameter("title"); 
author = request.getParameter("author");

if (title != null && author != null){  	
		Connection conn = null;
		ResultSet rset = null;
		try {
			OracleDataSource ods = new OracleDataSource();
			ods.setURL("jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111c.cs.columbia.edu:1521/ADB");
			conn = ods.getConnection();
			Statement stmt = conn.createStatement();
			rset = stmt
					.executeQuery("select * from BOOKS B where B.TITLE=title
						AND B.AUTHOR=author");
						} catch (SQLException e) {
			out.print(e.getMessage());
			if (conn != null) {
				conn.close();
			}
		} finally {
			if (conn != null)
				conn.close();
		}
	}
}

else if (title != null && author == null){
Connection conn = null;
		ResultSet rset = null;
		try {
			OracleDataSource ods = new OracleDataSource();
			ods.setURL("jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111c.cs.columbia.edu:1521/ADB");
			conn = ods.getConnection();
			Statement stmt = conn.createStatement();
			rset = stmt
					.executeQuery("select * from BOOKS B where B.TITLE=title");
			} catch (SQLException e) {
			out.print(e.getMessage());
			if (conn != null) {
				conn.close();
			}
		} finally {
			if (conn != null)
				conn.close();
		}
	}						
							}
							
else if (title == null && author != null){
Connection conn = null;
		ResultSet rset = null;
		try {
			OracleDataSource ods = new OracleDataSource();
			ods.setURL("jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111c.cs.columbia.edu:1521/ADB");
			conn = ods.getConnection();
			Statement stmt = conn.createStatement();
			rset = stmt
					.executeQuery("select * from BOOKS B where B.AUTHOR=author"
						);
	} catch (SQLException e) {
			out.print(e.getMessage());
			if (conn != null) {
				conn.close();
			}
		} finally {
			if (conn != null)
				conn.close();
		}
	}						
}
							
else {
System.out.println("error");														
							
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Book Search Result</title>
</head>
<body>

</body>
</html>y>
</html>
