/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.stadium.controller;

import com.google.gson.Gson; // อย่าลืมเพิ่ม Library Gson ในโปรเจกต์นะ
import com.stadium.dao.BookingDAO; // สมมติว่าคุณสร้าง BookingDAO ไว้แล้ว
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

/**
 *
 * @author zawsf
 */
@WebServlet("/getOccupiedTimes")
public class GetOccupiedTimesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. ตั้งค่า Response ให้เป็น JSON และรองรับภาษาไทย
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 2. รับค่าที่ส่งมาจาก AJAX (index.jsp)
        String stadiumIdStr = request.getParameter("id");
        String date = request.getParameter("date");

        try (PrintWriter out = response.getWriter()) {
            if (stadiumIdStr != null && date != null) {
                int stadiumId = Integer.parseInt(stadiumIdStr);

                // 3. เรียกใช้ DAO เพื่อไปดึงข้อมูลจาก Database
                // (เดี๋ยวเราไปสร้าง Method getOccupiedSlots ใน BookingDAO กัน)
                BookingDAO bdao = new BookingDAO();
                List<Map<String, String>> occupiedSlots = bdao.getOccupiedSlots(stadiumId, date);

                // 4. แปลง List เป็น JSON String แล้วส่งกลับไป
                String json = new Gson().toJson(occupiedSlots);
                out.print(json);
            } else {
                out.print("[]"); // ส่ง Array ว่างกลับไปถ้าไม่มีข้อมูล
            }
            out.flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
}
