
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <link rel="stylesheet" type="text/css" href="css/myPage.css"> <!-- CSS 파일 추가 -->
</head>
<body>
	
	
    <h2>마이페이지</h2>
    <%
        // URL 파라미터로 전달된 값 확인
        String userCodeParam = request.getParameter("userCode");
        String nickname = request.getParameter("nickname");
        String levelParam = request.getParameter("level");
        String cashParam = request.getParameter("cash");
        String adminParam = request.getParameter("admin_rights");
	%>
	
	<div class = "PageReturn">
		<a href="main.jsp?userCode=<%= userCodeParam %>&nickname=<%= nickname %>&level=<%= levelParam %>&cash=<%= cashParam %>">돌아가기</a>
	</div>
	
	<%
        // 필요한 정보가 전달되지 않으면 로그인 페이지로 리다이렉트
        if (userCodeParam == null || nickname == null || levelParam == null || cashParam == null) {
            response.sendRedirect("login.jsp"); // 필요한 정보가 없으면 로그인 페이지로 리다이렉트
            return;
        }

        int userCode;
        int level;
        int cash;

        try {
            userCode = Integer.parseInt(userCodeParam);
            level = Integer.parseInt(levelParam);
            cash = Integer.parseInt(cashParam);
            
        } catch (NumberFormatException e) {
            out.println("<p>잘못된 입력입니다.</p>");
            return; // 입력이 잘못된 경우 더 이상 진행하지 않음
        }

        // 데이터베이스 연결 설정
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db?useUnicode=true&characterEncoding=utf8", "root", "password"); // 비밀번호 1234

            // 사용자 정보 표시
            %>
            <h3>내 정보</h3>
            <p>닉네임: <%= nickname %></p>
            <p>레벨: <%= level %></p>
            <p>보유 캐쉬: <%= cash %></p>

            <h3>아이템 목록</h3>
            <table border="1">
                <tr>
                    <th>아이템 이름</th>
                    <th>구입 날짜</th>
                </tr>
            <%
            // 사용자가 구입한 아이템 목록을 조회
            String query = "SELECT items.item_name, user_items.acquired_date FROM user_items " +
                           "JOIN items ON user_items.item_code = items.item_code WHERE user_items.user_code = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, userCode);
            rs = stmt.executeQuery();

            while (rs.next()) {
                String itemName = rs.getString("item_name");
                String acquiredDate = rs.getString("acquired_date");
            %>
                <tr>
                    <td><%= itemName %></td>
                    <td><%= acquiredDate %></td>
                </tr>
            <%
            }
            %>
            </table>
			<%
			String admin = "SELECT admin_rights FROM users WHERE user_code = ?";
			stmt = conn.prepareStatement(admin);
			stmt.setInt(1, userCode);
			rs = stmt.executeQuery();
			if (rs.next()) {
				boolean adminrights = rs.getBoolean("admin_rights");
				if (adminrights) {
			%>
			<h3><a href="adminPanel.jsp?userCode=<%= userCode %>&nickname=<%= nickname %>&level=<%= levelParam %>&cash=<%= cashParam %>">관리자 페이지</a></h3>
			<%
				}
			}
			%>
            

        <%
        } catch (Exception e) {
            e.printStackTrace(); // 오류 발생 시 스택 트레이스 출력
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    %>
</body>
</html>
