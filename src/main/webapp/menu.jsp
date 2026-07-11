<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/menu.css">

<nav class="sidebar">

    <div class="sidebar-header">
        <div class="logo-box">🛒</div>
        <div class="brand-name">Quản Lý Bán Hàng</div>
    </div>

    <ul class="nav-links">
        <li><a href="dashboard">Dashboard</a></li>
        <c:if test="${sessionScope.quyen == 'admin'}">
            <li><a href="quanlytaikhoan">Quản lý tài khoản</a></li>
            <li><a href="quanlinhanvien">Quản lý nhân viên</a></li>
        </c:if>
        <li><a href="quanlysach">Quản lí sách</a></li>
        <li><a href="thongtinquanli">Thông tin cá nhân</a></li>
        <li><a href="doimatkhau">Đổi mật khẩu</a></li>
    </ul>
<div class="sidebar-footer">
        <div class="user-info">
            <div class="avatar">
                ${not empty sessionScope.tenTK ? fn:substring(sessionScope.tenTK,0,1) : 'U'}
            </div>
            <div>
                <div><b>${sessionScope.tenTK}</b></div>
                <div>${sessionScope.quyen == 'admin' ? 'Quản trị viên' : 'Nhân viên'}</div>
            </div>
        </div>

        <button class="logout-btn" onclick="window.location.href='index.jsp'">
            Đăng xuất
        </button>
    </div>

</nav>
