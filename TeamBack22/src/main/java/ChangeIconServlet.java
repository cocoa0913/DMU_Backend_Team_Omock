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

@WebServlet("/ChangeIconServlet")
public class ChangeIconServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userCode") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userCode = (int) session.getAttribute("userCode");
        int iconCode = Integer.parseInt(request.getParameter("iconCode"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");

            // 아이콘 코드 변경
            String query = "UPDATE users SET icon_code = ? WHERE user_code = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, iconCode);
            stmt.setInt(2, userCode);
            stmt.executeUpdate();

            response.sendRedirect("myPage.jsp?success=1");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("myPage.jsp?error=1");
        }
    }
}
