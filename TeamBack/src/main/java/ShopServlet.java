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

@WebServlet("/ShopServlet")
public class ShopServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/gomoku_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "password";  // 본인의 MySQL 비밀번호 사용
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        int userCode = (int) session.getAttribute("userCode");
        int itemCode = Integer.parseInt(request.getParameter("itemCode"));

        try {
            // MySQL 드라이버 로드 및 데이터베이스 연결
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // 광고제거권 코드 (아이템 테이블에서의 코드)
            final int AD_REMOVE_ITEM_CODE = 7777;  // 광고 제거권 코드

            if (itemCode == AD_REMOVE_ITEM_CODE) {
                // 사용자가 이미 광고제거권을 구매했는지 확인
                String checkQuery = "SELECT * FROM user_items WHERE user_code = ? AND item_code = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
                checkStmt.setInt(1, userCode);
                checkStmt.setInt(2, itemCode);
                ResultSet checkRs = checkStmt.executeQuery();

                if (checkRs.next()) {
                    // 이미 광고제거권을 소유한 경우
                    response.sendRedirect("shop.jsp?error=alreadyRemoved");
                } else {
                    // 사용자의 캐쉬 확인
                    String userQuery = "SELECT cash FROM users WHERE user_code = ?";
                    PreparedStatement userStmt = conn.prepareStatement(userQuery);
                    userStmt.setInt(1, userCode);
                    ResultSet userRs = userStmt.executeQuery();

                    if (userRs.next()) {
                        int currentCash = userRs.getInt("cash");

                        if (currentCash >= 7777) {
                            // 캐쉬 차감 후 광고제거권 지급
                            String updateCashQuery = "UPDATE users SET cash = cash - 7777 WHERE user_code = ?";
                            PreparedStatement updateCashStmt = conn.prepareStatement(updateCashQuery);
                            updateCashStmt.setInt(1, userCode);
                            updateCashStmt.executeUpdate();

                            // user_items 테이블에 광고제거권 추가
                            String addItemQuery = "INSERT INTO user_items (user_code, item_code) VALUES (?, ?)";
                            PreparedStatement addItemStmt = conn.prepareStatement(addItemQuery);
                            addItemStmt.setInt(1, userCode);
                            addItemStmt.setInt(2, itemCode);
                            addItemStmt.executeUpdate();

                            response.sendRedirect("shop.jsp?success=adsRemoved");
                        } else {
                            // 캐쉬 부족
                            response.sendRedirect("shop.jsp?error=notEnoughCash");
                        }
                    }
                }
            } else {
                // 일반 아이템 구매 처리
                // 기존 로직에 따라 처리
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("shop.jsp?error=server");
        }
    }
}
