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
 * Servlet implementation class ReturnBook
 */
@WebServlet(description = "Initiates a book return by adding the return to pending trades", urlPatterns = { "/return" })
public class ReturnBook extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String connect_string = "jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111c.cs.columbia.edu:1521/ADB";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ReturnBook() {
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
		// We're going to add this book, owner, and borrower to pendingtrade
		Statement stmt = null;
		int ownerID = -1;
		try {
			stmt = conn.createStatement();
			ownerID = Confirm.getIDFromUname(request.getParameter("ouname"),
					stmt);
		} catch (SQLException e) {
			System.out.println(e.getMessage());
			MakeUser.closeConn(conn, out);
			return;
		}
		// Format the string
		String query = "insert into PendingTrade (OwnerID, BorrowerID, BookID) values ("
				+ ownerID
				+ ", "
				+ request.getParameter("borruid")
				+ ", "
				+ request.getParameter("bid") + ")";
		// Send the update
		try {
			int rows = stmt.executeUpdate(query);
			if (rows < 1) {
				request.getSession().setAttribute("badpendadd", true);
				MakeUser.closeConn(conn, out);
				response.sendRedirect(request.getHeader("referer"));
				return;
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
			request.getSession().setAttribute("badpendadd", true);
			MakeUser.closeConn(conn, out);
			response.sendRedirect(request.getHeader("referer"));
			return;
		}
		// At this point, the query was completed successfully, so inform the
		// referer as such
		request.getSession().setAttribute("goodReturn", true);
		MakeUser.closeConn(conn, out);
		response.sendRedirect(request.getHeader("referer"));
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
