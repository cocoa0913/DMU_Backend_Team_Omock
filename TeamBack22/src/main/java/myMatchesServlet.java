import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/myMatchesServlet")
public class myMatchesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userCode") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userCode = (int) session.getAttribute("userCode");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");

            // 대전 기록 쿼리
            String query = "SELECT gl.game_time, gl.winner_code, gl.loser_code, u1.nickname AS opponent " +
                           "FROM game_logs gl " +
                           "JOIN users u1 ON (gl.winner_code = u1.user_code OR gl.loser_code = u1.user_code) " +
                           "WHERE (gl.winner_code = ? OR gl.loser_code = ?) " +
                           "AND u1.user_code != ? " +
                           "ORDER BY gl.game_time DESC";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, userCode);
            stmt.setInt(2, userCode);
            stmt.setInt(3, userCode);
            ResultSet rs = stmt.executeQuery();

            // 결과를 JSP로 전달
            request.setAttribute("matchResults", rs);
            request.getRequestDispatcher("myMatches.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("main.jsp");
        }
    }
}
