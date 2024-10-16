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
        <form action="SignupServlet" method="POST">
            ID: <input type="text" name="id" placeholder="ID" required><br>
            비밀번호: <input type="password" name="password" placeholder="비밀번호" required><br>
            닉네임: <input type="text" name="nickname" placeholder="닉네임" required><br>
            <input type="submit" value="회원가입">
        </form>
        <a href="login.jsp">로그인</a>
    </div>
</body>
</html>
