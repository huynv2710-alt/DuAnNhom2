<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isELIgnored="false" %>

    <link rel="stylesheet" href="css/menu.css">

<nav class="sidebar">

    <div class="sidebar-header">
        <div class="logo-box">🛒</div>
        <div class="brand-name">Quản Lý Bán Hàng</div>
    </div>

    <ul class="nav-links">
        <li><a href="quanlinhanvien">Quản lý nhân viên</a></li>
        <li><a href="thongtinquanli">Thông tin cá nhân</a></li>

    </ul>
<div class="sidebar-footer">
        <div class="user-info">
            <div class="avatar">
                ${fn:substring(sessionScope.tenTK,0,1)}
            </div>
            <div>
                <div><b>${sessionScope.tenTK}</b></div>
                <div>${sessionScope.quyen}</div>
            </div>
        </div>

        <button class="logout-btn" onclick="window.location.href='index.jsp'">
            Đăng xuất
        </button>
    </div>

</nav>
