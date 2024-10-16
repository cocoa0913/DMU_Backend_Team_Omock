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

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "1234");

            String query = "SELECT * FROM users WHERE id = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, id);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // 로그인 성공 시 userCode와 nickname, level, cash 정보를 URL 파라미터로 전달
                int userCode = rs.getInt("user_code");
                String nickname = rs.getString("nickname");
                int level = rs.getInt("level");
                int cash = rs.getInt("cash");

                // URL 파라미터로 메인 페이지에 사용자 정보를 전달
                String redirectURL = String.format(
                    "main.jsp?userCode=%d&nickname=%s&level=%d&cash=%d",
                    userCode, nickname, level, cash
                );

                response.sendRedirect(redirectURL);
            } else {
                response.sendRedirect("login.jsp?error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
