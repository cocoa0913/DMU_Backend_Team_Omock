<jsp:include page="${contextPath}/module/WeAreTheMoney.jsp" />
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>전설의 검 강화하기</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/Game_css/LegendSword_css/sword.css">
</head>
<body>
	<div class = "GameBox">
    	<h1>전설의 검 강화하기</h1>
    
    <%
        // 사용자 정보와 캐쉬를 받아오기
        String userCode = request.getParameter("userCode");
        String nickname = request.getParameter("nickname");
        String levelParam = request.getParameter("level");
        String swordLevelParam = request.getParameter("swordLevel");
        String cashParam = request.getParameter("cash");

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        int currentSwordLevel = 0; // 기본 강화 레벨
        int userCash = 0;         // 기본 캐쉬
        int currentExperience = 0; // 현재 경험치
        int currentLevel = Integer.parseInt(levelParam); // 현재 레벨

        try {
            // DB 연결 설정
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db?useUnicode=true&characterEncoding=utf8", "root", "password");

            // 사용자 정보가 DB에 존재하는지 확인
            String query = "SELECT sword_level, cash, experience, level FROM users WHERE user_code = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, userCode);
            rs = pstmt.executeQuery();

            // DB에서 사용자 데이터 가져오기
            if (rs.next()) {
                currentSwordLevel = rs.getInt("sword_level");
                userCash = rs.getInt("cash");
                currentExperience = rs.getInt("experience");
                currentLevel = rs.getInt("level");
            }

            // 강화 처리
            String upgradeSwordLevel = request.getParameter("upgradeSwordLevel");
            if (upgradeSwordLevel != null) {
                int maxSwordLevel = 10; // 최대 강화 레벨
                int upgradeCost = (currentSwordLevel + 1) * 100; // 강화 비용

                if (userCash >= upgradeCost) {
                    userCash -= upgradeCost; // 캐쉬 차감

                    // lose_count 업데이트
                    String updateLoseCountQuery = "UPDATE users SET lose_count = lose_count + ? WHERE user_code = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(updateLoseCountQuery)) {
                        stmt.setInt(1, upgradeCost);
                        stmt.setString(2, userCode);
                        stmt.executeUpdate();
                    }

                    // 강화 확률 계산
                    double successProbability = Math.max(1.0 - (currentSwordLevel * 0.1), 0.01); // 최소 1% 확률
                    boolean isSuccess = Math.random() < successProbability;

                    if (isSuccess) {
                        if (currentSwordLevel < maxSwordLevel) {
                            currentSwordLevel++;
                            out.println("<p>강화 성공! 검의 레벨이 " + currentSwordLevel + "강이 되었습니다.</p>");
                        } else {
                            out.println("<p>검은 이미 최대 강화 상태입니다.</p>");
                        }
                    } else {
                        currentSwordLevel = 0;
                        out.println("<p style='color:red;'>강화 실패! 처음부터 다시 강화해야 합니다.</p>");
                    }

                    // DB 업데이트
                    String updateQuery = "UPDATE users SET sword_level = ?, cash = ? WHERE user_code = ?";
                    pstmt = conn.prepareStatement(updateQuery);
                    pstmt.setInt(1, currentSwordLevel);
                    pstmt.setInt(2, userCash);
                    pstmt.setString(3, userCode);
                    pstmt.executeUpdate();
                } else {
                    out.println("<p style='color:red;'>보유 캐쉬가 부족합니다.</p>");
                }
            }

            // 검 팔기 처리
            String sellSword = request.getParameter("sellSword");
            if (sellSword != null && sellSword.equals("true")) {
                int sellPrice = (60 * currentSwordLevel) * ( currentSwordLevel); // 검 판매 가격
                userCash += sellPrice; // 캐쉬 증가
                
                // win_count 업데이트
                String updateWinCountQuery = "UPDATE users SET win_count = win_count + ? WHERE user_code = ?";
                try (PreparedStatement stmt = conn.prepareStatement(updateWinCountQuery)) {
                    stmt.setInt(1, sellPrice);
                    stmt.setString(2, userCode);
                    stmt.executeUpdate();
                }

                // 경험치 및 레벨 처리
                int experienceGain = currentSwordLevel * 10; // 경험치 계산
                currentExperience += experienceGain;

                // 레벨 업 체크
                while (currentExperience >= 100) {
                    currentExperience -= 100; // 경험치 100 차감
                    currentLevel += 1;        // 레벨 증가
                }

                // DB 업데이트
                String updateExpLevelQuery = "UPDATE users SET experience = ?, level = ?, sword_level = ?, cash = ? WHERE user_code = ?";
                pstmt = conn.prepareStatement(updateExpLevelQuery);
                pstmt.setInt(1, currentExperience);
                pstmt.setInt(2, currentLevel);
                pstmt.setInt(3, 0); // 검 레벨 초기화
                pstmt.setInt(4, userCash);
                pstmt.setString(5, userCode);
                pstmt.executeUpdate();

                out.println("<p>검을 팔아서 " + sellPrice + "원을 얻었습니다! 경험치 " + experienceGain + "을 획득했습니다.</p>");
                out.println("<p>현재 경험치: " + currentExperience + " / 100</p>");
                out.println("<p>현재 레벨: " + currentLevel + "</p>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p style='color:red;'>에러가 발생했습니다. 관리자에게 문의하세요.</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>

	    <p>현재 레벨: <%= currentSwordLevel %>강</p>
    	<p>이번 강화 비용: <%= (currentSwordLevel + 1) * 100 %> 원</p>
	    <p>검 판매 가격: <%= (60 * currentSwordLevel) * ( currentSwordLevel) %> 원</p>
    	<p>강화 성공 확률: <%= Math.round(Math.max(1.0 - (currentSwordLevel * 0.1), 0.01) * 100) %> %</p>
    
	    <div>
        	<img src="${pageContext.request.contextPath}/Picture/LegendofSword_picture/sword_<%= currentSwordLevel %>.png" alt="강화된 검 이미지" width="200" height="200">
    	</div>

    	<div class="button-container">
    	    <!-- 검 강화 버튼 -->
	        <form action="Sword.jsp" method="POST">
            	<input type="hidden" name="userCode" value="<%= userCode %>">
        	    <input type="hidden" name="nickname" value="<%= nickname %>">
    	        <input type="hidden" name="level" value="<%= currentLevel %>"> 
	            <input type="hidden" name="swordLevel" value="<%= currentSwordLevel %>">
        	    <input type="hidden" name="cash" value="<%= userCash %>">
    	        <input type="hidden" name="upgradeSwordLevel" value="<%= currentSwordLevel %>">
	            <input type="submit" value="검 강화">
        	</form>

        	<!-- 검 팔기 버튼 -->
        	<form action="Sword.jsp" method="POST">
            	<input type="hidden" name="userCode" value="<%= userCode %>">
            	<input type="hidden" name="nickname" value="<%= nickname %>">
            	<input type="hidden" name="level" value="<%= currentLevel %>">
            	<input type="hidden" name="swordLevel" value="<%= currentSwordLevel %>">
            	<input type="hidden" name="cash" value="<%= userCash %>">
            	<input type="hidden" name="sellSword" value="true">
            	<input type="submit" value="검 팔기" <%= (currentSwordLevel == 0) ? "disabled" : "" %> >
        	</form>
    	</div>
    	
    	<h4>현재 캐쉬 잔액: <%= userCash %> 원</h4>
    
    	<div class="PageReturn">
    		<!-- 뒤로 가는 버튼 -->
    		<a href="${pageContext.request.contextPath}/main.jsp?userCode=<%= userCode %>&nickname=<%= nickname %>&level=<%= currentLevel %>&cash=<%= userCash %>">돌아가기</a>
    	</div>
	</div>
</body>
</html>
