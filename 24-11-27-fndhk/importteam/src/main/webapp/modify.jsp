<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>정보 수정</title>
    <link rel="stylesheet" type="text/css" href="css/modify.css">
</head>
<body>
    <h2>정보 수정</h2>

    <%
        String userCode = request.getParameter("userCode");
        String nickname = request.getParameter("nickname");
        String level = request.getParameter("level");
        String cash = request.getParameter("cash");
        String error = request.getParameter("error");
        String success = request.getParameter("success");

        if (error != null) {
            out.println("<p style='color: red;'>" + error + "</p>");
        } else if (success != null) {
            out.println("<p style='color: green;'>" + success + "</p>");
        }

        if (userCode == null || nickname == null) {
            out.println("<p style='color: red;'>필수 정보가 누락되었습니다.</p>");
            return;
        }
    %>

    <form action="modifyServlet" method="POST">
        <input type="hidden" name="userCode" value="<%= userCode %>">
        <input type="hidden" name="level" value="<%= level %>">
        <input type="hidden" name="cash" value="<%= cash %>">
        <label for="newNickname">현재 닉네임: <b><%= nickname %></b></label><br>
        <label for="newNickname">새 닉네임:</label>
        <input type="text" id="newNickname" name="newNickname" placeholder="새 닉네임 입력" required>
        <button type="submit">변경</button>
    </form>

    <div class="PageReturn">
        <a href="myPage.jsp?userCode=<%= userCode %>&nickname=<%= nickname %>&level=<%= level %>&cash=<%= cash %>">돌아가기</a>
    </div>
</body>
</html>
