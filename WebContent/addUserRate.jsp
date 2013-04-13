<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="oracle.jdbc.pool.OracleDataSource"%>
<%@ page import="com.sun.rowset.CachedRowSetImpl" %>


<!-- Getting the input that was submitted -->
	<%
	String user = request.getParameter("user");
	String rating = request.getParameter("rating");
	String comment = request.getParameter("comments");
	Object suid = session.getAttribute("suid");
	System.out.println(suid);
	System.out.println(rating);
	System.out.println(comment);
	System.out.println(user);
	int temp = 5; 
	int rateeID = 0 ; 
	%>
	
	
	<%
	if (rateeID == 0){
		Connection conn = null;
		ResultSet result = null;
		try {
		OracleDataSource ods = new OracleDataSource();
		ods.setURL("jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111c.cs.columbia.edu:1521/ADB");
		conn = ods.getConnection();
		Statement stmt = conn.createStatement();
		result = stmt.executeQuery("select * from PERSON P where P.Uname='"
						+ user + "'");
		
		if (result.next())
		{
			//rateeID = result.getInt(1); 
			//out.println(result.getInt(1));
			//out.println(result.getString(2));
			rateeID = result.getInt(1); 
			//out.println("this is the answer: ");
			//out.println(suid);
			//out.println(user);
			//out.println(rating);
			//out.println(comment);
			//out.println(rateeID);
		}	
		String query = "INSERT into PersonRatings Values ('"+suid+"','"+rateeID+"','"+rating+"','"+comment+"')";
		if (stmt.executeUpdate(query) >0)
			out.println("Record inserted"); 
		else 
			out.println("Record insertion failed");

%>
<%
out.println("I'm here");
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
		response.sendRedirect("dupRate.jsp");
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
