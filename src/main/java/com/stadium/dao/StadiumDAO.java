package com.stadium.dao;

import com.stadium.model.Stadium;
import com.stadium.model.OpeningHours;
import com.stadium.config.DBConfig;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;


public class StadiumDAO {

    public List<Stadium> getAllStadiums() {
        List<Stadium> list = new ArrayList<>();
        // try-with-resources จะปิด conn, ps, rs ให้เอง ไม่ต้องสั่ง close()
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT * FROM stadiums");
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Stadium(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("type"),
                    rs.getDouble("price_per_hour"),
                    rs.getString("status")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE stadiums SET status = ? WHERE id = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ย้ายฟังก์ชันนี้เข้ามาอยู่ในปีกกาของ Class StadiumDAO
    public OpeningHours getTodayOpeningHours(String dayName) {
        String sql = "SELECT * FROM opening_hours WHERE day_name = ?";
        try (Connection conn = DBConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dayName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new OpeningHours(
                        rs.getString("day_name"),
                        rs.getTime("open_time"),
                        rs.getTime("close_time"),
                        rs.getBoolean("is_closed")
                    );
                }
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return null;
    }
    
  public boolean updateOpeningHours(String day, String open, String close, boolean isClosed) {
    String sql = "UPDATE opening_hours SET open_time = ?, close_time = ?, is_closed = ? WHERE day_name = ?";
    try (Connection conn = DBConfig.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        // ป้องกันค่า null หรือค่าว่าง
        String openTime = (open != null && !open.isEmpty()) ? open : "00:00:00";
        String closeTime = (close != null && !close.isEmpty()) ? close  : "00:00:00";

        ps.setString(1, openTime);
        ps.setString(2, closeTime);
        ps.setInt(3, isClosed ? 1 : 0);
        ps.setString(4, day);
        
        int rowsAffected = ps.executeUpdate();
       
        // ถ้า rowsAffected > 0 แสดงว่าหา day_name เจอและอัปเดตสำเร็จ
        if (rowsAffected > 0) {
            System.out.println("Successfully updated: " + day);
            return true;
        } else {
            System.out.println("No row found for day: " + day);
            return false;
        }
        
    } catch (Exception e) { 
        System.err.println("Error updating " + day + ": " + e.getMessage());
        e.printStackTrace(); 
        return false;
    }
}
    
    // สำหรับ Update ข้อมูลสนาม
public boolean updateStadium(Stadium s) {
    String sql = "UPDATE stadiums SET name=?, type=?, price_per_hour=? WHERE id=?";
    try (Connection conn = DBConfig.getConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, s.getName());
        ps.setString(2, s.getType());
        ps.setDouble(3, s.getPrice());
        ps.setInt(4, s.getId());
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

// สำหรับ Delete สนาม
public boolean deleteStadium(int id) {
    String sql = "DELETE FROM stadiums WHERE id=?";
    try (Connection conn = DBConfig.getConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, id);
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}

// สำหรับ Add สนามใหม่
public boolean addStadium(Stadium s) {
    String sql = "INSERT INTO stadiums (name, type, price_per_hour, status) VALUES (?, ?, ?, ?)";
    try (Connection conn = DBConfig.getConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, s.getName());
        ps.setString(2, s.getType());
        ps.setDouble(3, s.getPrice());
        ps.setString(4, s.getStatus());
        ps.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }
        return false;
}

public Map<String, Object> getActualOpeningHours(String targetDate) {
    Map<String, Object> result = new HashMap<>();
    
    try (Connection conn = DBConfig.getConnection()) {
        // 1. เช็ควันหยุด/วันพิเศษก่อน
        String sqlEx = "SELECT open_time, close_time, is_closed FROM stadium_exceptions WHERE exception_date = ?";
        PreparedStatement psEx = conn.prepareStatement(sqlEx);
        psEx.setString(1, targetDate);
        ResultSet rsEx = psEx.executeQuery();

        if (rsEx.next()) {
            if (rsEx.getInt("is_closed") == 1) {
                result.put("status", "CLOSED");
                return result;
            } else {
                result.put("status", "OPEN");
                result.put("open", rsEx.getTime("open_time"));
                result.put("close", rsEx.getTime("close_time"));
                return result;
            }
        }

        // 2. ถ้าไม่มีวันพิเศษ ให้ไปเช็คเวลาปกติของวันนั้น (จันทร์-อาทิตย์)
        String dayName = new SimpleDateFormat("EEEE", Locale.ENGLISH).format(java.sql.Date.valueOf(targetDate));
        String sqlNormal = "SELECT open_time, close_time, is_closed FROM opening_hours WHERE day_name = ?";
        PreparedStatement psNormal = conn.prepareStatement(sqlNormal);
        psNormal.setString(1, dayName);
        ResultSet rsNormal = psNormal.executeQuery();

        if (rsNormal.next()) {
            if (rsNormal.getInt("is_closed") == 1) {
                result.put("status", "CLOSED");
            } else {
                result.put("status", "OPEN");
                result.put("open", rsNormal.getTime("open_time"));
                result.put("close", rsNormal.getTime("close_time"));
            }
        }
    } catch (Exception e) { e.printStackTrace(); }
    
    return result;
}

public Map<String, Object> getOpeningHoursByDay(String dayName) {
    Map<String, Object> map = new HashMap<>();
    // ปรับ Query ตามชื่อตารางและคอลัมน์ของคุณ (ตัวอย่าง: day_name, open_time, close_time, is_closed)
    String sql = "SELECT open_time, close_time, is_closed FROM opening_hours WHERE day_name = ?";
    
    try (Connection conn = DBConfig.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setString(1, dayName);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            boolean isClosed = rs.getInt("is_closed") == 1;
            if (isClosed) {
                map.put("status", "CLOSED");
            } else {
                map.put("status", "OPEN");
                // แปลง Time เป็น String รูปแบบ HH:mm
                map.put("open", rs.getTime("open_time").toString().substring(0, 5));
                map.put("close", rs.getTime("close_time").toString().substring(0, 5));
            }
        } else {
            // กรณีไม่เจอข้อมูลใน DB
            map.put("status", "CLOSED");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return map;
}

public Stadium getStadiumById(int id) {
    Stadium s = null;
    String sql = "SELECT * FROM stadiums WHERE id = ?";
    
    try (Connection conn = DBConfig.getConnection(); 
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, id);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                s = new Stadium();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("name"));
                s.setType(rs.getString("type"));
                
                // --- แก้จุดนี้ให้ตรงกับชื่อคอลัมน์ใน DB (price_per_hour) ---
                double priceFromDB = rs.getDouble("price_per_hour");
                s.setPrice(priceFromDB); 
                
                // ลอง Log ดูเพื่อให้มั่นใจว่า 501 มาจริงไหม
                System.out.println("DEBUG DAO: Stadium ID " + id + " Price = " + priceFromDB);
                
                s.setStatus(rs.getString("status"));
            }
        }
    } catch (SQLException e) {
        System.out.println("StadiumDAO Error (getById): " + e.getMessage());
        e.printStackTrace();
    }
    return s;
}

} 