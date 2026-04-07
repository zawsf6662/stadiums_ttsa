<%-- 
    Document   : navbar
    Created on : Mar 28, 2026, 4:55:09 PM
    Author     : zawsf
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="${sessionScope.lang}" />
<fmt:setBundle basename="messages.messages" />
<div class="top-nav">
        <div>
            <span class="text-whiht"><fmt:message key="admin.welcome" />: </span>
            <span class="text-warning fw-bold">Admin Stadium</span>
        </div>
        
        <div class="d-flex align-items-center">
            <div class="me-4">
                <a href="?lang=th" class="btn btn-sm  ${sessionScope.lang == 'th' ? 'btn-warning' : 'btn-light'}  text-dark">TH</a>
                <a href="?lang=en" class="btn btn-sm ${sessionScope.lang == 'en' ? 'btn-warning' : 'btn-light'} text-dark  ">EN</a>
            </div>
            <span class="badge bg-dark border border-secondary p-2">
                <i class="bi bi-clock"></i>
                <fmt:formatDate value="<%= new java.util.Date() %>" pattern="EEEE d MMMM yyyy" />
            </span>
            <div class="m-1">
                 <button type="button" id="sidebarCollapse" class="btn btn-outline-light d-lg-none">
    <i class="bi bi-list"></i>
</button>
            </div>
        </div>
    </div>
