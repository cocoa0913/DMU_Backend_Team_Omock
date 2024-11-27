import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ChangeIconServlet")
public class ChangeIconServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	String userCode = request.getParameter("userCode");
        String iconCode = request.getParameter("iconCode");
        String nickname = request.getParameter("nickname");
        String level = request.getParameter("level");
        String cash = request.getParameter("cash");

        if (userCode == null || iconCode == null) {
        	response.sendRedirect("main.jsp?userCode=" + userCode + "&nickname=" + nickname + "&level=" + level + "&cash=" + cash);
            return;
        }

        try {
            // 데이터베이스 연결
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");

            // 아이콘 코드 업데이트
            String updateQuery = "UPDATE users SET icon_code = ? WHERE user_code = ?";
            PreparedStatement stmt = conn.prepareStatement(updateQuery);
            stmt.setInt(1, Integer.parseInt(iconCode));
            stmt.setInt(2, Integer.parseInt(userCode));

            int rowsUpdated = stmt.executeUpdate();

            stmt.close();
            

            if (rowsUpdated > 0) {
                response.sendRedirect("main.jsp?userCode=" + userCode + "&nickname=" + nickname + "&level=" + level + "&cash=" + cash);
            } else {
                // 실패 시
            	response.sendRedirect("main.jsp?userCode=" + userCode + "&nickname=" + nickname + "&level=" + level + "&cash=" + cash);
            }
            
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("main.jsp?error=serverError");
        }
    }

}
