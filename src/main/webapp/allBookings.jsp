<%-- 
    Document   : allBookings
    Created on : Apr 6, 2026, 4:10:12 AM
    Author     : zawsf
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ตารางการจองทั้งหมด</title>
     <link href="assets/css/bootstrap.min.css" rel="stylesheet">
     <script src='assets/js/index.global.min.js'></script>
     <link href="assets/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/bootstrap-icons-1.13.1/bootstrap-icons.css">
        <jsp:include page="assets/js/input.jsp"/>
        
    <style>
            <jsp:include page="assets/css/style.css"/>
        #calendar {
            max-width: 1100px;
            margin: 40px auto;
            background: #2a2a2a;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            font: #fff;
        }
        
         body {
                font-family: 'Prompt', sans-serif;
                background-color: var(--bg-dark);
                color: var(--text-light);
            }
            
            a {
                color: white;
            }
            
        /* ตกแต่งแถบสถานะ */
        .fc-event { cursor: pointer; border: none !important; }
        .status-pending { background-color: #ffc107 !important; color: #000 !important; }
        .status-confirmed { background-color: #198754 !important; color: #fff !important; }
    </style>
</head>
<body>
      <jsp:include page="assets/nav/navbar.jsp"/>
    <div class="container">
        <h2 class="text-center mt-5">📅 ตารางการจองสนามทั้งหมด</h2>
        <div id='calendar'></div>
    </div>
    <div class="modal fade" id="eventModal" tabindex="-1" aria-labelledby="eventModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content bg-dark text-white" style="border: 1px solid #444;">
      <div class="modal-header" style="border-bottom: 1px solid #444;">
        <h5 class="modal-title" id="eventModalLabel">📅 รายละเอียดการจอง</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="mb-3">
            <label class="text-secondary small">สนาม</label>
            <h4 id="infoStadium" class="text-info"></h4>
        </div>
        <div class="row">
            <div class="col-6">
                <label class="text-secondary small">วันที่</label>
                <p id="infoDate"></p>
            </div>
            <div class="col-6">
                <label class="text-secondary small">เวลา</label>
                <p id="infoTime"></p>
            </div>
        </div>
        <hr style="border-color: #444;">
        <div class="d-flex justify-content-between align-items-center">
            <span>สถานะการจอง:</span>
            <span id="infoStatus" class="badge p-2"></span>
        </div>
      </div>
      <div class="modal-footer" style="border-top: none;">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">ปิดหน้าต่าง</button>
      </div>
    </div>
  </div>
</div>
        <jsp:include page="assets/nav/footer.jsp"/>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        const calendarEl = document.getElementById('calendar');
        const calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
            slotMinTime: '08:00:00', // ให้แถวแรกเริ่ม
    slotMaxTime: '24:00:00', 
    allDaySlot: false,
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'timeGridDay,timeGridWeek,dayGridMonth'
            },
            locale: 'th',
            // URL ของ Servlet ที่เราจะสร้างในข้อ 2
            events: '${pageContext.request.contextPath}/getBookingEvents',
            
            eventClick: function(info) {
                // เมื่อคลิกที่รายการจอง ให้โชว์รายละเอียด
                const eventObj = info.event;
                document.getElementById('infoStadium').innerText = eventObj.title;
    
    // แปลงวันที่ให้เป็นแบบไทย
    const options = { year: 'numeric', month: 'long', day: 'numeric' };
    document.getElementById('infoDate').innerText = eventObj.start.toLocaleDateString('th-TH', options);

    // จัดการเรื่องเวลา (Start - End)
    const startTime = eventObj.start.toLocaleTimeString('th-TH', { hour: '2-digit', minute: '2-digit' });
    let timeText = startTime;
    if (eventObj.end) {
        const endTime = eventObj.end.toLocaleTimeString('th-TH', { hour: '2-digit', minute: '2-digit' });
        timeText += " - " + endTime + " น.";
    }
    document.getElementById('infoTime').innerText = timeText;

    // 2. จัดการสี Badge ตามสถานะ (เช็คจาก className ที่เราส่งมาจาก Java)
    const statusBadge = document.getElementById('infoStatus');
    if (eventObj.classNames.includes('status-pending')) {
        statusBadge.innerText = "รอดำเนินการ";
        statusBadge.className = "badge bg-warning text-dark";
    } else {
        statusBadge.innerText = "ยืนยันการจองแล้ว";
        statusBadge.className = "badge bg-success";
    }

    // 3. สั่งให้ Bootstrap Modal แสดงผล
    const myModal = new bootstrap.Modal(document.getElementById('eventModal'));
    myModal.show();
            }
        });
        calendar.render();
    });
    
    </script>
</body>
</html>
