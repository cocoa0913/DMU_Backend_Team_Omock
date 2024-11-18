<%@ include file = "module/WeAreTheMoney.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>캐쉬샵</title>
    <link rel="stylesheet" type="text/css" href="css/shop.css">
</head>
<body>
    <div class="content">
        <h2>캐쉬샵</h2>

        <%
            // URL 파라미터로 로그인 정보 받아오기
            String userCode = request.getParameter("userCode");
            String nickname = request.getParameter("nickname");
            String levelParam = request.getParameter("level");
            String cashParam = request.getParameter("cash");
            
     	%>
     	
     	<div class = "PageReturn">
			<a href="main.jsp?userCode=<%= userCode %>&nickname=<%= nickname %>&level=<%= levelParam %>&cash=<%= cashParam %>">돌아가기</a>
		</div>
     	
     	<%
            if (userCode == null || nickname == null || levelParam == null || cashParam == null) {
                response.sendRedirect("login.jsp");
            } else {
                int userCode_1 = Integer.parseInt(userCode); // 중복 선언된 userCode 제거
                int cashBalance = Integer.parseInt(cashParam);

                // 보유 캐쉬 표시
                out.println("<p>보유 캐쉬: " + cashBalance + " 캐쉬</p>");

                // 데이터베이스에서 아이템 목록 불러오기
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");

                    String query = "SELECT item_code, item_name, price FROM items";
                    PreparedStatement stmt = conn.prepareStatement(query);
                    ResultSet rs = stmt.executeQuery();

                    %>
                    <table border="1">
                        <tr>
                            <th>아이템 이름</th>
                            <th>가격</th>
                            <th>구매</th>
                        </tr>
                    <%
                    while (rs.next()) {
                        int itemCode = rs.getInt("item_code");
                        String itemName = rs.getString("item_name");
                        int price = rs.getInt("price");

                        // 아이템 구매 가능 여부 확인
                        String checkQuery = "SELECT * FROM user_items WHERE user_code = ? AND item_code = ?";
                        PreparedStatement checkStmt = conn.prepareStatement(checkQuery);
                        checkStmt.setInt(1, userCode_1);
                        checkStmt.setInt(2, itemCode);
                        ResultSet checkRs = checkStmt.executeQuery();

                        boolean alreadyPurchased = checkRs.next(); // 이미 구매한 경우
                    %>
                    <tr>
                        <td><%= itemName %></td>
                        <td><%= price %> 캐쉬</td>
                        <td>
                            <% if (alreadyPurchased) { %>
                                <span>이미 구매한 아이템</span>
                            <% } else { %>
                                <form action="ShopServlet" method="POST">
                                    <input type="hidden" name="itemCode" value="<%= itemCode %>">
                                    <input type="hidden" name="userCode" value="<%= userCode %>">
                                    <input type="submit" value="구매">
                                </form>
                            <% } %>
                        </td>
                    </tr>
                    <%
                    }
                    %>
                    </table>
                    <%
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        %>
    </div>
</body>
</html>
