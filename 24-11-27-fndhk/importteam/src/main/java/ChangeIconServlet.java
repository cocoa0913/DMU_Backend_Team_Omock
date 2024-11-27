import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ChangeIconServlet")
public class ChangeIconServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userCode = request.getParameter("userCode");
        String iconCode = request.getParameter("iconCode");
        String nickname = request.getParameter("nickname");
        String level = request.getParameter("level");
        String cash = request.getParameter("cash");

        if (userCode == null || iconCode == null) {
            response.sendRedirect("main.jsp?error=missingParameters");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");

            // users 테이블의 icon_code 업데이트
            String updateQuery = "UPDATE users SET icon_code = ? WHERE user_code = ?";
            PreparedStatement stmt = conn.prepareStatement(updateQuery);
            stmt.setInt(1, Integer.parseInt(iconCode));
            stmt.setInt(2, Integer.parseInt(userCode));
            int rowsUpdated = stmt.executeUpdate();

            stmt.close();
            conn.close();

            if (rowsUpdated > 0) {
                // 변경 성공: changeIcon.jsp로 리다이렉트
                String redirectUrl = String.format("changeIcon.jsp?userCode=%s&nickname=%s&level=%s&cash=%s&success=true", 
                                                   userCode, nickname, level, cash);
                response.sendRedirect(redirectUrl);
            } else {
                // 변경 실패: main.jsp로 리다이렉트
                response.sendRedirect("main.jsp?error=updateFailed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("main.jsp?error=serverError");
        }
    }
}