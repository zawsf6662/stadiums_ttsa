/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.stadium.model;
import java.sql.Time;
/**
 *
 * @author zawsf
 */
public class OpeningHours {
    private String dayName;
    private Time openTime;
    private Time closeTime;
    private boolean isClosed;

    public OpeningHours(String dayName, Time openTime, Time closeTime, boolean isClosed) {
        this.dayName = dayName;
        this.openTime = openTime;
        this.closeTime = closeTime;
        this.isClosed = isClosed;
    }
    
    // สร้าง Method เช็กว่า "ตอนนี้เปิดอยู่ไหม"
    public boolean isOpenNow() {
        if (isClosed) return false;
        Time now = new Time(System.currentTimeMillis());
        return now.after(openTime) && now.before(closeTime);
    }
    
    // Getter ด้านล่าง...
    public String getDayName() { return dayName; }
    public Time getOpenTime() { return openTime; }
    public Time getCloseTime() { return closeTime; }
    public boolean isClosed() { return isClosed; }
}