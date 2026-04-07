/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.stadium.dao;

import com.stadium.config.DBConfig;
import com.stadium.model.Booking;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 *
 * @author zawsf
 */

public class BookingDAO  {

public List<Map<String, String>> getOccupiedSlots(int courtId, String date) {
    List<Map<String, String>> list = new ArrayList<>();
    // 1. ดึงทั้ง start_time และ end_time ออกมา
    String sql = "SELECT start_time, end_time, u.full_name FROM bookings b " +
                 "JOIN users u ON b.user_id = u.user_id " +
                 "WHERE stadiums_id = ? AND booking_date = ? AND status != 'CANCEL'";
    
    try (Connection conn = DBConfig.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, courtId);
        ps.setString(2, date);
        ResultSet rs = ps.executeQuery();
        
        while (rs.next()) {
            String start = rs.getString("start_time"); // เช่น "10:00:00"
            String end = rs.getString("end_time");     // เช่น "12:00:00"
            String name = rs.getString("full_name");

            // 2. แตกชั่วโมงออกมา (เช่น 10:00-12:00 ต้องได้ 10:00 และ 11:00)
            int startHour = Integer.parseInt(start.split(":")[0]);
            int endHour = Integer.parseInt(end.split(":")[0]);

            for (int h = startHour; h < endHour; h++) {
                Map<String, String> map = new HashMap<>();
                String timeSlot = (h < 10 ? "0" + h : h) + ":00";
                map.put("time", timeSlot); 
                map.put("by", name);
                list.add(map);
            }
        }
    } catch (Exception e) { 
        e.printStackTrace(); 
    }
    return list;
}

    public int insertBooking(int userId, int courtId, String date, String startTime, String endTime, double price) {

    // เพิ่ม total_price ในคำสั่ง SQL
    String sql = "INSERT INTO bookings (user_id, stadiums_id, booking_date, start_time, end_time, status, total_price) " +
                 "VALUES (?, ?, ?, ?, ?, 'Pending', ?)";
    
    try (Connection conn = DBConfig.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
        ps.setInt(1, userId);
        ps.setInt(2, courtId);
        ps.setString(3, date);
        ps.setString(4, startTime);
        ps.setString(5, endTime);
        ps.setDouble(6, price); 
        
        int affectedRows = ps.executeUpdate();
        if (affectedRows > 0) {
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}
    
       public List<Map<String, Object>> getBookingForCalendar() {
    List<Map<String, Object>> events = new ArrayList<>();
    // Join ตารางเพื่อให้ได้ชื่อสนามด้วย
    String sql = "SELECT b.stadiums_id, s.name as stadium_name, b.booking_date, b.start_time, b.end_time, b.status " +
                 "FROM bookings b JOIN stadiums s ON b.stadiums_id  = s.id " +
                 "WHERE b.status != 'CANCEL'";

    try (Connection conn = DBConfig.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
          Map<String, Object> event = new HashMap<>();
    
    String d = rs.getString("booking_date"); // ต้องได้ YYYY-MM-DD
    String st = rs.getString("start_time");  // สมมติได้ 10:00
    String et = rs.getString("end_time");    // สมมติได้ 11:00

    // บังคับให้มีวินาทีเสมอ (FullCalendar ชอบแบบนี้)
    if (st != null && st.length() == 5) st += ":00"; 
    if (et != null && et.length() == 5) et += ":00";

    event.put("title", rs.getString("stadium_name"));
    event.put("start", d + "T" + st); // ผลลัพธ์ต้องเป็น 2026-04-06T10:00:00
    event.put("end", d + "T" + et);
    
    // ใส่สีให้เห็นชัดเจนที่สุด (ตัดปัญหาเรื่อง CSS ไม่โหลด)
    event.put("color", "#28a745"); 
    event.put("allDay", false); // บอกว่าเป็นรายการแบบระบุเวลา

    events.add(event);
            
           
        }
} catch (Exception e) {
    System.out.println("❌ DAO Error: " + e.getMessage()); // ดูใน Console ของ IDE (Eclipse/NetBeans)
    e.printStackTrace();
}
    return events;
}
       
    
       public boolean updateStatus(int bookingId, String newStatus) {
        String sql = "UPDATE bookings SET status = ? WHERE booking_id = ?";
        
        try (Connection conn = DBConfig.getConnection(); 
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newStatus);
            stmt.setInt(2, bookingId);
            
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0; // คืนค่า true ถ้าอัปเดตสำเร็จ
            
        } catch (SQLException e) {
            System.out.println("Error updateStatus: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // (แถม) Method สำหรับยกเลิกการจองเมื่อหมดเวลา 5 นาที
    public boolean cancelBooking(int bookingId) {
        return updateStatus(bookingId, "CANCEL");
    }
    
    public Booking getBookingById(int id) {
    Booking booking = null;
    // ปรับ SQL ให้ตรงกับชื่อตารางและคอลัมน์ของคุณ
    String sql = "SELECT status, created_at, total_price FROM bookings WHERE booking_id  = ?";
    
    try (Connection conn = DBConfig.getConnection(); // ใช้ตัวเชื่อมต่อ DB ของคุณ
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                booking = new Booking();
                booking.setStatus(rs.getString("status"));
                booking.setTotalPrice(rs.getDouble("total_price"));
                
                Timestamp ts = rs.getTimestamp("created_at");
                if (ts != null) {
                    booking.setCreatedAt(ts.toLocalDateTime());
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return booking;
}
       
public List<Booking> getBookingHistory(int userId) {
    // 1. ประกาศและ New ทันที (ป้องกัน NULL)
    List<Booking> list = new ArrayList<>(); 
    
    String sql = "SELECT b.booking_id, s.name AS stadium_name, b.status, " +
                 "b.booking_date, b.start_time, b.end_time, " + // <--- เพิ่มตรงนี้
                 "TIMESTAMPDIFF(SECOND, b.created_at, NOW()) AS seconds_passed " +
                 "FROM bookings b " +
                 "JOIN stadiums s ON b.stadiums_id = s.id " +
                 "WHERE b.user_id = ? " +
                 "ORDER BY b.created_at DESC";

    try (Connection conn = DBConfig.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, userId);
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
             Booking b = new Booking();
            b.setId(rs.getInt("booking_id"));
            b.setStadiumName(rs.getString("stadium_name"));
            b.setStatus(rs.getString("status"));
            b.setSecondsPassed(rs.getLong("seconds_passed"));

            // เพิ่มการ Set ค่าเหล่านี้ (เช็กชื่อ Method ใน Class Booking ของคุณด้วย)
            b.setBookingDate(rs.getDate("booking_date").toString()); 
            b.setStartTime(rs.getString("start_time"));
            b.setEndTime(rs.getString("end_time"));
            list.add(b);
            }
        }
    } catch (Exception e) {
        // ถ้า Error ให้พ่นออกมาดูว่าพังตรงไหน (เช่น ชื่อคอลัมน์ผิด)
        System.err.println("DAO Error in getBookingHistory: " + e.getMessage());
        e.printStackTrace();
    }
    
    // 2. มั่นใจได้ว่าไม่มีทางคืนค่า null กลับไป
    return list; 
}
    
}
