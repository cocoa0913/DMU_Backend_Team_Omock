
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/Game_css/racingGame_css/racingGame.css">
    <title>토끼와 거북이 달리기 게임</title>
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");
    String userCode = request.getParameter("userCode");
    String levelParam = request.getParameter("level");
    String cashParam = request.getParameter("cash");
    String nickname = request.getParameter("nickname");
    String experienceParam = request.getParameter("experience");
    String action = request.getParameter("action");
    String correctParam = request.getParameter("correct"); // 정답 여부 (Servlet에서 전달)
    String winner = (String) session.getAttribute("winner");

    // 파라미터 숫자 변환
    int currentCash = 0;
    int currentLevel = 0;
    int experience = 0;
    try { currentCash = (cashParam != null) ? Integer.parseInt(cashParam) : 0; } catch (NumberFormatException e) {}
    try { currentLevel = (levelParam != null) ? Integer.parseInt(levelParam) : 0; } catch (NumberFormatException e) {}
    try { experience = (experienceParam != null) ? Integer.parseInt(experienceParam) : 0; } catch (NumberFormatException e) {}

    // action=retry면 winner 초기화
    if ("retry".equals(action)) {
        session.removeAttribute("winner");
        action = null;
    }

    // winner가 없으면 랜덤 지정
    if (winner == null) {
        if (Math.random() < 0.5) {
            winner = "rabbit";
        } else {
            winner = "turtle";
        }
        session.setAttribute("winner", winner);
    }

    // correctParam 처리
    boolean correct = false;
    if (correctParam != null) {
        correct = Boolean.parseBoolean(correctParam);
    }

    // 승리 영상 경로
    String videoPath = "";
    if ("rabbit".equals(winner)) {
        videoPath = request.getContextPath() + "/Picture/racing/토끼승리.mp4";
    } else {
        videoPath = request.getContextPath() + "/Picture/racing/거북이승리.mp4";
    }
%>

<div id="game-container">
	<% if (action == null) { %>
    <div id="status-bar">
        <h4>닉네임: <%= nickname %></h4>
        <h4>레벨: <%= currentLevel %> | 경험치: <%= experience %></h4>
        <h4>현재 캐쉬: <%= currentCash %> 캐쉬</h4>
    </div>
	<% } %>
    <div id="game-content">
    <% if (action == null) { %>
        <!-- 초기 화면: 게임 시작 버튼 -->
        <h1>토끼와 거북이 달리기 게임</h1>
        <p>500캐쉬를 사용하여 게임을 시작하시겠습니까?</p>
        <form action="${pageContext.request.contextPath}/RacingGameServlet" method="get">
            <input type="hidden" name="action" value="startGame">
            <input type="hidden" name="userCode" value="<%= userCode %>">
            <input type="hidden" name="level" value="<%= currentLevel %>">
            <input type="hidden" name="nickname" value="<%= nickname %>">
            <input type="hidden" name="cash" value="<%= currentCash %>">
            <input type="hidden" name="experience" value="<%= experience %>">
            <button type="submit">게임 시작</button>
        </form>
        <div class="PageReturn">
            <a href="${pageContext.request.contextPath}/main.jsp?userCode=<%= userCode %>&level=<%= currentLevel %>&cash=<%= currentCash %>&nickname=<%= nickname %>&experience=<%= experience %>">돌아가기</a>
        </div>

    <% } else if ("startGame".equals(action)) { %>
        <!-- 게임 시작 후: 토끼 or 거북이 선택 -->
        <h2>누가 이길까요?</h2>
        <p>당신의 선택은?</p>
        <form action="${pageContext.request.contextPath}/RacingGameServlet" method="get">
            <input type="hidden" name="action" value="guessResult">
            <input type="hidden" name="userCode" value="<%= userCode %>">
            <input type="hidden" name="level" value="<%= currentLevel %>">
            <input type="hidden" name="nickname" value="<%= nickname %>">
            <input type="hidden" name="cash" value="<%= currentCash %>">
            <input type="hidden" name="experience" value="<%= experience %>">
            <button type="submit" name="userGuess" value="rabbit">토끼</button>
            <button type="submit" name="userGuess" value="turtle">거북이</button>
        </form>
        <div class="PageReturn">
            <a href="${pageContext.request.contextPath}/main.jsp?userCode=<%= userCode %>&level=<%= currentLevel %>&cash=<%= currentCash %>&nickname=<%= nickname %>&experience=<%= experience %>">돌아가기</a>
        </div>

    <% } else if ("guessResult".equals(action)) { %>
        <!-- 결과 확인 후: 영상 재생 -->
        <div id="video-container">
            <video width="960" height="540" autoplay onended="onVideoEnded()">
                <source src="<%= videoPath %>" type="video/mp4">
            </video>
        </div>
        <div id="result-text" style="display:none;">
            <p>당신의 선택: <%= correct ? "정답!" : "오답!" %></p>
            <p><%= correct ? "축하합니다! 500캐쉬를 획득했습니다! 한 판 더? " : "아깝네요! 한 판 더?" %></p>
            <form action="${pageContext.request.contextPath}/Game/racingGame.jsp" method="get">
                <input type="hidden" name="action" value="retry">
                <input type="hidden" name="userCode" value="<%= userCode %>">
                <input type="hidden" name="level" value="<%= currentLevel %>">
                <input type="hidden" name="nickname" value="<%= nickname %>">
                <input type="hidden" name="cash" value="<%= currentCash %>">
                <input type="hidden" name="experience" value="<%= experience %>">
                <button type="submit">다시하기</button>
            </form>
        </div>

        <script>
            function onVideoEnded() {
                document.getElementById('video-container').style.display = 'none';
                document.getElementById('result-text').style.display = 'block';
            }
        </script>

        <div class="PageReturn">
            <a href="${pageContext.request.contextPath}/main.jsp?userCode=<%= userCode %>&level=<%= currentLevel %>&cash=<%= currentCash %>&nickname=<%= nickname %>&experience=<%= experience %>">돌아가기</a>
        </div>
    <% } %>
    </div>
</div>

</body>
</html>
