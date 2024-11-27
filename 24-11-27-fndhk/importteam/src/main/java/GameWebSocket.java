import java.io.IOException;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint("/game")
public class GameWebSocket {
    private static Map<Integer, Set<Session>> roomSessions = new ConcurrentHashMap<>();
    private static Map<Session, Integer> sessionRoomMap = new ConcurrentHashMap<>();
    private static List<Room> publicRooms = Collections.synchronizedList(new ArrayList<>());

    @OnOpen
    public void onOpen(Session session) {
        System.out.println("New connection: " + session.getId());
    }

    @OnMessage
    public void onMessage(String message, Session session) {
        try {
            String[] parts = message.split(":", 2);
            String command = parts[0];

            switch (command) {
                case "room_new":
                    Room newRoom = createRoom(parts[1]);
                    if (newRoom != null) {
                        publicRooms.add(newRoom);
                        broadcastRoomList();
                    }
                    break;

                case "room_list":
                    broadcastRoomList();
                    break;

                case "room_enter":
                    int roomId = Integer.parseInt(parts[1]);
                    joinRoom(roomId, session);
                    break;

                case "room_leave":
                    leaveRoom(session);
                    break;

                case "room_remove":
                    int roomIdToRemove = Integer.parseInt(parts[1]);
                    removeRoom(roomIdToRemove);
                    break;

                default:
                    System.out.println("Unknown command: " + command);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @OnClose
    public void onClose(Session session) {
        leaveRoom(session);
        System.out.println("Connection closed: " + session.getId());
    }

    private void joinRoom(int roomId, Session session) {
        roomSessions.computeIfAbsent(roomId, k -> ConcurrentHashMap.newKeySet()).add(session);
        sessionRoomMap.put(session, roomId);

        int playerCount = roomSessions.get(roomId).size();
        broadcastToRoom(roomId, "playerUpdate", playerCount);

        // 참여자가 2명이 되면 게임 시작 알림
        if (playerCount == 2) {
            broadcastToRoom(roomId, "gameStart", playerCount);
        }

        System.out.println("Room " + roomId + ": Player joined (" + playerCount + " players total)");
    }

    private void leaveRoom(Session session) {
        Integer roomId = sessionRoomMap.remove(session);
        if (roomId != null) {
            Set<Session> sessions = roomSessions.get(roomId);
            if (sessions != null) {
                sessions.remove(session);
                if (sessions.isEmpty()) {
                    roomSessions.remove(roomId);
                } else {
                    broadcastToRoom(roomId, "playerUpdate", sessions.size());
                }
            }
        }
    }

    private void broadcastToRoom(int roomId, String type, int playerCount) {
        Set<Session> sessions = roomSessions.get(roomId);
        if (sessions != null) {
            sessions.forEach(session -> {
                try {
                    session.getBasicRemote().sendText("{\"type\":\"" + type + "\",\"playerCount\":" + playerCount + "}");
                } catch (IOException e) {
                    e.printStackTrace();
                }
            });
        }
    }

    // 새로운 메서드 추가: broadcastRoomUpdate
    public static void broadcastRoomUpdate(String message) {
        roomSessions.values().forEach(sessions -> sessions.forEach(session -> {
            try {
                session.getBasicRemote().sendText(message);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }));
    }

    public static void broadcastRoomList() {
        synchronized (publicRooms) {
            publicRooms.sort(Comparator.comparing(Room::getCreationTime));
            StringBuilder json = new StringBuilder("room_list:[");
            for (int i = 0; i < publicRooms.size(); i++) {
                Room room = publicRooms.get(i);
                json.append("{")
                    .append("\"id\":").append(i + 1).append(",")
                    .append("\"name\":\"").append(room.getName()).append("\",")
                    .append("\"players\":").append(room.getPlayerCount()).append(",")
                    .append("\"status\":\"").append(room.isPrivate() ? "비공개" : "공개").append("\",")
                    .append("\"creationTime\":").append(room.getCreationTime())
                    .append("}");
                if (i < publicRooms.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");
            broadcastRoomUpdate(json.toString()); // 새로운 메서드 사용
        }
    }

    private static Room createRoom(String roomData) {
        String[] data = roomData.split(",");
        String roomName = data[0].trim();
        boolean isPrivate = data.length > 1 && !data[1].isEmpty();
        if (roomName == null || roomName.isEmpty()) {
            return null;
        }
        Room newRoom = new Room(roomName);
        if (isPrivate) {
            newRoom.setPrivate(true);
        }
        return newRoom;
    }

    public static void removeRoom(int roomId) {
        synchronized (publicRooms) {
            publicRooms.removeIf(room -> room.getName().equals("Room" + roomId));
        }
        roomSessions.remove(roomId);
        broadcastRoomList();
    }

    public static void broadcast(String message) {
        roomSessions.values().forEach(sessions -> sessions.forEach(session -> {
            try {
                session.getBasicRemote().sendText(message);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }));
    }
}

class Room {
    private String name;
    private int playerCount;
    private boolean isPrivate;
    private long creationTime;

    public Room(String name) {
        this.name = name;
        this.playerCount = 0;
        this.isPrivate = false;
        this.creationTime = System.currentTimeMillis();
    }

    public String getName() {
        return name;
    }

    public int getPlayerCount() {
        return playerCount;
    }

    public void incrementPlayerCount() {
        this.playerCount++;
    }

    public void decrementPlayerCount() {
        if (this.playerCount > 0) {
            this.playerCount--;
        }
    }

    public boolean isPrivate() {
        return isPrivate;
    }

    public void setPrivate(boolean isPrivate) {
        this.isPrivate = isPrivate;
    }

    public long getCreationTime() {
        return creationTime;
    }
}
