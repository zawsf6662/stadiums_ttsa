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
            <div class="col-md-5 auth-card">
                <h2 class="text-center text-warning mb-4 fw-bold">LOGIN</h2>
                
                <% if(request.getParameter("error") != null) { %>
                    <div class="alert alert-danger py-2">Username หรือ Password ไม่ถูกต้อง</div>
                <% } %>

                <form action="adminControl" method="POST">
                    <input type="hidden" name="action" value="login">
                    <div class="mb-3">
                        <label class="form-label">Username</label>
                        <input type="text" name="username" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" class="form-control" required>
                    </div>
                    <button type="submit" class="btn btn-gold w-100 py-2 mt-3">เข้าสู่ระบบ</button>
                    <p class="text-center mt-3 small">ยังไม่มีบัญชี? <a href="register.jsp" class="text-warning">สมัครสมาชิก</a></p>
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

</body>
</html>
