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
        
        .kpi-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 24px; margin-bottom: 30px; }
        .kpi-card { background: white; padding: 25px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; position: relative; overflow: hidden; transition: transform 0.2s, box-shadow 0.2s; display: flex; flex-direction: column; justify-content: center; }
        .kpi-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }
        .kpi-title { font-size: 12px; font-weight: 800; color: #475569; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 12px; }
        .kpi-value { font-size: 32px; font-weight: 900; color: #0f172a; margin-bottom: 12px; letter-spacing: -1px; }
        .kpi-desc { font-size: 13px; color: #64748b; font-weight: 500; }
        
        .kpi-grid:first-of-type > div:nth-child(1) { border-top: 5px solid #3b82f6; background: linear-gradient(180deg, #eff6ff 0%, #ffffff 20%); }
        .kpi-grid:first-of-type > div:nth-child(2) { border-top: 5px solid #10b981; background: linear-gradient(180deg, #ecfdf5 0%, #ffffff 20%); }
        .kpi-grid:first-of-type > div:nth-child(3) { border-top: 5px solid #f59e0b; background: linear-gradient(180deg, #fffbeb 0%, #ffffff 20%); }
        .kpi-grid:first-of-type > div:nth-child(4) { border-top: 5px solid #8b5cf6; background: linear-gradient(180deg, #f5f3ff 0%, #ffffff 20%); }

        .kpi-grid:last-of-type > div:nth-child(1) { border-top: 5px solid #06b6d4; background: linear-gradient(180deg, #ecfeff 0%, #ffffff 20%); }
        .kpi-grid:last-of-type > div:nth-child(2) { border-top: 5px solid #ec4899; background: linear-gradient(180deg, #fdf2f8 0%, #ffffff 20%); }
        .kpi-grid:last-of-type > div:nth-child(3) { border-top: 5px solid #f43f5e; background: linear-gradient(180deg, #fff1f2 0%, #ffffff 20%); }
        .kpi-grid:last-of-type > div:nth-child(4) { border-top: 5px solid #64748b; background: linear-gradient(180deg, #f8fafc 0%, #ffffff 20%); }
        
        .kpi-trend { display: inline-flex; align-items: center; gap: 4px; padding: 3px 8px; border-radius: 6px; font-weight: 700; font-size: 12px; margin-right: 5px; }
        .kpi-trend.up { background: #dcfce7; color: #166534; }
        .kpi-trend.down { background: #fee2e2; color: #991b1b; }
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
            <p class="dashboard-subtitle">Hôm nay</p>
        </div>
        <div class="dashboard-actions">
            <button>Báo cáo đầy đủ</button>
            <button>Nhật ký</button>
        </div>
    </div>

    <c:if test="${sessionScope.quyen == 'admin'}">
        <!-- ADMIN DASHBOARD -->
        <div class="kpi-grid">
            <div class="kpi-card">
                <div class="kpi-title">DOANH THU HÔM NAY</div>
                <div class="kpi-value"><fmt:formatNumber value="${todayRevenue}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></div>
                <div class="kpi-desc"><span class="kpi-trend up"> 100%</span> so với hôm qua</div>
            </div>
            
            <div class="kpi-card">
                <div class="kpi-title">LỢI NHUẬN HÔM NAY</div>
                <div class="kpi-value"><fmt:formatNumber value="${todayProfit}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></div>
                <div class="kpi-desc">Tháng này: <fmt:formatNumber value="${todayProfit * 30}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></div>
            </div>
            
            <div class="kpi-card">
                <div class="kpi-title">ĐƠN HÀNG HÔM NAY</div>
                <div class="kpi-value">${todayOrders}</div>
                <div class="kpi-desc"><span class="kpi-trend up"> 100%</span> so với hôm qua</div>
            </div>
            
            <div class="kpi-card">
                <div class="kpi-title">KHÁCH HÀNG</div>
                <div class="kpi-value">${totalCustomers}</div>
                <div class="kpi-desc">Tổng cộng trên hệ thống</div>
            </div>
        </div>
        
        <div class="kpi-grid" style="margin-top: 20px;">
            <div class="kpi-card">
                <div class="kpi-title">SỐ LƯỢNG SÁCH</div>
                <div class="kpi-value">${totalBooks}</div>
                <div class="kpi-desc">Tổng số sách trong kho</div>
            </div>
            
            <div class="kpi-card">
                <div class="kpi-title">TỔNG HÓA ĐƠN</div>
                <div class="kpi-value">${totalOrders}</div>
                <div class="kpi-desc">Tổng số hóa đơn đã bán</div>
            </div>
            
            <div class="kpi-card">
                <div class="kpi-title">NHÂN VIÊN</div>
                <div class="kpi-value">${totalEmployees}</div>
                <div class="kpi-desc">Nhân viên đang làm việc</div>
            </div>
            
            <div class="kpi-card">
                <div class="kpi-title">TÀI KHOẢN</div>
                <div class="kpi-value">${totalAccounts}</div>
                <div class="kpi-desc">Tài khoản hệ thống</div>
            </div>
        </div>
    </c:if>

    <c:if test="${sessionScope.quyen != 'admin'}">
        <!-- NHAN VIEN DASHBOARD -->
        <div style="background: white; padding: 40px; border-radius: 12px; box-shadow: 0 2px 10px rgba(0,0,0,0.03); text-align: center; margin-top: 20px;">
            <h2 style="color: #1e293b; margin-bottom: 10px;">Xin chào, ${sessionScope.username}!</h2>
            <p style="color: #64748b; font-size: 15px; margin-bottom: 30px;">Chào mừng bạn đến với hệ thống quản lý Book Store. Hãy bắt đầu ca làm việc của bạn.</p>
            
            <a href="banhang" style="display: inline-block; background: #2d6652; color: white; text-decoration: none; padding: 12px 30px; border-radius: 8px; font-weight: bold; font-size: 16px;">
                Vào Bán Hàng Ngay
            </a>
        </div>
    </c:if>

</main>

</body>
</html>
