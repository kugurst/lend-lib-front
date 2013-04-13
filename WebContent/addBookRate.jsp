<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<%@ page import="com.sun.rowset.CachedRowSetImpl" %>

<!-- Getting the input that was submitted -->
	<%
	String title = request.getParameter("title");
	String author = request.getParameter("author");
	String rating = request.getParameter("rating");
	String comment = request.getParameter("comments");
	Object suid = session.getAttribute("suid");
	//int temp = 3; 
	int bookID =0;
	String ISBN = null;
	%>

	<%
	if (bookID == 0){
		Connection conn = null;
		ResultSet result = null;
		try {
		OracleDataSource ods = new OracleDataSource();
		ods.setURL("jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111c.cs.columbia.edu:1521/ADB");
		conn = ods.getConnection();
		Statement stmt = conn.createStatement();
		result = stmt.executeQuery("select * from BOOKS B where B.AUTHOR='"
				+ author + "' AND B.TITLE='" + title + "'");
	
		if (result.next())
		{
			bookID = result.getInt(1); 
			//out.println(result.getInt(1));
			//out.println(result.getString(2));
			bookID = result.getInt(1); 
			ISBN = result.getString(2);
			//out.println(suid);
			//out.println(title);
			//out.println(author);
			//out.println(rating);
			//out.println(comment);
			//out.println(bookID);
			//out.println(ISBN);
			}	
	String query = "INSERT into BookRatings Values ('"+suid+"','"+bookID+"','"+ISBN+"','"+rating+"','"+comment+"')";
		if (stmt.executeUpdate(query) >0)
			out.println("Record inserted"); 
		else 
			out.println("Record insertion failed");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<p>
		To return to the ratings page <a href="rate.jsp">click here</a> to sign up.
	</p>
	<p>
		To return home <a href="home.jsp">click here</a> to log in.
	</p>
</body>
</html>


<% } //try
	
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
