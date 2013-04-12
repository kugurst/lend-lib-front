<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<!-- Getting the title and the author that was submitted -->
<%
	String title = request.getParameter("title");
	String author = request.getParameter("author");

%>

<%
if (title != null && author != null){		
		Connection conn = null;
		ResultSet result = null;
		try {
			OracleDataSource ods = new OracleDataSource();
			ods.setURL("jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111c.cs.columbia.edu:1521/ADB");
			conn = ods.getConnection();
			Statement stmt = conn.createStatement();
			result = stmt.executeQuery("select * from BOOKS B where B.TITLE='"
							+ title + "' and B.AUTHOR='" + author + "'");
						} //end try
 			catch (SQLException e) {
			out.print(e.getMessage());
			if (conn != null) {
				conn.close();
			}//if
		} //catch
			finally {
			if (conn != null)
				conn.close();
		}//finally
	}//if


else if (title != null && author == null){
Connection conn = null;
		ResultSet result = null;
		try {
			OracleDataSource ods = new OracleDataSource();
			ods.setURL("jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111c.cs.columbia.edu:1521/ADB");
			conn = ods.getConnection();
			Statement stmt = conn.createStatement();
			result = stmt.executeQuery("select * from BOOKS B where B.TITLE='"
							+ title + "'");
			}//try
			catch (SQLException e) {
			out.print(e.getMessage());
			if (conn != null) {
				conn.close();
			}//if
		} //catch
			finally {
			if (conn != null)
				conn.close();
								
		}//finally
} //else if		
							
else if (title == null && author != null){
Connection conn = null;
		ResultSet result = null;
		try {
			OracleDataSource ods = new OracleDataSource();
			ods.setURL("jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111c.cs.columbia.edu:1521/ADB");
			conn = ods.getConnection();
			Statement stmt = conn.createStatement();
			result = stmt.executeQuery("select * from BOOKS B where B.AUTHOR='" + author + "'");
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

							
else {
Out.println("error you must enter either a title or author");		
}
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Find a Book</title>
</head>
<body>
	out.println(title); out.println(author);


	<TABLE cellpadding="15" border="1" style="background-color: #ffffcc;">
		<% 
while (result.next()) {out.println("
		<TR>
			<TD><%= result.getInt(1)%></TD>
			<TD><%=result.getInt(2)%></TD>
			<TD><%=result.getInt(3)%></TD>
			<TD><%=result.getString(4)%></TD>
			<TD><%=result.getString(5)%></TD>
			<TD><%=result.getString(6)%></TD>
			<TD><%=result.getInt(7)%></TD>
			<TD><%=result.getInt(8)%></TD>
			<TD><%=result.getInt(9)%></TD>
			<TD><%=result.getInt(10)%></TD>
		</TR>");
		}
		<%
 result.close(); 
 stmt.close(); 
 conn.close();							
%>
	</TABLE>
</body>
</html>

