package com.stadium.controller;

import com.stadium.dao.StadiumDAO;
import com.stadium.model.OpeningHours;
import com.stadium.websocket.StadiumWebSocket;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/bookStadium")
public class BookingServlet extends HttpServlet {
    
 @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("id");
        String date = request.getParameter("date");
        String[] times = request.getParameterValues("time[]");

        HttpSession session = request.getSession();
        com.users.model.User user = (com.users.model.User) session.getAttribute("user");

        if (user == null) {
            response.getWriter().write("not_logged_in");
            return;
        }

        try {
            int stadiumId = Integer.parseInt(idStr);
            StadiumDAO stadiumDao = new StadiumDAO();
            com.stadium.model.Stadium stadium = stadiumDao.getStadiumById(stadiumId);
            
            if (stadium == null) {
                response.getWriter().write("stadium_not_found");
                return;
            }

    
            if (times == null || times.length == 0) {
                response.getWriter().write("no_time_selected");
                return;
            }

           
java.util.Arrays.sort(times); 

String startTime = times[0]; 


String lastSlot = times[times.length - 1];
int endHour = Integer.parseInt(lastSlot.split(":")[0]) + 1;
String endTime = (endHour < 10 ? "0" + endHour : endHour) + ":00:00"; 

// คำนวณราคาตามจำนวนชั่วโมงที่ติ๊กจริง
double totalPrice = stadium.getPrice() * times.length;
            
            // บันทึกข้อมูลผ่าน DAO (ใช้ Method ที่คุณแก้ให้รับ 6 พารามิเตอร์)
            com.stadium.dao.BookingDAO dao = new com.stadium.dao.BookingDAO();
            int newBookingId = dao.insertBooking(user.getId(), stadiumId, date, startTime, endTime, totalPrice);

            if (newBookingId > 0) {
                // ส่ง success:ID กลับไปหน้า Index
                response.getWriter().print("success:" + newBookingId);
            } else {
                response.getWriter().print("fail");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error:" + e.getMessage());
        }
    }
}