<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="css/adminPanel.css">
    <title>관리자 페이지</title>
</head>
<body>
    <h2>관리자 페이지</h2>

    <%
        // URL 파라미터로 userCode 전달 받기
        String userCodeParam = request.getParameter("userCode");
   	 	String nickname = request.getParameter("nickname");
        String level = request.getParameter("level");
        String cash = request.getParameter("cash");
   	%>
   	
   	<div class = "PageReturn">
		<a href="myPage.jsp?userCode=<%= userCodeParam %>&nickname=<%= nickname %>&level=<%= level %>&cash=<%= cash %>">돌아가기</a>
	</div>
   	
   	<%      
        if (userCodeParam == null) {
            response.sendRedirect("login.jsp"); // userCode 없으면 로그인 페이지로 리다이렉트
            return;
        }

        int userCode = Integer.parseInt(userCodeParam);
        boolean isAdmin = false;
        Connection conn = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gomoku_db?useUnicode=true&characterEncoding=utf8", "root", "password"); // 비밀번호 1234

            // 관리자인지 확인
            String checkAdminQuery = "SELECT admin_rights FROM users WHERE user_code = ?";
            PreparedStatement adminStmt = conn.prepareStatement(checkAdminQuery);
            adminStmt.setInt(1, userCode);
            ResultSet adminRs = adminStmt.executeQuery();

            if (adminRs.next()) {
                isAdmin = adminRs.getBoolean("admin_rights");
            }

            if (!isAdmin) {
                // 관리자가 아닐 경우 메시지 표시 후 메인 페이지로 리다이렉트
                out.println("<h3>관리자 전용 페이지입니다.</h3>");
                response.sendRedirect("main.jsp"); // 메인 페이지로 리다이렉트
                return;
            }

            // 회원 목록 가져오기
            String query = "SELECT user_code, id, nickname, level, win_count, lose_count FROM users";
            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();
    %>

    <h3>회원 목록</h3>
    <table border="1">
        <tr>
            <th>회원 ID</th>
            <th>닉네임</th>
            <th>레벨</th>
            <th>승/패</th>
            <th>강제 탈퇴</th>
        </tr>
        <%
            while (rs.next()) {
                int memberCode = rs.getInt("user_code");
                String memberId = rs.getString("id");
                String memberNickname = rs.getString("nickname");
                int level1 = rs.getInt("level");
                int wins = rs.getInt("win_count");
                int losses = rs.getInt("lose_count");
        %>
        <tr>
            <td><%= memberId %></td>
            <td><%= memberNickname %></td>
            <td><%= level1 %></td>
            <td><%= wins %> 승 / <%= losses %> 패</td>
            <td>
                <form action="DeleteUserServlet" method="POST">
                    <input type="hidden" name="userCode" value="<%= memberCode %>">
                    <input type="hidden" name="userCode" value="<%= nickname %>">
                    <input type="hidden" name="userCode" value="<%= level %>">
                    <input type="hidden" name="userCode" value="<%= cash %>">
                    <input type="submit" value="강제 탈퇴">
                </form>
            </td>
        </tr>
        <%
            }
        %>
    </table>

    <%
        } catch (Exception e) {
            e.printStackTrace(); // 오류 발생 시 스택 트레이스 출력
        }
    %>
</body>
</html>
