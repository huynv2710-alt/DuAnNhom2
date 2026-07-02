<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang Nhân Viên - Book Store</title>
    <link rel="stylesheet" href="css/nv.css">
    <style>
        body {
            margin: 0 !important;
            padding: 0 !important;
            display: flex !important;
            align-items: flex-start !important;
            min-height: 100vh !important;
            background-color: #f4f6f9 !important;
        }

        .sidebar {
            position: sticky !important;
            top: 0 !important;
            height: 100vh !important;
            width: 260px !important;
            min-width: 260px !important;
            overflow-y: auto !important;
            z-index: 1000 !important;
        }

        .content {
            flex: 1 !important;
            width: calc(100% - 260px) !important;
            padding: 30px !important;
            box-sizing: border-box !important;
            min-height: 100vh !important;
            margin: 0 !important;
        }
    </style>
</head>
<body>

<jsp:include page="menu2.jsp"/>

<main class="content">

    <div class="page-header">
        <h1>Trang Nhân Viên</h1>
        <p>Chào mừng bạn trở lại hệ thống quản lý Book Store</p>
    </div>

    <div class="welcome-card">
        <div class="welcome-avatar">
            ${fn:substring(sessionScope.hoTen, 0, 1)}
        </div>
        <div class="welcome-text">
            <h2>Xin chào, ${sessionScope.hoTen}!</h2>
            <p>Tài khoản: <strong>${sessionScope.username}</strong> &nbsp;|&nbsp; Hôm nay chúc bạn làm việc vui vẻ 🎉</p>
        </div>
        <div class="welcome-badge">📋 ${sessionScope.quyen}</div>
    </div>

    <div class="stats-row">
        <div class="stat-card green">
            <div class="stat-icon green">📦</div>
            <div class="stat-info">
                <p>Đơn hàng hôm nay</p>
                <h3>--</h3>
            </div>
        </div>
        <div class="stat-card teal">
            <div class="stat-icon teal">✅</div>
            <div class="stat-info">
                <p>Đơn hoàn thành</p>
                <h3>--</h3>
            </div>
        </div>
        <div class="stat-card orange">
            <div class="stat-icon orange">⏳</div>
            <div class="stat-info">
                <p>Đơn chờ xử lý</p>
                <h3>--</h3>
            </div>
        </div>
    </div>

    <div class="info-card">
        <h2>👤 Thông tin tài khoản</h2>
        <div class="info-grid">
            <div class="info-item">
                <label>Tên đăng nhập</label>
                <span>${sessionScope.username}</span>
            </div>
            <div class="info-item">
                <label>Họ và tên</label>
                <span>${sessionScope.tenTK}</span>
            </div>
            <div class="info-item">
                <label>Vai trò</label>
                <span>${sessionScope.quyen}</span>
            </div>
            <div class="info-item">
                <label>Số điện thoại</label>
                <span>${sessionScope.sdt}</span>
            </div>
            <div class="info-item">
                <label>Email</label>
                <span>${sessionScope.email}</span>
            </div>
            <div class="info-item">
                <label>Địa chỉ</label>
                <span>${sessionScope.diaChi}</span>
            </div>
            <div class="info-item">
                <label>CCCD</label>
                <span>${sessionScope.cccd}</span>
            </div>
            <div class="info-item">
                <label>Ngày cấp CCCD</label>
                <span>${sessionScope.ngayCapCCCD}</span>
            </div>
            <div class="info-item">
                <label>Đặc điểm nhận dạng</label>
                <span>${sessionScope.dacDiemNhanDang}</span>
            </div>
            <div class="info-item">
                <label>Trạng thái</label>
                <span style="color:#2e7d32; font-weight:bold;">${sessionScope.tenTrangThai}</span>
            </div>
        </div>
    </div>

</main>

</body>
</html>