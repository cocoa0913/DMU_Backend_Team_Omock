<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>나의 대전 기록</title>
</head>
<body>
    <h2>나의 대전 기록</h2>
    <table border="1">
        <tr>
            <th>대전 상대</th>
            <th>결과</th>
            <th>날짜</th>
        </tr>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "1234");

                int userCode = (int) session.getAttribute("userCode");

                // 사용자가 관련된 대전 기록 조회
                String query = "SELECT gl.game_time, gl.winner_code, gl.loser_code, u1.nickname AS opponent " +
                               "FROM game_logs gl " +
                               "JOIN users u1 ON (gl.winner_code = u1.user_code OR gl.loser_code = u1.user_code) " +
                               "WHERE (gl.winner_code = ? OR gl.loser_code = ?) " +
                               "AND u1.user_code != ? " +
                               "ORDER BY gl.game_time DESC";
                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setInt(1, userCode);
                stmt.setInt(2, userCode);
                stmt.setInt(3, userCode);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    String opponent = rs.getString("opponent");
                    String result = rs.getInt("winner_code") == userCode ? "승리" : "패배";
                    String gameTime = rs.getString("game_time");
        %>
        <tr>
            <td><%= opponent %></td>
            <td><%= result %></td>
            <td><%= gameTime %></td>
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
