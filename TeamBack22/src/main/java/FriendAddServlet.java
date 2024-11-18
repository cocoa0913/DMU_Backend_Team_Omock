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
        String userCodestr = (String) session.getAttribute("userCode");
        String friendNickname = request.getParameter("friendNickname");
        int userCode = 0;
        
        try {
            userCode = Integer.parseInt(userCodestr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid user code.");
            return;
        }
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");
            System.out.println("ㅇㅋ");
            
            // 친구 닉네임으로 user_code 찾기
            String friendQuery = "SELECT user_code FROM users WHERE nickname = ?";
            PreparedStatement friendStmt = conn.prepareStatement(friendQuery);
            friendStmt.setString(1, friendNickname);
            ResultSet rs = friendStmt.executeQuery();

            if (rs.next()) {
                int friendCode = rs.getInt("user_code");
                
                // 입력된 닉네임이 "나"일 경우
                if (userCode == friendCode) {
                	String referer = request.getHeader("Referer");
                	if (referer != null) {
                		referer = removeErrorParam(referer);
                		response.sendRedirect(referer + "&error=selfFriend");
                	}
                	return;
                }
                
                String checkfriend = "SELECT * FROM friends WHERE user_code = ? AND friend_code = ?";
                PreparedStatement checkStmt = conn.prepareStatement(checkfriend);
                checkStmt.setInt(1, userCode);
                checkStmt.setInt(2, friendCode);
                ResultSet ckfr = checkStmt.executeQuery();
                
                if(ckfr.next()) {
                	// 이미 친구인 경우
                    String referer = request.getHeader("Referer");
                    // error 파라미터를 제거한 후 다시 리다이렉트
                    if (referer != null) {
                        referer = removeErrorParam(referer);
                        response.sendRedirect(referer + "&error=alreadyFriend");
                    }
                } else {
                	// 친구 추가
                    String addFriendQuery = "INSERT INTO friends (user_code, friend_code, status) VALUES (?, ?, 'pending')";
                    PreparedStatement addFriendStmt = conn.prepareStatement(addFriendQuery);
                    addFriendStmt.setInt(1, userCode);
                    addFriendStmt.setInt(2, friendCode);
                    addFriendStmt.executeUpdate();
                    
                    String referer = request.getHeader("Referer");
                    // error 파라미터를 제거한 후 다시 리다이렉트
                    if (referer != null) {
                        referer = removeErrorParam(referer);
                        response.sendRedirect(referer);
                    }
                }

            } else {
            	// 친구를 찾을 수 없는 경우
            	String referer = request.getHeader("Referer");
            	if (referer != null) {
                    referer = removeErrorParam(referer);
                    response.sendRedirect(referer + "&error=userNotFound");
            	}
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
    }
    
    private String removeErrorParam(String url) {
        if (url != null && url.contains("&error=")) {
            // error 파라미터 제거
            url = url.replaceAll("(&?error=[^&]+)", "");
            // 마지막에 '&'가 남지 않도록 처리
            if (url.endsWith("&")) {
                url = url.substring(0, url.length() - 1);
            }
        }
        return url;
    }
}
