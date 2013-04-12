package lendlib;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Arrays;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = new PrintWriter(response.getOutputStream());
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
				return;
			}
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
				response.sendRedirect("signup.jsp");
				return;
			}
		} catch (SQLException e) {
			out.println(e.getMessage());
			return;
		}
		// If we're here, then the user didn't exist, so let's make it.
		makeuser(request.getParameterMap());
		response.setContentType("text/html");
		out.println("<!DOCTYPE html>\n" + "<html>\n" + "<head>\n"
				+ "<meta charset=\"ISO-8859-1\">\n"
				+ "<title>Lib: Processing...</title>\n" + "</head>\n"
				+ "<body>\n" + "\t<table>");
		for (Entry<String, String[]> m : request.getParameterMap().entrySet())
			out.println("\t\t<tr><td>" + m.getKey() + ": "
					+ Arrays.toString(m.getValue()) + "</td></tr>");
		out.println("\t\t<tr><td>Session name: "
				+ request.getSession().getAttribute("sname") + "</td></tr>");
		out.println("\t</table>\n" + "</body>\n" + "</html>");
		out.close();
	}

	private void makeuser(Map<String, String[]> parameterMap) {

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
