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

@WebServlet("/EnterRoomServlet")
public class EnterRoomServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String roomIdParam = request.getParameter("roomId");
        String userCodeParam = request.getParameter("userCode");

        if (roomIdParam == null || userCodeParam == null) {
            response.sendRedirect("findRoom.jsp?error=missingParameters");
            return;
        }

        int roomId = Integer.parseInt(roomIdParam);
        int userCode = Integer.parseInt(userCodeParam);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");

            // 방 정보 업데이트
            String query = "UPDATE rooms SET participant_code = ? WHERE room_id = ? AND participant_code IS NULL";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, userCode);
            stmt.setInt(2, roomId);
            int updatedRows = stmt.executeUpdate();

            if (updatedRows > 0) {
                // WebSocket 서버로 참여자 수 업데이트 메시지 전송
                GameWebSocket.broadcastRoomUpdate(String.valueOf(roomId));

                response.sendRedirect("waitingRoom.jsp?roomId=" + roomId + "&userCode=" + userCode);
            } else {
                response.sendRedirect("findRoom.jsp?error=roomFull");
            }

            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("findRoom.jsp?error=serverError");
        }
    }
}
