/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.stadium.test;
import com.stadium.config.DBConfig;
import java.sql.Connection;
/**
 *
 * @author zawsf
 */
public class TestConn {
    public static void main(String[] args) {
        System.out.println("Starting Database Connection Test...");
        
        try (Connection conn = DBConfig.getConnection()) {
            if (conn != null) {
                System.out.println("------------------------------------------");
                System.out.println("✅ SUCCESS: Connected to XAMPP MySQL!");
                System.out.println("Your Stadium Booking System is ready to go.");
                System.out.println("------------------------------------------");
            }
        } catch (Exception e) {
            System.out.println("------------------------------------------");
            System.out.println("❌ ERROR: Connection Failed!");
            System.out.println("Reason: " + e.getMessage());
            System.out.println("Check: Is MySQL Running in XAMPP Control Panel?");
            System.out.println("------------------------------------------");
        }
    }
}
