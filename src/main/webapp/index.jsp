    <%@page contentType="text/html" pageEncoding="UTF-8"%>
    <%@page import="com.stadium.model.Stadium"%>
    <%@page import="com.stadium.dao.StadiumDAO"%>
    <%@page import="java.util.List"%>
    <%@ page import="java.text.DecimalFormat" %>
<%
    DecimalFormat df = new DecimalFormat("#,###.##");
%>
    <%
        // ดึงข้อมูลสนามจริงจาก Database
        StadiumDAO dao = new StadiumDAO();
        List<Stadium> stadiums = dao.getAllStadiums();
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
            /* กำหนดค่าตัวแปรสีหลัก */
            :root {
                --bg-dark: #121212;          /* ดำพื้นหลัง */
                --bg-card: #1e1e1e;          /* ดำการ์ด */
                --primary-yellow: #ffeb3b;   /* เหลืองหลัก */
                --hover-yellow: #fdd835;     /* เหลืองตอน Hover */
                --text-light: #e0e0e0;       /* เทาอ่อน */
                --text-dark: #212121;        /* ดำตัวอักษรบนพื้นเหลือง */
            }

            body {
                font-family: 'Prompt', sans-serif;
                background-color: var(--bg-dark);
                color: var(--text-light);
            }

            /* Navbar Style */
            .navbar-custom {
                background-color: #000000;
                border-bottom: 3px solid var(--primary-yellow);
                box-shadow: 0 4px 15px rgba(255, 235, 59, 0.2);
            }
            .navbar-brand {
                font-weight: 700;
                color: var(--primary-yellow) !important;
                font-size: 1.6rem;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .nav-link {
                color: var(--text-light) !important;
                font-weight: 500;
                margin-left: 1rem;
            }
            .nav-link:hover, .nav-link.active {
                color: var(--primary-yellow) !important;
            }

            /* Hero Section */
            .hero-section {
                background: url('https://images.unsplash.com/photo-1579952362224-d9472e3a103c?q=80&w=1920') no-repeat center center;
                background-size: cover;
                position: relative;
                padding: 6rem 0;
                margin-bottom: 4rem;
            }
            .hero-section::before {
                content: '';
                position: absolute;
                top: 0; left: 0; width: 100%; height: 100%;
                background: rgba(0, 0, 0, 0.7); /* Layer สีดำทับรูป */
            }
            .hero-content {
                position: relative;
                z-index: 1;
            }
            .hero-section h1 {
                color: var(--primary-yellow);
                font-weight: 700;
                text-transform: uppercase;
            }

            /* Stadium Card Style */
            .stadium-card {
                border: 1px solid #333;
                border-radius: 12px;
                transition: all 0.3s ease;
                background-color: var(--bg-card);
                overflow: hidden;
            }
            .stadium-card:hover {
                transform: translateY(-8px);
                border-color: var(--primary-yellow);
                box-shadow: 0 10px 30px rgba(255, 235, 59, 0.2);
            }
            .card-header-custom {
                background-color: #2a2a2a;
                border-bottom: 1px solid #444;
                padding: 1.25rem;
            }
            .card-title-custom {
                color: var(--primary-yellow);
                font-weight: 600;
                margin-bottom: 0;
                font-size: 1.3rem;
            }

            /* Status Badges */
            .badge-status {
                font-weight: 600;
                padding: 0.6em 1.2em;
                border-radius: 50px;
                text-transform: uppercase;
                font-size: 0.8rem;
            }
            .status-available {
                background-color: rgba(40, 167, 69, 0.2);
                color: #2ecc71;
                border: 1px solid #2ecc71;
            }
            .status-occupied {
                background-color: rgba(220, 53, 69, 0.2);
                color: #e74c3c;
                border: 1px solid #e74c3c;
            }

            /* Booking Button */
            .btn-booking {
                background-color: var(--primary-yellow);
                color: var(--text-dark);
                border: none;
                font-weight: 700;
                padding: 0.8rem;
                width: 100%;
                border-radius: 8px;
                text-transform: uppercase;
                letter-spacing: 1px;
                transition: all 0.2s;
            }
            .btn-booking:hover {
                background-color: var(--hover-yellow);
                transform: scale(1.03);
            }
            .btn-booking:disabled {
                background-color: #444;
                color: #888;
                cursor: not-allowed;
                transform: none;
            }

            /* Footer */
            .footer {
                background-color: #000000;
                color: #888;
                padding: 3rem 0;
                margin-top: 6rem;
                border-top: 1px solid #333;
            }

            /* Real-time Update Animation */
            @keyframes pulse {
                0% { box-shadow: 0 0 0 0 rgba(255, 235, 59, 0.4); }
                70% { box-shadow: 0 0 0 10px rgba(255, 235, 59, 0); }
                100% { box-shadow: 0 0 0 0 rgba(255, 235, 59, 0); }
            }
            .realtime-update {
                animation: pulse 1.5s;
            }
            
            .btn-time-slot:focus, 
.btn-time-slot:active {
    outline: none !important;
    box-shadow: none !important;
}

/* บังคับให้สีเปลี่ยนตาม Class ที่เราแก้ใน JS ทันทีโดยไม่สนสถานะ Focus */
.btn-outline-warning.btn-time-slot:focus {
    background-color: transparent !important;
    color: #ffc107 !important; /* สีเหลืองหม่นของ Bootstrap */
}

.btn-warning.btn-time-slot:focus {
    background-color: #ffc107 !important;
    color: #212529 !important; /* สีดำ */
}
        </style>
    </head>
    <body>

        <jsp:include page="assets/nav/navbar.jsp"/>

        <header class="hero-section text-center">
            <div class="container hero-content">
                <h1 class="display-3 fw-bold">จองสนามของคุณได้ทันที</h1>
                <p class="lead text-light FS-4">สัมผัสประสบการณ์การจองแบบเรียลไทม์ รวดเร็ว แม่นยำที่สุด</p>
                <div class="mt-4">
                    <span class="badge bg-warning text-dark p-2 FS-6">
                        <i class="bi bi-broadcast me-2"></i>เชื่อมต่อระบบ Real-time แล้ว
                    </span>
                </div>
            </div>
        </header>

        <main class="container">
            <div class="d-flex justify-content-between align-items-center mb-5 pb-3 border-bottom border-secondary">
                <h2 class="fw-bold text-light">
                    <i class="bi bi-trophy-fill me-3 text-warning"></i>สนามที่เปิดให้บริการ
                </h2>
                <div class="text-muted">
                    <i class="bi bi-clock me-1 text-white"></i><span class="text-white">อัปเดต:</span> <span id="last-update" class="text-warning">...</span>
                </div>
            </div>

            <div class="row g-4" id="stadium-container">

                <% 
                    // วนลูปสร้างการ์ดสนามจากข้อมูลจริง
                    if (stadiums != null && !stadiums.isEmpty()) {
                        for(Stadium s : stadiums) { 
                %>
                <div class="col-12 col-md-6 col-lg-4 stadium-wrapper" id="stadium-<%= s.getId() %>">
                    <div class="card stadium-card">
                        <div class="card-header card-header-custom d-flex justify-content-between align-items-center">
                            <h5 class="card-title-custom"><%= s.getName() %></h5>
                            <i class="bi bi-shield-shaded FS-5 text-secondary"></i>
                        </div>
                        <div class="card-body p-4 text-center">
                            <p class="text-warning  mb-3 ">ประเภท: <%= s.getType() %></p>

                            <div class="mb-4">
                                <span class="badge-status <%= s.getStatus().equals("Available") ? "status-available" : "status-occupied" %>">
                                    <i class="bi <%= s.getStatus().equals("Available") ? "bi-check-circle-fill" : "bi-x-circle-fill" %> me-2"></i>
                                    <%= s.getStatus().equals("Available") ? "ว่าง" : "ไม่ว่าง" %>
                                </span>
                            </div>

                            <div class="mb-4">
                                <span class="display-5 fw-bold text-light"><%= df.format(s.getPrice()) %>   </span> 
                                <span class="text-warning ">บาท / ชม.</span>
                            </div>

    <button class="btn-booking btn-open-booking" 
            data-id="<%= s.getId() %>" 
            data-name="<%= s.getName() %>"
            <%= s.getStatus().equals("Occupied") ? "disabled" : "" %>>
        <i class="bi bi-calendar-plus me-2"></i>จองสนามนี้
    </button>
                        </div>
                    </div>
                </div>
                <% 
                        } 
                    } else {
                %>
                    <div class="col-12 text-center py-5">
                        <i class="bi bi-exclamation-triangle display-1 text-warning"></i>
                        <h3 class="mt-3">ไม่พบข้อมูลสนามในระบบ</h3>
                        <p class="text-muted">กรุณาตรวจสอบการเชื่อมต่อฐานข้อมูล หรือเพิ่มข้อมูลสนามใน phpMyAdmin</p>
                    </div>
                <% } %>

            </div>
                <div class="modal fade" id="bookingModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dark">
            <div class="modal-content bg-dark text-light border-warning">
                <div class="modal-header">
                    <h5 class="modal-title text-warning" id="modalStadiumName">จองสนาม</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="modalStadiumId">
                    <div class="mb-3">
                        <label class="form-label">เลือกวันที่</label>
                       <input type="date" id="bookingDate" onchange="loadSlots($('#modalStadiumId').val(), this.value)">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">ช่วงเวลาที่ว่าง</label>
                        <div id="timeSlotContainer" class="d-flex flex-wrap gap-2">
                            <p class="text-muted small">กรุณาเลือกวันที่ก่อน...</p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">ยกเลิก</button>
                    <button type="button" class="btn btn-warning fw-bold" onclick="submitBooking()">ยืนยันการจอง</button>
                </div>
            </div>
        </div>
    </div>
        </main>

                <jsp:include page="assets/nav/footer.jsp"/>



        <script>
            // แสดงเวลาอัปเดตล่าสุด
            setInterval(() => {
                 document.getElementById('last-update').innerText = new Date().toLocaleTimeString('th-TH');
             }, 1000);

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

 
   
            };

            socket.onerror = function(event) {
                console.error("WebSocket Error: เกิดข้อผิดพลาดในการเชื่อมต่อ Real-time");
            };


        </script>
        <script>
       let selectedTimes = [];      

        // --- ย้าย loadSlots ออกมาข้างนอก $(document).ready เพื่อให้ HTML (onchange) เรียกใช้ได้ ---
       function loadSlots(stadiumId, date) {
    if (!stadiumId || !date) return;
    
    const $container = $('#timeSlotContainer');
    $container.html('<div class="spinner-border text-warning" role="status"></div>');

    // 1. ไปดึงเวลาเปิด-ปิดมาก่อน
    $.get('getOpeningHours', { date: date }, function(openRes) {
        // สมมติเปิด 10:00 - 22:00
        if (openRes.status === "CLOSED") {
            $('#opening-label').text("วันนี้สนามปิดทำการ");
            $container.html('<span class="text-danger">ขออภัย วันนี้สนามปิดทำการ</span>');
            return;
        }

        $('#opening-label').text("เวลาเปิดวันนี้: " + openRes.open + " - " + openRes.close);

        // 2. เมื่อรู้เวลาเปิดแล้ว ค่อยไปดึงข้อมูลว่าเวลาไหน "ไม่ว่าง"
        $.ajax({
            url: 'getOccupiedTimes',
            method: 'GET',
            data: { id: stadiumId, date: date },
            success: function(occupiedData) {
                $container.empty();
                selectedTimes = [];

                // 3. สร้างช่วงเวลา (Slots) จาก open ถึง close (สมมติเป็นรายชั่วโมง)
                let startHour = parseInt(openRes.open.split(':')[0]);
                let endHour = parseInt(openRes.close.split(':')[0]);
                
                if (endHour === 0) {
                    endHour = 24;
                }
                
                for (let hour = startHour; hour < endHour; hour++) {
                    
                    let displayHour = hour;
                    if (displayHour >= 24) displayHour = displayHour - 24;
                    
                    const time = (hour < 10 ? '0' + displayHour : displayHour) + ':00';           
                    const booking = occupiedData.find(d => d.time === time);
                    const isOccupied = !!booking;
                    
                    const $btn = $('<button type="button"></button>')
                        .addClass('btn m-1 ' + (isOccupied ? 'btn-danger disabled' : 'btn-outline-warning'))
                        .css('min-width', '100px')
                        .html(isOccupied ? time : time)
                        .prop('disabled', isOccupied);

                        if (!isOccupied) {
                                                $btn.addClass('btn-time-slot');
                                                // --- แก้ไขตรงนี้: ให้มี .on('click') แค่ชั้นเดียว ---
                                                $btn.on('click', function() {
                                                    // ใช้ค่า time จาก loop ได้เลย ไม่ต้องดึงจาก .text() ป้องกัน Error จากภาษา/ช่องว่าง
                                                    if ($(this).hasClass('btn-warning')) {
                                                        // ยกเลิกเลือก
                                                       $(this).css({
                                                            'background-color': 'transparent',
                                                            'color': '#ffc107',
                                                            'border-color': '#ffc107'
                                                        }).removeClass('btn-warning text-dark').addClass('btn-outline-warning');
                                                        selectedTimes = selectedTimes.filter(t => t !== time);
                                                      
                                                        console.log("ยกเลิก: " + time, selectedTimes);
                                                    } else {
                                                        // เลือก
                                                        $(this).css({
                                                            'background-color': '#ffc107',
                                                            'color': '#212529',
                                                            'border-color': '#ffc107'
                                                        }).removeClass('btn-outline-warning').addClass('btn-warning text-dark');
                                                        selectedTimes.push(time);
                                                        console.log("เลือก: " + time, selectedTimes);
                                                    }
                                                    $(this).blur();
                                                });
                                            }
                    $container.append($btn);
                }
            }
        });
    });
}

        $(document).ready(function() {
            // อัปเดตเวลาล่าสุด
            document.getElementById('last-update').innerText = new Date().toLocaleTimeString('th-TH');

            // 1. เมื่อคลิกปุ่ม "จองสนามนี้"
            $('.btn-open-booking').on('click', function() {
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

                const today = new Date().toISOString().split('T')[0];
                $('#bookingDate').attr('min', today).val(today);

                loadSlots(id, today);
                
                // ใช้คำสั่งเปิด Modal ของ Bootstrap 5
                var myModal = new bootstrap.Modal(document.getElementById('bookingModal'));
                myModal.show();
            });
        });

        // 4. ฟังก์ชันส่งข้อมูลจอง
        window.submitBooking = function() {
            const stadiumId = $('#modalStadiumId').val();
            const date = $('#bookingDate').val();
           
if (!selectedTimes || selectedTimes.length === 0) {
        alert("กรุณาเลือกช่วงเวลาอย่างน้อย 1 ช่วง");
        return;
    }
            
            console.log("กำลังจองวันที่: " + date + " สนาม ID: " + stadiumId + " เวลา: " + selectedTimes.join(', '));
            $.ajax({
                url: 'bookStadium',
                method: 'POST',
                data: {
                    id: stadiumId,
                    date: date,
                    'time[]': selectedTimes
                },
                success: function(res) {
                    console.log("Server Response:", res);
                    if (res.includes("success")) {
        // แยกข้อความด้วยเครื่องหมาย :
        const parts = res.split(":");
        const bookingId = parts[1]; // จะได้เลข 31 ออกมา

        // ถ้าได้ ID มาจริง ให้เด้งไปหน้าชำระเงิน
        if (bookingId && bookingId !== "0") {
            window.location.href = "payment.jsp?bookingId=" + bookingId;
        } else {
            alert("จองสำเร็จ แต่ระบบไม่ได้รับเลข ID");
        }
    } else {    
        alert("เกิดข้อผิดพลาด: " + res);
    }
                }
            });
        };
        
     

        </script>
    </body>
    </html>
