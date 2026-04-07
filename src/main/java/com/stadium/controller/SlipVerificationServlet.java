/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.stadium.controller;

import jakarta.servlet.ServletException;
import com.stadium.dao.StadiumDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import com.stadium.dao.BookingDAO; 
import jakarta.servlet.annotation.MultipartConfig;
import okhttp3.*; 
import org.json.JSONObject; 
import java.io.InputStream;
import java.time.LocalDateTime;

/**
 *
 * @author zawsf
 */
@WebServlet("/verifySlip")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5)  
public class SlipVerificationServlet extends HttpServlet {
    
  
    private static final OkHttpClient client = new OkHttpClient();
    private final String API_KEY = "#"; 

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain;charset=UTF-8");
        
        try {
            Part filePart = request.getPart("slip_image");
            String bookingIdStr = request.getParameter("booking_id");

            if (filePart == null || bookingIdStr == null) {
                response.getWriter().write("fail: Missing data");
                return;
            }

            int bookingId = Integer.parseInt(bookingIdStr);
            BookingDAO dao = new BookingDAO();
            var booking = dao.getBookingById(bookingId);
            
            if (booking != null) {
                  LocalDateTime bookingTime = booking.getCreatedAt(); 
                  String currentStatus = booking.getStatus();

                  // 3. Logic เช็ก 5 นาที (ต้องวางก่อนเช็ก API เพื่อประหยัด Quota)
                  long diffInMinutes = java.time.Duration.between(bookingTime, LocalDateTime.now()).toMinutes();

                  if (diffInMinutes > 5 && "PENDING".equals(currentStatus)) {
                      dao.updateStatus(bookingId, "CANCEL"); // อัปเดตเป็นยกเลิก
                      response.getWriter().print("fail: หมดเวลาชำระเงิน (เกิน 5 นาที)");
                      return; 
                  }
              }

         
           double expectedAmount = 0.0;
                if (booking != null) {
                    expectedAmount = booking.getTotalPrice(); 
                } else {
                    response.getWriter().write("fail: Booking not found");
                    return;
                }

            boolean isValid = checkSlipWithAPI(filePart, expectedAmount);
            
            if (isValid) {
                dao.updateStatus(bookingId, "PAID");
                response.getWriter().write("success");
            } else {
                response.getWriter().write("fail: Invalid Slip or Amount mismatch");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error: " + e.getMessage());
        }
    }

    private boolean checkSlipWithAPI(Part filePart, double expectedAmount) {

    String branchId = "#"; 
    String apiUrl = "https://api.slipok.com/api/line/apikey/" + branchId;

    try {
        byte[] fileBytes = filePart.getInputStream().readAllBytes();

        
        okhttp3.RequestBody requestBody = new okhttp3.MultipartBody.Builder()
            .setType(okhttp3.MultipartBody.FORM)
            .addFormDataPart("files", "slip.jpg",
                okhttp3.RequestBody.create(fileBytes, okhttp3.MediaType.parse("image/jpeg")))
            .addFormDataPart("amount", String.valueOf(expectedAmount))
            .addFormDataPart("log", "true")
            .build();

        okhttp3.Request apiRequest = new okhttp3.Request.Builder()
            .url(apiUrl)
            .addHeader("x-authorization", API_KEY)
            .post(requestBody)
            .build();

        try (okhttp3.Response apiResponse = client.newCall(apiRequest).execute()) {
            if (apiResponse.body() != null) {
                String jsonData = apiResponse.body().string();
                System.out.println("SlipOK Response: " + jsonData); // สำหรับ Debug ดูใน Console

                org.json.JSONObject json = new org.json.JSONObject(jsonData);
                
                // เช็คชั้นแรก: Request Success?
                if (json.optBoolean("success", false)) {
                    org.json.JSONObject data = json.optJSONObject("data");
                    
                    // เช็คชั้นที่สอง: Valid QR/Slip? (ตามตาราง Mandatory ใน Guide)
                    if (data != null && data.optBoolean("success", false)) {
                        // เช็คยอดเงินอีกครั้งเพื่อความชัวร์ (API Guide บอกคืนค่าเป็น decimal)                      
                        double actualAmount = data.optDouble("amount", 0.0);
                        System.out.println("DEBUG: Actual from Slip = " + actualAmount);
                        return Math.abs(actualAmount - expectedAmount) < 0.01;
                    }
                }
            }
        }
    } catch (Exception e) {
        System.err.println("SlipOK Error: " + e.getMessage());
    }
    return false;
}
}
