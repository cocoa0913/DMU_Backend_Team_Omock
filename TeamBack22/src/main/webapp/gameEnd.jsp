<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게임 종료</title>
    <script>
        // 팝업을 통해 재경기 여부 확인
        function confirmRematch(roomId) {
            const result = confirm("패자가 재경기를 신청하시겠습니까?");
            if (result) {
                // 재경기 신청: 방 유지
                alert("재경기가 진행됩니다!");
                window.location.href = "rematch.jsp?roomId=" + roomId; // 재경기 로직 처리
            } else {
                // 재경기 미신청: 방 삭제
                alert("방이 삭제됩니다.");
                window.location.href = "deleteRoomServlet?roomId=" + roomId; // 방 삭제 서블릿 호출
            }
        }

        // 일정 시간 내 응답이 없으면 자동 방 삭제
        function autoDeleteRoom(roomId) {
            setTimeout(() => {
                alert("시간 초과로 방이 삭제됩니다.");
                window.location.href = "deleteRoomServlet?roomId=" + roomId;
            }, 60000); // 1분 대기
        }

        // 페이지 로드 후 팝업 실행
        window.onload = function() {
            const roomId = "<%= request.getParameter("roomId") %>"; // 방 ID
            confirmRematch(roomId);
            autoDeleteRoom(roomId); // 자동 삭제 타이머 시작
        }
    </script>
</head>
<body>
    <h2>게임이 종료되었습니다.</h2>
</body>
</html>
