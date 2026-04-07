/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.stadium.controller;
import com.stadium.dao.StadiumDAO;
import com.users.dao.UserDAO;
import com.users.model.User;
import com.stadium.model.Stadium;
import com.stadium.websocket.StadiumWebSocket;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;



/**
 *
 * @author zawsf
 */
@WebServlet("/adminControl")
public class AdminServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        StadiumDAO dao = new StadiumDAO();
        UserDAO udo = new UserDAO();

      try {
        if ("updateTime".equals(action)) {
            String[] days = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
try {
        for (String day : days) {
            String open = request.getParameter("open_" + day);
            String close = request.getParameter("close_" + day);
            // ถ้าติ๊กถูกจะเป็นค่าบางอย่าง (ไม่ null), ถ้าไม่ติ๊กจะเป็น null
            boolean isClosed = request.getParameter("closed_" + day) != null;
            System.out.println("DEBUG: Day=" + day + " | Open=" + open + " | Closed=" + isClosed);
           
            boolean isSuccess = dao.updateOpeningHours(day, open, close, isClosed);
             System.out.println("DEBUG: Update Result for " + day + " is " + isSuccess);
        }
        // ✅ ใช้ ContextPath ป้องกัน 404
        response.sendRedirect(request.getContextPath() + "/admin/admin.jsp?success=true");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect(request.getContextPath() + "/admin/admin.jsp?error=true");
    }

        } else if ("toggleStatus".equals(action)) {
            int id = Integer.parseInt(request.getParameter("stadiumId"));
            String current = request.getParameter("currentStatus");
            String newStatus = current.equals("Available") ? "Occupied" : "Available";
            
            if (dao.updateStatus(id, newStatus)) {
                StadiumWebSocket.broadcast("{\"stadiumId\": " + id + ", \"status\": \"" + newStatus + "\"}");
            }
            response.sendRedirect(request.getContextPath() + "/admin/admin.jsp");

        } else if ("updateStadium".equals(action)) {
    response.setContentType("text/plain");
    response.setCharacterEncoding("UTF-8");
    try {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String type = request.getParameter("type");
        double price = Double.parseDouble(request.getParameter("price"));

        Stadium s = new Stadium();
        s.setId(id); s.setName(name); s.setType(type); s.setPrice(price);

        if (dao.updateStadium(s)) {
            // ส่ง Broadcast (แก้ JSON ให้ไม่มีคอมม่าเกิน)
            String json = String.format(
                "{\"action\":\"update\", \"stadiumId\":%d, \"name\":\"%s\", \"type\":\"%s\", \"price\":%.2f}",
                id, name, type, price
            );
            StadiumWebSocket.broadcast(json);
            
            response.getWriter().write("success");
        } else {
            response.getWriter().write("fail");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.getWriter().write("Error: " + e.getMessage());
    }

} else if ("deleteStadium".equals(action)) {
            // ส่วนของ AJAX
            int id = Integer.parseInt(request.getParameter("id"));
            if (dao.deleteStadium(id)) {
                // 📣 ส่ง Broadcast บอกทุกคนให้ลบแถวนี้ทิ้งจากหน้าจอ
                StadiumWebSocket.broadcast("{\"action\":\"delete\", \"stadiumId\":" + id + "}");
                response.setContentType("text/plain");
                response.getWriter().write("success");
            } else {
                response.setStatus(500);
                response.getWriter().write("fail");
            }

        } else if ("addStadium".equals(action)) {
            // ส่วนของ Form ปกติ
            String name = request.getParameter("name");
            String type = request.getParameter("type");
            double price = Double.parseDouble(request.getParameter("price"));

            Stadium s = new Stadium(name, type, price, "Available");
            if(dao.addStadium(s)) {
                 // 📣 ส่ง Broadcast บอกทุกคนว่ามีสนามใหม่เพิ่มมา (หรือสั่งให้ทุกคน refresh ตาราง)
                 StadiumWebSocket.broadcast("{\"action\":\"reload\"}");
            }
            
            // Redirect ไปยังหน้า Stadium.jsp (เช็ค path ให้ดีว่าอยู่ admin/stadium.jsp หรือเปล่า)
                System.out.println("Redirecting to: " + request.getContextPath() + "/admin/stadium.jsp"); // ดูใน Console ว่า Path ตรงไหม
                response.sendRedirect(request.getContextPath() + "/admin/Stadium.jsp");

        } else if ("register".equals(action)) {
            String user = request.getParameter("username");
            String pass = request.getParameter("password");
            String name = request.getParameter("fullname");
            String phone = request.getParameter("phone");
            String role = "USER";
           
            boolean success = udo.register(user, pass, name, phone, role);
            if (success) {
                response.sendRedirect("login.jsp?registered=true");
            } else {
                response.sendRedirect("register.jsp?error=exists");
            }

        } else if ("login".equals(action)) {
            String user = request.getParameter("username");
            String pass = request.getParameter("password");

            User loggedUser = udo.login(user, pass);
            if (loggedUser != null) {
                // บันทึกข้อมูลผู้ใช้ลงใน Session
                HttpSession session = request.getSession();
                session.setAttribute("user", loggedUser);
                if ("ADMIN".equals(loggedUser.getRole())) { 
                    response.sendRedirect("admin/admin.jsp");
                } else {
                    response.sendRedirect("index.jsp"); 
                }
            } else {
                response.sendRedirect("login.jsp?error=invalid");
            }
        }  
    } catch (Exception e) {
        e.printStackTrace();
        if (!response.isCommitted()) {
            response.sendError(500);
        }
    } 
}
    
 
protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    
    // 1. ดึงค่า action จาก URL (เช่น ?action=logout)
    String action = request.getParameter("action"); 
    
    // 2. ตรวจสอบเงื่อนไข
    if ("logout".equals(action)) {
        HttpSession session = request.getSession(false); // get session ถ้ามี
        if (session != null) {
            session.invalidate(); // ทำลาย Session
        }
        // 3. Redirect กลับหน้าแรก
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return; // จบการทำงาน
    }
    
    // ถ้ามีการเรียก GET มาแต่ไม่ใช่ logout อาจจะส่งกลับหน้าหลักหรือแสดง Error
    response.sendRedirect(request.getContextPath() + "/index.jsp");
}


}
