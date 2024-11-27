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

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int userCode = Integer.parseInt(request.getParameter("userCode"));
        
   	 	String nickname = request.getParameter("nickname");
        String level = request.getParameter("level");
        String cash = request.getParameter("cash");
        
        String referer = request.getHeader("Referer");
        
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");

            // 외래 키 제약 비활성화
            String disableFK = "SET FOREIGN_KEY_CHECKS = 0";
            stmt = conn.prepareStatement(disableFK);
            stmt.executeUpdate();

            // 회원 강제 탈퇴 (회원 삭제)
            String query = "DELETE FROM users WHERE user_code = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, userCode);
            stmt.executeUpdate();

            // 외래 키 제약 활성화
            String enableFK = "SET FOREIGN_KEY_CHECKS = 1";
            stmt = conn.prepareStatement(enableFK);
            stmt.executeUpdate();
            
            // 해당 회원과 관련된 다른 테이블의 정보도 삭제해야 할 경우 처리 추가
            // 예: DELETE FROM game_logs WHERE player1_code = ? OR player2_code = ?
            
            response.sendRedirect(referer != null ? referer : "adminPanel.jsp?userCode=" + userCode + "&nickname=" + nickname + "&level=" + level + "&cash=" + cash);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(referer != null ? referer : "adminPanel.jsp?userCode=" + userCode + "&nickname=" + nickname + "&level=" + level + "&cash=" + cash);
        }
    }
}
