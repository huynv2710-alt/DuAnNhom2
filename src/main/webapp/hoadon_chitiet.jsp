<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Hóa Đơn</title>
    <link rel="stylesheet" href="css/qlnv.css?v=2.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .receipt-card {
            background: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            max-width: 800px;
            margin: 0 auto;
        }
        .receipt-header {
            display: flex;
            justify-content: space-between;
            border-bottom: 2px solid #f1f5f9;
            padding-bottom: 25px;
            margin-bottom: 25px;
        }
        .store-info { flex: 1; }
        .store-logo { font-size: 24px; font-weight: 800; color: #0f2820; display: flex; align-items: center; gap: 10px; margin-bottom: 10px; }
        .store-logo i { color: #2d6652; }
        .store-details { color: #64748b; font-size: 14px; line-height: 1.6; }
        .invoice-info { flex: 1; text-align: right; }
        .invoice-title { font-size: 20px; font-weight: 800; color: #0f2820; margin-bottom: 10px; letter-spacing: 1px; }
        .invoice-meta { color: #64748b; font-size: 14px; line-height: 1.6; }
        
        .parties-section {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
        }
        .party-box { flex: 1; }
        .party-box:last-child { border-left: 2px solid #f1f5f9; padding-left: 40px; }
        .party-heading { font-size: 12px; font-weight: 700; color: #64748b; margin-bottom: 10px; letter-spacing: 0.5px; }
        .party-name { font-size: 16px; font-weight: 700; color: #1e293b; margin-bottom: 5px; }
        .party-detail { font-size: 14px; color: #64748b; margin-bottom: 3px; }
        
        .receipt-table th { background: transparent; padding: 12px 10px; border-bottom: 1px solid #e2e8f0; font-size: 12px; }
        .receipt-table td { padding: 15px 10px; border-bottom: 1px solid #f8fafc; font-size: 14px; font-weight: 600; color: #1e293b; }
        .receipt-summary { margin-top: 30px; width: 300px; margin-left: auto; }
        .summary-row { display: flex; justify-content: space-between; padding: 10px 0; font-size: 14px; color: #64748b; }
        .summary-row.total { font-size: 18px; font-weight: 800; color: #2d6652; border-top: 2px solid #2d6652; padding-top: 15px; margin-top: 5px; }
        
        @media print {
            body * { visibility: hidden; }
            .receipt-card, .receipt-card * { visibility: visible; }
            .receipt-card { position: absolute; left: 0; top: 0; margin: 0; padding: 20px; box-shadow: none; width: 100%; max-width: 100%; }
            .print-hide { display: none !important; }
        }
    </style>
</head>

<body>

<jsp:include page="menu.jsp"/>

<main class="content">

    <a href="quanlyhoadon" class="print-hide" style="display:inline-block; margin-bottom:20px; color:#64748b; text-decoration:none; font-weight:600;"><i class="fas fa-arrow-left"></i> Quay lại</a>

    <div class="receipt-card">
        <div class="receipt-header">
            <div class="store-info">
                <div class="store-logo"><i class="fas fa-book-open"></i> BOOKSTORE</div>
                <div class="store-details">
                    Địa chỉ: 123 Đường Láng, Đống Đa, Hà Nội<br>
                    Hotline: 1900 6000 | Email: contact@bookstore.com
                </div>
            </div>
            <div class="invoice-info">
                <div class="invoice-title">HÓA ĐƠN BÁN LẺ</div>
                <div class="invoice-meta">
                    Mã HĐ: <b>#${param.id}</b><br>
                    Ngày lập: <fmt:formatDate value="${hd.ngayTao}" pattern="HH:mm:ss dd/MM/yyyy"/>
                </div>
            </div>
        </div>

        <div class="parties-section">
                <div style="flex: 1;">
                    <div style="font-size: 11px; font-weight: 700; color: #64748b; margin-bottom: 8px;">THÔNG TIN KHÁCH HÀNG</div>
                    <div style="font-weight: 700; font-size: 16px; margin-bottom: 4px;">${not empty hd.tenKH ? hd.tenKH : 'Khách lẻ'}</div>
                    <div style="font-size: 13px; color: #64748b; margin-bottom: 4px;">Số điện thoại: ${not empty hd.sdtKH ? hd.sdtKH : '0000000000'}</div>
                    <div style="font-size: 13px; color: #64748b; margin-bottom: 4px;">Địa chỉ: Tại cửa hàng</div>
                    <div style="font-size: 13px; color: #64748b;">Hình thức TT: <span style="font-weight: bold; color: #1e293b;">${sessionScope.lastPhuongThucTT eq 'ChuyenKhoan' ? 'Chuyển khoản' : 'Tiền mặt'}</span></div>
                </div>
            <div class="party-box">
                <div class="party-heading">ĐƠN VỊ BÁN HÀNG</div>
                <div class="party-name">Nhân viên: ${hd.tenNV}</div>
                <div class="party-detail">Cửa hàng: Chi nhánh chính</div>
            </div>
        </div>

        <table class="receipt-table" style="width:100%; border-collapse:collapse;">
            <thead>
                <tr>
                    <th style="text-align:left;">TÊN SÁCH</th>
                    <th style="text-align:right;">ĐƠN GIÁ</th>
                    <th style="text-align:center; width: 60px;">SL</th>
                    <th style="text-align:right;">THÀNH TIỀN</th>
                </tr>
            </thead>
            <tbody>
                <c:set var="total" value="0" />
                <c:forEach var="item" items="${details}">
                    <c:set var="subTotal" value="${item.soLuong * item.donGia}" />
                    <c:set var="total" value="${total + subTotal}" />
                    <tr>
                        <td style="text-align:left;">${item.tenSach}</td>
                        <td style="text-align:right;"><fmt:formatNumber value="${item.donGia}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></td>
                        <td style="text-align:center;">${item.soLuong}</td>
                        <td style="text-align:right; font-weight:700;"><fmt:formatNumber value="${subTotal}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="receipt-summary">
            <div class="summary-row">
                <span>Tạm tính:</span>
                <span><fmt:formatNumber value="${total}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
            </div>
            <div class="summary-row">
                <span>Giảm giá:</span>
                <span><fmt:formatNumber value="${not empty sessionScope.lastGiamGia ? sessionScope.lastGiamGia : 0}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
            </div>
            <div class="summary-row total">
                <span>Tổng cộng:</span>
                <span><fmt:formatNumber value="${total - (not empty sessionScope.lastGiamGia ? sessionScope.lastGiamGia : 0)}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
            </div>
            <c:if test="${not empty sessionScope.lastTienKhachDua && sessionScope.lastPhuongThucTT eq 'TienMat'}">
            <div class="summary-row" style="margin-top: 15px;">
                <span>Khách đưa:</span>
                <span><fmt:formatNumber value="${sessionScope.lastTienKhachDua}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
            </div>
            <div class="summary-row">
                <span>Tiền thừa:</span>
                <span><fmt:formatNumber value="${sessionScope.lastTienKhachDua - (total - (not empty sessionScope.lastGiamGia ? sessionScope.lastGiamGia : 0))}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
            </div>
            </c:if>
        </div>
        
        <div class="print-hide" style="text-align: center; margin-top: 40px;">
            <button onclick="window.print()" style="background: #2d6652; color: white; padding: 12px 30px; border: none; border-radius: 8px; cursor: pointer; font-weight: bold; font-size: 16px; box-shadow: 0 4px 10px rgba(45,102,82,0.2);"><i class="fas fa-print"></i> IN HÓA ĐƠN NÀY</button>
            <a href="banhang" style="display:inline-block; margin-left: 15px; background: #e2e8f0; color: #1e293b; padding: 12px 30px; border-radius: 8px; text-decoration: none; font-weight: bold; font-size: 16px;"><i class="fas fa-shopping-cart"></i> BÁN ĐƠN MỚI</a>
        </div>
    </div>

    <c:if test="${param.print == 'true'}">
        <script>
            window.onload = function() {
                setTimeout(function() { window.print(); }, 500);
            };
        </script>
    </c:if>
</main>

</body>
</html>
