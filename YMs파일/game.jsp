<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import = "java.sql.*" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/Game_css/mysteryBox_css/game.css">
    <title>미스터리 박스</title>
</head>
<body>
<jsp:include page="${contextPath}/module/WeAreTheMoney.jsp" />
<%
    // 파라미터 처리
    String userCode = request.getParameter("userCode");
    String levelParam = request.getParameter("level");
    String cashParam = request.getParameter("cash");
    String nickname = request.getParameter("nickname");
    String clickedBox = request.getParameter("clickedBox");
    String reward = request.getParameter("reward");

    // DB 연결
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    int cashBalance = 0;
    int currentLevel = 0;
    int experience = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");

        // 사용자 정보를 DB에서 가져옴
        String query = "SELECT cash, level, experience FROM users WHERE user_code = ?";
        stmt = conn.prepareStatement(query);
        stmt.setInt(1, Integer.parseInt(userCode));
        rs = stmt.executeQuery();

        if (rs.next()) {
            cashBalance = rs.getInt("cash");
            currentLevel = rs.getInt("level");
            experience = rs.getInt("experience");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p style='color:red;'>사용자 데이터를 불러오는 중 오류가 발생했습니다.</p>");
        return;
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }

    // 남은 경험치 계산 (다음 레벨까지)
    int expToNextLevel = 100 - experience;
    if (expToNextLevel < 0) expToNextLevel = 0; // 초과 상황 대비

    // 박스에 랜덤 보상 값 생성
    int box1Reward = (int) (Math.random() * 3) + 1; // 1, 2, 3 중 하나
    int box2Reward = (int) (Math.random() * 3) + 1; 
    int box3Reward = (int) (Math.random() * 3) + 1;

    boolean boxClicked = reward != null && clickedBox != null; 
%>
<div class = "GameBox">
	<!-- 현재 보유 캐시 및 레벨, 경험치 출력 -->
	<div id="cash-display">
    	<h3>현재 보유 캐쉬: <%= cashBalance %> 캐쉬</h3>
    	<h3>현재 경험치: <%= experience %> EXP</h3>
	</div>

	<div id="wrap">
    	<% if (!boxClicked) { %>
	        <!-- 박스 클릭 전 -->
        	<a href="${pageContext.request.contextPath}/GameServlet?action=openBox&userCode=<%= userCode %>&level=<%= currentLevel %>&nickname=<%= nickname %>&cash=<%= cashBalance %>&experience=<%= experience %>&rewardNum=<%= box1Reward %>&clickedBox=1">
    	        <div class="box" style="left: 0;" id="box1"></div>
	        </a>
        	<a href="${pageContext.request.contextPath}/GameServlet?action=openBox&userCode=<%= userCode %>&level=<%= currentLevel %>&nickname=<%= nickname %>&cash=<%= cashBalance %>&experience=<%= experience %>&rewardNum=<%= box2Reward %>&clickedBox=2">
    	        <div class="box" style="left: 170px;" id="box2"></div>
	        </a>
        	<a href="${pageContext.request.contextPath}/GameServlet?action=openBox&userCode=<%= userCode %>&level=<%= currentLevel %>&nickname=<%= nickname %>&cash=<%= cashBalance %>&experience=<%= experience %>&rewardNum=<%= box3Reward %>&clickedBox=3">
    	        <div class="box" style="left: 340px;" id="box3"></div>
	        </a>
    	<% } else { %>
    	    <!-- 박스 클릭 후 -->
	        <div class="box" style="<%= "1".equals(clickedBox) ? "display:none;" : "left: 0;" %>" id="box1"></div>
        	<div class="box" style="<%= "2".equals(clickedBox) ? "display:none;" : "left: 170px;" %>" id="box2"></div>
        	<div class="box" style="<%= "3".equals(clickedBox) ? "display:none;" : "left: 340px;" %>" id="box3"></div>

    	    <!-- 클릭된 박스 위치에 보상 이미지 출력 -->
	        <img class="reward" src="${pageContext.request.contextPath}/Picture/game_picture/reward<%= reward %>.png" 
             	style="<%= "1".equals(clickedBox) ? "display:block; left:0;" : 
            	            "2".equals(clickedBox) ? "display:block; left:170px;" : 
        	                "3".equals(clickedBox) ? "display:block; left:340px;" : "display:none;" %>" />
    	<% } %>
	</div>

	<% if (boxClicked) { %>
	    <div id="reward-popup" class="popup">
        	<span id="reward-message">보상: <%= reward %> cash</span><br>
    	    <span id="exp-message">+10exp</span><br>
	        <span id="level-message">현재 레벨: <%= currentLevel %></span><br>
        	<span id="next-level-message">다음 레벨까지: <%= expToNextLevel %> exp</span><br><br>

        	<a href="game.jsp?userCode=<%= userCode %>&level=<%= currentLevel %>&cash=<%= cashBalance %>&nickname=<%= nickname %>&experience=<%= experience %>">
    	        <button>다시하기</button>
	        </a>
    	</div>
	<% } %>
</div>
<div class="PageReturn">
    <a href="${pageContext.request.contextPath}/main.jsp?userCode=<%= userCode %>&level=<%= currentLevel %>&cash=<%= cashBalance %>&nickname=<%= nickname %>&experience=<%= experience %>">돌아가기</a>
</div>
</body>
</html>
