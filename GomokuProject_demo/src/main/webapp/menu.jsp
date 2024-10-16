<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메뉴</title>
    <link rel="stylesheet" type="text/css" href="css/menu.css">
</head>
<body>
    <div class="sidebar">
        <%
            // URL 파라미터로 받은 로그인 정보
            String userCode = request.getParameter("userCode");
            String nickname = request.getParameter("nickname");
            String level = request.getParameter("level");
            String cash = request.getParameter("cash");

            // 파라미터가 없을 경우 로그인 페이지로 리다이렉트 (필수)
            if (userCode == null || nickname == null || level == null || cash == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>

        <a href="main.jsp?userCode=<%= userCode %>&nickname=<%= nickname %>&level=<%= level %>&cash=<%= cash %>">홈</a>
        <a href="shop.jsp?userCode=<%= userCode %>&nickname=<%= nickname %>&level=<%= level %>&cash=<%= cash %>">캐쉬샵</a>
        <a href="myPage.jsp?userCode=<%= userCode %>&nickname=<%= nickname %>&level=<%= level %>&cash=<%= cash %>">마이페이지</a>
        <a href="friends.jsp?userCode=<%= userCode %>&nickname=<%= nickname %>&level=<%= level %>&cash=<%= cash %>">친구 목록</a>
        <a href="logout.jsp">로그아웃</a>
    </div>
</body>
</html>
