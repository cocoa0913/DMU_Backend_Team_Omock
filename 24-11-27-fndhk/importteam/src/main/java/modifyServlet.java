import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/modifyServlet")
public class modifyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // 한글 인코딩 설정
        String userCode = request.getParameter("userCode");
        String newNickname = request.getParameter("newNickname");
        String level = request.getParameter("level");
        String cash = request.getParameter("cash");

        // 파라미터 유효성 검사
        if (userCode == null || userCode.trim().isEmpty() || newNickname == null || newNickname.trim().isEmpty()) {
            response.sendRedirect("modify.jsp?userCode=" + userCode + "&error=닉네임을 입력해주세요");
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // 데이터베이스 연결
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/gomoku_db?useUnicode=true&characterEncoding=utf8", "root", "password");

            // 닉네임 업데이트 쿼리
            String updateQuery = "UPDATE users SET nickname = ? WHERE user_code = ?";
            stmt = conn.prepareStatement(updateQuery);
            stmt.setString(1, newNickname);
            stmt.setInt(2, Integer.parseInt(userCode));

            int rowsUpdated = stmt.executeUpdate();

            // 업데이트 결과에 따른 처리
            if (rowsUpdated > 0) {
                // 닉네임 변경 성공 시 JavaScript 팝업과 로그아웃 처리
                response.setContentType("text/html;charset=UTF-8");
                response.getWriter().write(
                    "<script>" +
                        "alert('변경 완료! 다시 로그인 해주세요!');" +
                        "window.location.href = 'LogoutServlet';" +
                    "</script>"
                );
                response.sendRedirect("myPage.jsp?userCode=" + userCode + "&nickname=" + newNickname + "&level=" + level + "&cash=" + cash);
            } else {
                response.sendRedirect("modify.jsp?userCode=" + userCode + "&error=사용자 정보를 찾을 수 없습니다");
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("modify.jsp?userCode=" + userCode + "&error=JDBC 드라이버를 찾을 수 없습니다");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("modify.jsp?userCode=" + userCode + "&error=DB 처리 중 오류가 발생했습니다");
        } finally {
            // 연결 닫기
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ignored) {
            }
        }
    }
}
