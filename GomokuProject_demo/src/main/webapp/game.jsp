<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>오목 게임</title>
    <style>
        #gameBoard {
            border: 1px solid black;
        }
    </style>
    <script>
        var socket;
        var playerColor = 'black';  // 흑돌/백돌 (서버에서 할당할 수 있음)
        var gameOver = false;

        // 웹소켓 연결
        function connectWebSocket() {
            socket = new WebSocket("ws://localhost:8080/gomoku/game");

            socket.onmessage = function(event) {
                var data = JSON.parse(event.data);
                if (data.type === 'move') {
                    drawMove(data.x, data.y, data.color);
                } else if (data.type === 'gameOver') {
                    alert(data.winner + " 승리!");
                    gameOver = true;
                }
            };

            socket.onclose = function() {
                alert('연결이 끊어졌습니다.');
            };
        }

        // 게임판 설정
        function initGameBoard() {
            var canvas = document.getElementById('gameBoard');
            var context = canvas.getContext('2d');

            // 바둑판 그리기
            for (var i = 0; i < 15; i++) {
                context.moveTo(20 + i * 30, 20);
                context.lineTo(20 + i * 30, 440);
                context.stroke();
                context.moveTo(20, 20 + i * 30);
                context.lineTo(440, 20 + i * 30);
                context.stroke();
            }

            // 클릭 시 착수 이벤트
            canvas.addEventListener('click', function(event) {
                if (gameOver) {
                    alert('게임이 이미 끝났습니다.');
                    return;
                }
                var rect = canvas.getBoundingClientRect();
                var x = Math.floor((event.clientX - rect.left) / 30);
                var y = Math.floor((event.clientY - rect.top) / 30);

                socket.send(JSON.stringify({ type: 'move', x: x, y: y, color: playerColor }));
            });
        }

        // 돌 그리기
        function drawMove(x, y, color) {
            var canvas = document.getElementById('gameBoard');
            var context = canvas.getContext('2d');
            context.beginPath();
            context.arc(20 + x * 30, 20 + y * 30, 10, 0, 2 * Math.PI);
            context.fillStyle = color;
            context.fill();
        }

        window.onload = function() {
            connectWebSocket();
            initGameBoard();
        };
    </script>
</head>
<body>
    <h2>오목 게임</h2>
    <canvas id="gameBoard" width="460" height="460"></canvas>
</body>
</html>
