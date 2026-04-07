/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.stadium.controller;

import com.stadium.dao.BookingDAO;
import com.stadium.model.Booking;
import com.users.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 *
 * @author zawsf
 */
@WebServlet("/history")
public class HistoryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        BookingDAO dao = new BookingDAO();
        List<Booking> history = dao.getBookingHistory(user.getId());
        
        // ส่งตัวแปรชื่อ "bookingList" ไปที่ JSP
        request.setAttribute("bookingList", history);
        request.getRequestDispatcher("history.jsp").forward(request, response);
    }
}
