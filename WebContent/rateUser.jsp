<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

<p> Enter the username of the user you wish to rate: </p> 
  <form method=post action="rateUser.jsp">
		<p>
			User: <input type="text" name="title" size="20"
				maxlength="50" >
		</p>
<p> What rating would you like to give this User? </p>
	<select name ="Rating">
	<option value=1>1</option>
	<option value=2>2</option>
	<option value=3>3</option>
	<option value=4>4</option>
	<option value=5>5</option>
	<option value=6>6</option>
	<option value=7>7</option>
	<option value=8>8</option>
	<option value=9>9</option>
	<option value=10>10</option>
	</select>		
		<P><P>
		<input type=submit>
	</form>

</body>
</html>
