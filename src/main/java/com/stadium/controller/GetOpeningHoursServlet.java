/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.stadium.controller;

import com.google.gson.Gson; // อย่าลืม Add Library GSON ในโปรเจกต์ด้วยนะครับ
import com.stadium.dao.StadiumDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author zawsf
 */
@WebServlet("/getOpeningHours") // *** ตรงนี้ต้องสะกดให้ตรงกับที่เรียกใน AJAX ***
public class GetOpeningHoursServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String dateStr = request.getParameter("date");
        
        // จำลอง Logic การเช็ค (คุณสามารถเปลี่ยนไปดึงจาก DB ได้ตามที่เราคุยกันก่อนหน้า)
        Map<String, Object> result = new HashMap<>();
        
        try {
            // ดึงชื่อวันจากวันที่ที่ส่งมา (เช่น 2026-04-05 -> Sunday)
            java.time.LocalDate date = java.time.LocalDate.parse(dateStr);
            String dayName = date.getDayOfWeek().name(); // SUNDAY, MONDAY...

            com.stadium.dao.StadiumDAO stadiumDao = new com.stadium.dao.StadiumDAO();
             result = stadiumDao.getOpeningHoursByDay(dayName);

            // แปลง Map เป็น JSON ส่งกลับไป
            String json = new Gson().toJson(result);
            response.getWriter().write(json);

        } catch (Exception e) {
            response.setStatus(500);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}