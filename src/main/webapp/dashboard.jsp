<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tổng quan - Book Store</title>
    <link rel="stylesheet" href="css/qlnv.css?v=2.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .dashboard-header {
            display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 25px;
        }
        .dashboard-title { font-size: 20px; font-weight: 800; color: #1e293b; margin: 0 0 5px 0; }
        .dashboard-subtitle { font-size: 13px; color: #64748b; margin: 0; display: flex; align-items: center; gap: 6px; }
        .dashboard-actions button {
            background: white; border: 1px solid #cbd5e1; padding: 8px 15px; border-radius: 6px; color: #475569; font-weight: 600; font-size: 13px; cursor: pointer; margin-left: 10px; box-shadow: 0 1px 2px rgba(0,0,0,0.05);
        }
        
        .kpi-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 25px; }
        .kpi-card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.03); border: 1px solid #f1f5f9; position: relative; overflow: hidden; }
        .kpi-title { font-size: 11px; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 10px; }
        .kpi-value { font-size: 24px; font-weight: 800; color: #1e293b; margin-bottom: 10px; }
        .kpi-desc { font-size: 12px; color: #64748b; }
        .kpi-trend { display: inline-flex; align-items: center; gap: 4px; padding: 2px 6px; border-radius: 4px; font-weight: 700; font-size: 11px; margin-right: 5px; }
        .kpi-trend.up { background: #dcfce7; color: #166534; }
        .kpi-trend.down { background: #fee2e2; color: #991b1b; }
        .kpi-icon { position: absolute; top: 20px; right: 20px; width: 36px; height: 36px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 16px; }
        .icon-revenue { background: #fef3c7; color: #d97706; }
        .icon-profit { background: #dcfce7; color: #059669; }
        .icon-orders { background: #ede9fe; color: #6d28d9; }
        .icon-customers { background: #e0e7ff; color: #4338ca; }

        .dashboard-row { display: grid; grid-template-columns: 2fr 1fr; gap: 20px; }
        .panel { background: white; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.03); border: 1px solid #f1f5f9; display: flex; flex-direction: column; }
        .panel-header { padding: 20px; border-bottom: 1px solid #f1f5f9; display: flex; justify-content: space-between; align-items: center; }
        .panel-title { font-size: 14px; font-weight: 700; color: #1e293b; margin: 0; }
        .panel-body { padding: 20px; flex: 1; }
        
        .stock-item { display: flex; justify-content: space-between; align-items: center; padding: 12px 0; border-bottom: 1px dashed #e2e8f0; }
        .stock-item:last-child { border-bottom: none; }
        .stock-name { font-size: 14px; font-weight: 600; color: #1e293b; }
        .stock-count { font-size: 13px; font-weight: 700; color: #ef4444; background: #fee2e2; padding: 2px 8px; border-radius: 12px; }
        
        .chart-placeholder { background: #fdf6e3; border: 1px solid #fde047; border-radius: 8px; height: 250px; display: flex; align-items: center; justify-content: center; position: relative; }
        .chart-placeholder::after { content: ''; width: 8px; height: 8px; background: #22c55e; border-radius: 50%; position: absolute; }
    </style>
</head>
<body>

<jsp:include page="menu.jsp"/>

<main class="content">

    <div class="dashboard-header">
        <div>
            <h1 class="dashboard-title">Tổng quan</h1>
            <p class="dashboard-subtitle"><i class="far fa-calendar-alt"></i> Hôm nay</p>
        </div>
        <div class="dashboard-actions">
            <button><i class="fas fa-file-alt"></i> Báo cáo đầy đủ</button>
            <button><i class="fas fa-history"></i> Nhật ký</button>
        </div>
    </div>

    <c:if test="${sessionScope.quyen == 'admin'}">
        <!-- ADMIN DASHBOARD -->
        <div class="kpi-grid">
            <div class="kpi-card">
                <div class="kpi-icon icon-revenue"><i class="fas fa-coins"></i></div>
                <div class="kpi-title">DOANH THU HÔM NAY</div>
                <div class="kpi-value"><fmt:formatNumber value="${todayRevenue}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></div>
                <div class="kpi-desc"><span class="kpi-trend up"><i class="fas fa-arrow-up"></i> 100%</span> so với hôm qua</div>
            </div>
            
            <div class="kpi-card">
                <div class="kpi-icon icon-profit"><i class="fas fa-chart-line"></i></div>
                <div class="kpi-title">LỢI NHUẬN HÔM NAY</div>
                <div class="kpi-value"><fmt:formatNumber value="${todayProfit}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></div>
                <div class="kpi-desc">Tháng này: <fmt:formatNumber value="${todayProfit * 30}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></div>
            </div>
            
            <div class="kpi-card">
                <div class="kpi-icon icon-orders"><i class="fas fa-shopping-bag"></i></div>
                <div class="kpi-title">ĐƠN HÀNG HÔM NAY</div>
                <div class="kpi-value">${todayOrders}</div>
                <div class="kpi-desc"><span class="kpi-trend up"><i class="fas fa-arrow-up"></i> 100%</span> so với hôm qua</div>
            </div>
            
            <div class="kpi-card">
                <div class="kpi-icon icon-customers"><i class="fas fa-users"></i></div>
                <div class="kpi-title">KHÁCH HÀNG</div>
                <div class="kpi-value">${totalCustomers}</div>
                <div class="kpi-desc">Tổng cộng trên hệ thống</div>
            </div>
        </div>
        
        <div class="kpi-grid" style="margin-top: 20px;">
            <div class="kpi-card">
                <div class="kpi-icon" style="background:#e0f2fe; color:#0284c7;"><i class="fas fa-book"></i></div>
                <div class="kpi-title">SỐ LƯỢNG SÁCH</div>
                <div class="kpi-value">${totalBooks}</div>
                <div class="kpi-desc">Tổng số sách trong kho</div>
            </div>
            
            <div class="kpi-card">
                <div class="kpi-icon" style="background:#fce7f3; color:#db2777;"><i class="fas fa-file-invoice"></i></div>
                <div class="kpi-title">TỔNG HÓA ĐƠN</div>
                <div class="kpi-value">${totalOrders}</div>
                <div class="kpi-desc">Tổng số hóa đơn đã bán</div>
            </div>
            
            <div class="kpi-card">
                <div class="kpi-icon" style="background:#ffedd5; color:#ea580c;"><i class="fas fa-id-badge"></i></div>
                <div class="kpi-title">NHÂN VIÊN</div>
                <div class="kpi-value">${totalEmployees}</div>
                <div class="kpi-desc">Nhân viên đang làm việc</div>
            </div>
            
            <div class="kpi-card">
                <div class="kpi-icon" style="background:#f3f4f6; color:#4b5563;"><i class="fas fa-user-shield"></i></div>
                <div class="kpi-title">TÀI KHOẢN</div>
                <div class="kpi-value">${totalAccounts}</div>
                <div class="kpi-desc">Tài khoản hệ thống</div>
            </div>
        </div>
    </c:if>

    <c:if test="${sessionScope.quyen != 'admin'}">
        <!-- NHAN VIEN DASHBOARD -->
        <div style="background: white; padding: 40px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.03); text-align: center; margin-top: 20px;">
            <i class="fas fa-cash-register" style="font-size: 64px; color: #2d6652; margin-bottom: 20px;"></i>
            <h2 style="color: #1e293b; margin-bottom: 10px;">Xin chào, ${sessionScope.username}!</h2>
            <p style="color: #64748b; font-size: 15px; margin-bottom: 30px;">Chào mừng bạn đến với hệ thống quản lý Book Store. Hãy bắt đầu ca làm việc của bạn.</p>
            
            <a href="banhang" style="display: inline-block; background: #2d6652; color: white; text-decoration: none; padding: 12px 30px; border-radius: 8px; font-weight: bold; font-size: 16px;">
                <i class="fas fa-shopping-cart"></i> Vào Bán Hàng Ngay
            </a>
        </div>
    </c:if>

</main>

</body>
</html>
