package com.stadium.model;

public class Stadium {
    private int id;
    private String name;
    private String type;
    private double price;
    private String status;
    
    public Stadium() {}
    
    // 2. Constructor สำหรับตอน "เพิ่มสนามใหม่" (ไม่ต้องใส่ ID เพราะ DB จะ Auto Increment ให้)
    public Stadium(String name, String type, double price, String status) {
        this.name = name;
        this.type = type;
        this.price = price;
        this.status = status;
    }

    // Constructor และ Getter/Setter (คลิกขวาใน NetBeans เลือก Insert Code... > Getter and Setter ก็ได้ครับ)
    public Stadium(int id, String name, String type, double price, String status) {
        this.id = id;
        this.name = name;
        this.type = type;
        this.price = price;
        this.status = status;
    }

    public int getId() { return id; }
    public String getName() { return name; }
    public String getType() { return type; }
    public double getPrice() { return price; }
    public String getStatus() { return status; }
    
    // --- Setter Methods (เพิ่มเข้ามาเพื่อให้ AdminServlet เรียกใช้ได้) ---
    public void setId(int id) { this.id = id; }
    public void setName(String name) { this.name = name; }
    public void setType(String type) { this.type = type; }
    public void setPrice(double price) { this.price = price; }
    public void setStatus(String status) { this.status = status; }

}