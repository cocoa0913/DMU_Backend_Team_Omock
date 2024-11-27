<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <link rel="stylesheet" type="text/css" href="css/myPage.css">
</head>
<body>
    <h2>마이페이지</h2>
    <%
        String userCodeParam = request.getParameter("userCode");
        String nickname = request.getParameter("nickname");
        String levelParam = request.getParameter("level");
        String cashParam = request.getParameter("cash");

        // 항상 돌아가기 버튼 출력
        out.println("<div class='PageReturn'>");
        out.println("<a href='main.jsp?userCode=" + userCodeParam + "&nickname=" + nickname + "&level=" + levelParam + "&cash=" + cashParam + "'>돌아가기</a>");
        out.println("</div>");

        if (userCodeParam == null || nickname == null || levelParam == null || cashParam == null) {
            out.println("<p style='color: red;'>필수 정보가 누락되었습니다.</p>");
            return;
        }

        int userCode = 0;
        int level = 0;
        int cash = 0;

        try {
            userCode = Integer.parseInt(userCodeParam);
            level = Integer.parseInt(levelParam);
            cash = Integer.parseInt(cashParam);
        } catch (NumberFormatException e) {
            out.println("<p style='color: red;'>입력값이 잘못되었습니다: " + e.getMessage() + "</p>");
            e.printStackTrace();
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db?useUnicode=true&characterEncoding=utf8", "root", "password");

            // 사용자 정보 출력
            out.println("<h3>내 정보</h3>");
            out.println("<p>닉네임: " + nickname + "</p>");
            out.println("<p>레벨: " + level + "</p>");
            out.println("<p>보유 캐쉬: " + cash + "</p>");

            // 승패 및 기타 정보를 계산
            String userQuery = "SELECT win_count, lose_count, experience, ads_removed FROM users WHERE user_code = ?";
            stmt = conn.prepareStatement(userQuery);
            stmt.setInt(1, userCode);
            rs = stmt.executeQuery();

            if (rs.next()) {
                int winCount = rs.getInt("win_count");
                int loseCount = rs.getInt("lose_count");
                int totalGames = winCount + loseCount;
                double winRate = (totalGames > 0) ? ((double) winCount / totalGames) * 100 : 0.0;
                int experience = rs.getInt("experience");
                boolean adsRemoved = rs.getBoolean("ads_removed");

                out.println("<h3>전적 정보</h3>");
                out.println("<p>대전 횟수: " + totalGames + "회</p>");
                out.println("<p>" + winCount + "승, " + loseCount + "패</p>");
                out.println("<p>승률: " + String.format("%.2f", winRate) + "%</p>");
                out.println("<p>경험치: " + experience + "</p>");
                out.println("<p>프리미엄 구독 여부: " + (adsRemoved ? "구독중" : "미구독") + "</p>");
            }

            // 아이템 목록 출력
            out.println("<h3>아이템 목록</h3>");
            out.println("<table border='1'><tr><th>아이템 이름</th><th>구입 날짜</th></tr>");

            String itemQuery = "SELECT items.item_name, user_items.acquired_date FROM user_items " +
                               "JOIN items ON user_items.item_code = items.item_code WHERE user_items.user_code = ?";
            stmt = conn.prepareStatement(itemQuery);
            stmt.setInt(1, userCode);
            rs = stmt.executeQuery();

            boolean hasItems = false;

            while (rs.next()) {
                hasItems = true;
                String itemName = rs.getString("item_name");
                String acquiredDate = rs.getString("acquired_date");
                out.println("<tr><td>" + itemName + "</td><td>" + acquiredDate + "</td></tr>");
            }

            if (!hasItems) {
                out.println("<tr><td colspan='2'>구입한 아이템이 없습니다.</td></tr>");
            }

            out.println("</table>");

            // 관리자 권한 확인
            String adminQuery = "SELECT admin_rights FROM users WHERE user_code = ?";
            stmt = conn.prepareStatement(adminQuery);
            stmt.setInt(1, userCode);
            rs = stmt.executeQuery();

            if (rs.next()) {
                boolean isAdmin = rs.getBoolean("admin_rights");
                if (isAdmin) {
                    out.println("<h3><a href='adminPanel.jsp?userCode=" + userCodeParam + "&nickname=" + nickname + "&level=" + levelParam + "&cash=" + cashParam + "'>관리자 페이지</a></h3>");
                }
            }
            
         // '수정' 버튼 추가
            out.println("<h3 class='modify'><a href='modify.jsp?userCode=" + userCodeParam + "&nickname=" + nickname + "&level=" + levelParam + "&cash=" + cashParam + "'>수정</a></h3>");
        } catch (SQLException e) {
            out.println("<p style='color: red;'>데이터베이스 오류: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            out.println("<p style='color: red;'>드라이버 로드 실패: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    %>
</body>
</html>
