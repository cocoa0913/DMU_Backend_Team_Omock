import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userCode = Integer.parseInt(request.getParameter("userCode"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");

            // 회원 강제 탈퇴 (회원 삭제)
            String query = "DELETE FROM users WHERE user_code = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, userCode);
            stmt.executeUpdate();

            // 해당 회원과 관련된 다른 테이블의 정보도 삭제해야 할 경우 처리 추가
            // 예: DELETE FROM game_logs WHERE player1_code = ? OR player2_code = ?

            response.sendRedirect("adminPanel.jsp?success=1");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminPanel.jsp?error=1");
        }
    }
}
