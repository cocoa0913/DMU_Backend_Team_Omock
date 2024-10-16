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

@WebServlet("/CreateRoomServlet")
public class CreateRoomServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userCode") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String roomTitle = request.getParameter("roomTitle");
        String roomPassword = request.getParameter("roomPassword");
        int ownerCode = (int) session.getAttribute("userCode");
        int roomId = 0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "1234");

            // 방 생성 쿼리 실행
            String query = "INSERT INTO rooms (room_title, room_password, owner_code, is_private) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS);
            stmt.setString(1, roomTitle);
            stmt.setString(2, roomPassword != null && !roomPassword.isEmpty() ? roomPassword : null);
            stmt.setInt(3, ownerCode);
            stmt.setBoolean(4, roomPassword != null && !roomPassword.isEmpty());
            stmt.executeUpdate();

            // 생성된 방의 ID 가져오기
            ResultSet generatedKeys = stmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                roomId = generatedKeys.getInt(1); // 방 ID
            }

            // 방에 접속한 정보를 세션에 저장
            session.setAttribute("roomId", roomId);

            // 방으로 이동
            response.sendRedirect("waitingRoom.jsp?roomId=" + roomId); // 대기실 페이지로 이동
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
