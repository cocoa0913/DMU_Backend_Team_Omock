<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>재경기 진행</title>
</head>
<body>
    <h2>재경기가 시작됩니다!</h2>

    <%
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        
        // 재경기 로직 처리 (예: 게임 초기화)
        // 이 부분에 재경기를 위한 게임 초기화 및 준비 로직을 작성
    %>
</body>
</html>
