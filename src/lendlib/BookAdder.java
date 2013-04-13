package lendlib;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import oracle.jdbc.pool.OracleDataSource;

/**
 * Servlet implementation class BookAdder
 */
@WebServlet(description = "Adds a book to the library under the current user", urlPatterns = { "/addbook" })
public class BookAdder extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String connect_string = "jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111f.cs.columbia.edu:1521/ADB";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public BookAdder() {
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
			MakeUser.closeConn(conn, out);
			return;
		}
		// Make sure ISBN is 13 digits
		if (request.getParameter("isbn").length() != 13) {
			request.getSession().setAttribute("badbook", true);
			MakeUser.closeConn(conn, out);
			response.sendRedirect("home.jsp");
			return;
		}
		// Check to see if the number of pages was set
		String pagenum = request.getParameter("pagenum");
		String query = "";
		// If pagenum is only a number
		if (pagenum.matches("^\\d+$"))
			query = "insert into BOOKS (ISBN, TITLE, AUTHOR, GENRE, NUMOFPAGES, OWNERID) values ("
					+ request.getParameter("isbn")
					+ ", '"
					+ request.getParameter("title")
					+ "', '"
					+ request.getParameter("author")
					+ "', '"
					+ request.getParameter("genre")
					+ "', "
					+ request.getParameter("pagenum")
					+ ", "
					+ request.getSession().getAttribute("suid") + ")";
		else
			query = "insert into BOOKS (ISBN, TITLE, AUTHOR, GENRE, OWNERID) values ("
					+ request.getParameter("isbn")
					+ ", '"
					+ request.getParameter("title")
					+ "', '"
					+ request.getParameter("author")
					+ "', '"
					+ request.getParameter("genre")
					+ "', "
					+ request.getSession().getAttribute("suid") + ")";
		Statement stmt;
		try {
			stmt = conn.createStatement();
			int result = stmt.executeUpdate(query);
			// check to make sure that there was a result
			if (result == 0)
				request.getSession().setAttribute("badbook", true);
		} catch (SQLException e) {
			System.out.println(e.getMessage());
			MakeUser.closeConn(conn, out);
			return;
		}
		MakeUser.closeConn(conn, out);
		response.sendRedirect("home.jsp");
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
