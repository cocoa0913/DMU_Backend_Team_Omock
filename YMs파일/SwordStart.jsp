<jsp:include page="${contextPath}/module/WeAreTheMoney.jsp" />
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/Game_css/LegendSword_css/sword.css">
    <title>전설의 검 강화하기</title>
</head>

<body>
    <%
        // 요청 파라미터 가져오기
        String userCode = request.getParameter("userCode");
        String nickname = request.getParameter("nickname");
        String level = request.getParameter("level");
        String cash = request.getParameter("cash");

        // 필수 파라미터가 없으면 main.jsp로 리다이렉트
        if (userCode == null || nickname == null || level == null || cash == null) {
            response.sendRedirect("main.jsp?error=missingParameters");
            return;
        }
    %>

    <div class="PageReturn">
        <!-- 뒤로 가는 버튼 -->
        <a href="${pageContext.request.contextPath}/main.jsp?userCode=<%= userCode %>&nickname=<%= nickname %>&level=<%= level %>&cash=<%= cash %>">돌아가기</a>
    </div>
	<div class = "GameBox">
		<h1>전설의 검 강화하기</h1>

    	<p><%= nickname %> 님, 검 강화에 도전해 보세요!</p>

    	<!-- 게임 시작 버튼 -->
    	<form action="${pageContext.request.contextPath}/Game/Sword.jsp" method="POST">
        	<input type="hidden" name="userCode" value="<%= userCode %>">
        	<input type="hidden" name="nickname" value="<%= nickname %>">
        	<input type="hidden" name="level" value="<%= level %>">
        	<input type="hidden" name="cash" value="<%= cash %>">
        	<input type="submit" value="게임 시작">
    	</form>
	</div>
    

</body>
</html>
