<%@ include file="module/WeAreTheMoney.jsp" %>
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
    <%
        // URL 파라미터로 전달된 값 확인
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

    <div class="content">
        <h2>방 만들기</h2>
        <form action="CreateRoomServlet" method="POST">
            <!-- 숨겨진 필드로 userCode 전달 -->
            <input type="hidden" name="userCode" value="<%= userCode %>">
            <label for="roomTitle">방 제목:</label>
            <input type="text" name="roomTitle" id="roomTitle" required><br>
            <label for="roomPassword">비밀번호 (선택):</label>
            <input type="password" name="roomPassword" id="roomPassword"><br>
            <input type="submit" value="방 만들기">
        </form>
        <% if (request.getParameter("error") != null) { %>
            <p style="color: red;">에러: <%= request.getParameter("error") %></p>
        <% } %>
    </div>
</body>
</html>
