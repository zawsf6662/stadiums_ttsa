/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.stadium.model;
import java.time.LocalDateTime;
/**
 *
 * @author zawsf
 */
public class Booking {
    private int id;
    private String stadiumName; 
    private String status;
    private LocalDateTime createdAt;
    private long secondsPassed; 
    private double totalPrice;   
    private String bookingDate; 
    private String startTime;   
    private String endTime;


    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getStadiumName() { return stadiumName; }
    public void setStadiumName(String stadiumName) { this.stadiumName = stadiumName; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public long getSecondsPassed() { return secondsPassed; }
    public void setSecondsPassed(long secondsPassed) { this.secondsPassed = secondsPassed; }

 
    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }

    public String getBookingDate() { return bookingDate; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }

    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }
    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }
}
