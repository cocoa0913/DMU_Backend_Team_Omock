<%@ include file="module/WeAreTheMoney.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>방 찾기</title>
    <link rel="stylesheet" type="text/css" href="css/findRoom.css">
</head>
<body>
    <%
        String userCode = request.getParameter("userCode");
        String nickname = request.getParameter("nickname");
        String level = request.getParameter("level");
        String cash = request.getParameter("cash");

        if (userCode == null) {
            response.sendRedirect("main.jsp?error=missingUserCode");
            return;
        }
    %>
    <div class="PageReturn">
        <a href="main.jsp?userCode=<%= userCode %>&nickname=<%= nickname %>&level=<%= level %>&cash=<%= cash %>">돌아가기</a>
    </div>
    <h2>방 목록</h2>
    <table border="1">
        <tr>
            <th>방 제목</th>
            <th>방 주인</th>
            <th>레벨</th>
            <th>전적</th>
            <th>비밀번호</th>
            <th>입장</th>
        </tr>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");

                String query = "SELECT rooms.room_id, rooms.room_title, users.nickname, users.level, users.win_count, users.lose_count, rooms.is_private " +
                               "FROM rooms JOIN users ON rooms.owner_code = users.user_code";
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    int roomId = rs.getInt("room_id");
                    String roomTitle = rs.getString("room_title");
                    String owner = rs.getString("nickname");
                    int level1 = rs.getInt("level");
                    int wins = rs.getInt("win_count");
                    int losses = rs.getInt("lose_count");
                    boolean isPrivate = rs.getBoolean("is_private");
        %>
        <tr>
            <td><%= roomTitle %></td>
            <td><%= owner %></td>
            <td><%= level1 %></td>
            <td><%= wins %>승 / <%= losses %>패</td>
            <td><%= isPrivate ? "Yes" : "No" %></td>
            <td>
                <form action="EnterRoomServlet" method="POST">
                    <input type="hidden" name="roomId" value="<%= roomId %>">
                    <input type="hidden" name="userCode" value="<%= userCode %>">
                    <% if (isPrivate) { %>
                        비밀번호: <input type="password" name="roomPassword">
                    <% } %>
                    <input type="submit" value="입장">
                </form>
            </td>
        </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </table>
</body>
</html>
