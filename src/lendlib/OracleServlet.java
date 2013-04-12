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
 * Servlet implementation class OracleServlet
 */
@WebServlet("/OracleServlet")
public class OracleServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String connect_string = "jdbc:oracle:thin:ma2799/EiVQBUGs@//w4111c.cs.columbia.edu:1521/ADB";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public OracleServlet() {
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
		PrintWriter pw = new PrintWriter(response.getOutputStream());
		Connection conn = null;
		try {
			if (conn == null) {
				// Create a OracleDataSource instance and set URL
				OracleDataSource ods = new OracleDataSource();
				ods.setURL(connect_string);
				conn = ods.getConnection();
			}
			Statement stmt = conn.createStatement();
			ResultSet rset = stmt.executeQuery("select UNAME from PERSON");
			response.setContentType("text/html");
			pw.println("<html>");
			pw.println("<head><title>Person Table Servlet Sample</title></head>");
			pw.println("<H1>Show Person Table Data <BR></H1>");
			pw.println("<body><BR>");
			while (rset.next()) {
				pw.println(rset.getString("uname") + "<BR>");
			}
			pw.println("</body></html>");
		} catch (SQLException e) {
			pw.println(e.getMessage());
		}
		pw.close();
		MakeUser.closeConn(conn, pw);
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