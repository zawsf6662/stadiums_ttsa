    /*
     * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
     * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
     */
    package com.users.model;

    /**
     *
     * @author zawsf
     */

    public class User {

        private int id;
        private String username;
        private  String password;
        private  String fullname;
        private String phone;
        private String role;

        public User () {}

        public User ( int id, String username, String password, String fullname, String phone, String role) {
            this.id = id;
            this.username = username;
            this.password = password;
            this.fullname = fullname;
            this.phone = phone;
            this.role = role;
        }

        public User (String username, String password, String fullname, String phone) {
            this.username = username;
            this.password = password;
            this.fullname = fullname;
            this.phone = phone;
        }

            public User (String username, String password) {
            this.username = username;
            this.password = password;
        }

        public int getId () {return id;}
        public String getUsername () {return username;}
        public String getPassword () {return password;}
        public String getFullname () {return fullname;}
        public String getPhone () {return phone;}
        public String getRole () {return role;}


        public void setId (int id) {this.id = id;}
        public void setUsername (String username) {this.username = username;}
        public void setPassword (String password) {this.password = password;}
        public void setFullname (String fullname) {this.fullname = fullname;}
        public void setPhone (String phone) {this.phone = phone;}
        public void setRole (String role) {this.role = role;}

    }
