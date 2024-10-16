<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    <link rel="stylesheet" type="text/css" href="css/login.css">
</head>
<body>
    <div class="container">
        <h2>로그인</h2>
        <form action="LoginServlet" method="POST">
            ID: <input type="text" name="id" placeholder="ID" required><br>
            비밀번호: <input type="password" name="password" placeholder="비밀번호" required><br>
            <input type="submit" value="로그인">
        </form>

        <!-- 로그인 실패 시 에러 메시지 -->
        <% if (request.getParameter("error") != null) { %>
            <p style="color: red;">잘못된 ID 또는 비밀번호입니다.</p>
        <% } %>

        <a href="signup.jsp">회원가입</a>
    </div>
</body>
</html>
