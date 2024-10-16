<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>대기실</title>
    <link rel="stylesheet" type="text/css" href="css/waitingRoom.css">
</head>
<body>
    <h2>대기실</h2>
    <p>다른 유저를 기다리고 있습니다...</p>

    <%
        if (session != null && session.getAttribute("roomId") != null) {
            int roomId = (int) session.getAttribute("roomId");

            // 데이터베이스에서 방 정보 가져오기
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "1234");

                String query = "SELECT * FROM rooms WHERE room_id = ?";
                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setInt(1, roomId);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    String roomTitle = rs.getString("room_title");
                    boolean isPrivate = rs.getBoolean("is_private");
                    out.println("<p>방 제목: " + roomTitle + "</p>");
                    out.println("<p>비밀번호 설정 여부: " + (isPrivate ? "Yes" : "No") + "</p>");
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            response.sendRedirect("main.jsp");
        }
    %>

    <!-- 홈페이지로 나가기 버튼 -->
    <form action="deleteRoomServlet" method="POST">
        <input type="hidden" name="roomId" value="<%= session.getAttribute("roomId") %>">
        <input type="submit" value="홈페이지로 나가기">
    </form>
</body>
</html>
