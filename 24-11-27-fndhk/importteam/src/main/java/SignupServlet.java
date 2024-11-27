import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.DriverManager;
import java.sql.ResultSet;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String password = request.getParameter("password");
        String nickname = request.getParameter("nickname");

        try {
            // DB 연결
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");

            // ID 중복 체크
            String checkIdQuery = "SELECT COUNT(*) FROM users WHERE id = ?";
            PreparedStatement checkIdStmt = conn.prepareStatement(checkIdQuery);
            checkIdStmt.setString(1, id);
            ResultSet rsId = checkIdStmt.executeQuery();
            rsId.next();

            // 닉네임 중복 체크
            String checkNicknameQuery = "SELECT COUNT(*) FROM users WHERE nickname = ?";
            PreparedStatement checkNicknameStmt = conn.prepareStatement(checkNicknameQuery);
            checkNicknameStmt.setString(1, nickname);
            ResultSet rsNickname = checkNicknameStmt.executeQuery();
            rsNickname.next();

            boolean idExists = rsId.getInt(1) > 0;
            boolean nicknameExists = rsNickname.getInt(1) > 0;

            // 중복된 항목에 대해 오류 처리
            if (idExists && nicknameExists) {
                request.setAttribute("error", "ID와 닉네임이 모두 이미 존재합니다.");
            } else if (idExists) {
                request.setAttribute("error", "이미 존재하는 ID입니다.");
            } else if (nicknameExists) {
                request.setAttribute("error", "이미 존재하는 닉네임입니다.");
            } else {
                // 새로운 계정 삽입
                String insertQuery = "INSERT INTO users (id, password, nickname) VALUES (?, ?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertQuery, PreparedStatement.RETURN_GENERATED_KEYS);
                insertStmt.setString(1, id);
                insertStmt.setString(2, password);
                insertStmt.setString(3, nickname);
                insertStmt.executeUpdate();

                // 생성된 user_code 가져오기
                ResultSet generatedKeys = insertStmt.getGeneratedKeys();
                int userCode = -1;
                if (generatedKeys.next()) {
                    userCode = generatedKeys.getInt(1);
                }

                // 기본 아이템 추가
                if (userCode != -1) {
                    String insertItemQuery = "INSERT INTO user_items (user_code, item_code, acquired_date) VALUES (?, ?, NOW())";
                    PreparedStatement insertItemStmt = conn.prepareStatement(insertItemQuery);
                    insertItemStmt.setInt(1, userCode); // 회원가입 시 생성된 user_code
                    insertItemStmt.setInt(2, 1); // 기본 아이템의 item_code (1)
                    insertItemStmt.executeUpdate();
                }

                // 회원가입 성공 시 로그인 페이지로 이동
                response.sendRedirect("login.jsp");
                return;
            }

            // 중복된 ID나 닉네임이 있을 경우, signup.jsp로 다시 이동
            request.setAttribute("id", id);
            request.setAttribute("nickname", nickname);
            request.getRequestDispatcher("signup.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // 오류 발생 시에도 로그인 페이지로 이동
            response.sendRedirect("login.jsp");
        }
    }
}
