package com.stadium.websocket;

import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

@ServerEndpoint("/stadiumWS") // นี่คือที่อยู่ของท่อส่งข้อมูล
public class StadiumWebSocket {
    
    // เก็บรายการหน้าเว็บที่เปิดอยู่ทั้งหมด
    private static Set<Session> clients = Collections.synchronizedSet(new HashSet<Session>());

    @OnOpen
    public void onOpen(Session session) {
        clients.add(session);
        System.out.println("New Connection: " + session.getId()); // เติม get เข้าไปข้างหน้า
    }

    @OnClose
    public void onClose(Session session) {
        clients.remove(session);
    }

    // ฟังก์ชันสำหรับส่งข้อมูลหาทุกคน (Broadcast)
    public static void broadcast(String message) {
        for (Session client : clients) {
            try {
                client.getBasicRemote().sendText(message);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}