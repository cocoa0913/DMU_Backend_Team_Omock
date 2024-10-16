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

@WebServlet("/EnterRoomServlet")
public class EnterRoomServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        String roomPassword = request.getParameter("roomPassword");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "1234");

            String query = "SELECT * FROM rooms WHERE room_id = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, roomId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String dbPassword = rs.getString("room_password");
                boolean isPrivate = rs.getBoolean("is_private");

                if (isPrivate && (roomPassword == null || !roomPassword.equals(dbPassword))) {
                    response.sendRedirect("findRoom.jsp?error=wrongPassword");
                    return;
                }

                HttpSession session = request.getSession();
                session.setAttribute("roomId", roomId);
                response.sendRedirect("game.jsp");
            } else {
                response.sendRedirect("findRoom.jsp?error=noRoomFound");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
