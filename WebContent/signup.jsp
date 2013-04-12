<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript">
	function validateForm() {
		var pass = document.forms["reg"]["password"].value;
		var vpass = document.forms["reg"]["vpassword"].value;
		if (pass != vpass) {
			alert("Your passwords do not match!");
			return false;
		}
	}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Lib: Register</title>
</head>
<body>
	<form name="reg" method=post action="makeuser"
		onsubmit="return validateForm()">
		<p>
			Choose your username: <input type="text" name="username" size="20"
				maxlength="30" required>
		</p>
		<p>
			Choose your password: <input type="password" name="password"
				size="20" maxlength="50" required>
		</p>
		<p>
			Verify your password: <input type="password" name="vpassword"
				size="20" maxlength="50" required>
		</p>
		<p>
			Choose your display name: <input type="text" name="dispname"
				size="20" maxlength="50" required>
		</p>
		<p>
			What city do you live in: <input type="text" name="city" size="20"
				maxlength="50" required>
		</p>
		<p>
			What state do you live in: <input type="text" name="state" size="20"
				maxlength="50" required>
		</p>
		<p>
			What country do you live in: <input type="text" name="country"
				size="20" maxlength="50" required>
		</p>
		<input type=submit>
	</form>
</body>
</html>