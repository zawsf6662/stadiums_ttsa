package com.stadium.controller;

import com.stadium.dao.BookingDAO;
import com.stadium.model.OpeningHours;
import com.stadium.websocket.StadiumWebSocket;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/getBookingEvents")
public class BookingEventServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        BookingDAO dao = new BookingDAO();
        List<Map<String, Object>> bookings = dao.getBookingForCalendar();

        // ⚠️ ใช้ GSON แปลง List เป็นข้อความ JSON
        String json = new com.google.gson.Gson().toJson(bookings);
        
        // ลองจด Log ดูใน Console ของโปรแกรมว่ามีข้อมูลไหม
        System.out.println("JSON Data: " + json); 
        
        response.getWriter().write(json);
    }
}