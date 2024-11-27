import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RoomStatusServlet")
public class RoomStatusServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String roomIdParam = request.getParameter("roomId");
        if (roomIdParam == null || roomIdParam.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid room ID");
            return;
        }

        int roomId = Integer.parseInt(roomIdParam);

        response.setContentType("text/plain; charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            try (
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");
                PreparedStatement stmt = conn.prepareStatement(
                    "SELECT rooms.room_title, users.nickname AS owner_name, participants.nickname AS participant_name " +
                    "FROM rooms " +
                    "LEFT JOIN users ON rooms.owner_code = users.user_code " +
                    "LEFT JOIN users AS participants ON rooms.participant_code = participants.user_code " +
                    "WHERE rooms.room_id = ?"
                );
            ) {
                stmt.setInt(1, roomId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        String roomTitle = rs.getString("room_title");
                        String ownerName = rs.getString("owner_name");
                        String participantName = rs.getString("participant_name");

                        out.println("Room Title: " + roomTitle);
                        out.println("Owner: " + ownerName);
                        if (participantName != null) {
                            out.println("Participant: " + participantName);
                        } else {
                            out.println("Participant: Waiting for someone to join...");
                        }
                    } else {
                        out.println("Room not found");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.println("Error retrieving room status");
            }
        }
    }
}
