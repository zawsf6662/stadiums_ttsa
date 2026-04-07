/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.users.dao;

import com.users.model.User;
import com.stadium.config.DBConfig;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;
/**
 *
 * @author zawsf
 */

public class UserDAO {

public boolean  register(String user, String pass, String name, String phone, String role) {
    String sql = "INSERT INTO users (username, password, full_name, phone, role) VALUES (?, ?, ?, ?, ?)";
    String hashedBtn = BCrypt.hashpw(pass, BCrypt.gensalt());
    try(Connection conn = DBConfig.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, user);
        ps.setString(2, hashedBtn);
        ps.setString(3, name);
        ps.setString(4, phone);
        ps.setString(5, role);
       return ps.executeUpdate() > 0; 
    }catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
    
public User login(String user, String pass){
String sql = "SELECT * FROM users WHERE username = ?";
try(Connection conn = DBConfig.getConnection();
    PreparedStatement ps = conn.prepareStatement(sql)){
    ps.setString(1, user);
    ResultSet rs = ps.executeQuery();
     if(rs.next()){
         String storedHash = rs.getString("password");
         if(BCrypt.checkpw(pass, storedHash)){
         return new User(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    null, 
                    rs.getString("full_name"),
                    rs.getString("phone"),
                    rs.getString("role")
                );
         } 
                 }
     }catch (Exception e) {
                 e.printStackTrace();                 
   }
return null;
}

}
