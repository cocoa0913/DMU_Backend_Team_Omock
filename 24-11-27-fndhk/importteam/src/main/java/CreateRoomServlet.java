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

@WebServlet("/CreateRoomServlet")
public class CreateRoomServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userCodeParam = request.getParameter("userCode");
        String roomTitle = request.getParameter("roomTitle");
        String roomPassword = request.getParameter("roomPassword");

        // 디버깅: 전달받은 파라미터 로그 출력
        System.out.println("Received userCode: " + userCodeParam);
        System.out.println("Received roomTitle: " + roomTitle);
        System.out.println("Received roomPassword: " + roomPassword);

        if (userCodeParam == null || roomTitle == null || roomTitle.isEmpty()) {
            response.sendRedirect("createRoom.jsp?error=missingParameters");
            return;
        }

        int userCode;
        try {
            userCode = Integer.parseInt(userCodeParam);
        } catch (NumberFormatException e) {
            response.sendRedirect("createRoom.jsp?error=invalidUserCode");
            return;
        }

        int roomId = 0;

        try {
            // 데이터베이스 연결
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");

            // 방 생성 SQL 실행
            String query = "INSERT INTO rooms (room_title, room_password, owner_code, is_private) VALUES (?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS);
            stmt.setString(1, roomTitle);
            stmt.setString(2, roomPassword != null && !roomPassword.isEmpty() ? roomPassword : null);
            stmt.setInt(3, userCode);
            stmt.setBoolean(4, roomPassword != null && !roomPassword.isEmpty());
            stmt.executeUpdate();

            // 생성된 방의 ID 가져오기
            ResultSet generatedKeys = stmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                roomId = generatedKeys.getInt(1);
            }

            stmt.close();
            conn.close();

            if (roomId > 0) {
                // 방 생성 성공 시 대기실로 이동
                response.sendRedirect("waitingRoom.jsp?roomId=" + roomId + "&userCode=" + userCode);
            } else {
                // 방 ID가 생성되지 않았을 경우 에러 처리
                response.sendRedirect("createRoom.jsp?error=creationFailed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("createRoom.jsp?error=serverError");
        }
    }
}
