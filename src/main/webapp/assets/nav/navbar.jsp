<%-- 
    Document   : navbar
    Created on : Mar 28, 2026, 4:55:09 PM
    Author     : zawsf
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.users.model.User"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="${sessionScope.lang}" />
<fmt:setBundle basename="messages.messages" />
<%

    User currentUser = (User) session.getAttribute("user");
%>
<%
    // ดึงชื่อไฟล์ปัจจุบันมาเช็ก
    String uri = request.getRequestURI();
    String currentPage = uri.substring(uri.lastIndexOf("/") + 1);
%>
<nav class="navbar navbar-expand-lg navbar-dark navbar-custom sticky-top">
    <div class="container">
        <a class="navbar-brand" href="index.jsp">
            <i class="bi bi-lightning-charge-fill me-2"></i>STADIUM ARENA
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto align-items-center">
                <li class="nav-item"><a class="nav-link <%= currentPage.equals("index.jsp") || currentPage.equals("") ? "active" : "" %>" href="index.jsp">หน้าแรก</a></li>
                <li class="nav-item"><a class="nav-link <%= currentPage.equals("allBookings.jsp") || currentPage.equals("") ? "active" : "" %>" href="allBookings.jsp">ตารางการจอง</a></li>
                <li class="nav-item"><a class="nav-link" href="#">ติดต่อเรา</a></li>

                <% if (currentUser != null) { %>
                    <li class="nav-item dropdown ms-lg-3">
                        <a class="nav-link dropdown-toggle text-warning fw-bold" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="bi bi-person-circle me-1"></i>
                            <%= currentUser.getFullname() %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-dark dropdown-menu-end">
                            <li><a class="dropdown-item" href="history">ประวัติการจอง</a></li>
                            <% if (currentUser != null && "ADMIN".equals(currentUser.getRole())) { %>
                            <li><a class="dropdown-item" href="admin/admin.jsp">admin</a></li>
                            <% } %>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/adminControl?action=logout">ออกจากระบบ</a></li>
                        </ul>
                    </li>
                <% } else { %>
                    <li class="nav-item">
                        <a class="btn btn-outline-warning ms-lg-3" href="login.jsp">เข้าสู่ระบบ</a>
                    </li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>
