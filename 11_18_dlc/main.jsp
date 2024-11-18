<%@ include file = "module/menu.jsp" %>
<%@ include file = "module/WeAreTheMoney.jsp" %>
<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" import = "java.sql.*, java.util.Base64"%>
<!DOCTYPE html>
<html lang = "ko">
<head>
    <meta charset = "UTF-8">
    <meta name = "viewport" content = "width=device-width, initial-scale=1.0">
    <title>메인 페이지</title>
    <link rel = "stylesheet" type = "text/css" href = "css/main.css">
</head>
<body>
    <div class="main-container">
    	<div class = "headbox">
    		<h1>오목왕 온라인</h1> <br>
        	<p>오목의 최강자가 되어보세요</p>
    	</div>
        
        <%
            // URL에서 사용자 정보를 가져옴
            userCode = request.getParameter("userCode");
            nickname = request.getParameter("nickname");
            level = request.getParameter("level");
            cash = request.getParameter("cash");
            String iconCode = request.getParameter("iconCode");
            
            if (iconCode != null) {
                session.setAttribute("iconCode", iconCode); // iconCode를 세션에 저장
                session.setAttribute("userCode", userCode);
            } else {
                iconCode = (String) session.getAttribute("iconCode"); // 세션에서 iconCode 가져오기
            }

            // 필수 정보가 없을 경우 로그인 페이지로 리다이렉트
            if (userCode == null || nickname == null || level == null || cash == null) {
                response.sendRedirect("login.jsp?error=missingParameters");
                return;
            }

            // 사용자 아이콘 로드
            String base64Icon = "";
            try (
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "1234");
                PreparedStatement stmt = conn.prepareStatement(
                		"SELECT icons.icon_img FROM icons " +
                				"JOIN users ON icons.icon_code = users.icon_code " +
                				"WHERE users.user_code = ?"
                );
            ) {
                stmt.setInt(1, Integer.parseInt(userCode)); // 사용자 코드로 아이콘 조회
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        byte[] iconData = rs.getBytes("icon_img"); // icons 테이블의 icon_img 필드 가져오기
                        if (iconData != null) {
                            base64Icon = Base64.getEncoder().encodeToString(iconData); // Base64 인코딩
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
        
        <!-- 방 만들기와 방 찾기 기능 버튼 -->
        <div class="content-container">
            <div class="single-box">
                <h3>온라인 매칭</h3>
                <div class="option-box">
                    <form action="createRoom.jsp" method="GET">
                        <input type="hidden" name="userCode" value="<%= userCode %>">
                        <input type="hidden" name="nickname" value="<%= nickname %>">
                        <input type="hidden" name="level" value="<%= level %>">
                        <input type="hidden" name="cash" value="<%= cash %>">
                        <input type="submit" value="방 만들기">
                    </form>
                </div>
            </div>
            
            <div class="user-info-container">
                <h2>환영합니다</h2>
                <div class="icon-level-container">
                    <div class="icon-box">
                        <img src="<%= !base64Icon.isEmpty() ? "data:image/png;base64," + base64Icon : "Picture/icon.png" %>"
                             alt="회원 아이콘" width="80" height="80">
                    </div>
                    <div class="level-info">
                        <p>닉네임: <%= nickname %></p>
                        <p>레벨: <%= level %></p>
                    </div>
                </div>
                <hr class="divider">
                <div class="cash-membership-container">
                    <p>보유 캐쉬: <%= cash %></p>
                    <p>멤버쉽 등급: 기본 회원</p>
                    <div class="option-box">
                        <form action="" method="GET">
                            <input type="submit" value="충전하러 가기">
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
