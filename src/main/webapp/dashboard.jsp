<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Book Store</title>
    <link rel="stylesheet" href="css/nv.css">
    <style>
        body { margin: 0 !important; padding: 0 !important; display: flex !important; align-items: flex-start !important; min-height: 100vh !important; background-color: #f4f6f9 !important; }
        .sidebar { position: sticky !important; top: 0 !important; height: 100vh !important; width: 260px !important; min-width: 260px !important; overflow-y: auto !important; z-index: 1000 !important; }
        .content { flex: 1 !important; width: calc(100% - 260px) !important; padding: 30px !important; box-sizing: border-box !important; min-height: 100vh !important; margin: 0 !important; }
    </style>
</head>
<body>
    <jsp:include page="menu.jsp" />

    <main class="content">
        <div class="page-header">
            <h1>Tổng Quan Hệ Thống</h1>
            <p>Báo cáo thống kê hoạt động kinh doanh Book Store</p>
        </div>

        <div class="welcome-card" style="background: linear-gradient(135deg, #0277bd 0%, #01579b 100%); margin-bottom: 30px;">
            <div class="welcome-avatar" style="color: #0277bd; font-size: 36px; border-color: rgba(255,255,255,0.7);">
                $
            </div>
            <div class="welcome-text">
                <h2 style="font-size: 26px;">Doanh Thu Tổng Cộng</h2>
                <p style="font-size: 15px; opacity: 0.9;">Tổng doanh thu từ tất cả các hóa đơn đã thanh toán</p>
            </div>
            <div class="welcome-badge" style="font-size: 28px; padding: 12px 30px; border-radius: 12px; font-weight: bold; background: rgba(255,255,255,0.25);">
                <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="VND" pattern="#,##0 ₫"/>
            </div>
        </div>

        <div class="stats-row" style="grid-template-columns: repeat(4, 1fr);">
            <div class="stat-card">
                <div class="stat-icon green">📚</div>
                <div class="stat-info"><p>Số Lượng Sách</p><h3>${totalBooks}</h3></div>
            </div>
            <div class="stat-card">
                <div class="stat-icon teal">🧾</div>
                <div class="stat-info"><p>Tổng Hóa Đơn</p><h3>${totalOrders}</h3></div>
            </div>
            <div class="stat-card">
                <div class="stat-icon orange">👥</div>
                <div class="stat-info"><p>Nhân Viên</p><h3>${totalEmployees}</h3></div>
            </div>
            <div class="stat-card">
                <div class="stat-icon" style="background:#e8eaf6;">🔐</div>
                <div class="stat-info"><p>Tài Khoản</p><h3>${totalAccounts}</h3></div>
            </div>
        </div>
    </main>
</body>
</html>
