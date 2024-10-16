<%@ include file = "menu.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel = "stylesheet" href = "css/Friends.css">
    <title>친구 목록</title>
</head>
<body>
    <h2>친구 목록</h2>
    <p>친구 추가, 친구 요청을 관리하세요!</p>

    <form action="FriendAddServlet" method="POST">
        닉네임으로 친구 추가: <input type="text" name="friendNickname" required>
        <input type="submit" value="추가">
    </form>

    <h3>내 친구 목록</h3>
    <table border="1">
        <tr>
            <th id = "FnickName">닉네임</th>
            <th>레벨</th>
            <th id = "rating">전적</th>
        </tr>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");
                int userCode1 = (int) session.getAttribute("userCode");

                String query = "SELECT users.nickname, users.level, users.win_count, users.lose_count FROM friends " +
                               "JOIN users ON friends.friend_code = users.user_code WHERE friends.user_code = ?";
                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setInt(1, userCode1);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    String nickname1 = rs.getString("nickname");
                    int level1 = rs.getInt("level");
                    int winCount = rs.getInt("win_count");
                    int loseCount = rs.getInt("lose_count");
        %>
        <tr>
            <td><%= nickname %></td>
            <td><%= level %></td>
            <td><%= winCount %>승 / <%= loseCount %>패</td>
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
