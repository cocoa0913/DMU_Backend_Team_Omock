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

@WebServlet("/deleteRoomServlet")
public class DeleteRoomServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        int roomId = Integer.parseInt(request.getParameter("roomId"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");

            // 방 삭제 쿼리 실행
            String query = "DELETE FROM rooms WHERE room_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, roomId);
            stmt.executeUpdate();

            // 방 삭제 후 세션에서 roomId 제거
            session.removeAttribute("roomId");

            // 삭제 후 메인 페이지로 리다이렉트
            response.sendRedirect("main.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
