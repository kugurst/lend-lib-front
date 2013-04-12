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
	private Connection conn;

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
		if (conn == null) {
			OracleDataSource ods;
			try {
				ods = new OracleDataSource();
				ods.setURL(connect_string);
				conn = ods.getConnection();
			} catch (SQLException e) {
				out.println(e.getMessage());
				closeConn(conn, out);
				return;
			}
		}
		// If the connection is closed, open it again.
		try {
			if (conn.isClosed()) {
				OracleDataSource ods = new OracleDataSource();
				ods.setURL(connect_string);
				conn = ods.getConnection();
			}
		} catch (SQLException e1) {
			out.println(e1.getMessage());
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
			stmt.close();
		} catch (SQLException e) {
			out.println(e.getMessage());
			closeConn(conn, out);
			return;
		}
		// If we're here, then the user didn't exist, so let's make it.
		boolean made = makeuser(request, out);
		// If the user was made, let's go to home.jsp
		if (made) {
			HttpSession session = request.getSession(true);
			session.setAttribute("sname", request.getParameter("uname"));
			// Get the user id
			try {
				stmt = conn.createStatement();
				ResultSet rset = stmt
						.executeQuery("select USERID from PERSON where PERSON.UNAME='"
								+ name + "'");
				if (rset.next()) {
					Integer uid = rset.getInt(1);
					session.setAttribute("suid", uid);
				}
			} catch (SQLException e) {
				System.out.println(e.getMessage());
				closeConn(conn, out);
				return;
			}
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
				conn.close();
			} catch (SQLException e) {
				out.println(e.getMessage());
			}
		}
	}

	private boolean makeuser(HttpServletRequest request, PrintWriter out) {
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
		// Make a statement to execute the query
		try {
			Statement stmt = conn.createStatement();
			stmt.executeUpdate(query);
			stmt.close();
			conn.commit();
		} catch (SQLException e) {
			System.out.println(e.getMessage());
			return false;
		}
		return true;
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
