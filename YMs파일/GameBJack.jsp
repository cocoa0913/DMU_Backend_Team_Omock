<%@ page import="game.BlackJack.GameDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
	<head>
		<meta charset="UTF-8">
		<title>블랙잭</title>
		<link rel = "stylesheet" type = "text/css" href = "${pageContext.request.contextPath}/css/Game_css/BlackJack_css/GameBJack.css">
	</head>
	
<body>

	<%
		String userCode = (String) session.getAttribute("userCode");	
		String nickname = (String) session.getAttribute("nickname");
		String level = (String) session.getAttribute("level");
		int cash = (int) session.getAttribute("cash");
	%>
	<div class = "GameBox">
    	<h1>블랙잭 게임</h1>
    
    	<c:if test="${not empty game}">
        	<h3>플레이어 카드:</h3>
        	
        	<ul>
	            <!-- playerCards가 null이 아닐 때만 반복문 실행 -->
    	        <c:if test="${not empty game.playerCards}">
        	        <c:forEach var="card" items="${game.playerCards}">
            	        <li> <h4><img alt="cardImage" src="${pageContext.request.contextPath}/Picture/BlackJack_picture/${card.suit}.png"> ${card.suit} ${card.rank}</h4></li>
                	</c:forEach>
            	</c:if>
        	</ul>
        	<p><strong>플레이어 점수:</strong> ${game.playerScore}</p>

        	<h3>딜러 카드:</h3>
        	<ul>
	            <!-- dealerCards가 null이 아닐 때만 반복문 실행 -->
    	        <c:if test="${not empty game.dealerCards}">
        	        <c:forEach var="card" items="${game.dealerCards}">
            	        <li> <h4><img alt="cardImage" src="${pageContext.request.contextPath}/Picture/BlackJack_picture/${card.suit}.png"> ${card.suit} ${card.rank}</h4></li>
                	</c:forEach>
	            </c:if>
    	    </ul>
        	<p><strong>딜러 점수:</strong> ${game.dealerScore}</p>

        	<!-- 히트 버튼 -->
        	<c:if test="${not game.gameOver && game.playerScore < 21}">
	            <form action="blackjack" method="POST">
    	            <button type="submit" name="action" value="hit">히트</button>
        	    </form>
        	</c:if>

        	<!-- 결과보기 버튼 -->
            <form action="blackjack" method="POST">
	            <button type="submit" name="action" value="result">결과 보기</button>
            </form>

    	</c:if>
	</div>
</body>
</html>