import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/DeleteFriend")
public class DeleteFriend extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
   		request.setCharacterEncoding("utf-8");
   		int userCode = Integer.parseInt(request.getParameter("userCode"));
   		int friendCode = Integer.parseInt(request.getParameter("friendCode"));
   		
   		String nickname = request.getParameter("nickname");
   		String level = request.getParameter("level");
   		String cash = request.getParameter("cash");

        try {
            // 데이터베이스 연결
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");

            // SQL 쿼리 작성 및 실행
            String sql = "DELETE FROM friends WHERE user_code = ? AND friend_Code = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userCode);
            stmt.setInt(2, friendCode);
            stmt.executeUpdate();
            
            response.sendRedirect("friends.jsp?userCode=" + userCode + "&nickname=" + nickname + "&level=" + level + "&cash=" + cash);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("friends.jsp?userCode=" + userCode + "&nickname=" + nickname + "&level=" + level + "&cash=" + cash);
        }
    }
}