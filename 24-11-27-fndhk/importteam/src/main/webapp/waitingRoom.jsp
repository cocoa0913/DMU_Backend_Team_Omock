<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>대기실</title>
    <link rel="stylesheet" type="text/css" href="css/waitingRoom.css">
    <script>
        let socket;

        // WebSocket 연결
        function connectWebSocket(roomId) {
            socket = new WebSocket("ws://localhost:8080/Game1118/game");

            socket.onopen = function () {
                socket.send(JSON.stringify({ type: "join", roomId: roomId }));
            };

            socket.onmessage = function (event) {
                const message = JSON.parse(event.data);

                if (message.type === "playerUpdate") {
                    document.getElementById("participants").innerText = "참여자 수: " + message.playerCount;

                    // 참여자 수가 2명이 되면 게임 시작
                    if (message.playerCount === 2) {
                        alert("참여자 2명 확인. 5초 후 게임이 시작됩니다!");
                        setTimeout(() => {
                            window.location.href = "game.jsp?roomId=" + roomId;
                        }, 5000);
                    }
                }
            };

            socket.onclose = function () {
                alert("서버와의 연결이 끊어졌습니다.");
            };
        }

        window.onload = function () {
            const roomId = "<%= request.getParameter("roomId") %>";
            connectWebSocket(roomId);
        };
    </script>
</head>
<body>
    <h2>대기실</h2>
    <div id="participants">참여자 수를 불러오는 중...</div>

    <%
        String roomIdParam = request.getParameter("roomId");
        if (roomIdParam == null) {
            out.println("<p style='color: red;'>유효하지 않은 접근입니다.</p>");
            response.sendRedirect("main.jsp");
            return;
        }

        int roomId = Integer.parseInt(roomIdParam);
        out.println("<p>방 ID: " + roomId + "</p>");
    %>
</body>
</html>
