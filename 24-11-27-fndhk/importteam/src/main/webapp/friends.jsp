<%@ include file="module/WeAreTheMoney.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="css/Friends.css">
<title>전적 검색</title>
</head>
<body>
	<%
            // 중복 변수를 선언하지 않고 기존 변수를 재사용
            request.setCharacterEncoding("utf-8");
            String userCode = request.getParameter("userCode");
            String nickname = request.getParameter("nickname");
            String level = request.getParameter("level");
            String cash = request.getParameter("cash");

        %>

	<div class="PageReturn">
		<a href="main.jsp?userCode=<%= userCode %>&nickname=<%= nickname %>&level=<%= level %>&cash=<%= cash %>">돌아가기</a>
	</div>


	<h2>전적 검색</h2>
	<br>
	<p>이곳에서 다른 유저들의 전적을 추가하여 확인하세요!</p>

	<form action="FriendAddServlet" method="POST">
		닉네임으로 전적 추가: <input type="text" name="friendNickname"
			class="friend-name" required> <input type="submit" value="추가">
	</form>
	<%
            String error = request.getParameter("error");
            if ("selfFriend".equals(error)) {
        %>
	<div class="error-message">
		<p class="err">다른 유저의 닉네임을 입력하세요!</p>
	</div>
	<%
            } else if ("alreadyFriend".equals(error)) {
        %>
	<div class="error-message">
		<p class="err">이미 전적이 등록된 유저입니다!</p>
	</div>
	<%
            } else if ("userNotFound".equals(error)) {
        %>
	<div class="error-message">
		<p class="err">존재하지 않는 유저입니다!</p>
	</div>
	<%
            }
        %>

	<h3>전적 목록</h3>
	<table border="1">
		<colgroup>
			<col style="width: 40%;">
			<col style="width: 25%;">
			<col style="width: 25%;">
			<col style="width: 10%;">
		</colgroup>
		<tr>
			<th id="FnickName">닉네임</th>
			<th>레벨</th>
			<th id="rating">전적</th>
			<th>삭제</th>
		</tr>
		<%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db", "root", "password");
                String userCodestr = (String) session.getAttribute("userCode");
                int userCode1 = 0;
                userCode1 = Integer.parseInt(userCodestr);
                
                String query = "SELECT users.nickname, users.level, users.win_count, users.lose_count, friends.friend_code FROM friends " +
                               "JOIN users ON friends.friend_code = users.user_code WHERE friends.user_code = ?";
                PreparedStatement stmt = conn.prepareStatement(query);
                stmt.setInt(1, userCode1);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    String nickname1 = rs.getString("nickname");
                    int level1 = rs.getInt("level");
                    int winCount = rs.getInt("win_count");
                    int loseCount = rs.getInt("lose_count");
                    int friendCode = rs.getInt("friend_code");
                    
        %>
		<tr>
			<td><%= nickname1 %></td>
			<td><%= level1 %></td>
			<td><%= winCount %>승 / <%= loseCount %>패</td>
			<td>
				<form action="DeleteFriend" method="POST">
					<input type="hidden" name="userCode" value="<%= userCode1 %>">
					<input type="hidden" name="friendCode" value="<%= friendCode %>">
					<input type="hidden" name="nickname" value="<%= nickname %>">
					<input type="hidden" name="level" value="<%= level %>"> 
					<input type="hidden" name="cash" value="<%= cash %>">
					<input type="submit" value="삭제">
				</form>
			</td>
		</tr>
		<%
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>전적 목록을 불러오는데 실패</p>");
            }
        %>
	</table>
</body>
</html>
