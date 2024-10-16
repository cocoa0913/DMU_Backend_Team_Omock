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

@WebServlet("/FriendAddServlet")
public class FriendAddServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int userCode = (int) session.getAttribute("userCode");
        String friendNickname = request.getParameter("friendNickname");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "1234");

            // 친구 닉네임으로 user_code 찾기
            String friendQuery = "SELECT user_code FROM users WHERE nickname = ?";
            PreparedStatement friendStmt = conn.prepareStatement(friendQuery);
            friendStmt.setString(1, friendNickname);
            ResultSet rs = friendStmt.executeQuery();

            if (rs.next()) {
                int friendCode = rs.getInt("user_code");

                // 친구 추가
                String addFriendQuery = "INSERT INTO friends (user_code, friend_code, status) VALUES (?, ?, 'pending')";
                PreparedStatement addFriendStmt = conn.prepareStatement(addFriendQuery);
                addFriendStmt.setInt(1, userCode);
                addFriendStmt.setInt(2, friendCode);
                addFriendStmt.executeUpdate();

                response.sendRedirect("friends.jsp?success=1");
            } else {
                response.sendRedirect("friends.jsp?error=userNotFound");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
