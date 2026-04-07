<%-- 
    Document   : sidebar
    Created on : Mar 28, 2026, 4:32:14 PM
    Author     : zawsf
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<fmt:setLocale value="${sessionScope.lang}" />
<fmt:setBundle basename="messages.messages" />
    <div class="sidebar">
    <div class="sidebar-brand">
        <i class="bi bi-shield-lock-fill"></i> ARENA ADMIN
    </div>
    <nav>
        <a href="admin.jsp" class="nav-link-admin">
            <i class="bi bi-speedometer2"></i> <fmt:message key="admin.nav.dashboard" />
        </a>
        <a href="Stadium.jsp" class="nav-link-admin text-secondary">
            <i class="bi bi-calendar-check"></i> <fmt:message key="admin.nav.stadium" />
        </a>
          <a href="#" class="nav-link-admin text-secondary">
            <i class="bi bi-calendar-check"></i> <fmt:message key="admin.nav.today" />
        </a>
        <hr style="border-color: #333;">
        <a href="../index.jsp" class="nav-link-admin text-white">
            <i class="bi bi-house-door"></i> <fmt:message key="admin.nav.home" />
        </a>
        <a href="index.jsp" class="nav-link-admin text-danger">
            <i class="bi bi-box-arrow-left"></i> <fmt:message key="admin.nav.logout" />
        </a>
    </nav>
</div>

        <script>
    document.addEventListener("DOMContentLoaded", function() {
        // 1. หาชื่อไฟล์ปัจจุบันจาก URL (เช่น admin.jsp หรือ Stadium.jsp)
        const currentPath = window.location.pathname.split("/").pop();
        
        // 2. เลือกทุกลิงก์ใน nav
        const navLinks = document.querySelectorAll(".nav-link-admin");

        navLinks.forEach(link => {
            // ดึงค่า href มาเทียบ (เช่น admin.jsp)
            const linkPath = link.getAttribute("href");

            if (currentPath === linkPath) {
                // ถ้าตรงกัน ให้ใส่ class active
                link.classList.add("active");
                link.classList.remove("text-secondary");
            } else {
                // ถ้าไม่ตรง ให้เป็นตัวจาง (ยกเว้นปุ่ม Logout/Home ถ้าต้องการสีพิเศษ)
                if(!link.classList.contains('text-danger') && !link.classList.contains('text-white')) {
                    link.classList.add("text-secondary");
                }
            }
        });
    });
     $(document).ready(function() {
        $('#sidebarCollapse').on('click', function() {
        $('.sidebar').toggleClass('active');
    })
     });
</script>