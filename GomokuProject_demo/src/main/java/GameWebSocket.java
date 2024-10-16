import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.*;

@ServerEndpoint("/game")
public class GameWebSocket {
    private static Set<Session> playerSessions = Collections.synchronizedSet(new HashSet<>());
    private static Map<Session, String> playerColors = new HashMap<>();  // 각 세션의 돌 색상
    private static String currentTurn = "black";  // 첫 번째 턴은 흑돌

    @OnOpen
    public void onOpen(Session session) throws IOException {
        playerSessions.add(session);
        if (playerSessions.size() == 1) {
            playerColors.put(session, "black");
        } else {
            playerColors.put(session, "white");
        }
    }

    @OnMessage
    public void onMessage(String message, Session session) throws IOException {
        Map<String, Object> moveData = new HashMap<>();
        moveData.put("type", "move");
        moveData.put("color", playerColors.get(session));

        if (!playerColors.get(session).equals(currentTurn)) {
            session.getBasicRemote().sendText("{\"type\":\"error\", \"message\":\"잘못된 차례입니다.\"}");
            return;
        }

        // 착수 정보 전송
        for (Session s : playerSessions) {
            if (s.isOpen()) {
                s.getBasicRemote().sendText(message);  // 다른 클라이언트에 전송
            }
        }

        // 턴 전환
        currentTurn = currentTurn.equals("black") ? "white" : "black";
    }

    @OnClose
    public void onClose(Session session) throws IOException {
        playerSessions.remove(session);
        playerColors.remove(session);
    }
}
