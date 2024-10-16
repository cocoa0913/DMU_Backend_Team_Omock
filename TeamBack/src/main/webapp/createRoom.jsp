<%@ include file = "WeAreTheMoney.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>방 만들기</title>
    <link rel="stylesheet" type="text/css" href="css/createRoom.css">
</head>
<body>
    <div class="content">
        <h2>방 만들기</h2>
        <form action="CreateRoomServlet" method="POST">
            <label for="roomTitle">방 제목:</label>
            <input type="text" name="roomTitle" id="roomTitle" required><br>
            <label for="roomPassword">비밀번호 (선택):</label>
            <input type="password" name="roomPassword" id="roomPassword"><br>
            <input type="submit" value="방 만들기">
        </form>

        <%
            String roomTitle = request.getParameter("roomTitle");
            String roomPassword = request.getParameter("roomPassword");

            if (roomTitle != null && !roomTitle.isEmpty()) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");

                    String query = "INSERT INTO rooms (room_title, room_password, is_private) VALUES (?, ?, ?)";
                    PreparedStatement stmt = conn.prepareStatement(query);
                    stmt.setString(1, roomTitle);
                    stmt.setString(2, roomPassword != null && !roomPassword.isEmpty() ? roomPassword : null);
                    stmt.setBoolean(3, roomPassword != null && !roomPassword.isEmpty());
                    stmt.executeUpdate();

                    out.println("<p>방이 성공적으로 생성되었습니다!</p>");
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        %>
    </div>
</body>
</html>
