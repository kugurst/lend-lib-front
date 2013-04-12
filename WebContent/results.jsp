<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<%@ page import="com.sun.rowset.CachedRowSetImpl" %>



<!-- Getting the title and the author that was submitted -->
	<%
	String title = request.getParameter("title");
	String author = request.getParameter("author");

	%>

	 
<%
 if (title != null && author ==""){
	Connection conn = null;
	ResultSet result = null;
	CachedRowSetImpl crs = new CachedRowSetImpl();
	try {
		OracleDataSource ods = new OracleDataSource();
		ods.setURL("jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111c.cs.columbia.edu:1521/ADB");
		conn = ods.getConnection();
		Statement stmt = conn.createStatement();
		result = stmt.executeQuery("select * from BOOKS B where B.TITLE='"
						+ title + "'");

		crs.populate(result);
		out.println("I'm here");
while (crs.next()) {

%>

	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Find a Book</title>
</head>
<body>
	<%out.println(title); 
	out.println(author);
	 %>


	
<TABLE cellpadding="15" border="1" style="background-color: #ffffcc;">
<TR>
<TH> ISBN Number</TH>
<TH> Title </TH>
<TH> Author</TH>
<TH> Genre</TH>
<TH> Number of Pages </TH>
<TH> Times Borrowed</TH>
</TR>


<TR>

<TD><%=crs.getString(2)%></TD>
<TD><%=crs.getString(4)%></TD>
<TD><%=crs.getString(5)%></TD>
<TD><%=crs.getString(6)%></TD>
<TD><%=crs.getInt(7)%></TD>
<TD><%=crs.getString(8)%></TD>
</TR>
	


</TABLE>	
<%  } 
%>	
</body>
</html>

<%
	} //try
		catch (SQLException e) {
			out.print(e.getMessage());
			if (conn != null) {
				conn.close();
			}//if
		} //catch
		finally {
		if (conn != null)
			conn.close();
		} //finally
	}//if
	%>
