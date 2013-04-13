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

import oracle.jdbc.pool.OracleDataSource;

/**
 * Servlet implementation class Confirm
 */
@WebServlet(description = "Confirms trades and returns", urlPatterns = { "/confirm" })
public class Confirm extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String connect_string = "jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111c.cs.columbia.edu:1521/ADB";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Confirm() {
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

		// If this book is in lends, then we want to drop it
		String query = "select * from LENDS where LENDS.BOOKID = "
				+ request.getParameter("bid");
		Statement stmt = null;
		ResultSet rset = null;
		boolean inLends = false;
		try {
			stmt = conn.createStatement();
			rset = stmt.executeQuery(query);
			inLends = rset.next();
		} catch (SQLException e) {
			System.out.println(e.getMessage());
			MakeUser.closeConn(conn, out);
			return;
		}
		// Drop the book
		if (inLends) {
			query = "delete from LENDS where BOOKID = "
					+ request.getParameter("bid");
			try {
				int rows = stmt.executeUpdate(query);
				// Something went wrong with dropping the book.
				if (rows < 1) {
					request.getSession().setAttribute("baddrop", true);
					MakeUser.closeConn(conn, out);
					response.sendRedirect(request.getHeader("referer"));
					return;
				}
				// We successfully dropped the book. Delete the entry in the
				// pending table
				query = "delete from PendingTrade where bookid = "
						+ request.getParameter("bid");
				rows = stmt.executeUpdate(query);
				if (rows < 1) {
					request.getSession().setAttribute("badpenddel", true);
					MakeUser.closeConn(conn, out);
					response.sendRedirect(request.getHeader("referer"));
				}
				// If we're here, then we dropped the lends successfully and
				// dropped
				// from the pending successfully. Let's say so
				request.getSession().setAttribute("handshake", true);
				MakeUser.closeConn(conn, out);
				response.sendRedirect(request.getHeader("referer"));
				return;
			} catch (SQLException e) {
				System.out.println(e.getMessage());
				MakeUser.closeConn(conn, out);
				return;
			}
		}
		try {
			rset.close();
		} catch (SQLException e) {
			System.out.println(e.getMessage());
			MakeUser.closeConn(conn, out);
			return;
		}
		// Otherwise, add the book to lends
		int oid = 0;
		int borrid = 0;
		try {
			oid = getIDFromUname(request.getParameter("ouname"), stmt);
			borrid = getIDFromUname(request.getParameter("buname"), stmt);
		} catch (SQLException e) {
			System.out.println(e.getMessage());
			MakeUser.closeConn(conn, out);
			return;
		}
		query = "insert into LENDS (LenderID, BorrowerID, BookID) values ("
				+ oid + ", " + borrid + ", " + request.getParameter("bid")
				+ ")";
		try {
			int rows = stmt.executeUpdate(query);
			if (rows < 1) {
				request.getSession().setAttribute("badadd", true);
				MakeUser.closeConn(conn, out);
				response.sendRedirect(request.getHeader("referer"));
				return;
			}
			// We successfully added the book. Delete the pending trade
			query = "delete from PendingTrade where bookid = "
					+ request.getParameter("bid");
			rows = stmt.executeUpdate(query);
			if (rows < 1) {
				request.getSession().setAttribute("badpenddel", true);
				MakeUser.closeConn(conn, out);
				response.sendRedirect(request.getHeader("referer"));
				return;
			}
			// If we're here, then we added the lends successfully and dropped
			// from the pending successfully. Let's say so
			request.getSession().setAttribute("handshake", true);
			MakeUser.closeConn(conn, out);
			response.sendRedirect(request.getHeader("referer"));
			return;
		} catch (SQLException e) {
			System.out.println(e.getMessage());
			MakeUser.closeConn(conn, out);
			return;
		}
	}

	public static int getIDFromUname(String uname, Statement stmt)
			throws SQLException {
		String query = "select userid from person p where p.uname='" + uname
				+ "'";
		ResultSet rset = stmt.executeQuery(query);
		rset.next();
		return Integer.parseInt(rset.getString(1));
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
