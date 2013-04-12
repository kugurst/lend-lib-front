package lendlib;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import oracle.jdbc.pool.OracleDataSource;

/**
 * Servlet implementation class MakeUser
 */
@WebServlet("/makeuser")
public class MakeUser extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String connect_string = "jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111c.cs.columbia.edu:1521/ADB";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public MakeUser() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = new PrintWriter(response.getOutputStream());
		response.setContentType("text/html");
		// Create a OracleDataSource instance and set URL if it doesn't already
		// exist
		Connection conn = null;
		OracleDataSource ods;
		try {
			ods = new OracleDataSource();
			ods.setURL(connect_string);
			conn = ods.getConnection();
		} catch (SQLException e) {
			System.out.println(e.getMessage());
			closeConn(conn, out);
			return;
		}
		// Check to see if the user already exists
		String name = request.getParameter("username");
		Statement stmt;
		try {
			stmt = conn.createStatement();
			ResultSet rset = stmt
					.executeQuery("select UNAME from PERSON where PERSON.UNAME='"
							+ name + "'");
			// If the below is true, then there's already a person with that
			// user name.
			if (rset.next()) {
				request.getSession(true).setAttribute("badsignup", true);
				closeConn(conn, out);
				response.sendRedirect("signup.jsp");
				return;
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
			closeConn(conn, out);
			return;
		}
		// If we're here, then the user didn't exist, so let's make it.
		Boolean made = false;
		Integer uid = null;
		try {
			uid = makeuser(request, out, stmt);
			made = true;
		} catch (SQLException e1) {
			// Let's defer returning until we check the status of made
			System.out.println(e1.getMessage());
		}
		// If the user was made, let's go to home.jsp
		if (made) {
			// Set the session variables
			HttpSession session = request.getSession(true);
			session.setAttribute("sname", request.getParameter("uname"));
			session.setAttribute("suid", uid);
			// Go to the home page if successful with the new credentials
			closeConn(conn, out);
			response.sendRedirect("home.jsp");
		} else {
			// Otherwise, let's go back to the signup page
			request.getSession(true).setAttribute("badsignup", true);
			closeConn(conn, out);
			response.sendRedirect("signup.jsp");
		}
	}

	public static void closeConn(Connection conn, PrintWriter out) {
		if (conn != null) {
			try {
				conn.commit();
			} catch (SQLException e) {
				System.out.println(e.getMessage());
			}
			try {
				conn.close();
			} catch (SQLException e) {
				System.out.println(e.getMessage());
			}
		}
	}

	private int makeuser(HttpServletRequest request, PrintWriter out,
			Statement stmt) throws SQLException {
		// Format the query
		String query = "insert into PERSON (uname, name, state, password, city, country) VALUES ('"
				+ request.getParameter("uname")
				+ "', '"
				+ request.getParameter("name")
				+ "', '"
				+ request.getParameter("state")
				+ "', '"
				+ request.getParameter("password")
				+ "', '"
				+ request.getParameter("city")
				+ "', '"
				+ request.getParameter("country") + "')";
		// execute the query
		stmt.executeUpdate(query);
		// Get the generated ID of the user
		ResultSet rset = stmt
				.executeQuery("select USERID from PERSON where PERSON.UNAME='"
						+ request.getParameter("uname") + "'");
		rset.next();
		int id = rset.getInt(1);
		return id;
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
