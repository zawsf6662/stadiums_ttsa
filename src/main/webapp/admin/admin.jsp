<%-- 
    Document   : admin
    Created on : Mar 27, 2026, 9:16:49 PM
    Author     : zawsf
--%>

<%@page import="com.users.model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.stadium.model.*, com.stadium.dao.*, java.util.List"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%
    User u = (User) session.getAttribute("user");
    
    if (u == null || !"ADMIN".equals(u.getRole())) {
        response.sendRedirect("../index.jsp");
    }
    
    String lang = request.getParameter("lang");
    if (lang == null) {
        lang = (String) session.getAttribute("lang");
        if (lang == null) lang = "th";
    }
    session.setAttribute("lang", lang);
    
    StadiumDAO dao = new StadiumDAO();
    List<Stadium> stadiums = dao.getAllStadiums();
    // ดึงเวลาของทั้ง 7 วันมาแสดง
    String[] daysKeys = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
%>

<fmt:setLocale value="${sessionScope.lang}" />
<fmt:setBundle basename="messages.messages" />

<!DOCTYPE html>
<html>
<head>
    <title><fmt:message key="admin.title" /> | STADIUM ARENA</title>
    <link href="../assets/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../assets/bootstrap-icons-1.13.1/bootstrap-icons.min.css">
    <link rel="stylesheet" href="css/style.css"/>
    <jsp:include page="js/input.jsp" />
    <style>
        /* เพิ่มสไตล์พิเศษสำหรับ List Group ในหน้านี้ */
        .list-group-item {
            background-color: rgba(255, 255, 255, 0.03) !important;
            border-color: var(--border-color) !important;
            padding: 15px 20px;
            margin-bottom: 5px;
            border-radius: 8px !important;
            transition: 0.3s;
        }
        .list-group-item:hover {
            background-color: rgba(255, 255, 255, 0.08) !important;
        }
        .btn-outline-info {
            border-color: var(--info-color);
            color: var(--info-color);
        }
        .btn-outline-info:hover {
            background-color: var(--info-color);
            color: #fff;
        }
        /* แก้ไข input time ให้เข้ากับธีม */
        input[type="time"]::-webkit-calendar-picker-indicator {
            filter: invert(1); /* ทำให้ไอคอนนาฬิกาเป็นสีขาว */
            cursor: pointer;
        }
    </style>
</head>

<body>
    
    <jsp:include page="nav/sidebar.jsp" />
    
    <div class="main-content">
    <jsp:include page="nav/navbar.jsp" />

    <div class="container-fluid">
        <h2 class="mb-4 text-warning"><fmt:message key="admin.title" /></h2>
        <div class="row">
            <div class="col-lg-7">
                <div class="admin-card">
                    <h4 class="text-info mb-3"><fmt:message key="admin.set_time" /></h4>
                    <form action="../adminControl" method="POST">
                        <input type="hidden" name="action" value="updateTime">
                        <table id="stadiumTable" class="table table-dark table-hover">
                            <thead>
                                <tr>
                                    <th><fmt:message key="admin.day" /></th>
                                    <th><fmt:message key="admin.open" /></th>
                                    <th><fmt:message key="admin.close" /></th>
                                    <th class="text-center"><fmt:message key="admin.closed_service" /></th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for(String dayKey : daysKeys) { 
                                    OpeningHours oh = dao.getTodayOpeningHours(dayKey);
                                %>
                                <c:set var="currentDay" value="<%= dayKey %>" />
                                <tr>
                                    <td><fmt:message key="day.${currentDay}" /></td>
                                    <td><input type="time" name="open_<%= dayKey %>" value="<%= (oh != null) ? oh.getOpenTime() : "10:00" %>" class="form-control form-control-sm"></td>
                                    <td><input type="time" name="close_<%= dayKey %>" value="<%= (oh != null) ? oh.getCloseTime() : "22:00" %>" class="form-control form-control-sm"></td>
                                    <td class="text-center">
                                        <input type="checkbox" name="closed_<%= dayKey %>" <%= (oh != null && oh.isClosed()) ? "checked" : "" %>>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                        <button type="submit" class="btn btn-gold w-100 fw-bold"><fmt:message key="admin.save" /></button>
                    </form>
                </div>
            </div>

            <div class="col-lg-5">
                <div class="admin-card">
                    <h4 class="text-danger mb-3"><fmt:message key="admin.manage_stadium" /></h4>
                    <div class="list-group">
                        <% for(Stadium s : stadiums) { %>
                        <div class="list-group-item bg-dark text-light d-flex justify-content-between align-items-center border-secondary">
                            <%= s.getName() %> 
                            <div>
                                <span class="badge <%= s.getStatus().equals("Available") ? "bg-success" : "bg-danger" %> me-2">
                                    <%= s.getStatus() %>
                                </span>
                                <form action="../adminControl" method="POST" style="display:inline;">
                                    <input type="hidden" name="action" value="toggleStatus">
                                    <input type="hidden" name="stadiumId" value="<%= s.getId() %>">
                                    <input type="hidden" name="currentStatus" value="<%= s.getStatus() %>">
                                    <button class="btn btn-outline-info btn-sm"><fmt:message key="admin.toggle" /></button>
                                </form>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

                    <script>
                        $(document).ready(function() {
                            // สั่งให้ตารางทำงาน
                            $('#stadiumTable').DataTable({
                                "paging" false,
                                "searching" false,
                                "info" false,
                                "language": {
                                    // ถ้า session เป็นไทย ให้ใช้เมนูไทย
                                    "url": "${sessionScope.lang == 'th' ? '../assets/json/th.json' : ''}"
                                },
                                "pageLength": 7 // แสดงกี่แถวต่อหน้า        
                            });
                        });
                    </script>  
</body>
</html>
