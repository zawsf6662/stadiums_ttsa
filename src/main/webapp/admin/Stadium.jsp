<%-- 
    Document   : Stadium
    Created on : Mar 27, 2026, 9:16:49 PM
    Author     : zawsf
--%>

<%@page import="com.users.model.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.stadium.model.*, com.stadium.dao.*, java.util.List"%>
<%@page import="com.stadium.model.Stadium"%>
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
        
                    <h4 class="text-info mb-3">STADIUM</h4>
                        <table id="stadiumTable" class="table table-dark table-hover">
                            <thead>
                                <tr>
                                    <th><fmt:message key="admin.stadium.name" /></th>
                                    <th><fmt:message key="admin.stadium.type" /></th>
                                    <th><fmt:message key="admin.stadium.price" /></th>
                                    <th><fmt:message key="admin.stadium.status" /></th>
                                    <th class="text-center">Action</th>
                                </tr>
                            </thead>
                            <tbody>
        <% if(stadiums != null && !stadiums.isEmpty()){
            for(Stadium s : stadiums) { %>
             <tr id="row-<%= s.getId() %>">
            <td class="stadium-name"><%= s.getName() %></td>
            <td class="stadium-type"><%= s.getType() %></td>
            <td class="stadium-price"><%= s.getPrice() %></td>
            <td>
                <span class="badge <%= s.getStatus().equals("Available") ? "bg-success" : "bg-danger" %> status-badge">
                    <%= s.getStatus() %>
                </span>
            </td>
            <td class="text-center">
                <div class="btn-group-display">
                    <button type="button" class="btn btn-sm btn-outline-warning edit-btn" onclick="editRow(this, '<%= s.getId() %>')">
                        <i class="bi bi-pencil"></i>
                    </button>
                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="deleteStadium(this, '<%= s.getId() %>')">
                        <i class="bi bi-trash"></i>
                    </button>
                </div>
                <div class="btn-group-edit d-none">
                    <button type="button" class="btn btn-sm btn-success save-btn" onclick="saveRow(this, '<%= s.getId() %>')">
                        <i class="bi bi-check-lg"></i>
                    </button>
                    <button type="button" class="btn btn-sm btn-secondary cancel-btn" onclick="cancelEdit(this, '<%= s.getId() %>')">
                        <i class="bi bi-x-lg"></i>
                    </button>
                </div>
            </td>
        </tr>
        <% } } %>
    </tbody>
                        </table>
                </div>
            </div>

            <div class="col-lg-5">
                <div class="admin-card">
    <h4 class="text-warning mb-3"><i class="bi bi-plus-circle"></i> <fmt:message key="admin.add_stadium" /></h4>
    <form action="../adminControl" method="POST">
        <input type="hidden" name="action" value="addStadium">
        <div class="mb-3">
            <label class="form-label text-muted">Stadium Name</label>
            <input type="text" name="name" class="form-control bg-dark text-white border-secondary" required>
        </div>
        <div class="row">
            <div class="col-6 mb-3">
                <label class="form-label text-muted">Type</label>
                <select name="type" class="form-select bg-dark text-white border-secondary">
                    <option value="Indoor">Indoor</option>
                    <option value="Outdoor">Outdoor</option>
                </select>
            </div>
            <div class="col-6 mb-3">
                <label class="form-label text-muted">Price / Hr</label>
                <input type="number" name="price" class="form-control bg-dark text-white border-secondary" required>
            </div>
        </div>
        <button type="submit" class="btn btn-gold w-100 fw-bold mt-2">ADD STADIUM</button>
    </form>
</div>
            </div>
        </div>
    </div>
</div>
         
<script>
    // --- 1. ประกาศตัวแปร Global ---
    let originalData = {};

    // --- 2. ฟังก์ชันแก้ไข (ต้องอยู่นอก document.ready) ---
function editRow(btn, id) { // รับ btn เพิ่มเข้ามา
    console.log("Edit click ID:", id);
    
    // ✅ หาแถวจากปุ่มที่กดโดยตรง (แม่นยำ 100% ไม่ต้องสน ID)
    const row = $(btn).closest('tr'); 
    
    if (row.length === 0) {
        console.error("หาแถวไม่เจอ!");
        return;
    }
    
    const currentName = row.find('.stadium-name').text().trim();
    const currentType = row.find('.stadium-type').text().trim();
    const currentPrice = row.find('.stadium-price').text().trim();

    // เก็บค่าเดิม (ใช้ id เป็น Key เหมือนเดิม)
        originalData[id] = {
        name: currentName,
        type: currentType,
        price: currentPrice
         };
         console.log(currentName);
    // เปลี่ยนเป็น Input
row.find('.stadium-name').html('<input type="text" class="form-control form-control-sm edit-input-name">');
    row.find('.stadium-type').html('<input type="text" class="form-control form-control-sm edit-input-type">');
    row.find('.stadium-price').html('<input type="number" class="form-control form-control-sm edit-input-price">');

    // 4. ใช้คำสั่ง .val() ของ jQuery ยัดค่าเข้าไป (วิธีนี้ปลอดภัยและแม่นยำที่สุด)
    row.find('.edit-input-name').val(currentName);
    row.find('.edit-input-type').val(currentType);
    row.find('.edit-input-price').val(currentPrice);

    // 4. สลับกลุ่มปุ่มกด
    row.find('.btn-group-display').addClass('d-none');
    row.find('.btn-group-edit').removeClass('d-none');
}

    function cancelEdit(btn, id) {
        const row = $(btn).closest('tr');
        console.log(btn);
        const data = originalData[id];
       if (data) {
        // คืนค่าตัวหนังสือปกติกลับไปในช่องต่างๆ
        row.find('.stadium-name').text(data.name);
        row.find('.stadium-type').text(data.type);
        row.find('.stadium-price').text(data.price);
        
        // สลับปุ่มกลับมาเป็นโหมดปกติ (Edit/Delete)
        row.find('.btn-group-display').removeClass('d-none');
        row.find('.btn-group-edit').addClass('d-none');
    } else {
        console.error("ไม่มีข้อมูลเดิมเก็บไว้สำหรับ ID:", id);
        // แผนสำรองถ้าหาข้อมูลเดิมไม่เจอจริงๆ ให้รีโหลดหน้าจอ
        location.reload();
    }
    }

function saveRow(btn, id) {
    const row = $(btn).closest('tr');
    const nameVal = row.find('.edit-input-name').val();
    const typeVal = row.find('.edit-input-type').val();
    const priceVal = row.find('.edit-input-price').val();
    const statusVal = row.find('.status-badge').text().trim();

    console.log("กำลังส่ง ID:", id, "ค่าที่ส่ง:", nameVal, typeVal, priceVal);

    $.post('../adminControl', {
        action: 'updateStadium',
        id: id,
        name: nameVal,
        type: typeVal,
        price: priceVal,
        status: statusVal
    })
    .done(function(response) {
        console.log("Server Response:", response);
        if(response.trim() === 'success') {
            row.find('.stadium-name').text(nameVal);
            row.find('.stadium-type').text(typeVal);
            row.find('.stadium-price').text(priceVal);
            row.find('.btn-group-display').removeClass('d-none');
            row.find('.btn-group-edit').addClass('d-none');
            row.css('background-color', 'rgba(40, 167, 69, 0.2)');
            setTimeout(() => row.css('background-color', ''), 1000);
        } else {
            alert("บันทึกไม่สำเร็จ: " + response);
        }
    })
    .fail(function(xhr, status, error) {
        // ดู Error แบบละเอียดใน Console
        console.error("Status:", status);
        console.error("Error:", error);
        console.error("Response Text:", xhr.responseText);
        alert("ติดต่อเซิร์ฟเวอร์ล้มเหลว! (รหัส: " + xhr.status + ")");
    });
}

    function deleteStadium(btn, id) {
        if(confirm('ยืนยันการลบ?')) {
            $.post('../adminControl', { action: 'deleteStadium', id: id }, function(response) {
                if(response.trim() === 'success') {
                    $('#stadiumTable').DataTable().row($(btn).closest('tr')).remove().draw(false);
                }
            });
        }
    }

    // --- 3. ส่วนที่ทำงานเมื่อโหลดหน้าเสร็จ ---
    $(document).ready(function() {
        // DataTable
        const table = $('#stadiumTable').DataTable({
        "responsive": true, // เปิดโหมด responsive ของ plugin
        "scrollX": true,    // เปิดการเลื่อนแนวนอนถ้าจอแคบมาก
        "autoWidth": false, // 👈 เพิ่มบรรทัดนี้ เพื่อให้มันขยายเต็มที่ตาม Container
        "width": "100%",    // 👈 บังคับความกว้างเป็น 100%
        "language": {
            "url": "${sessionScope.lang == 'th' ? '../assets/json/th.json' : ''}"
        }
    });
    
    setTimeout(function() {
        table.columns.adjust().draw();
    }, 200);

    // --- 3. แก้ไขบั๊ก DataTables เมื่อมีการหดขยายหน้าจอ ---
    $(window).on('resize', function() {
        table.columns.adjust();
    });

        // WebSocket
        const socket = new WebSocket("ws://" + window.location.host + "${pageContext.request.contextPath}/stadiumWS");
        
        socket.onmessage = function(event) {
            const data = JSON.parse(event.data);
            if (data.action === "update") {
                const row = $(`#row-${data.stadiumId}`);
                row.find('.stadium-name').text(data.name);
                row.find('.stadium-type').text(data.type);
                row.find('.stadium-price').text(data.price);
                const badge = row.find('.status-badge');
                badge.text(data.status).removeClass('bg-success bg-danger').addClass(data.status === 'Available' ? 'bg-success' : 'bg-danger');
                row.fadeOut(100).fadeIn(100);
            } else if (data.action === "delete") {
                $(`#row-${data.stadiumId}`).fadeOut(500, function() { $(this).remove(); });
            }
        };
    });
</script>
</body>
</html>
