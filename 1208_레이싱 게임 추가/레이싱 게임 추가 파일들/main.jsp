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
            <h1>바다 이야기 온라인</h1> <br>
            <p>이곳에서 여러가지 게임을 플레이하세요!</p>
        </div>
        
        <%
            // URL에서 사용자 정보를 가져옴
            String userCode = request.getParameter("userCode");
            String nickname = request.getParameter("nickname");
            String level = request.getParameter("level");
            String cash = request.getParameter("cash");
            String iconCode = request.getParameter("iconCode");

         	
            // 아이콘 변경 시 세션에서 아이콘 코드 갱신
            if (userCode != null) {
            	session.setAttribute("userCode", userCode);
            	session.setAttribute("nickname", nickname);
            	session.setAttribute("level", level);
            	session.setAttribute("cash", cash);
            	session.setAttribute("iconCode", iconCode); // iconCode를 세션에 저장
            } else {
                userCode = (String) session.getAttribute("userCode");
                nickname = (String) session.getAttribute("nickname");
                level = (String) session.getAttribute("level");
                cash = (String) session.getAttribute("cash");
                iconCode = (String) session.getAttribute("iconCode"); // 세션에서 iconCode 가져오기
            }
            
         	// 필수 정보가 없을 경우 로그인 페이지로 리다이렉트
            if (userCode == null || nickname == null || level == null || cash == null) {
                response.sendRedirect("login.jsp"); // 로그인 페이지로 리다이렉트
                return;
            }

            // 사용자 아이콘 로드
            String base64Icon = "";
            try (
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "1234");
                PreparedStatement stmt = conn.prepareStatement(
                    "SELECT icons.icon_img " +
                    "FROM icons " +
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
                        } else {
                            throw new Exception("DB에서 이미지가 없습니다."); // 예외 던짐
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p style='color:red;'>DB에서 이미지를 불러오지 못했습니다.</p>");
                return; // 이미지 로드 실패 시 종료
            }
        %>
        
        <!-- 게임 시작 버튼 -->
        <div class="content-container">
            <div class="single-box">
                <h3>게임 동산</h3>
                <div class="option-box">
                    <form action="GameBindex.jsp" method="GET">
                        <input type="hidden" name="userCode" value="<%= userCode %>">
                        <input type="hidden" name="nickname" value="<%= nickname %>">
                        <input type="hidden" name="level" value="<%= level %>">
                        <input type="hidden" name="cash" value="<%= cash %>">
                        <input type="submit" value="블 랙 잭">
                    </form>
                </div>
                <div class="option-box">
                    <form action="SwordStart.jsp" method="GET">
                        <input type="hidden" name="userCode" value="<%= userCode %>">
                        <input type="hidden" name="nickname" value="<%= nickname %>">
                        <input type="hidden" name="level" value="<%= level %>">
                        <input type="hidden" name="cash" value="<%= cash %>">
                        <input type="submit" value="전설의 검 강화하기">
                    </form>
                </div>
                <div class="option-box">
                    <form action="game.jsp" method="GET">
                        <input type="hidden" name="userCode" value="<%= userCode %>">
                        <input type="hidden" name="nickname" value="<%= nickname %>">
                        <input type="hidden" name="level" value="<%= level %>">
                        <input type="hidden" name="cash" value="<%= cash %>">
                        <input type="submit" value="미스터리 박스">
                    </form>
                </div>
                <div class="option-box">
                    <form action="game2.jsp" method="GET">
                        <input type="hidden" name="userCode" value="<%= userCode %>">
                        <input type="hidden" name="nickname" value="<%= nickname %>">
                        <input type="hidden" name="level" value="<%= level %>">
                        <input type="hidden" name="cash" value="<%= cash %>">
                        <input type="submit" value="슬롯 머신">
                    </form>
                </div>
                <div class="option-box">
                    <form action="racingGame.jsp" method="GET">
                        <input type="hidden" name="userCode" value="<%= userCode %>">
                        <input type="hidden" name="nickname" value="<%= nickname %>">
                        <input type="hidden" name="level" value="<%= level %>">
                        <input type="hidden" name="cash" value="<%= cash %>">
                        <input type="submit" value="토끼와 거북이 레이싱">
                    </form>
                </div>
            </div>
            
            <div class="user-info-container">
                <h2>환영합니다</h2>
                <div class="icon-level-container">
                    <div class="icon-box">
                        <!-- 아이콘 클릭 시 아이콘 변경 페이지로 이동 -->
                        <a href="changeIcon.jsp?userCode=<%= userCode %>&nickname=<%= nickname %>&level=<%= level %>&cash=<%= cash %>">
                            <img src="data:image/png;base64,<%= base64Icon %>" alt="회원 아이콘" width="80" height="80">
                        </a>
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
                        <form action="chargeRequest.jsp" method="GET">
                        	<input type="hidden" name="userCode" value="<%= userCode %>">
                        	<input type="hidden" name="nickname" value="<%= nickname %>">
                        	<input type="hidden" name="level" value="<%= level %>">
                        	<input type="hidden" name="cash" value="<%= cash %>">
                            <input type="submit" value="충전 신청">
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
