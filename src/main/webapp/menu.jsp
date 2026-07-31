<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isELIgnored="false" %>

<link rel="stylesheet" href="css/menu.css?v=2.0">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<nav class="sidebar">
    <div class="sidebar-header">
        <div class="brand-name">BookStore</div>
    </div>

    <ul class="nav-links">
        <li><a href="dashboard"> Bảng điều khiển</a></li>
        <!-- <li><a href="#"> Thống kê doanh thu</a></li> -->

        <c:if test="${sessionScope.quyen == 'admin'}">
            <li class="menu-heading">NHÂN SỰ</li>
            <li><a href="quanlinhanvien"> Quản lý nhân viên</a></li>
            <li><a href="quanlytaikhoan"> Quản lý tài khoản</a></li>
        </c:if>


        <c:if test="${sessionScope.quyen == 'admin'}">
            <li class="menu-heading">SÁCH & DANH MỤC</li>
            <li><a href="quanlysach"> Quản lý sách</a></li>
            <li><a href="quanlytheloai"> Thể loại</a></li>
            <li><a href="quanlynxb"> Nhà xuất bản</a></li>
        </c:if>

        <li class="menu-heading">BÁN HÀNG</li>
        <li><a href="quanlykhachhang"> Khách hàng</a></li>
        <li><a href="quanlyhoadon"> Hóa đơn</a></li>
        <li><a href="banhang"> Bán hàng (POS)</a></li>

        <li class="menu-heading">CÁ NHÂN</li>
        <li><a href="thongtinquanli"> Thông tin cá nhân</a></li>
        <li><a href="doimatkhau"> Đổi mật khẩu</a></li>
    </ul>

    <div class="sidebar-footer">
        <div style="display:flex; align-items:center; color:#a3b8b0; margin-bottom: 15px;">
            <div style="width:35px; height:35px; background:#2d6652; border-radius:50%; display:flex; justify-content:center; align-items:center; font-weight:bold; color:white; margin-right:10px;">
                ${not empty sessionScope.tenTK ? fn:substring(sessionScope.tenTK,0,1) : 'U'}
            </div>
            <div style="font-size:13px; line-height:1.2;">
                <div style="font-weight:600; color:white;">${sessionScope.tenTK}</div>
                <div style="font-size:12px;">${sessionScope.quyen == 'admin' ? 'Admin' : 'Employee'}</div>
            </div>
        </div>
        <a href="index.jsp" class="logout-link"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
    </div>
</nav>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        var currentUrl = window.location.pathname;
        var links = document.querySelectorAll('.nav-links li a');
        links.forEach(function(link) {
            var href = link.getAttribute('href');
            if (href && href !== '#' && href !== 'index.jsp') {
                if (currentUrl.includes(href)) {
                    link.parentElement.classList.add('active');
                }
            }
        });
    });
</script>
