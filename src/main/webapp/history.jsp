<%@page import="com.users.model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
  User u = (User) session.getAttribute("user");
    
    if (u == null) {
        response.sendRedirect("index.jsp");
    }
%>

<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ประวัติการจอง | STADIUM ARENA</title>

    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="assets/bootstrap-icons-1.13.1/bootstrap-icons.css">
    <jsp:include page="assets/js/input.jsp"/>
    <style>
          <jsp:include page="assets/css/style.css"/>
        
        body { 
            background-color: #0f0f0f; 
            color: #e0e0e0; 
            font-family: 'Prompt', sans-serif;
            background-image: radial-gradient(circle at 50% -20%, #2c2c2c 0%, #0f0f0f 80%);
        }

        .page-title {
            font-weight: 700;
            color: #fff;
            letter-spacing: 1px;
            margin-bottom: 2.5rem;
            border-left: 5px solid #ffeb3b;
            padding-left: 15px;
        }

        /* --- New Booking Card Style --- */
        .booking-card {
            background: #1a1a1a;
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.08);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
        }

        .booking-card:hover {
            transform: translateY(-8px);
            border-color: rgba(255, 235, 59, 0.4);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.5);
        }

        .card-top {
            background: rgba(255, 255, 255, 0.03);
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .stadium-name {
            font-size: 1.3rem;
            font-weight: 600;
            color: #fff;
            margin: 0;
        }

        .booking-id {
            color: #ffeb3b;
            font-family: monospace;
            font-size: 0.85rem;
            background: rgba(255, 235, 59, 0.1);
            padding: 2px 8px;
            border-radius: 5px;
        }

        .info-label {
            font-size: 0.8rem;
            color: #888;
            margin-bottom: 2px;
        }

        .info-value {
            font-size: 1rem;
            color: #ddd;
            font-weight: 500;
        }

        /* Status Badges */
        .status-badge {
            font-size: 0.7rem;
            padding: 6px 12px;
            border-radius: 50px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Glow effects for PAID status */
        .card-paid {
            border-color: rgba(40, 167, 69, 0.3) !important;
        }
        .card-paid::after {
            content: '';
            position: absolute;
            top: 0; right: 0;
            width: 60px; height: 60px;
            background: linear-gradient(135deg, transparent 50%, rgba(40, 167, 69, 0.2) 50%);
        }

        .btn-pay {
            background: linear-gradient(45deg, #ffeb3b, #fdd835);
            color: #000;
            border: none;
            font-weight: 700;
            border-radius: 12px;
            padding: 10px;
            transition: 0.3s;
        }

        .btn-pay:hover {
            transform: scale(1.02);
            box-shadow: 0 5px 15px rgba(255, 235, 59, 0.3);
            background: #fff;
        }

        .empty-state {
            background: #1a1a1a;
            border-radius: 30px;
            padding: 80px 20px;
            border: 2px dashed rgba(255, 255, 255, 0.1);
        }
    </style>
</head>
<body>

<jsp:include page="assets/nav/navbar.jsp"/>

<div class="container py-5">
    <div class="row mb-4">
        <div class="col-12 text-center text-md-start">
            <h2 class="page-title">ประวัติการจองของคุณ</h2>
        </div>
    </div>

    <div class="row g-4">
        <c:forEach var="b" items="${bookingList}">
            <c:set var="status" value="${b.status.toUpperCase()}" />
            
            <div class="col-12 col-md-6 col-lg-4">
                <div class="booking-card h-100 d-flex flex-column ${status == 'PAID' ? 'card-paid' : ''}">
                    
                    <div class="card-top d-flex justify-content-between align-items-start">
                        <div>
                            <h3 class="stadium-name">${b.stadiumName}</h3>
                            <span class="booking-id">ID: #${b.id}</span>
                        </div>
                        <c:choose>
                            <c:when test="${status == 'PENDING'}">
                                <span class="status-badge bg-warning text-dark shadow-sm">รอชำระเงิน</span>
                            </c:when>
                            <c:when test="${status == 'PAID' || status == 'CONFIRMED'}">
                                <span class="status-badge bg-success text-white shadow-sm">สำเร็จ</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge bg-secondary text-white">${status}</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="p-4 flex-grow-1">
                        <div class="row g-3">
                            <div class="col-6">
                                <div class="info-label"><i class="bi bi-calendar-event me-1"></i> วันที่จอง</div>
                                <div class="info-value">${b.bookingDate}</div>
                            </div>
                            <div class="col-6">
                                <div class="info-label"><i class="bi bi-clock me-1"></i> เวลา</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty b.startTime}">
                                            ${b.startTime.substring(0,5)} - ${b.endTime.substring(0,5)}
                                        </c:when>
                                        <c:otherwise>รอยืนยัน</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="info-label"><i class="bi bi-cash-stack me-1"></i> ยอดชำระเงิน</div>
                                <div class="info-value text-white fs-5">฿${b.totalPrice}</div>
                            </div>
                        </div>
                    </div>

                    <div class="p-4 pt-0">
                        <c:choose>
                            <c:when test="${status == 'PENDING' && b.secondsPassed < 300}">
                                <a href="payment.jsp?bookingId=${b.id}" class="btn btn-pay w-100 mb-2">
                                    <i class="bi bi-credit-card-2-front me-2"></i>ชำระเงินตอนนี้
                                </a>
                                <div class="text-center">
                                    <small class="text-warning">
                                        <i class="bi bi-stopwatch me-1"></i> 
                                        หมดอายุใน ${Math.max(1, 5 - (b.secondsPassed / 60).intValue())} นาที
                                    </small>
                                </div>
                            </c:when>

                            <c:when test="${status == 'PENDING' && b.secondsPassed >= 300}">
                                <div class="alert alert-dark border-0 mb-0 py-2 text-center" style="background: rgba(255,255,255,0.05)">
                                    <small class="text-danger fw-bold"><i class="bi bi-x-circle me-1"></i> รายการหมดอายุ</small>
                                </div>
                            </c:when>

                            <c:when test="${status == 'PAID' || status == 'CONFIRMED'}">
                                <div class="alert alert-success border-0 mb-0 py-2 text-center" style="background: rgba(40,167,69,0.1)">
                                    <small class="text-success fw-bold"><i class="bi bi-check-all me-1"></i> บุ๊คกิ้งพร้อมใช้งาน</small>
                                </div>
                            </c:when>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <c:if test="${empty bookingList}">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="empty-state text-center">
                    <div class="mb-4">
                        <i class="bi bi-calendar-x text-secondary" style="font-size: 5rem; opacity: 0.3;"></i>
                    </div>
                    <h3 class="text-white mb-3">ไม่พบประวัติการจอง</h3>
                    <p class="text-secondary mb-4">ดูเหมือนว่าคุณยังไม่มีการจองสนามในขณะนี้ เริ่มจองสนามแรกของคุณเลย!</p>
                    <a href="index.jsp" class="btn btn-pay px-4 py-2">
                        จองสนามตอนนี้ <i class="bi bi-arrow-right ms-2"></i>
                    </a>
                </div>
            </div>
        </div>
    </c:if>
</div>

<script>
    // รีเฟรชหน้าทุก 1 นาที เพื่ออัปเดตเวลาถอยหลัง
    setTimeout(() => { location.reload(); }, 60000);
</script>

<jsp:include page="assets/nav/footer.jsp"/>

</body>
</html>