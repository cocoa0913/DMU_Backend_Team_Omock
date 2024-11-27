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
    private static final String DB_PASSWORD = "password";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userCodeParam = request.getParameter("userCode");
        String nickname = request.getParameter("nickname");
        String level = request.getParameter("level");
        String cashParam = request.getParameter("cash");
        String itemCodeParam = request.getParameter("itemCode");

        if (userCodeParam == null || nickname == null || level == null || cashParam == null || itemCodeParam == null) {
            response.sendRedirect("shop.jsp?error=missingParameters");
            return;
        }

        try {
            int userCode = Integer.parseInt(userCodeParam);
            int itemCode = Integer.parseInt(itemCodeParam);
            int currentCash = Integer.parseInt(cashParam);

            // 데이터베이스 연결
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // 아이템 가격 조회
            String itemQuery = "SELECT price FROM items WHERE item_code = ?";
            PreparedStatement itemStmt = conn.prepareStatement(itemQuery);
            itemStmt.setInt(1, itemCode);
            ResultSet itemRs = itemStmt.executeQuery();

            if (itemRs.next()) {
                int itemPrice = itemRs.getInt("price");

                if (currentCash >= itemPrice) {
                    // 캐쉬 차감 및 구매 처리
                    String updateCashQuery = "UPDATE users SET cash = cash - ? WHERE user_code = ?";
                    PreparedStatement updateCashStmt = conn.prepareStatement(updateCashQuery);
                    updateCashStmt.setInt(1, itemPrice);
                    updateCashStmt.setInt(2, userCode);
                    updateCashStmt.executeUpdate();

                    String insertItemQuery = "INSERT INTO user_items (user_code, item_code, acquired_date) VALUES (?, ?, NOW())";
                    PreparedStatement insertItemStmt = conn.prepareStatement(insertItemQuery);
                    insertItemStmt.setInt(1, userCode);
                    insertItemStmt.setInt(2, itemCode);
                    insertItemStmt.executeUpdate();

                    // 구매 성공, 남은 캐쉬 계산
                    currentCash -= itemPrice;
                    String redirectURL = String.format("shop.jsp?userCode=%d&nickname=%s&level=%s&cash=%d&error=notEnoughCash", userCode, nickname, level, currentCash);
                    response.sendRedirect(redirectURL);
                } else {
                    // 캐쉬 부족
                    String redirectURL = String.format("shop.jsp?userCode=%d&nickname=%s&level=%s&cash=%d&error=notEnoughCash", userCode, nickname, level, currentCash);
                    response.sendRedirect(redirectURL);
                }
            } else {
                // 아이템이 존재하지 않을 경우
                response.sendRedirect("shop.jsp?userCode=" + userCode + "&nickname=" + nickname + "&level=" + level + "&cash=" + currentCash + "&error=itemNotFound");
            }

            // 자원 정리
            itemRs.close();
            itemStmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("shop.jsp?error=serverError");
        }
    }
}
