<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <link rel="stylesheet" type="text/css" href="css/signup.css">
</head>
<body>
    <div class="container">
        <h2>회원가입</h2>
        
        <!-- 에러 메시지 출력 -->
        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
            <p style="color: red;"><%= error %></p>
        <% } %>

        <form action="SignupServlet" method="POST">
            <!-- 기존 입력값 유지 -->
            ID: <input type="text" name="id" placeholder="ID" value="<%= request.getAttribute("id") != null ? request.getAttribute("id") : "" %>" required><br>
            비밀번호: <input type="password" name="password" placeholder="비밀번호" required><br>
            닉네임: <input type="text" name="nickname" placeholder="닉네임" value="<%= request.getAttribute("nickname") != null ? request.getAttribute("nickname") : "" %>" required><br>
            <input type="submit" value="회원가입">
        </form>
        <a href="login.jsp">로그인</a>
    </div>
</body>
</html>
