import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/GameResultServlet")
public class GameResultServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int player1Code = (int) session.getAttribute("player1Code");
        int player2Code = (int) session.getAttribute("player2Code");
        String winner = request.getParameter("winner");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");

            int winnerCode = winner.equals("black") ? player1Code : player2Code;
            int loserCode = winner.equals("black") ? player2Code : player1Code;

            String query = "INSERT INTO game_logs (player1_code, player2_code, winner_code, loser_code) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, player1Code);
            stmt.setInt(2, player2Code);
            stmt.setInt(3, winnerCode);
            stmt.setInt(4, loserCode);
            stmt.executeUpdate();

            updateWinLoss(conn, winnerCode, loserCode);
            response.sendRedirect("main.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void updateWinLoss(Connection conn, int winnerCode, int loserCode) throws Exception {
        String updateWinner = "UPDATE users SET win_count = win_count + 1, experience = experience + 20 WHERE user_code = ?";
        PreparedStatement stmtWinner = conn.prepareStatement(updateWinner);
        stmtWinner.setInt(1, winnerCode);
        stmtWinner.executeUpdate();

        String updateLoser = "UPDATE users SET lose_count = lose_count + 1, experience = experience + 5 WHERE user_code = ?";
        PreparedStatement stmtLoser = conn.prepareStatement(updateLoser);
        stmtLoser.setInt(1, loserCode);
        stmtLoser.executeUpdate();
    }
}
