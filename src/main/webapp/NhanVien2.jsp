<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trang Nhân Viên - Book Store</title>
    <link rel="stylesheet" href="nv.css">
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
            ${fn:substring(sessionScope.tenTK, 0, 1)}
        </div>
        <div class="welcome-text">
            <h2>Xin chào, ${sessionScope.tenTK}!</h2>
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
                <label>Trạng thái</label>
                <span style="color:#2e7d32; font-weight:bold;">🟢 Đang hoạt động</span>
            </div>
        </div>
    </div>

    <div class="actions-card">
        <h2>⚡ Thao tác nhanh</h2>
        <div class="actions-grid">
            <a href="index.jsp" class="action-btn">
                <div class="action-icon">📋</div>
                <span>Đơn hàng</span>
            </a>
            <a href="#" class="action-btn">
                <div class="action-icon">👥</div>
                <span>Khách hàng</span>
            </a>
            <a href="#" class="action-btn">
                <div class="action-icon">📚</div>
                <span>Nhập kho</span>
            </a>
            <a href="#" class="action-btn">
                <div class="action-icon">📊</div>
                <span>Báo cáo</span>
            </a>
            <a href="#" class="action-btn">
                <div class="action-icon">🔑</div>
                <span>Đổi mật khẩu</span>
            </a>
            <a href="index.jsp" class="action-btn">
                <div class="action-icon">🚪</div>
                <span>Đăng xuất</span>
            </a>
        </div>
    </div>

</main>

</body>
</html>