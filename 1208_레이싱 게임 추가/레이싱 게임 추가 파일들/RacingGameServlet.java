import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/RacingGameServlet")
public class RacingGameServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String userCodeParam = request.getParameter("userCode");
        String levelParam = request.getParameter("level");
        String nickname = request.getParameter("nickname");
        String cashParam = request.getParameter("cash");
        String experienceParam = request.getParameter("experience");

        if (userCodeParam == null || userCodeParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters");
            return;
        }

        int userCode = Integer.parseInt(userCodeParam);
        int currentCash = 0;
        int currentLevel = 0;
        int currentExperience = 0;

        try { currentCash = Integer.parseInt(cashParam); } catch (NumberFormatException e) {}
        try { currentLevel = Integer.parseInt(levelParam); } catch (NumberFormatException e) {}
        try { currentExperience = Integer.parseInt(experienceParam); } catch (NumberFormatException e) {}

        HttpSession session = request.getSession();
        String winner = (String) session.getAttribute("winner");

        if ("startGame".equals(action)) {
            // 500 캐쉬 차감
            if (currentCash < 500) {
                response.sendRedirect("racingGame.jsp?userCode=" + userCode +
                                      "&level=" + currentLevel +
                                      "&nickname=" + nickname +
                                      "&cash=" + currentCash +
                                      "&experience=" + currentExperience +
                                      "&error=잔액부족");
                return;
            }
            updateCash(userCode, -500);
            currentCash -= 500;

            response.sendRedirect("racingGame.jsp?action=startGame&userCode=" + userCode +
                                  "&level=" + currentLevel +
                                  "&nickname=" + nickname +
                                  "&cash=" + currentCash +
                                  "&experience=" + currentExperience);

        } else if ("guessResult".equals(action)) {
            String userGuess = request.getParameter("userGuess");
            boolean correct = (winner != null && winner.equals(userGuess));

            if (correct) {
                // 맞췄을 때: cash +500, lose_count +500, win_count +1000
                updateCash(userCode, 500);
                updateCount(userCode, "lose_count", 500);
                updateCount(userCode, "win_count", 1000);
                currentCash += 500;
            } else {
                // 틀렸을 때: cash -500, lose_count +500
                updateCash(userCode, -500);
                updateCount(userCode, "lose_count", 500);
                currentCash -= 500;
            }

            // racingGame.jsp로 correct 결과 전달
            response.sendRedirect("racingGame.jsp?action=guessResult&correct=" + correct +
                                  "&userCode=" + userCode +
                                  "&level=" + currentLevel +
                                  "&nickname=" + nickname +
                                  "&cash=" + currentCash +
                                  "&experience=" + currentExperience);
        }
    }

    private void updateCash(int userCode, int amount) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "1234")) {
                String query = "UPDATE users SET cash = cash + ? WHERE user_code = ?";
                try (PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setInt(1, amount);
                    stmt.setInt(2, userCode);
                    stmt.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void updateCount(int userCode, String columnName, int amount) {
        // columnName은 lose_count 또는 win_count
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "1234")) {
                String query = "UPDATE users SET " + columnName + " = " + columnName + " + ? WHERE user_code = ?";
                try (PreparedStatement stmt = conn.prepareStatement(query)) {
                    stmt.setInt(1, amount);
                    stmt.setInt(2, userCode);
                    stmt.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
