<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>승부 결과(블랙잭)</title>
		<link rel = "stylesheet" type = "text/css" href = "${pageContext.request.contextPath}/css/Game_css/BlackJack_css/GameBJwinner.css">
	</head>
	
	<body>
	<div class = "GameBox">
    	<h1>블랙잭 - 승부 결과</h1>
    	<h3>플레이어 카드:</h3>
        	
        	<ul>
    	        <c:if test="${not empty game.playerCards}">
        	        <c:forEach var="card" items="${game.playerCards}">
            	        <li> <h4><img alt="cardImage" src="${pageContext.request.contextPath}/Picture/BlackJack_picture/${card.suit}.png"> ${card.suit} ${card.rank}</h4></li>
                	</c:forEach>
            	</c:if>
        	</ul>
        	<p><strong>플레이어 점수:</strong> ${game.playerScore}</p>

        	<h3>딜러 카드:</h3>
        	<ul>
    	        <c:if test="${not empty game.dealerCards}">
        	        <c:forEach var="card" items="${game.dealerCards}">
            	        <li> <h4><img alt="cardImage" src="${pageContext.request.contextPath}/Picture/BlackJack_picture/${card.suit}.png"> ${card.suit} ${card.rank}</h4></li>
                	</c:forEach>
	            </c:if>
    	    </ul>
        	<p><strong>딜러 점수:</strong> ${game.dealerScore}</p>
    	<p class = "endBox"><strong>승부 결과:</strong> ${winner}</p>
    	<p><strong>현재 보유 캐쉬:</strong> ${ cash }원</p>
    	
    	<div class = "ReturnBox">
    		<div class="PageReturn">
       			<a href="${pageContext.request.contextPath}/Game/GameBindex.jsp?userCode=${ userCode }&nickname=${ nickname }&level=${ level }&cash=${ cash }">베팅하러 가기</a>
    		</div>
    		<div class="PageReturn">
       			<a href="${pageContext.request.contextPath}/main.jsp?userCode=${ userCode }&nickname=${ nickname }&level=${ level }&cash=${ cash }">그만 하기</a>
	    	</div>
    	</div>
    </div>
	</body>
</html>