🏟️ Stadium Arena Booking System (Java Web Application)
ระบบจองสนามกีฬารูปแบบเว็บแอปพลิเคชัน พัฒนาด้วยเทคโนโลยี Java J2EE โดยเน้นการทำงานที่รวดเร็ว (Real-time) และการจัดการข้อมูลที่ปลอดภัยด้วยโครงสร้างแบบ MVC

🚀 ฟีเจอร์หลัก (Key Features)
Stadium Selection: ระบบแสดงรายการสนามพร้อมรายละเอียดและราคา

Booking System: ระบบจองสนามระบุวันที่และช่วงเวลา (Time Slot)

Real-time History: หน้าประวัติการจองส่วนตัว พร้อมสถานะการชำระเงิน (Pending/Paid)

Countdown Timer: ระบบนับถอยหลัง 5 นาทีสำหรับการชำระเงิน หากเกินเวลาสถานะจะเปลี่ยนเป็น Expired อัตโนมัติ

User Authentication: ระบบสมัครสมาชิกและเข้าสู่ระบบที่ปลอดภัยด้วย Session Management

🛠️ เทคโนโลยีที่ใช้ (Tech Stack)
Frontend: JSP (Java Server Pages), JSTL, HTML5, CSS3, Bootstrap 5

Backend: Java Servlet (J2EE)

Database: MySQL / MariaDB

Pattern: MVC Architecture (Model-View-Controller)

Server: Apache Tomcat 
🛡️ ความปลอดภัย (Security & Logic)
มีการใช้ PreparedStatement เพื่อป้องกัน SQL Injection

ระบบตรวจสอบสิทธิ์ (Authentication Check) ในทุกหน้าที่มีข้อมูลส่วนตัว

การคำนวณเวลา secondsPassed ผ่านคำสั่ง SQL TIMESTAMPDIFF เพื่อความแม่นยำระดับวินาที
