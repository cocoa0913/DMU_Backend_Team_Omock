<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/Game_css/BlackJack_css/Bindex.css">
    <title>블랙잭 - 베팅</title>
</head>
<body>
<div class = "GameBox">
	<%
        String userCode = request.getParameter("userCode");
        String nickname = request.getParameter("nickname");
        String level = request.getParameter("level");
        String cash = request.getParameter("cash");

        if (userCode == null) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>
	<div class="PageReturn">
       	<a href="${pageContext.request.contextPath}/main.jsp?userCode=<%= userCode %>&nickname=<%= nickname %>&level=<%= level %>&cash=<%= cash %>">돌아가기</a>
    </div>
    	
    <h1>블랙잭 - 베팅하기</h1>
    
    <h4>현재 보유 캐쉬: <%= cash %>원</h4>

    <form action="${pageContext.request.contextPath}/bet" method="POST">
    	<input type="hidden" name="userCode" value="<%= userCode %>">
        <input type="hidden" name="nickname" value="<%= nickname %>">
        <input type="hidden" name="level" value="<%= level %>">
        <input type="hidden" name="cash" value="<%= cash %>">
        <input type="number" name="betAmount" max = "50000" min = "1000" step = "1000" size = 1000 placeholder="베팅 금액">
        <%  %>
        <button type="submit" name="action" value="bet">베팅 완료</button>
    </form>
    <h5 class = "betting">[베팅범위]<p>최소 : </p>1000원<hr><p>최대 : </p>50000원<hr><p>단위 : </p>1000원 <hr></h5>

    <c:if test="${not empty errorMessage}">
    	<p style="color: red;">${errorMessage}</p>
	</c:if>
</div>
</body>
</html>
