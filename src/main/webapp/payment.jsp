<%@page import="com.users.model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.stadium.dao.BookingDAO"%>
<%@page import="com.stadium.model.Booking"%>
<%@page import="java.text.DecimalFormat"%>
<%
    String bookingIdStr = request.getParameter("bookingId");
    if (bookingIdStr == null || bookingIdStr.equals("undefined")) {
        response.sendRedirect("index.jsp");
        return;
    }

    // 1. ดึงข้อมูลการจองจาก Database
    int bookingId = Integer.parseInt(bookingIdStr);
    BookingDAO dao = new BookingDAO();
    Booking booking = dao.getBookingById(bookingId); // คุณต้องมี Method นี้ใน DAO

    if (booking == null) {
        //response.sendRedirect("index.jsp");
        return;
    }

    double totalPrice = booking.getTotalPrice(); // ราคาสุทธิที่คำนวณไว้ตอนบันทึก
    DecimalFormat df = new DecimalFormat("0.00");
    DecimalFormat displayDf = new DecimalFormat("#,###.00");
%>
<%
  User u = (User) session.getAttribute("user");
    
    if (u == null) {
        response.sendRedirect("index.jsp");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>ชำระเงิน | STADIUM ARENA</title>
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body { background-color: #121212; color: white; font-family: 'Prompt', sans-serif; }
        .payment-card { background: #1e1e1e; border: 2px solid #ffeb3b; border-radius: 20px; box-shadow: 0 0 20px rgba(255, 235, 59, 0.2); }
        #timer { font-size: 2.5rem; font-weight: bold; color: #ffeb3b; }
        .price-tag { font-size: 1.8rem; color: #ffeb3b; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-5 text-center">
                <div class="payment-card p-5">
                    <h3 class="mb-3">ชำระเงินค่าจองสนาม</h3>
                    <p class="text-secondary">Booking ID: <b>#<%= bookingId %></b></p>
                    
                    <div id="timer" class="my-3">05:00</div>
                    
                    <%-- 2. แสดงราคาจริงให้ลูกค้าเห็น --%>
                    <div class="mb-3">
                        <span class="text-secondary">ยอดชำระทั้งสิ้น</span><br>
                        <span class="price-tag text-white"><%= displayDf.format(totalPrice) %> บาท</span>
                    </div>

                    <hr class="border-secondary">
                    
                    <%-- 3. เจน QR Code ตามราคาจริง (PromptPay.io) --%>
                    <img src="https://promptpay.io/0946462718/<%= df.format(totalPrice) %>.png" 
                         class="img-fluid rounded mb-4" 
                         style="max-width: 250px; border: 5px solid white;">
                    
                    <div class="mb-4 text-start">
                        <label class="form-label small text-secondary">แนบหลักฐานการโอนเงิน (สลิป)</label>
                        <input type="file" id="slipFile" class="form-control bg-dark text-white border-secondary" accept="image/*">
                    </div>
                    
                    <button type="button" id="btnSubmit" class="btn btn-warning w-100 fw-bold py-2" onclick="confirmPayment()">
                        ยืนยันการโอนเงิน
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
   
    const currentBookingId = "<%= bookingId %>";
    const duration = 5 * 60 * 1000; // 5 นาที (มิลลิวินาที)
    const expireTime = Date.now() + duration; 
    
    // ประกาศครั้งเดียวพอ
    const timerElement = document.getElementById('timer');

    // 2. ฟังก์ชันนับถอยหลังที่แม่นยำ
    function updateTimer() {
        const now = Date.now();
        const diff = expireTime - now;

        if (diff <= 0) {
            timerElement.innerText = "00:00";
            clearInterval(countdown);
            Swal.fire({
                icon: 'error',
                title: 'หมดเวลาชำระเงิน',
                text: 'รายการจองของคุณถูกยกเลิกแล้ว',
                confirmButtonText: 'กลับหน้าหลัก'
            }).then(() => {
                window.location.href = "index.jsp";
            });
            return;
        }

        let minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
        let seconds = Math.floor((diff % (1000 * 60)) / 1000);

        // แสดงผลในรูปแบบ 00:00
        timerElement.innerText = (minutes < 10 ? "0" + minutes : minutes) + ":" + (seconds < 10 ? "0" + seconds : seconds);
    }

    const countdown = setInterval(updateTimer, 1000);
    updateTimer();

     function confirmPayment() {
    const fileInput = document.getElementById('slipFile'); // ID ของ input type="file"
    const bookingId = "<%= request.getParameter("bookingId") %>"; // ดึงจาก URL

    if (fileInput.files.length === 0) {
        alert("กรุณาเลือกไฟล์สลิปก่อนครับ");
        return;
    }

    // เตรียมข้อมูลส่งแบบ Multipart
    const formData = new FormData();
    formData.append("slip_image", fileInput.files[0]);
    formData.append("booking_id", bookingId);
    formData.append("amount", "<%= totalPrice %>");


  
    const btn = document.getElementById('btnSubmit');
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> กำลังตรวจสอบ...';

    fetch('verifySlip', {
        method: 'POST',
        body: formData
    })
    .then(res => res.text())
    .then(data => {
        if (data.trim() === "success") {
            Swal.fire('สำเร็จ!', 'ชำระเงินเรียบร้อยแล้ว', 'success').then(() => {
                        window.location.href = "history"; // จ่ายเสร็จไปดูประวัติเลย
                    });      
        } else {
            Swal.fire('ผิดพลาด', data, 'error');
                    btn.disabled = false;
                    btn.innerText = "ยืนยันการโอนเงิน";
        }
    })
    .catch(err => {
        console.error(err);
        alert("เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์");
        btn.disabled = false;
    });
}
    </script>
</body>
</html>