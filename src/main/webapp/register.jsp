<%-- 
    Document   : index
    Created on : Mar 25, 2026, 11:18:49 PM
    Author     : zawsf
--%>

<%@page import="com.users.model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.stadium.model.Stadium"%>
<%@page import="com.stadium.dao.StadiumDAO"%>
<%@page import="java.util.List"%>
<%
  User u = (User) session.getAttribute("user");
    
    if (u != null) {
        response.sendRedirect("index.jsp");
    }
%>
<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>STADIUM ARENA | ระบบจองสนามเรียลไทม์</title>
    
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/bootstrap-icons-1.13.1/bootstrap-icons.css">
    <jsp:include page="assets/js/input.jsp"/>
    <style>
        <jsp:include page="assets/css/style.css"/>
    </style>
</head>
<body>

    <jsp:include page="assets/nav/navbar.jsp"/>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5 auth-card shadow-lg">
                <h2 class="text-center text-warning mb-4 fw-bold">REGISTER</h2>
                <form action="adminControl" method="POST">
                    
                    <input type="hidden" name="action" value="register">
                    <div class="mb-3">
                        <label class="form-label">ชื่อผู้ใช้งาน (Username)</label>
                        <input type="text" name="username" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">รหัสผ่าน</label>
                        <input type="password" name="password" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">ชื่อ-นามสกุล</label>
                        <input type="text" name="fullname" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">เบอร์</label>
                        <input type="text" name="phone" class="form-control" required>
                    </div>
       
                    
                    <button type="submit" class="btn btn-gold w-100 py-2 mt-3">สร้างบัญชีผู้ใช้</button>
                    <p class="text-center mt-3 small">มีบัญชีอยู่แล้ว? <a href="login.jsp" class="text-warning">เข้าสู่ระบบ</a></p>
                </form>
            </div>
        </div>
    </div>

    <footer class="footer text-center">
        <div class="container">
            <h5 class="text-warning fw-bold mb-3">STADIUM ARENA</h5>
            <p class="mb-2">123 ถนนสนามกีฬา, กรุงเทพมหานคร, 10xxx</p>
            <p class="mb-1">&copy; 2023 แผนกกีฬาและสันทนาการ. สงวนลิขสิทธิ์.</p>
            <p class="small text-muted mt-3">Powered by Java EE, WebSocket & Bootstrap 5 (Dark Yellow Edition)</p>
        </div>
    </footer>



    <script>
        // แสดงเวลาอัปเดตล่าสุด
        document.getElementById('last-update').innerText = new Date().toLocaleTimeString('th-TH');

        // ฟังก์ชันยืนยันการจอง
function confirmBooking(stadiumName, stadiumId) {
    if(confirm("ยืนยันการจอง " + stadiumName + " ?")) {
        // ใช้ fetch ส่งข้อมูลไปหลังบ้านแบบไม่รีเฟรชหน้า (AJAX)
        const params = new URLSearchParams();
        params.append('id', stadiumId);

        fetch('bookStadium', {
            method: 'POST',
            body: params
        })
        .then(res => res.text())
        .then(result => {
            if(result === "success") {
                // ไม่ต้องเขียนโค้ดเปลี่ยนสีตรงนี้! 
                // เพราะท่อ WebSocket จะได้รับสัญญาณแล้วเปลี่ยนสีให้เองอัตโนมัติ
                console.log("จองสำเร็จ รอรับสัญญาณ Real-time...");
            } else {
                alert("จองไม่สำเร็จ กรุณาลองใหม่");
            }
        });
    }
}

        // ==========================================
        // ส่วนของ Real-time WebSocket
        // ==========================================
        
        // เชื่อมต่อท่อ WebSocket (ตรวจสอบ Path SDS ให้ถูกนะครับ)
        const socket = new WebSocket("ws://" + window.location.host + "/SDS/stadiumWS");

        socket.onopen = function(event) {
            console.log("WebSocket Connected: สัญญาณ Real-time พร้อมใช้งาน");
        };

        socket.onmessage = function(event) {
            // ได้รับข้อมูลใหม่จาก Server
            const data = JSON.parse(event.data);
            console.log("ได้รับข้อมูลอัปเดต:", data);
            
            // เรียกฟังก์ชันอัปเดตหน้าจอทันที
            updateStadiumStatus(data.stadiumId, data.status);
        };

        socket.onerror = function(event) {
            console.error("WebSocket Error: เกิดข้อผิดพลาดในการเชื่อมต่อ Real-time");
        };

        function updateStadiumStatus(id, status) {
            const stadiumWrapper = document.getElementById("stadium-" + id);
            if (!stadiumWrapper) return; // ไม่พบการ์ดสนามนี้

            const badge = stadiumWrapper.querySelector(".badge-status");
            const button = stadiumWrapper.querySelector(".btn-booking");
            const statusIcon = badge.querySelector("i");
            const buttonIcon = button.querySelector("i");

            // เพิ่ม Animation เพื่อบอกว่ามีการอัปเดต
            stadiumWrapper.classList.add("realtime-update");
            setTimeout(() => stadiumWrapper.classList.remove("realtime-update"), 1500);

            if (status === "Occupied") {
                // เปลี่ยนสถานะเป็น 'ไม่ว่าง'
                badge.classList.remove("status-available");
                badge.classList.add("status-occupied");
                badge.innerHTML = '<i class="bi bi-x-circle-fill me-2"></i>ไม่ว่าง';
                
                button.disabled = true;
                button.innerHTML = '<i class="bi bi-slash-circle me-2"></i>จองเต็มแล้ว';
            } else {
                // เปลี่ยนสถานะเป็น 'ว่าง'
                badge.classList.remove("status-occupied");
                badge.classList.add("status-available");
                badge.innerHTML = '<i class="bi bi-check-circle-fill me-2"></i>ว่าง';
                
                button.disabled = false;
                button.innerHTML = '<i class="bi bi-calendar-plus me-2"></i>จองสนามนี้';
            }
            
            // อัปเดตเวลาล่าสุด
            document.getElementById('last-update').innerText = new Date().toLocaleTimeString('th-TH');
        }
       
       $(document).ready(function() {
    let selectedTime = null;

    // 1. เมื่อคลิกปุ่ม "จองสนามนี้"
    $('.btn-open-booking').on('click', function() {
        // เช็ค Login เบื้องต้นจาก Session (ส่งค่าจาก JSP มาที่ JS)
        const isLoggedIn = <%= session.getAttribute("user") != null %>;
        if (!isLoggedIn) {
            alert("กรุณาเข้าสู่ระบบก่อนทำการจอง");
            window.location.href = "login.jsp";
            return;
        }

        const id = $(this).data('id');
        const name = $(this).data('name');

        $('#modalStadiumId').val(id);
        $('#modalStadiumName').text("จองสนาม: " + name);
        
        // กำหนดวันที่ขั้นต่ำเป็นวันนี้
        const today = new Date().toISOString().split('T')[0];
        $('#bookingDate').attr('min', today).val(today);

        loadSlots(id, today);
        $('#bookingModal').modal('show'); // เปิด Modal (ใช้ Bootstrap 5)
    });

    // 2. เมื่อเปลี่ยนวันที่ใน Modal
    $('#bookingDate').on('change', function() {
        const id = $('#modalStadiumId').val();
        const date = $(this).val();
        loadSlots(id, date);
    });

    // 3. ฟังก์ชันโหลดช่วงเวลาด้วย AJAX (jQuery)
    function loadSlots(stadiumId, date) {
        const $container = $('#timeSlotContainer');
        $container.html('<div class="spinner-border text-warning"></div>');

        $.ajax({
            url: 'getOccupiedTimes', // Servlet ที่คุณต้องสร้าง
            method: 'GET',
            data: { id: stadiumId, date: date },
            success: function(occupiedTimes) {
                $container.empty();
                selectedTime = null;
                
                // รายการเวลาที่เปิดให้จอง (ปรับแต่งตามใจชอบ)
                const timeSlots = ["17:00", "18:00", "19:00", "20:00", "21:00", "22:00"];

                $.each(timeSlots, function(i, time) {
                    const isOccupied = occupiedTimes.includes(time);
                    const $btn = $('<button></button>')
                        .addClass('btn m-1 ' + (isOccupied ? 'btn-danger disabled' : 'btn-outline-warning'))
                        .text(time)
                        .prop('disabled', isOccupied);

                    if (!isOccupied) {
                        $btn.on('click', function() {
                            $('.btn-time-slot').removeClass('btn-warning').addClass('btn-outline-warning');
                            $(this).removeClass('btn-outline-warning').addClass('btn-warning');
                            selectedTime = time;
                        });
                        $btn.addClass('btn-time-slot');
                    }
                    $container.append($btn);
                });
            },
            error: function() {
                $container.html('<p class="text-danger">เกิดข้อผิดพลาดในการโหลดข้อมูล</p>');
            }
        });
    }

    // 4. เมื่อกดยืนยันการจอง
    window.submitBooking = function() {
        if (!selectedTime) {
            alert("กรุณาเลือกช่วงเวลาที่ต้องการจอง");
            return;
        }

        $.ajax({
            url: 'bookStadium', // Servlet บันทึกการจอง
            method: 'POST',
            data: {
                id: $('#modalStadiumId').val(),
                date: $('#bookingDate').val(),
                time: selectedTime
            },
            success: function(res) {
                if (res === "success") {
                    alert("จองสำเร็จ!");
                    $('#bookingModal').modal('hide');
                    // ไม่ต้องรีเฟรชหน้า เพราะ WebSocket จะอัปเดตสีการ์ดให้เอง
                } else {
                    alert("จองไม่สำเร็จ: " + res);
                }
            }
        });
    };
});
    </script>
</body>
</html>
