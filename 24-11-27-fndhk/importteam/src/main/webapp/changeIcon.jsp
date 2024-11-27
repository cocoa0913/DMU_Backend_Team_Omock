<%@ include file = "module/WeAreTheMoney.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, java.util.Base64" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이콘 변경</title>
    <link rel="stylesheet" type="text/css" href="css/changeIcon.css">
</head>
<body>
    <div class="content">
        <h2>아이콘 변경</h2>

        <%
            String userCode = request.getParameter("userCode");
            String nickname = request.getParameter("nickname");
            String levelParam = request.getParameter("level");
            String cashParam = request.getParameter("cash");

            if (userCode == null || levelParam == null || cashParam == null) {
                response.sendRedirect("main.jsp");
                return;
            }

            int userCodeInt = Integer.parseInt(userCode);
            String currentIcon = ""; // 현재 아이콘
            List<String[]> iconList = new ArrayList<>(); // 아이콘 목록 [icon_code, icon_img]

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");

                // 현재 아이콘 가져오기
                String currentIconQuery = 
                    "SELECT icons.icon_img FROM users JOIN icons ON users.icon_code = icons.icon_code WHERE users.user_code = ?";
                PreparedStatement stmt = conn.prepareStatement(currentIconQuery);
                stmt.setInt(1, userCodeInt);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    byte[] currentIconData = rs.getBytes("icon_img");
                    if (currentIconData != null) {
                        currentIcon = "data:image/png;base64," + Base64.getEncoder().encodeToString(currentIconData);
                    }
                }
                rs.close();
                stmt.close();

                // 보유한 아이콘 목록 가져오기 (수정된 쿼리)
                String iconQuery = 
                    "SELECT icons.icon_code, icons.icon_img " +
                    "FROM icons " +
                    "WHERE icons.icon_code IN (" +
                    "    SELECT user_items.item_code " +
                    "    FROM user_items " +
                    "    WHERE user_items.user_code = ?" +
                    ")";
                stmt = conn.prepareStatement(iconQuery);
                stmt.setInt(1, userCodeInt);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    String iconCode = rs.getString("icon_code");
                    byte[] iconImg = rs.getBytes("icon_img");
                    if (iconImg != null) {
                        String base64Icon = "data:image/png;base64," + Base64.getEncoder().encodeToString(iconImg);
                        iconList.add(new String[]{iconCode, base64Icon});
                    }
                }

                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color:red;'>아이콘 목록을 불러오는 중 오류가 발생했습니다.</p>");
            }
        %>

        <!-- 현재 아이콘 -->
        <div class="current-icon">
            <h3>현재 아이콘</h3>
            <img src="<%= currentIcon %>" alt="현재 아이콘" width="80" height="80">
        </div>

        <!-- 보유 아이콘 목록 -->
        <h3>보유 아이콘</h3>
        <form action="ChangeIconServlet" method="POST">
            <input type="hidden" name="userCode" value="<%= userCode %>">
            <input type="hidden" name="nickname" value="<%= nickname %>">
            <input type="hidden" name="level" value="<%= levelParam %>">
            <input type="hidden" name="cash" value="<%= cashParam %>">
            <div class="icon-list">
                <% 	int a = 0;
                	for (String[] icon : iconList) { 
                    String iconCode = icon[0];
                    String iconImg = icon[1];
                    a++;
                %>
                <div class="icon-item">
                    <label>
                        <input type="radio" name="iconCode" value="<%= iconCode %>"
                            <% if (a == 1) { %>checked<% } %>>
                        <img src="<%= iconImg %>" alt="아이콘" width="80" height="80">
                    </label>
                </div>
                <% } %>
            </div>
            <div class="submit-button">
                <input type="submit" value="아이콘 변경">
            </div>
        </form>

        <!-- 돌아가기 버튼 -->
        <div class="PageReturn">
            <a href="main.jsp?userCode=<%= userCode %>&nickname=<%= nickname %>&level=<%= levelParam %>&cash=<%= cashParam %>">돌아가기</a>
        </div>
    </div>
</body>
</html>
