<%@ include file = "menu.jsp" %>
<%@ include file = "WeAreTheMoney.jsp" %>
<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8"%>
<!DOCTYPE html>
<html lang = "ko">
<head>
    <meta charset = "UTF-8">
    <meta name = "viewport" content = "width=device-width, initial-scale=1.0">
    <title>메인 페이지</title>
    <link rel = "stylesheet" type = "text/css" href = "css/main.css">
    
</head>
<body>
    <div class = "content">
        <h1>오목 온라인 대전</h1>

        <%
            // 중복 변수를 선언하지 않고 기존 변수를 재사용
            userCode = request.getParameter("userCode");
            nickname = request.getParameter("nickname");
            level = request.getParameter("level");
            cash = request.getParameter("cash");

            if (userCode == null || nickname == null || level == null || cash == null) {
                out.println("<p>필요한 정보가 없습니다.</p>");
            }
        %>

        <p>이곳에서 오목을 즐기세요!</p>
        
        <!-- 방 만들기와 방 찾기 기능 버튼 -->
        <div class = "single-box">
            <h3>오목 온라인</h3>
            <div class = "option-box">
                <form action = "createRoom.jsp?userCode=<%= userCode %>&nickname=<%= nickname %>&level=<%= level %>&cash=<%= cash %>" method="GET">
                    <input type = "submit" value="방 만들기">
                </form>
            </div>
            <div class = "option-box">
                <form action = "findRoom.jsp?userCode=<%= userCode %>&nickname=<%= nickname %>&level=<%= level %>&cash=<%= cash %>" method="GET">
                    <input type = "submit" value="방 찾기">
                </form>
            </div>
        </div>
    </div>
</body>
</html>
