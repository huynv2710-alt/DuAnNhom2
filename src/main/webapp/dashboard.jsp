<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tổng quan - Book Store Dashboard</title>
    <link rel="stylesheet" href="css/qlnv.css?v=2.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* Modern Premium Dashboard CSS */
        :root {
            --primary: #2d6652;
            --primary-light: #e6f0ec;
            --secondary: #0ea5e9;
            --bg-color: #f8fafc;
            --card-bg: rgba(255, 255, 255, 0.85);
            --text-main: #1e293b;
            --text-muted: #64748b;
            --border-color: rgba(255, 255, 255, 0.6);
            --shadow-sm: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
            --shadow-md: 0 10px 15px -3px rgba(0, 0, 0, 0.08), 0 4px 6px -2px rgba(0, 0, 0, 0.04);
            --shadow-lg: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
            --shadow-3d: 0 15px 35px rgba(45, 102, 82, 0.1), 0 5px 15px rgba(0,0,0,0.05);
            --radius-md: 18px;
            --radius-lg: 22px;
            --transition: all 0.45s cubic-bezier(0.16, 1, 0.3, 1);
        }

        body, .content {
            background-color: var(--bg-color) !important;
            background-image: 
                radial-gradient(circle at top right, rgba(45,102,82,0.08) 0%, transparent 40%), 
                radial-gradient(circle at bottom left, rgba(14,165,233,0.06) 0%, transparent 40%);
            background-attachment: fixed;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-main);
        }

        .dashboard-container {
            max-width: 1300px;
            margin: 0 auto;
            animation: fadeIn 0.6s ease-out;
        }
        
        .dashboard-header {
            display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 25px;
            animation: fadeInDown 0.5s ease-out;
        }
        .dashboard-title { font-size: 24px; font-weight: 800; color: var(--text-main); margin: 0 0 5px 0; }
        .dashboard-subtitle { font-size: 14px; color: var(--text-muted); margin: 0; display: flex; align-items: center; gap: 8px; }
        
        .clock-container {
            background: var(--card-bg); padding: 10px 20px; border-radius: var(--radius-md);
            box-shadow: var(--shadow-sm); font-weight: 700; color: var(--primary);
            display: flex; align-items: center; gap: 10px; border: 1px solid var(--border-color);
        }

        .kpi-grid { 
            display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 22px; margin-bottom: 30px; 
            perspective: 1200px;
            position: relative;
            z-index: 20;
            animation: fadeInUp 0.6s ease-out;
        }
        .kpi-card { 
            padding: 28px; border-radius: var(--radius-md); 
            position: relative; overflow: visible;
            display: flex; flex-direction: column; justify-content: space-between;
            
            /* 3D Light Glassmorphism */
            background: linear-gradient(145deg, rgba(255, 255, 255, 0.95), rgba(248, 250, 252, 0.8));
            backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 1);
            
            /* 3D Depth Shadow */
            box-shadow: 
                0 15px 35px -10px rgba(0, 0, 0, 0.08),
                0 5px 15px rgba(0, 0, 0, 0.03),
                inset 0 1px 0 rgba(255, 255, 255, 1),
                inset 0 -1px 0 rgba(0, 0, 0, 0.02);
            
            /* 3D Transform */
            transform: perspective(1000px) rotateX(0deg) rotateY(0deg) translateZ(0);
            transition: 
                transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1),
                box-shadow 0.5s ease,
                border-color 0.3s ease;
        }

        .kpi-card:hover { 
            transform: perspective(1000px) rotateX(-3deg) rotateY(3deg) translateZ(15px) translateY(-6px); 
            box-shadow: 
                0 25px 50px -12px rgba(0, 0, 0, 0.15),
                0 10px 20px rgba(0, 0, 0, 0.05),
                inset 0 1px 0 rgba(255, 255, 255, 1);
            border-color: rgba(255, 255, 255, 1);
        }

        .kpi-title { font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 1.5px; margin-bottom: 14px; position: relative; z-index: 1; }
        .kpi-value { font-size: 30px; font-weight: 900; color: var(--text-main); margin-bottom: 5px; letter-spacing: -0.5px; position: relative; z-index: 1; text-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        .kpi-icon { 
            position: absolute; top: 25px; right: 25px; width: 50px; height: 50px; border-radius: 14px; 
            display: flex; align-items: center; justify-content: center; font-size: 22px; 
            z-index: 1;
            /* 3D icon shadow */
            box-shadow: 
                0 4px 12px rgba(0,0,0,0.1),
                inset 0 1px 1px rgba(255,255,255,0.6),
                inset 0 -1px 1px rgba(0,0,0,0.05);
            transform: perspective(500px) rotateY(0deg);
            transition: all 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        .kpi-card:hover .kpi-icon { 
            transform: perspective(500px) rotateY(15deg) scale(1.12); 
            box-shadow: 
                0 8px 20px rgba(0,0,0,0.15),
                inset 0 1px 1px rgba(255,255,255,0.8);
        }
        
        /* Grid cho biểu đồ và danh sách */
        .dashboard-row { 
            display: grid; grid-template-columns: 2fr 1fr; gap: 22px; margin-bottom: 28px; 
            perspective: 1000px;
            position: relative;
            z-index: 10;
            animation: fadeInUp 0.8s ease-out; 
        }
        .dashboard-row.equal { grid-template-columns: 1fr 1fr; }
        
        .panel { 
            border-radius: var(--radius-lg); 
            display: flex; flex-direction: column; overflow: hidden;
            
            /* 3D Glass Panel */
            background: linear-gradient(160deg, rgba(255, 255, 255, 0.95), rgba(248, 250, 252, 0.85));
            backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 1);
            box-shadow: 
                0 15px 35px -10px rgba(0, 0, 0, 0.08),
                0 5px 15px rgba(0, 0, 0, 0.03),
                inset 0 1px 0 rgba(255, 255, 255, 1);
            
            transform: perspective(1000px) translateZ(0);
            transition: var(--transition);
        }
        .panel:hover { 
            transform: perspective(1000px) translateZ(10px) translateY(-4px); 
            box-shadow: 
                0 25px 50px -12px rgba(0, 0, 0, 0.12),
                0 10px 20px rgba(0, 0, 0, 0.05),
                inset 0 1px 0 rgba(255, 255, 255, 1);
            border-color: rgba(255, 255, 255, 1);
        }
        .panel-header { padding: 20px 25px; border-bottom: 1px solid rgba(226, 232, 240, 0.6); display: flex; justify-content: space-between; align-items: center; background: rgba(255, 255, 255, 0.4); }
        .panel-title { font-size: 16px; font-weight: 800; color: var(--text-main); margin: 0; display: flex; align-items: center; gap: 10px; }
        .panel-body { padding: 25px; flex: 1; overflow-y: auto; max-height: 420px; }
        
        /* Danh sách Item Premium */
        .list-item { 
            display: flex; justify-content: space-between; align-items: center; padding: 15px; 
            background: rgba(255, 255, 255, 0.6); 
            border: 1px solid rgba(255, 255, 255, 0.8); 
            border-radius: 14px; margin-bottom: 12px; 
            transition: var(--transition);
            transform: perspective(600px) translateZ(0);
        }
        .list-item:hover { 
            background: #ffffff; 
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.06); 
            border-color: #ffffff; 
            transform: perspective(600px) translateZ(8px) translateX(4px); 
        }
        .list-item:last-child { margin-bottom: 0; }
        .item-info { display: flex; align-items: center; gap: 15px; }
        .item-img { width: 45px; height: 45px; border-radius: 10px; object-fit: cover; background: #f1f5f9; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .item-name { font-size: 14px; font-weight: 700; color: var(--text-main); margin-bottom: 4px; }
        .item-sub { font-size: 12px; color: var(--text-muted); font-weight: 500; }
        .item-badge { font-size: 12px; font-weight: 800; padding: 6px 12px; border-radius: 20px; box-shadow: inset 0 1px 2px rgba(255,255,255,0.5); }
        .badge-red { background: linear-gradient(135deg, #fee2e2, #fecaca); color: #dc2626; border: 1px solid #fca5a5; }
        .badge-green { background: linear-gradient(135deg, #dcfce7, #bbf7d0); color: #059669; border: 1px solid #86efac; }
        .badge-blue { background: linear-gradient(135deg, #e0f2fe, #bae6fd); color: #0284c7; border: 1px solid #7dd3fc; }
        .badge-yellow { background: linear-gradient(135deg, #fef3c7, #fde68a); color: #d97706; border: 1px solid #fcd34d; }

        /* Empty State */
        .empty-state { display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 40px 20px; color: #94a3b8; }
        .empty-state i { font-size: 40px; color: #cbd5e1; margin-bottom: 15px; }
        .empty-state p { font-size: 14px; font-weight: 600; margin: 0; }

        /* Premium Tag */
        .premium-tag {
            background: linear-gradient(135deg, #ffffff, #f8fafc);
            padding: 8px 16px; border-radius: 20px; font-size: 13px; font-weight: 700; color: #334155; 
            border: 1px solid #e2e8f0; display: inline-flex; align-items: center; gap: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02); transition: var(--transition); cursor: default;
        }
        .premium-tag:hover { transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0,0,0,0.04); border-color: #cbd5e1; }
        .premium-tag span.val { font-weight: 800; }

        /* Premium Custom Dropdown */
        .custom-dropdown { position: relative; width: 100%; margin-top: 15px; }
        .dropdown-selected {
            padding: 12px 16px; background: rgba(255, 255, 255, 0.8); border: 1px solid rgba(45, 102, 82, 0.2); border-radius: 10px;
            color: #2d6652; font-weight: 700; font-size: 14px; display: flex; justify-content: space-between; align-items: center; cursor: pointer; transition: 0.3s;
            box-shadow: inset 0 1px 2px rgba(255,255,255,0.8), 0 2px 4px rgba(0,0,0,0.02);
        }
        .dropdown-selected:hover { border-color: #2d6652; background: #ffffff; box-shadow: 0 4px 12px rgba(45, 102, 82, 0.1); transform: translateY(-1px); }
        .dropdown-selected i { transition: transform 0.3s; }
        .custom-dropdown.active .dropdown-selected i { transform: rotate(180deg); }
        
        .dropdown-options {
            position: absolute; top: calc(100% + 8px); left: 0; right: 0; background: rgba(255, 255, 255, 0.95); 
            backdrop-filter: blur(12px); border: 1px solid var(--border-color);
            border-radius: 12px; box-shadow: var(--shadow-lg); z-index: 100;
            display: none; flex-direction: column; overflow: hidden; padding: 8px;
        }
        .custom-dropdown.active .dropdown-options { display: flex; animation: slideDown 0.3s cubic-bezier(0.16, 1, 0.3, 1); }
        .dropdown-options div {
            padding: 10px 14px; font-size: 14px; font-weight: 600; color: #475569; cursor: pointer; transition: 0.2s;
            border-radius: 8px; display: flex; align-items: center; gap: 10px; margin-bottom: 2px;
        }
        .dropdown-options div:last-child { margin-bottom: 0; }
        .dropdown-options div:hover { background: #e6f0ec; color: #2d6652; transform: translateX(4px); }
        .dropdown-options div i { width: 16px; text-align: center; opacity: 0.7; }

        /* Small Inline Filter Dropdown for Panel Headers */
        .filter-dropdown {
            position: relative;
            display: inline-block;
        }
        .filter-dropdown .filter-btn {
            background: rgba(255, 255, 255, 0.6);
            border: 1px solid rgba(245, 158, 11, 0.3);
            border-radius: 8px;
            padding: 6px 12px;
            font-size: 13px;
            font-weight: 700;
            color: #b45309; /* Yellow/Orange matching the trophy */
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: var(--transition);
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        }
        .filter-dropdown .filter-btn:hover {
            background: #ffffff;
            box-shadow: 0 4px 8px rgba(245, 158, 11, 0.15);
            border-color: rgba(245, 158, 11, 0.5);
            transform: translateY(-1px);
        }
        .filter-dropdown .filter-menu {
            position: absolute;
            top: 100%;
            right: 0;
            margin-top: 8px;
            min-width: 130px;
            background: rgba(255, 255, 255, 0.98);
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            box-shadow: var(--shadow-lg);
            backdrop-filter: blur(10px);
            display: none;
            flex-direction: column;
            padding: 6px;
            z-index: 100;
        }
        .filter-dropdown.active .filter-menu { display: flex; animation: slideDown 0.2s ease-out; }
        .filter-dropdown .filter-menu div {
            padding: 8px 12px;
            font-size: 13px;
            font-weight: 600;
            color: #475569;
            cursor: pointer;
            border-radius: 6px;
            transition: 0.2s;
        }
        .filter-dropdown .filter-menu div:hover {
            background: #fef3c7; /* light yellow bg */
            color: #d97706; /* dark yellow/orange text */
        }

        /* Animations */
        @keyframes slideDown { from { opacity: 0; transform: translateY(-10px) scale(0.98); } to { opacity: 1; transform: translateY(0) scale(1); } }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes fadeInDown { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes fadeInUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        
        /* Loading Overlay */
        #loader { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: white; z-index: 9999; display: flex; justify-content: center; align-items: center; flex-direction: column; }
        .spinner { width: 50px; height: 50px; border: 4px solid var(--border-color); border-top-color: var(--primary); border-radius: 50%; animation: spin 1s linear infinite; }
        @keyframes spin { to { transform: rotate(360deg); } }
    </style>
</head>
<body>

<div id="loader">
    <div class="spinner"></div>
    <h3 style="color: #2d6652; margin-top: 20px;">Đang tải dữ liệu...</h3>
</div>
<jsp:include page="menu.jsp"/>

<main class="content" style="opacity: 0; transition: opacity 0.5s ease;" id="mainContent">

        <div class="dashboard-header" style="margin-bottom: 20px;">
            <div>
                <h1 class="dashboard-title">Thống Kê Doanh Thu</h1>
                <p class="dashboard-subtitle">
                    <i class="fas fa-calendar-alt"></i> Dữ liệu thống kê theo thời gian thực
                </p>
                <div class="clock-container" style="display:inline-flex; margin-top:10px; font-size:14px; padding: 5px 12px; background: white; border-radius: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
                    <i class="far fa-clock" style="color: #2d6652;"></i> <span id="clock" style="color: #2d6652; font-weight: bold;">00:00:00</span>
                </div>
            </div>
            
            <form id="filterForm" action="dashboard" method="get" style="display:flex; gap:10px; align-items:flex-end;">
                <div>
                    <label style="font-size:12px; font-weight:bold; color:#64748b; margin-bottom:4px; display:block;">Từ ngày</label>
                    <input type="date" name="fromDate" value="${param.fromDate}" style="padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; outline:none; font-family: inherit;">
                </div>
                <div>
                    <label style="font-size:12px; font-weight:bold; color:#64748b; margin-bottom:4px; display:block;">Đến ngày</label>
                    <input type="date" name="toDate" value="${param.toDate}" style="padding:8px 12px; border:1px solid #cbd5e1; border-radius:6px; outline:none; font-family: inherit;">
                </div>
                <button type="submit" style="padding:8px 16px; background:#2d6652; color:white; border:none; border-radius:6px; cursor:pointer; font-weight:bold; height:36px; transition: 0.3s;"><i class="fas fa-filter"></i> Xem thống kê</button>
                <button type="button" onclick="submitExport()" style="padding:8px 16px; background:#10b981; color:white; border:none; border-radius:6px; cursor:pointer; font-weight:bold; height:36px; transition: 0.3s;"><i class="fas fa-file-excel"></i> Xuất Excel</button>
            </form>
            <script>
                function submitExport() {
                    let form = document.getElementById('filterForm');
                    let oldAction = form.action;
                    form.action = 'exportExcel';
                    form.submit();
                    // Revert back so normal submit still works
                    setTimeout(() => form.action = oldAction, 100);
                }
            </script>
        </div> 

    <c:if test="${sessionScope.quyen == 'admin'}">
        <!-- TỔNG QUAN HỆ THỐNG -->
        <h3 style="margin-bottom: 15px; color: #334155; font-size: 16px;"><i class="fas fa-chart-pie" style="color:#2d6652;"></i> Báo cáo tổng quan</h3>
        <div class="kpi-grid">
            <!-- Card Doanh Thu -->
            <div class="kpi-card" style="border-top: 4px solid #2d6652;">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px;">
                    <div>
                        <div class="kpi-title" style="color:#2d6652;">TỔNG DOANH THU</div>
                        <div class="kpi-value" id="revenue-val"><fmt:formatNumber value="${todayRevenue}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></div>
                    </div>
                    <div class="kpi-icon" style="background:#e6f0ec; color:#2d6652; position:relative; top:0; right:0;"><i class="fas fa-coins"></i></div>
                </div>
                <div class="custom-dropdown" id="dropdown-revenue">
                    <div class="dropdown-selected" onclick="toggleDropdown('dropdown-revenue')">
                        <span id="lbl-revenue"><i class="fas fa-calendar-day" style="margin-right: 8px; opacity: 0.7;"></i>Hôm nay</span> 
                        <i class="fas fa-chevron-down" style="font-size: 12px; opacity: 0.7;"></i>
                    </div>
                    <div class="dropdown-options">
                        <div onclick="selectOption('dropdown-revenue', 'today', '<i class=\'fas fa-calendar-day\' style=\'margin-right: 8px; opacity: 0.7;\'></i>Hôm nay', updateRevenue)"><i class="fas fa-calendar-day"></i> Hôm nay</div>
                        <div onclick="selectOption('dropdown-revenue', 'week', '<i class=\'fas fa-calendar-week\' style=\'margin-right: 8px; opacity: 0.7;\'></i>Tuần này', updateRevenue)"><i class="fas fa-calendar-week"></i> Tuần này</div>
                        <div onclick="selectOption('dropdown-revenue', 'month', '<i class=\'fas fa-calendar-alt\' style=\'margin-right: 8px; opacity: 0.7;\'></i>Tháng này', updateRevenue)"><i class="fas fa-calendar-alt"></i> Tháng này</div>
                        <div onclick="selectOption('dropdown-revenue', 'year', '<i class=\'fas fa-calendar\' style=\'margin-right: 8px; opacity: 0.7;\'></i>Năm nay', updateRevenue)"><i class="fas fa-calendar"></i> Năm nay</div>
                        <div onclick="selectOption('dropdown-revenue', 'all', '<i class=\'fas fa-list-ul\' style=\'margin-right: 8px; opacity: 0.7;\'></i>Tất cả', updateRevenue)"><i class="fas fa-list-ul"></i> Tất cả</div>
                    </div>
                </div>
            </div>

            <!-- Card Đơn Hàng -->
            <div class="kpi-card" style="border-top: 4px solid #0369a1;">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px;">
                    <div>
                        <div class="kpi-title" style="color:#0369a1;">ĐƠN HÀNG</div>
                        <div class="kpi-value" id="orders-val">${todayOrders}</div>
                        <div class="kpi-title" style="margin-top:5px; font-size:11px; opacity: 0.8;">Tổng hệ thống: ${totalOrders} đơn</div>
                    </div>
                    <div class="kpi-icon" style="background:#e0f2fe; color:#0369a1; position:relative; top:0; right:0;"><i class="fas fa-shopping-bag"></i></div>
                </div>
                <div class="custom-dropdown" id="dropdown-orders">
                    <div class="dropdown-selected" onclick="toggleDropdown('dropdown-orders')" style="border-color: rgba(3, 105, 161, 0.2); color: #0369a1;">
                        <span id="lbl-orders"><i class="fas fa-clock" style="margin-right: 8px; opacity: 0.7;"></i>Hôm nay</span> 
                        <i class="fas fa-chevron-down" style="font-size: 12px; opacity: 0.7;"></i>
                    </div>
                    <div class="dropdown-options">
                        <div onclick="selectOption('dropdown-orders', 'today', '<i class=\'fas fa-clock\' style=\'margin-right: 8px; opacity: 0.7;\'></i>Hôm nay', updateOrders)"><i class="fas fa-clock"></i> Hôm nay</div>
                        <div onclick="selectOption('dropdown-orders', 'all', '<i class=\'fas fa-list-ul\' style=\'margin-right: 8px; opacity: 0.7;\'></i>Tất cả', updateOrders)"><i class="fas fa-list-ul"></i> Tất cả</div>
                    </div>
                </div>
            </div>

            <!-- Card Sách & Tồn Kho -->
            <div class="kpi-card" style="border-top: 4px solid #b45309;">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px;">
                    <div>
                        <div class="kpi-title" style="color:#b45309;">KHO SÁCH</div>
                        <div class="kpi-value">${totalBooks} <span style="font-size:16px; color:#64748b; font-weight:600;">cuốn</span></div>
                        <div class="kpi-title" style="margin-top:5px; font-size:11px; color:#ef4444; opacity: 0.9;">Sắp hết hàng: ${lowStock} quyển</div>
                    </div>
                    <div class="kpi-icon" style="background:#fef3c7; color:#b45309; position:relative; top:0; right:0;"><i class="fas fa-book"></i></div>
                </div>
                <div style="width: 100%; padding: 10px 14px; border: 1px solid rgba(180, 83, 9, 0.2); border-radius: 10px; background: rgba(254, 243, 199, 0.3); color: #b45309; font-size: 13px; font-weight: 600; text-align: center; margin-top: 15px; display: flex; justify-content: center; align-items: center; gap: 8px;"><i class="fas fa-sync fa-spin" style="animation-duration: 3s;"></i> Tự động cập nhật</div>
            </div>

            <!-- Card Khách Hàng & Nhân Sự -->
            <div class="kpi-card" style="border-top: 4px solid #6d28d9;">
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 15px;">
                    <div>
                        <div class="kpi-title" style="color:#6d28d9;">TỔNG KHÁCH HÀNG</div>
                        <div class="kpi-value">${totalCustomers} <span style="font-size:16px; color:#64748b; font-weight:600;">người</span></div>
                        <div class="kpi-title" style="margin-top:5px; font-size:11px; opacity: 0.8;">Nhân sự: ${totalEmployees} người</div>
                    </div>
                    <div class="kpi-icon" style="background:#ede9fe; color:#6d28d9; position:relative; top:0; right:0;"><i class="fas fa-users"></i></div>
                </div>
                <div style="width: 100%; padding: 10px 14px; border: 1px solid rgba(109, 40, 217, 0.2); border-radius: 10px; background: rgba(237, 233, 254, 0.3); color: #6d28d9; font-size: 13px; font-weight: 600; text-align: center; margin-top: 15px; display: flex; justify-content: center; align-items: center; gap: 8px;"><i class="fas fa-database"></i> Dữ liệu hệ thống</div>
            </div>
        </div>

        <!-- BIỂU ĐỒ -->
        <div class="dashboard-row equal">
            <div class="panel">
                <div class="panel-header">
                    <h3 class="panel-title"><i class="fas fa-chart-area" style="color:#2d6652;"></i> Biểu đồ Doanh Thu 7 Ngày Gần Nhất</h3>
                </div>
                <div class="panel-body">
                    <canvas id="revenueByDayChart"></canvas>
                </div>
            </div>
            <div class="panel">
                <div class="panel-header">
                    <h3 class="panel-title"><i class="fas fa-chart-bar" style="color:#2d6652;"></i> Biểu đồ Doanh Thu Theo Tháng (Năm Nay)</h3>
                </div>
                <div class="panel-body">
                    <canvas id="revenueByMonthChart"></canvas>
                </div>
            </div>
        </div>

        <!-- TOP LISTS -->
        <div class="dashboard-row">
            <!-- Top Sách Bán Chạy -->
            <div class="panel">
                <div class="panel-header">
                    <h3 class="panel-title"><i class="fas fa-trophy" style="color:#f59e0b;"></i> Top 5 Sách Bán Chạy Nhất</h3>
                    <div class="filter-dropdown" id="dropdown-top-books">
                        <div class="filter-btn" onclick="toggleDropdown('dropdown-top-books')">
                            <span id="lbl-top-books">
                                <c:choose>
                                    <c:when test="${topBooksFilter == 'today'}">Hôm nay</c:when>
                                    <c:when test="${topBooksFilter == 'week'}">Tuần này</c:when>
                                    <c:when test="${topBooksFilter == 'month'}">Tháng này</c:when>
                                    <c:when test="${topBooksFilter == 'year'}">Năm nay</c:when>
                                    <c:otherwise>Tất cả</c:otherwise>
                                </c:choose>
                            </span> 
                            <i class="fas fa-chevron-down" style="font-size: 10px;"></i>
                        </div>
                        <div class="filter-menu">
                            <div onclick="filterTopBooks('today')">Hôm nay</div>
                            <div onclick="filterTopBooks('week')">Tuần này</div>
                            <div onclick="filterTopBooks('month')">Tháng này</div>
                            <div onclick="filterTopBooks('year')">Năm nay</div>
                            <div onclick="filterTopBooks('all')">Tất cả</div>
                        </div>
                    </div>
                </div>
                <div class="panel-body">
                    <c:forEach var="book" items="${topBooks}">
                        <div class="list-item">
                            <div class="item-info">
                                <c:choose>
                                    <c:when test="${not empty book[2] && book[2] != 'null'}">
                                        <img src="${book[2]}" class="item-img">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="item-img" style="display:flex; align-items:center; justify-content:center; font-size:16px; color:#94a3b8;"><i class="fas fa-book"></i></div>
                                    </c:otherwise>
                                </c:choose>
                                <div>
                                    <div class="item-name">${book[0]}</div>
                                    <div class="item-sub"><i class="fas fa-fire" style="color: #ef4444;"></i> Sản phẩm nổi bật</div>
                                </div>
                            </div>
                            <div class="item-badge badge-green">Đã bán: ${book[1]}</div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty topBooks}">
                        <div class="empty-state">
                            <i class="fas fa-box-open"></i>
                            <p>Chưa có dữ liệu sách bán chạy</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Sách Sắp Hết Hàng -->
            <div class="panel">
                <div class="panel-header">
                    <h3 class="panel-title"><i class="fas fa-exclamation-triangle" style="color:#ef4444;"></i> Sách Sắp Hết Hàng (<= 5)</h3>
                </div>
                <div class="panel-body">
                    <c:forEach var="book" items="${lowStockList}">
                        <div class="list-item">
                            <div class="item-info">
                                <div class="item-img" style="display:flex; align-items:center; justify-content:center; font-size:16px; color:#ef4444; background: #fee2e2;"><i class="fas fa-exclamation-circle"></i></div>
                                <div>
                                    <div class="item-name">${book[0]}</div>
                                    <div class="item-sub">Cần nhập thêm hàng</div>
                                </div>
                            </div>
                            <div class="item-badge badge-red">Còn: ${book[1]}</div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty lowStockList}">
                        <div class="empty-state">
                            <i class="fas fa-check-circle" style="color: #10b981;"></i>
                            <p style="color: #10b981;">Kho hàng đầy đủ</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
        
        <div class="dashboard-row equal">
            <!-- Hoạt động gần đây (Đơn hàng) -->
            <div class="panel">
                <div class="panel-header">
                    <h3 class="panel-title"><i class="fas fa-history" style="color:#6366f1;"></i> Hóa Đơn Mới Gần Đây</h3>
                </div>
                <div class="panel-body">
                    <c:forEach var="order" items="${recentOrders}">
                        <div class="list-item">
                            <div class="item-info">
                                <div style="width: 45px; height: 45px; border-radius: 12px; background: linear-gradient(135deg, #e0e7ff, #c7d2fe); color: #4f46e5; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 16px; box-shadow: 0 2px 5px rgba(0,0,0,0.05);">
                                    <i class="fas fa-receipt"></i>
                                </div>
                                <div>
                                    <div class="item-name">Hóa đơn #${order[0]}</div>
                                    <div class="item-sub"><i class="fas fa-user" style="opacity:0.7;"></i> ${order[1]} &nbsp;&bull;&nbsp; <i class="far fa-clock" style="opacity:0.7;"></i> ${order[3]}</div>
                                </div>
                            </div>
                            <div class="item-badge badge-blue">
                                <fmt:formatNumber value="${order[2]}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty recentOrders}">
                        <div class="empty-state">
                            <i class="fas fa-receipt"></i>
                            <p>Chưa có hóa đơn nào</p>
                        </div>
                    </c:if>
                </div>
            </div>

            <!-- Top Nhân Viên & Thể Loại -->
            <div class="panel">
                <div class="panel-header">
                    <h3 class="panel-title"><i class="fas fa-medal" style="color:#8b5cf6;"></i> Top Hiệu Suất</h3>
                </div>
                <div class="panel-body">
                    <h4 style="margin: 0 0 15px 0; color: #64748b; font-size: 12px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.5px;"><i class="fas fa-crown" style="color: #f59e0b; margin-right: 5px;"></i> Top Nhân Viên Bán Hàng</h4>
                    <c:forEach var="emp" items="${topEmployees}">
                        <div class="list-item" style="padding: 10px 15px; margin-bottom: 8px;">
                            <div class="item-info">
                                <div class="item-img" style="width: 35px; height: 35px; border-radius: 50%; background: linear-gradient(135deg, #fef3c7, #fde68a); color: #d97706; display: flex; align-items: center; justify-content: center;"><i class="fas fa-user-tie"></i></div>
                                <div><div class="item-name" style="margin: 0;">${emp[0]}</div></div>
                            </div>
                            <div class="item-badge badge-yellow">
                                <fmt:formatNumber value="${emp[1]}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty topEmployees}"><div class="empty-state" style="padding: 20px;"><p>Chưa có dữ liệu</p></div></c:if>
                    
                    <h4 style="margin: 25px 0 15px 0; color: #64748b; font-size: 12px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.5px;"><i class="fas fa-chart-pie" style="color: #0ea5e9; margin-right: 5px;"></i> Phân Bổ Thể Loại Bán Chạy</h4>
                    <c:if test="${not empty topCategories}">
                        <c:set var="maxCat" value="${topCategories[0][1]}" />
                        <div style="display: flex; flex-direction: column; gap: 15px;">
                            <c:forEach var="cat" items="${topCategories}">
                                <div>
                                    <div style="display: flex; justify-content: space-between; font-size: 13px; font-weight: 700; color: #334155; margin-bottom: 6px;">
                                        <span>${cat[0]}</span>
                                        <span style="color: #0ea5e9;">${cat[1]} cuốn</span>
                                    </div>
                                    <div style="width: 100%; height: 8px; background: #f1f5f9; border-radius: 4px; overflow: hidden; box-shadow: inset 0 1px 2px rgba(0,0,0,0.05);">
                                        <div style="width: ${(cat[1] * 100.0) / maxCat}%; height: 100%; background: linear-gradient(90deg, #38bdf8, #0284c7); border-radius: 4px; transition: width 1s ease-in-out;"></div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                    <c:if test="${empty topCategories}"><div class="empty-state" style="padding: 20px;"><p>Chưa có dữ liệu</p></div></c:if>
                </div>
            </div>
        </div>
    </c:if>

    <c:if test="${sessionScope.quyen != 'admin'}">
        <!-- NHAN VIEN DASHBOARD -->
        <div style="background: white; padding: 50px; border-radius: 16px; box-shadow: var(--shadow-lg); text-align: center; margin-top: 40px; animation: fadeInUp 0.5s ease-out;">
            <div style="width: 100px; height: 100px; background: #e0f2fe; color: #0ea5e9; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 40px; margin: 0 auto 20px auto;">
                <i class="fas fa-user-tie"></i>
            </div>
            <h2 style="color: #1e293b; margin-bottom: 10px; font-size: 28px;">Xin chào, ${sessionScope.username}!</h2>
            <p style="color: #64748b; font-size: 16px; margin-bottom: 30px; max-width: 500px; margin-left: auto; margin-right: auto;">
                Chúc bạn một ngày làm việc hiệu quả. Hãy kiểm tra các đơn hàng và phục vụ khách hàng chu đáo nhé!
            </p>
            
            <div style="display: flex; gap: 15px; justify-content: center;">
                <a href="banhang" style="display: inline-flex; align-items: center; gap: 8px; background: var(--primary); color: white; text-decoration: none; padding: 12px 30px; border-radius: 8px; font-weight: bold; font-size: 16px; transition: var(--transition); box-shadow: var(--shadow-md);">
                    <i class="fas fa-shopping-cart"></i> Màn hình Bán Hàng (POS)
                </a>
                <a href="quanlyhoadon" style="display: inline-flex; align-items: center; gap: 8px; background: white; color: var(--text-main); border: 1px solid var(--border-color); text-decoration: none; padding: 12px 30px; border-radius: 8px; font-weight: bold; font-size: 16px; transition: var(--transition); box-shadow: var(--shadow-sm);">
                    <i class="fas fa-file-invoice"></i> Lịch sử Hóa đơn
                </a>
            </div>
        </div>
    </c:if>

</main>

<script>
    // Dropdown Logic
    function toggleDropdown(id) {
        // Đóng các dropdown khác
        document.querySelectorAll('.custom-dropdown, .filter-dropdown').forEach(d => {
            if (d.id !== id) d.classList.remove('active');
        });
        document.getElementById(id).classList.toggle('active');
    }

    function selectOption(dropdownId, value, label, callback) {
        document.getElementById(dropdownId).classList.remove('active');
        // Update label
        if (dropdownId === 'dropdown-revenue') document.getElementById('lbl-revenue').innerHTML = label;
        if (dropdownId === 'dropdown-orders') document.getElementById('lbl-orders').innerHTML = label;
        // Call function
        callback(value);
    }

    // Đóng dropdown khi click ra ngoài
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.custom-dropdown') && !e.target.closest('.filter-dropdown')) {
            document.querySelectorAll('.custom-dropdown, .filter-dropdown').forEach(d => d.classList.remove('active'));
        }
    });

    // Xử lý Loading Screen & Hiển thị Main Content
    window.onload = function() {
        document.getElementById('loader').style.display = 'none';
        document.getElementById('mainContent').style.opacity = '1';
        
        // Khởi tạo đồng hồ
        initClock();
        
        // Khởi tạo Chart.js (Chỉ nếu là admin)
        <c:if test="${sessionScope.quyen == 'admin'}">
            initCharts();
        </c:if>
    };

    function initClock() {
        const timeEl = document.getElementById('clock');
        const dateEl = document.getElementById('currentDate');
        
        const days = ['Chủ nhật', 'Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];
        
        setInterval(() => {
            const now = new Date();
            const h = String(now.getHours()).padStart(2, '0');
            const m = String(now.getMinutes()).padStart(2, '0');
            const s = String(now.getSeconds()).padStart(2, '0');
            timeEl.innerText = h + ':' + m + ':' + s;
            
            if (now.getSeconds() === 0 || dateEl.innerText.includes('Đang cập nhật')) {
                const dayName = days[now.getDay()];
                const d = String(now.getDate()).padStart(2, '0');
                const month = String(now.getMonth() + 1).padStart(2, '0');
                const y = now.getFullYear();
                dateEl.innerHTML = '<i class="far fa-calendar-alt"></i> ' + dayName + ', ' + d + '/' + month + '/' + y;
            }
        }, 1000);
    }

    <c:if test="${sessionScope.quyen == 'admin'}">
    // Biến lưu trữ dữ liệu doanh thu
    const revData = {
        today: ${todayRevenue},
        week: ${weeklyRevenue},
        month: ${monthlyRevenue},
        year: ${yearlyRevenue},
        all: ${totalRevenue}
    };
    
    // Biến lưu trữ dữ liệu đơn hàng
    const orderData = {
        today: ${todayOrders},
        all: ${totalOrders}
    };

    function formatCurrency(amount) {
        return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
    }

    function updateRevenue(timeframe) {
        const revVal = revData[timeframe] || 0;
        document.getElementById('revenue-val').innerText = formatCurrency(revVal);
    }

    function updateOrders(timeframe) {
        const oVal = orderData[timeframe] || 0;
        document.getElementById('orders-val').innerText = oVal + ' \u0111\u01A1n';
    }

    function initCharts() {
        // Dữ liệu từ Server
        let daysData = [];
        let revDaysData = [];
        <c:forEach var="item" items="${revenueByDay}">
            // Note: Data is ordered by Ngay DESC, so we need to reverse it or handle it.
            // Better to push to front to have chronological order
            daysData.unshift('${item[0]}');
            revDaysData.unshift(${item[1]});
        </c:forEach>

        let monthsData = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];
        let revMonthsData = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        <c:forEach var="item" items="${revenueByMonth}">
            var monthIndex = ${item[0]} - 1;
            if(monthIndex >= 0 && monthIndex < 12) {
                revMonthsData[monthIndex] = ${item[1]};
            }
        </c:forEach>


        // Chart 1: Doanh thu 7 ngày qua (Line Chart with gradient)
        const ctxDay = document.getElementById('revenueByDayChart');
        if (ctxDay) {
            const ctxD = ctxDay.getContext('2d');
            let gradientDay = ctxD.createLinearGradient(0, 0, 0, 400);
            gradientDay.addColorStop(0, 'rgba(45, 102, 82, 0.5)'); // Theme primary: 2d6652
            gradientDay.addColorStop(1, 'rgba(45, 102, 82, 0.0)');

            new Chart(ctxD, {
                type: 'line',
                data: {
                    labels: daysData.length > 0 ? daysData : ['Chưa có dữ liệu'],
                    datasets: [{
                        label: 'Doanh thu (VNĐ)',
                        data: revDaysData.length > 0 ? revDaysData : [0],
                        borderColor: '#2d6652',
                        backgroundColor: gradientDay,
                        borderWidth: 3,
                        pointBackgroundColor: '#ffffff',
                        pointBorderColor: '#2d6652',
                        pointBorderWidth: 2,
                        pointRadius: 4,
                        pointHoverRadius: 6,
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: { beginAtZero: true, grid: { borderDash: [5, 5] } },
                        x: { grid: { display: false } }
                    }
                }
            });
        }

        // Chart 2: Doanh thu theo tháng (Bar Chart)
        const ctxMonth = document.getElementById('revenueByMonthChart');
        if (ctxMonth) {
            const ctxM = ctxMonth.getContext('2d');
            new Chart(ctxM, {
                type: 'bar',
                data: {
                    labels: monthsData.length > 0 ? monthsData : ['Chưa có dữ liệu'],
                    datasets: [{
                        label: 'Doanh thu (VNĐ)',
                        data: revMonthsData.length > 0 ? revMonthsData : [0],
                        backgroundColor: '#2d6652',
                        borderRadius: 6,
                        barPercentage: 0.6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: { beginAtZero: true, grid: { borderDash: [5, 5] } },
                        x: { grid: { display: false } }
                    }
                }
            });
        }
    }
    </c:if>

    function filterTopBooks(filterValue) {
        window.location.href = 'dashboard?topBooksFilter=' + filterValue;
    }
</script>

</body>
</html>
