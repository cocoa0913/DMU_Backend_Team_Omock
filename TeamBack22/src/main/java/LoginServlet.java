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

        // 디버깅 로그
        System.out.println("Received ID: " + id);
        System.out.println("Received Password: " + password);

        if (id == null || password == null || id.isEmpty() || password.isEmpty()) {
            response.sendRedirect("login.jsp?error=emptyFields");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");

            String query = "SELECT * FROM users WHERE id = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(query);

            // 디버깅 로그
            System.out.println("Executing Query: " + query);

            stmt.setString(1, id);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                System.out.println("로그인 성공");

                int userCode = rs.getInt("user_code");
                String nickname = rs.getString("nickname");
                int level = rs.getInt("level");
                int cash = rs.getInt("cash");
                int iconCode = rs.getInt("icon_code");

                String redirectURL = String.format(
                    "main.jsp?userCode=%d&nickname=%s&level=%d&cash=%d&iconCode=%d",
                    userCode, nickname, level, cash, iconCode
                );

                response.sendRedirect(redirectURL);
            } else {
                System.out.println("로그인 실패: 잘못된 ID 또는 비밀번호");
                response.sendRedirect("login.jsp?error=invalidCredentials");
            }

            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=serverError");
        }
    }
}
