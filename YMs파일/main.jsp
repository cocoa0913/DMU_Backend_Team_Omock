<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" import = "java.sql.*, java.util.Base64"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="${contextPath}/module/menu.jsp" />
<jsp:include page="${contextPath}/module/WeAreTheMoney.jsp" />

<!DOCTYPE html>
<html lang = "ko">
<head>
    <meta charset = "UTF-8">
    <meta name = "viewport" content = "width=device-width, initial-scale=1.0">
    <title>메인 페이지</title>
    <link rel = "stylesheet" type = "text/css" href = "${pageContext.request.contextPath}/css/main.css">
</head>
<body>

<audio autoplay>
    <source src="${pageContext.request.contextPath}/Picture/audio/ㄱㄱ.m4a" type="audio/mpeg">
</audio>
    <div class="main-container">
        <div class = "headbox">
            <h1>황금 대박 카지노</h1> <br>
            <p>일확천금의 기회를 손에 넣으세요!</p>
        </div>
        
        <%
    // URL에서 사용자 정보를 가져옴
    String userCode = request.getParameter("userCode");
    String nickname = request.getParameter("nickname");
    String level = request.getParameter("level");
    String cash = request.getParameter("cash");
    String iconCode = request.getParameter("iconCode");
    int exp = 0;

    // 아이콘 변경 시 세션에서 아이콘 코드 갱신
    if (userCode != null) {
        session.setAttribute("userCode", userCode);
        session.setAttribute("nickname", nickname);
        session.setAttribute("level", level);
        session.setAttribute("cash", cash);
        session.setAttribute("iconCode", iconCode);
    } else {
        userCode = (String) session.getAttribute("userCode");
        nickname = (String) session.getAttribute("nickname");
        level = (String) session.getAttribute("level");
        cash = (String) session.getAttribute("cash");
        iconCode = (String) session.getAttribute("iconCode");
    }
    
    // 필수 정보가 없을 경우 로그인 페이지로 리다이렉트
    if (userCode == null || nickname == null || level == null || cash == null) {
        response.sendRedirect("login.jsp"); // 로그인 페이지로 리다이렉트
        return;
    }

    // 사용자 아이콘, 경험치, 멤버십 정보 로드
    String base64Icon = "";
    boolean isPremium = false; // 멤버십 상태
    try (
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");
        PreparedStatement stmt = conn.prepareStatement(
            "SELECT u.ads_removed, u.experience, i.icon_img " +
            "FROM users u " +
            "LEFT JOIN icons i ON u.icon_code = i.icon_code " +
            "WHERE u.user_code = ?"
        );
    ) {
        stmt.setInt(1, Integer.parseInt(userCode)); // 사용자 코드로 조회
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                exp = rs.getInt("experience"); // 경험치 로드
                byte[] iconData = rs.getBytes("icon_img"); // icons 테이블의 icon_img 필드 가져오기
                isPremium = rs.getBoolean("ads_removed"); // 멤버십 상태 확인
                if (iconData != null) {
                    base64Icon = Base64.getEncoder().encodeToString(iconData); // Base64 인코딩
                } else {
                    base64Icon = ""; // 기본 아이콘 처리
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p style='color:red;'>DB에서 정보를 불러오지 못했습니다.</p>");
        return; // 정보 로드 실패 시 종료
    }

    // 멤버십 등급 설정
    String membershipLevel = isPremium ? "프리미엄 회원" : "기본 회원";
%>

        
        <!-- 게임 시작 버튼 -->
        <div class="content-container">
            <div class="single-box">
            <hr>
                <h3>게임 선택</h3>
                <hr>
                <div class="option-box">
                    <form action="${pageContext.request.contextPath}/Game/GameBindex.jsp" method="GET">
                        <input type="hidden" name="userCode" value="<%= userCode %>">
                        <input type="hidden" name="nickname" value="<%= nickname %>">
                        <input type="hidden" name="level" value="<%= level %>">
                        <input type="hidden" name="cash" value="<%= cash %>">
                        <input type="submit" value="블 랙 잭">
                    </form>
                </div>
                <div class="option-box">
                    <form action="${pageContext.request.contextPath}/Game/SwordStart.jsp" method="GET">
                        <input type="hidden" name="userCode" value="<%= userCode %>">
                        <input type="hidden" name="nickname" value="<%= nickname %>">
                        <input type="hidden" name="level" value="<%= level %>">
                        <input type="hidden" name="cash" value="<%= cash %>">
                        <input type="submit" value="전설의 검 강화하기">
                    </form>
                </div>
                <div class="option-box">
                    <form action="${pageContext.request.contextPath}/Game/game.jsp" method="GET">
                        <input type="hidden" name="userCode" value="<%= userCode %>">
                        <input type="hidden" name="nickname" value="<%= nickname %>">
                        <input type="hidden" name="level" value="<%= level %>">
                        <input type="hidden" name="cash" value="<%= cash %>">
                        <input type="submit" value="미스터리 박스">
                    </form>
                </div>
                
                <div class="option-box">
                    <form action="${pageContext.request.contextPath}/Game/racingGame.jsp" method="GET">
                        <input type="hidden" name="userCode" value="<%= userCode %>">
                        <input type="hidden" name="nickname" value="<%= nickname %>">
                        <input type="hidden" name="level" value="<%= level %>">
                        <input type="hidden" name="cash" value="<%= cash %>">
                        <input type="hidden" name="experience" value="<%= exp %>">
                        <input type="submit" value="토끼와 거북이 레이싱">
                    </form>
                </div>
            </div>
            
            <div class="user-info-container">
            <hr>
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
                    <p>보유 캐쉬: <%= cash %> 캐쉬</p>
                    <p>멤버십 등급: <%= membershipLevel %></p>
                    <div class="option-box">
                        <form action="${pageContext.request.contextPath}/chargeRequest.jsp" method="GET">
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
