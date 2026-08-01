<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bán Hàng (POS)</title>
    <link rel="stylesheet" href="css/qlnv.css?v=2.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .pos-container { display: flex; gap: 20px; height: calc(100vh - 40px); }
        .pos-left { flex: 2; display: flex; flex-direction: column; overflow: hidden; }
        .pos-right { flex: 1; min-width: 380px; background: white; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); display: flex; flex-direction: column; overflow: hidden; }
        
        .pos-header-actions { display: flex; justify-content: space-between; margin-bottom: 20px; }
        .search-bar { display: flex; gap: 15px; flex: 1; }
        .search-bar input { flex: 1; padding: 12px 15px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; outline: none; }
        .search-bar select { padding: 12px 15px; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 14px; outline: none; }
        .search-bar input:focus, .search-bar select:focus { border-color: #2d6652; box-shadow: 0 0 0 2px rgba(45, 102, 82, 0.1); }
        
        .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 20px; overflow-y: auto; padding-right: 10px; padding-bottom: 20px; }
        .product-card { background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.04); transition: 0.2s; border: 1px solid #f1f5f9; display: flex; flex-direction: column; min-height: 460px; }
        .product-card:hover { transform: translateY(-3px); box-shadow: 0 8px 20px rgba(0,0,0,0.08); }
        .product-img { width: 100%; height: 200px; object-fit: cover; }
        .product-info { padding: 12px 15px; display: flex; flex-direction: column; flex-grow: 1; }
        .product-name { font-weight: 700; font-size: 14px; color: #1e293b; margin-bottom: 5px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .product-author { font-size: 12px; color: #64748b; margin-bottom: 10px; }
        .product-price { color: #2d6652; font-weight: 800; font-size: 16px; margin-bottom: 5px; }
        .product-stock { font-size: 12px; color: #64748b; margin-bottom: 15px; }
        .btn-add-cart { display: block; width: 100%; padding: 10px 0; background: #2d6652; color: white; border: none; border-radius: 6px; text-decoration: none; font-weight: 600; text-align: center; margin-top: auto; transition: 0.2s; box-sizing: border-box; }
        .btn-add-cart:hover { background: #1e4537; }
        
        .cart-header { background: #2d6652; color: white; padding: 15px 20px; display: flex; justify-content: space-between; align-items: center; font-weight: 600; font-size: 16px; }
        .cart-badge { background: #fca5a5; color: #991b1b; padding: 2px 8px; border-radius: 12px; font-size: 12px; font-weight: 800; }
        
        .cart-list { flex: 1; overflow-y: auto; padding: 15px; background: #f8fafc; }
        .cart-item { display: flex; justify-content: space-between; align-items: flex-start; background: white; padding: 12px; border-radius: 8px; margin-bottom: 10px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); }
        .cart-item-info { flex: 1; padding-right: 10px; }
        .cart-item-title { font-weight: 600; color: #1e293b; font-size: 14px; margin-bottom: 5px; }
        .cart-item-price { color: #2d6652; font-size: 13px; font-weight: 600; }
        .btn-remove-item { background: transparent; color: #ef4444; border: none; cursor: pointer; font-size: 16px; padding: 5px; }
        .btn-remove-item:hover { color: #dc2626; }
        
        .checkout-section { background: white; border-top: 1px solid #e2e8f0; padding: 15px 20px; overflow-y: auto; max-height: 55vh; flex-shrink: 0; }
        .checkout-group { margin-bottom: 10px; }
        .checkout-group label { display: block; font-size: 12px; font-weight: 700; color: #64748b; margin-bottom: 5px; letter-spacing: 0.5px; }
        .checkout-group select, .checkout-group textarea, .checkout-group input { width: 100%; padding: 8px 12px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px; outline: none; font-family: inherit; box-sizing: border-box; }
        .checkout-group select:focus, .checkout-group textarea:focus, .checkout-group input:focus { border-color: #2d6652; }
        .checkout-total { display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 14px; color: #64748b; font-weight: 600; }
        .checkout-total.final { font-size: 18px; color: #2d6652; font-weight: 800; border-top: 1px dashed #cbd5e1; padding-top: 12px; margin-top: 5px; margin-bottom: 15px; }
        
        .btn-checkout { background: #2d6652; color: white; border: none; padding: 12px; border-radius: 8px; cursor: pointer; width: 100%; font-weight: 700; font-size: 16px; display: flex; justify-content: center; align-items: center; gap: 10px; transition: 0.2s; margin-top: 10px; }
        .btn-checkout:hover { background: #1e4537; box-shadow: 0 4px 12px rgba(45, 102, 82, 0.2); }
        .btn-checkout:disabled { background: #cbd5e1; cursor: not-allowed; box-shadow: none; color: #94a3b8; }
        
        /* Custom scrollbar for cart and products */
        .cart-list::-webkit-scrollbar, .product-grid::-webkit-scrollbar, .checkout-section::-webkit-scrollbar { width: 6px; }
        .cart-list::-webkit-scrollbar-thumb, .product-grid::-webkit-scrollbar-thumb, .checkout-section::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 4px; }
    </style>
</head>

<body>

<jsp:include page="menu.jsp"/>

<main class="content">

    <c:if test="${param.success == 1}">
        <div style="background: #ecfdf5; color: #059669; padding: 15px; border-radius: 8px; margin-bottom: 20px; font-weight: 600; text-align: center; border: 1px solid #a7f3d0;">
            <i class="fas fa-check-circle"></i> Thanh toán thành công!
        </div>
    </c:if>
    <c:if test="${param.error == 'empty_cart'}">
        <div style="background: #fef2f2; color: #ef4444; padding: 15px; border-radius: 8px; margin-bottom: 20px; font-weight: 600; text-align: center; border: 1px solid #fecaca;">
            <i class="fas fa-exclamation-circle"></i> Giỏ hàng trống! Vui lòng chọn sản phẩm.
        </div>
    </c:if>
    <c:if test="${param.error == 'out_of_stock'}">
        <div style="background: #fef2f2; color: #ef4444; padding: 15px; border-radius: 8px; margin-bottom: 20px; font-weight: 600; text-align: center; border: 1px solid #fecaca;">
            <i class="fas fa-exclamation-circle"></i> Sản phẩm trong giỏ hàng đã hết hoặc không đủ tồn kho! Vui lòng kiểm tra lại.
        </div>
    </c:if>
    <c:if test="${param.error == 'db_error'}">
        <div style="background: #fef2f2; color: #ef4444; padding: 15px; border-radius: 8px; margin-bottom: 20px; font-weight: 600; text-align: center; border: 1px solid #fecaca;">
            <i class="fas fa-exclamation-circle"></i> Đã xảy ra lỗi khi tạo hóa đơn. Vui lòng thử lại.
        </div>
    </c:if>
    <c:if test="${param.error == 'barcode_not_found'}">
        <div style="background: #fef2f2; color: #ef4444; padding: 15px; border-radius: 8px; margin-bottom: 20px; font-weight: 600; text-align: center; border: 1px solid #fecaca;">
            <i class="fas fa-exclamation-triangle"></i> Mã vạch không hợp lệ hoặc sách không tồn tại!
        </div>
    </c:if>
    <c:if test="${param.successScanner == 1}">
        <div id="scannerToast" style="background: #ecfdf5; color: #059669; padding: 10px 20px; border-radius: 8px; font-weight: 600; text-align: center; border: 1px solid #a7f3d0; position: fixed; top: 20px; left: 50%; transform: translateX(-50%); z-index: 9999; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">
            <i class="fas fa-barcode"></i> Đã quét và thêm sách vào giỏ!
        </div>
        <script>
            setTimeout(function() {
                var toast = document.getElementById('scannerToast');
                if (toast) toast.style.display = 'none';
            }, 2000);
        </script>
    </c:if>

    <div class="pos-container">
        <!-- CỘT TRÁI: DANH SÁCH SẢN PHẨM -->
        <div class="pos-left">
            <div class="pos-header-actions">
                <form class="search-bar" action="banhang" method="get">
                    <input type="text" name="searchSach" value="${searchSach}" placeholder="Tìm kiếm sách bằng tên...">
                    <select name="maTheLoai" onchange="this.form.submit()">
                        <option value="0">-- Tất cả danh mục --</option>
                        <c:forEach var="parent" items="${dsTheLoai}">
                            <c:if test="${empty parent.maTheLoaiCha}">
                                <option value="${parent.maTheLoai}" style="font-weight: bold; background: #f8fafc;" ${maTheLoai == parent.maTheLoai ? 'selected' : ''}>■ ${parent.tenTheLoai}</option>
                                <c:forEach var="child" items="${dsTheLoai}">
                                    <c:if test="${child.maTheLoaiCha == parent.maTheLoai}">
                                        <option value="${child.maTheLoai}" ${maTheLoai == child.maTheLoai ? 'selected' : ''}>&nbsp;&nbsp;&nbsp;&nbsp;↳ ${child.tenTheLoai}</option>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </c:forEach>
                    </select>
                </form>
                
                <form action="banhang" method="get" id="barcodeForm" style="display:flex; margin-left:10px; align-items: center; gap: 8px;">
                    <input type="hidden" name="action" value="addCartByBarcode">
                    <div style="position:relative;" title="Nhập mã vạch">
                        <i class="fas fa-barcode" style="position:absolute; left:12px; top:50%; transform:translateY(-50%); color:#64748b;"></i>
                        <input type="text" id="barcodeScanner" name="barcode" placeholder="Nhập mã vạch..." autofocus autocomplete="off" style="padding: 10px 15px 10px 35px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px; outline: none; width:180px; background:#f8fafc; font-weight: bold;">
                    </div>
                    <button type="button" id="btnOpenScanner" style="background: #2d6652; color: white; border: none; padding: 10px 15px; border-radius: 6px; cursor: pointer; font-weight: 600; display: flex; align-items: center; gap: 5px;" title="Quét bằng Camera">
                        <i class="fas fa-camera"></i>
                    </button>
                </form>
            </div>
            
            <div class="product-grid">
                <c:forEach var="s" items="${dsSach}">
                    <div class="product-card">
                        <c:choose>
                            <c:when test="${not empty s.hinhAnh}">
                                <img src="${s.hinhAnh}" class="product-img" alt="${s.tenSach}" onerror="this.src='https://via.placeholder.com/200x200?text=No+Image';">
                            </c:when>
                            <c:otherwise>
                                <div class="product-img" style="background:#f1f5f9; display:flex; align-items:center; justify-content:center; color:#94a3b8; font-size:12px;">No Image</div>
                            </c:otherwise>
                        </c:choose>
                        
                        <div class="product-info">
                            <div class="product-name" title="${s.tenSach}">${s.tenSach}</div>
                            <div class="product-author">${s.tacGiaString}</div>
                            <div class="product-price"><fmt:formatNumber value="${s.giaBan}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></div>
                            <div class="product-stock">Tồn kho: ${s.soLuongTon}</div>
                            
                            <div style="display: flex; align-items: center; justify-content: space-evenly; border: 1px dashed #cbd5e1; border-radius: 6px; padding: 6px; margin-top: 8px; margin-bottom: 8px; background: #f8fafc;">
                                <img src="https://api.qrserver.com/v1/create-qr-code/?size=50x50&data=${not empty s.isbn ? s.isbn : s.maSach}" alt="QR" style="height: 38px; width: 38px;">
                                <div style="width: 1px; height: 30px; background: #cbd5e1;"></div>
                                <div style="display: flex; flex-direction: column; align-items: center;">
                                    <img src="https://barcode.orcascan.com/?type=code128&data=${not empty s.isbn ? s.isbn : s.maSach}&text=" alt="Barcode" style="height: 25px; max-width: 90px; mix-blend-mode: multiply;">
                                    <span style="font-size: 10px; font-weight: bold; color: #475569; margin-top: 2px; letter-spacing: 1px;">${not empty s.isbn ? s.isbn : s.maSach}</span>
                                </div>
                            </div>
                            
                            <c:if test="${s.soLuongTon > 0}">
                                <form action="banhang" method="get" style="display: flex; gap: 8px; margin-top: auto;">
                                    <input type="hidden" name="action" value="addCartMulti">
                                    <input type="hidden" name="maSach" value="${s.maSach}">
                                    <input type="number" name="soLuong" value="1" min="1" max="${s.soLuongTon}" title="Nhập số lượng" style="width: 70px; padding: 8px 5px; border: 1px solid #cbd5e1; border-radius: 6px; text-align: center; outline: none; font-weight: bold; color: #1e293b; box-sizing: border-box;">
                                    <button type="submit" class="btn-add-cart" style="flex: 1; margin: 0; padding: 10px 0;"><i class="fas fa-cart-plus"></i> Thêm</button>
                                </form>
                            </c:if>
                            <c:if test="${s.soLuongTon <= 0}">
                                <button class="btn-add-cart" style="background:#e2e8f0; color:#94a3b8; cursor:not-allowed; margin-top: auto;" disabled>Hết hàng</button>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty dsSach}">
                    <div style="grid-column: 1 / -1; text-align: center; padding: 40px; color: #64748b;">
                        <i class="fas fa-box-open" style="font-size: 48px; color: #cbd5e1; margin-bottom: 15px; display: block;"></i>
                        Không tìm thấy sách nào khả dụng.
                    </div>
                </c:if>
            </div>
        </div>
        
        <!-- CỘT PHẢI: GIỎ HÀNG VÀ THANH TOÁN -->
        <div class="pos-right">
            <div class="cart-header">
                <div>Giỏ Hàng Bán <span class="cart-badge">${fn:length(sessionScope.cart)}</span></div>
                <a href="banhang?action=clearCart" style="color:#fca5a5; font-size:12px; text-decoration:none;"><i class="fas fa-trash-alt"></i> Xóa tất cả</a>
            </div>
            
            <div class="cart-list" id="cartListBody">
                <c:forEach var="item" items="${sessionScope.cart}">
                    <div class="cart-item">
                        <div class="cart-item-info">
                            <div class="cart-item-title">${item.tenSach}</div>
                            <div class="cart-item-price" style="display:flex; align-items:center; gap:8px; margin-top:5px;">
                                <form action="banhang" method="get" style="margin:0; display: flex; align-items: center;">
                                    <input type="hidden" name="action" value="updateCart">
                                    <input type="hidden" name="maSach" value="${item.maSach}">
                                    <input type="number" name="soLuong" value="${item.soLuong}" min="1" onchange="this.form.submit()" onkeydown="if(event.key === 'e' || event.key === 'E' || event.key === '+' || event.key === '-') return false;" style="width: 60px; padding: 4px; border: 1px solid #cbd5e1; border-radius: 4px; text-align: center; font-size:13px; font-weight: bold; outline: none;">
                                </form>
                                <span style="color: #64748b;">x</span> <span><fmt:formatNumber value="${item.donGia}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                            </div>
                        </div>
                        <form action="banhang" method="get" style="margin:0;">
                            <input type="hidden" name="action" value="removeCart">
                            <input type="hidden" name="maSach" value="${item.maSach}">
                            <button type="submit" class="btn-remove-item"><i class="fas fa-times-circle"></i></button>
                        </form>
                    </div>
                </c:forEach>
                <c:if test="${empty sessionScope.cart}">
                    <div style="text-align:center; color:#94a3b8; padding:40px 20px;" id="emptyCartDiv">
                        <i class="fas fa-shopping-basket" style="font-size: 48px; color: #e2e8f0; margin-bottom: 15px; display: block;"></i>
                        Chưa có sản phẩm nào trong giỏ hàng.
                    </div>
                </c:if>
            </div>
            
            <div class="checkout-section">
                <form id="checkoutForm" action="banhang" method="post" onsubmit="return validateCheckout()">
                    <input type="hidden" name="action" value="checkout">
                    
                    <div class="checkout-group">
                        <label>KHÁCH HÀNG</label>
                        <select name="maKH" id="maKHSelect" style="width: 100%;">
                            <option value="0">-- Khách Lẻ --</option>
                            <c:forEach var="kh" items="${dsKhachHang}">
                                <option value="${kh.maKH}">${kh.hoTen} - ${kh.sdt}</option>
                            </c:forEach>
                        </select>
                        <input type="text" id="fastSearchCustomer" placeholder="Gõ Tên/SĐT để chọn nhanh..." style="width:100%; padding: 8px; border: 1px solid #cbd5e1; border-radius: 4px; box-sizing: border-box; outline: none; margin-top: 6px; font-size: 13px;">
                        <div style="text-align:right; margin-top:5px;">
                            <a href="quanlykhachhang" style="font-size:12px; color:#2d6652; font-weight:600;"><i class="fas fa-plus"></i> Thêm khách hàng mới</a>
                        </div>
                    </div>
                    
                    <div class="checkout-group">
                        <label>GHI CHÚ HÓA ĐƠN</label>
                        <textarea rows="2" placeholder="Nhập ghi chú (nếu có)..."></textarea>
                    </div>
                    
                    <div class="checkout-total" style="margin-bottom: 15px;">
                        <span>Tạm tính:</span>
                        <span id="tamTinh"><fmt:formatNumber value="${tongTien}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                    </div>
                    
                    <div class="checkout-group">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 5px;">
                            <span style="font-size:12px; font-weight:600; color:#64748b; text-transform:uppercase;">MÃ KHUYẾN MÃI</span>
                            <span onclick="openVoucherListModal()" style="font-size:12px; color:#2d6652; font-weight:600; cursor:pointer;"><i class="fas fa-search"></i> Chọn / Quản lý</span>
                        </div>
                        <input type="hidden" name="maKM" id="maKM" value="0">
                        <div id="voucherSelector" onclick="openVoucherListModal()" style="border: 1px solid #cbd5e1; border-radius: 6px; padding: 10px; cursor: pointer; background: #f8fafc; transition: 0.2s; margin-bottom: 10px;">
                            <div style="display:flex; justify-content: space-between; align-items: center;">
                                <span id="selectedVoucherText" style="font-weight: 600; color: #1e293b; font-size: 14px;"><i class="fas fa-ticket-alt" style="color: #2d6652; margin-right: 5px;"></i> -- Không áp dụng --</span>
                                <div style="display:flex; align-items:center; gap:10px;">
                                    <i class="fas fa-times-circle" id="clearVoucherBtn" onclick="removeVoucher(event)" style="color: #ef4444; display: none;" title="Bỏ chọn"></i>
                                    <i class="fas fa-chevron-right" style="color: #94a3b8;"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="checkout-group">
                        <label>GIẢM GIÁ TRỰC TIẾP (đ)</label>
                        <input type="number" id="giamGiaTrucTiep" name="giamGiaTrucTiep" min="0" value="0" placeholder="Nhập số tiền giảm..." oninput="calculateTotal()" style="font-weight: bold; color: #ef4444; background: #fff;">
                        <input type="hidden" id="giamGia" name="giamGia" value="0">
                    </div>
                    <div class="checkout-total final">
                        <span>Tổng cộng:</span>
                        <span id="tongCong"><fmt:formatNumber value="${tongTien}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                    </div>
                    
                    <div class="checkout-group">
                        <label>Phương thức thanh toán</label>
                        <select name="phuongThucTT" id="phuongThucTT" onchange="togglePaymentFields()" style="width: 100%; padding: 10px; border-radius: 6px; border: 1px solid #cbd5e1; font-size: 14px;">
                            <option value="TienMat">Tiền mặt</option>
                            <option value="ChuyenKhoan">Chuyển khoản (Mã QR)</option>
                            <option value="TheNganHang">Thẻ ngân hàng (POS)</option>
                        </select>
                    </div>
                    
                    <div id="cash-fields">
                        <div class="checkout-group">
                            <label>Tiền khách đưa (đ)</label>
                            <input type="number" id="tienKhachDua" name="tienKhachDua" style="width: 100%; padding: 10px; border-radius: 6px; border: 1px solid #cbd5e1; font-size: 14px;" placeholder="Nhập số tiền..." oninput="calculateTotal()">
                        </div>
                        
                        <div class="checkout-group">
                            <label>Tiền thừa trả khách</label>
                            <input type="text" id="tienThua" readonly style="width: 100%; padding: 10px; border-radius: 6px; border: 1px solid #cbd5e1; background: #f1f5f9; font-size: 14px; font-weight: bold; color: #ef4444;" value="0 đ">
                        </div>
                    </div>
                    
                    <button type="submit" class="btn-checkout" id="btnMainCheckout" ${empty sessionScope.cart ? 'disabled' : ''}>
                        <i class="fas fa-check-circle"></i> THANH TOÁN
                    </button>
                </form>
                
                <script>
                    var baseTotal = ${tongTien != null ? tongTien : 0};
                    window.currentBaseTotal = baseTotal;
                    
                    function togglePaymentFields() {
                        let method = document.getElementById('phuongThucTT').value;
                        let cashFields = document.getElementById('cash-fields');
                        
                        if(method === 'TienMat') {
                            cashFields.style.display = 'block';
                        } else {
                            cashFields.style.display = 'none';
                            document.getElementById('tienKhachDua').value = '';
                            calculateTotal();
                        }
                    }
                    
                    function calculateTotal() {
                        let giamGia = 0;
                        let phanTram = window.currentVoucherPhanTram || 0;
                        let giamToiDa = window.currentVoucherGiamToiDa || 0;
                        
                        if (phanTram > 0) {
                            giamGia = window.currentBaseTotal * (phanTram / 100.0);
                            if (giamToiDa > 0 && giamGia > giamToiDa) {
                                giamGia = giamToiDa;
                            }
                            document.getElementById('giamGiaTrucTiep').value = 0;
                            document.getElementById('giamGiaTrucTiep').disabled = true;
                            document.getElementById('giamGiaTrucTiep').style.background = "#f1f5f9";
                        } else {
                            document.getElementById('giamGiaTrucTiep').disabled = false;
                            document.getElementById('giamGiaTrucTiep').style.background = "#fff";
                            giamGia = parseFloat(document.getElementById('giamGiaTrucTiep').value) || 0;
                        }
                        
                        document.getElementById('giamGia').value = giamGia;
                        
                        let finalTotal = window.currentBaseTotal - giamGia;
                        if(finalTotal < 0) finalTotal = 0;
                        
                        document.getElementById('tongCong').innerText = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(finalTotal);
                        
                        let method = document.getElementById('phuongThucTT').value;
                        if(method === 'TienMat') {
                            let tienKhachDua = parseFloat(document.getElementById('tienKhachDua').value) || 0;
                            let tienThua = tienKhachDua - finalTotal;
                            
                            if(tienThua >= 0 && tienKhachDua > 0) {
                                document.getElementById('tienThua').value = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(tienThua);
                                document.getElementById('tienThua').style.color = '#059669'; // Green if enough money
                            } else {
                                document.getElementById('tienThua').value = "0 đ";
                                document.getElementById('tienThua').style.color = '#ef4444';
                            }
                        } else {
                            document.getElementById('tienThua').value = "0 đ";
                            document.getElementById('tienThua').style.color = '#ef4444';
                        }
                    }
                    
                    function validateCheckout() {
                        if(window.currentBaseTotal <= 0) return true;
                        const finalTotal = window.currentBaseTotal - (parseFloat(document.getElementById('giamGia').value) || 0);
                        const method = document.getElementById('phuongThucTT').value;
                        
                        if (method === 'TienMat') {
                            const tienKhachDua = parseFloat(document.getElementById('tienKhachDua').value) || 0;
                            if (tienKhachDua < finalTotal) {
                                alert('Tiền khách đưa (' + new Intl.NumberFormat('vi-VN').format(tienKhachDua) + ' đ) phải lớn hơn hoặc bằng tổng tiền (' + new Intl.NumberFormat('vi-VN').format(finalTotal) + ' đ)!');
                                document.getElementById('tienKhachDua').focus();
                                return false;
                            }
                        }
                        return true;
                    }

                    // Khởi tạo ban đầu
                    window.onload = function() {
                        togglePaymentFields();
                        calculateTotal();
                    };
                </script>
            </div>
        </div>
    </div>

</main>

<!-- Modal Thêm Khuyến Mãi -->
<div id="addKMModal" style="display:none; position:fixed; z-index:1000; left:0; top:0; width:100%; height:100%; background-color:rgba(0,0,0,0.5);">
    <div style="background-color:#fff; margin:10% auto; padding:20px; border-radius:8px; width:400px; box-shadow:0 4px 15px rgba(0,0,0,0.2);">
        <h3 id="kmModalTitle" style="margin-top:0; color:#1e293b;">Thêm Khuyến Mãi Mới</h3>
        <form action="quanlykhuyenmai" method="post" onsubmit="return validateKMForm()">
            <input type="hidden" name="action" id="kmFormAction" value="add">
            <input type="hidden" name="maKM" id="kmMaKM" value="0">
            <div style="margin-bottom:15px;">
                <label style="display:block; font-size:13px; font-weight:600; color:#64748b; margin-bottom:5px;">Trạng thái</label>
                <select name="trangThai" id="kmTrangThai" style="width:100%; padding:8px; border:1px solid #cbd5e1; border-radius:4px; box-sizing:border-box; outline:none;">
                    <option value="1">Đang kích hoạt</option>
                    <option value="0">Tạm dừng</option>
                </select>
            </div>
            <div style="margin-bottom:15px;">
                <label style="display:block; font-size:13px; font-weight:600; color:#64748b; margin-bottom:5px;">Tên Khuyến Mãi</label>
                <input type="text" name="tenKM" id="kmTen" required style="width:100%; padding:8px; border:1px solid #cbd5e1; border-radius:4px; box-sizing:border-box; outline:none;">
            </div>
            <div style="margin-bottom:15px;">
                <label style="display:block; font-size:13px; font-weight:600; color:#64748b; margin-bottom:5px;">Phần trăm giảm (%)</label>
                <input type="number" name="phanTramGiam" id="kmPhanTram" min="1" max="100" required style="width:100%; padding:8px; border:1px solid #cbd5e1; border-radius:4px; box-sizing:border-box; outline:none;">
            </div>
            <div style="margin-bottom:15px;">
                <label style="display:block; font-size:13px; font-weight:600; color:#64748b; margin-bottom:5px;">Giảm Tối Đa (đ)</label>
                <input type="number" name="giamToiDa" id="kmGiamToiDa" min="0" required style="width:100%; padding:8px; border:1px solid #cbd5e1; border-radius:4px; box-sizing:border-box; outline:none;">
            </div>
            <div style="margin-bottom:15px;">
                <label style="display:block; font-size:13px; font-weight:600; color:#64748b; margin-bottom:5px;">Ngày Bắt Đầu</label>
                <input type="datetime-local" id="kmNgayBatDau" name="ngayBatDau" required style="width:100%; padding:8px; border:1px solid #cbd5e1; border-radius:4px; box-sizing:border-box; outline:none;">
            </div>
            <div style="margin-bottom:15px;">
                <label style="display:block; font-size:13px; font-weight:600; color:#64748b; margin-bottom:5px;">Ngày Kết Thúc</label>
                <input type="datetime-local" id="kmNgayKetThuc" name="ngayKetThuc" required style="width:100%; padding:8px; border:1px solid #cbd5e1; border-radius:4px; box-sizing:border-box; outline:none;">
            </div>
            <div style="text-align:right; margin-top:20px;">
                <button type="button" onclick="closeAddKMModal()" style="padding:8px 15px; background:#e2e8f0; border:none; border-radius:4px; cursor:pointer; color:#475569; font-weight:600; margin-right:10px;">Hủy</button>
                <button type="submit" style="padding:8px 15px; background:#2d6652; border:none; border-radius:4px; cursor:pointer; color:white; font-weight:600;">Lưu Mã</button>
            </div>
        </form>
    </div>
</div>
<!-- Modal Danh Sách Khuyến Mãi -->
<div id="voucherListModal" style="display:none; position:fixed; z-index:1000; left:0; top:0; width:100%; height:100%; background-color:rgba(0,0,0,0.5);">
    <div style="background-color:#fff; margin:5% auto; padding:20px; border-radius:8px; width:600px; max-height: 80vh; overflow-y: auto; box-shadow:0 4px 15px rgba(0,0,0,0.2);">
        <div style="display:flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 1px solid #e2e8f0; padding-bottom: 10px;">
            <h3 style="margin:0; color:#1e293b;"><i class="fas fa-ticket-alt" style="color: #2d6652;"></i> Chọn / Quản lý Khuyến Mãi</h3>
            <div style="display: flex; gap: 10px;">
                <c:if test="${sessionScope.quyen == 'admin'}">
                    <button type="button" onclick="openAddKMModal()" style="padding: 6px 12px; background: #2d6652; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 13px;"><i class="fas fa-plus"></i> Thêm mới</button>
                </c:if>
                <button type="button" onclick="closeVoucherListModal()" style="background:none; border:none; font-size:20px; color:#64748b; cursor:pointer;"><i class="fas fa-times"></i></button>
            </div>
        </div>
        
        <input type="text" id="voucherSearch" placeholder="Tìm kiếm voucher..." style="width:100%; padding:10px; border:1px solid #cbd5e1; border-radius:6px; margin-bottom: 15px; box-sizing:border-box; outline:none;" oninput="filterVouchers()">
        
        <div id="voucherContainer">
            <c:forEach var="km" items="${dsKhuyenMai}">
                <c:set var="statusColor" value="${km.trangThai == 1 ? '#10b981' : '#94a3b8'}" />
                <c:set var="statusText" value="${km.trangThai == 1 ? 'Đang diễn ra' : 'Đã hết hạn/Dừng'}" />
                
                <div class="voucher-item" data-name="${km.tenKM}" style="border: 1px solid #e2e8f0; border-radius: 8px; padding: 15px; margin-bottom: 10px; display:flex; justify-content: space-between; align-items: center;">
                    <div>
                        <div style="font-weight: bold; color: #1e293b; font-size: 16px;">${km.tenKM} <span style="font-size:11px; padding: 2px 6px; border-radius: 4px; background: ${statusColor}20; color: ${statusColor}; margin-left: 8px;">${statusText}</span></div>
                        <div style="color: #ef4444; font-weight: bold; margin-top: 5px;">Giảm ${km.phanTramGiam}% <span style="color: #64748b; font-size: 13px; font-weight: normal;">(Tối đa: <fmt:formatNumber value="${km.giamToiDa}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>)</span></div>
                        <div style="color: #94a3b8; font-size: 12px; margin-top: 5px;"><i class="far fa-clock"></i> HSD: 
                            <c:choose>
                                <c:when test="${not empty km.ngayKetThuc}">
                                    <fmt:formatDate value="${km.ngayKetThuc}" pattern="dd/MM/yyyy HH:mm" />
                                </c:when>
                                <c:otherwise>Không thời hạn</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div style="display:flex; flex-direction: column; gap: 8px;">
                        <c:if test="${km.trangThai == 1}">
                            <button type="button" onclick="applyVoucher(${km.maKM}, '${fn:escapeXml(km.tenKM)}', ${km.phanTramGiam}, ${km.giamToiDa})" style="padding: 8px 15px; background: #2d6652; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">Áp dụng</button>
                        </c:if>
                        <c:if test="${sessionScope.quyen == 'admin'}">
                            <button type="button" onclick="openEditKMModal(${km.maKM}, '${fn:escapeXml(km.tenKM)}', ${km.phanTramGiam}, ${km.giamToiDa}, '${km.ngayBatDau}', '${km.ngayKetThuc}', ${km.trangThai})" style="padding: 6px 15px; background: #f8fafc; color: #475569; border: 1px solid #cbd5e1; border-radius: 4px; cursor: pointer; font-size: 12px;">Sửa</button>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>
<!-- Modal Scanner -->
<div id="scannerModal" style="display:none; position:fixed; z-index:9999; left:0; top:0; width:100%; height:100%; background-color:rgba(0,0,0,0.6);">
    <div style="background-color:#fff; margin:5% auto; padding:20px; border-radius:8px; width:500px; max-width: 90%; box-shadow:0 4px 15px rgba(0,0,0,0.2); position:relative;">
        <button type="button" onclick="closeScanner()" style="position:absolute; right:15px; top:15px; background:none; border:none; font-size:20px; color:#64748b; cursor:pointer;"><i class="fas fa-times"></i></button>
        <h3 style="margin-top:0; color:#1e293b; text-align:center;"><i class="fas fa-qrcode"></i> Quét mã từ Camera</h3>
        <div id="reader" style="width:100%; min-height: 300px;"></div>
    </div>
</div>

    <script>
function openAddKMModal() {
    document.getElementById('kmModalTitle').innerText = 'Thêm Khuyến Mãi Mới';
    document.getElementById('kmFormAction').value = 'add';
    document.getElementById('kmTen').value = '';
    document.getElementById('kmPhanTram').value = '';
    document.getElementById('kmGiamToiDa').value = '';
    document.getElementById('addKMModal').style.display = 'block';
}
function openEditKMModal(maKM, ten, phanTram, toiDa, start, end, trangThai) {
    document.getElementById('kmModalTitle').innerText = 'Sửa Khuyến Mãi';
    document.getElementById('kmFormAction').value = 'update';
    document.getElementById('kmMaKM').value = maKM;
    document.getElementById('kmTen').value = ten;
    document.getElementById('kmPhanTram').value = phanTram;
    document.getElementById('kmGiamToiDa').value = toiDa;
    document.getElementById('kmTrangThai').value = trangThai;
    // Format dates for datetime-local
    document.getElementById('kmNgayBatDau').value = (start && start.length >= 16) ? start.replace(' ', 'T').substring(0,16) : '';
    document.getElementById('kmNgayKetThuc').value = (end && end.length >= 16) ? end.replace(' ', 'T').substring(0,16) : '';
    document.getElementById('addKMModal').style.display = 'block';
}
function closeAddKMModal() {
    document.getElementById('addKMModal').style.display = 'none';
}
function openVoucherListModal() {
    document.getElementById('voucherListModal').style.display = 'block';
}
function closeVoucherListModal() {
    document.getElementById('voucherListModal').style.display = 'none';
}
function filterVouchers() {
    let q = document.getElementById('voucherSearch').value.toLowerCase();
    document.querySelectorAll('.voucher-item').forEach(item => {
        let name = item.getAttribute('data-name');
        if(name && name.toLowerCase().includes(q)) {
            item.style.display = 'flex';
        } else {
            item.style.display = 'none';
        }
    });
}
function applyVoucher(ma, ten, phanTram, toiDa) {
    document.getElementById('maKM').value = ma;
    document.getElementById('selectedVoucherText').innerHTML = '<i class="fas fa-ticket-alt" style="color: #2d6652; margin-right: 5px;"></i> ' + ten + ' (-' + phanTram + '%)';
    document.getElementById('clearVoucherBtn').style.display = 'block';
    window.currentVoucherPhanTram = phanTram;
    window.currentVoucherGiamToiDa = toiDa;
    closeVoucherListModal();
    calculateTotal();
}
function removeVoucher(event) {
    if (event) {
        event.stopPropagation();
    }
    document.getElementById('maKM').value = 0;
    document.getElementById('selectedVoucherText').innerHTML = '<i class="fas fa-ticket-alt" style="color: #2d6652; margin-right: 5px;"></i> -- Không áp dụng --';
    document.getElementById('clearVoucherBtn').style.display = 'none';
    window.currentVoucherPhanTram = 0;
    window.currentVoucherGiamToiDa = 0;
    calculateTotal();
}
function validateKMForm() {
    let start = new Date(document.getElementById('kmNgayBatDau').value);
    let end = new Date(document.getElementById('kmNgayKetThuc').value);
    if(end <= start) {
        alert("Ngày kết thúc phải sau ngày bắt đầu!");
        return false;
    }
    return true;
}
    </script>
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript" defer></script>
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script>
$(document).ready(function() {
    $('#maKHSelect').select2({
        width: '100%',
        placeholder: 'Tìm khách hàng theo tên, sđt...'
    });
});

document.getElementById('fastSearchCustomer').addEventListener('input', function(e) {
    let val = e.target.value.toLowerCase().trim();
    if(val === '') {
        $('#maKHSelect').val('0').trigger('change');
        return;
    }
    let options = document.getElementById('maKHSelect').options;
    for(let i=0; i<options.length; i++) {
        if(options[i].value !== '0' && options[i].text.toLowerCase().includes(val)) {
            $('#maKHSelect').val(options[i].value).trigger('change');
            break;
        }
    }
});

// Native Form Scanning Logic
document.getElementById('barcodeForm').addEventListener('submit', function(e) {
    var barcodeInput = document.getElementById('barcodeScanner');
    var barcode = barcodeInput.value.trim();
    if (!barcode) {
        e.preventDefault();
        return;
    }
    // Form submits natively to action="banhang"
});

function showToast(type, message) {
    var toast = document.createElement('div');
    toast.style.position = 'fixed';
    toast.style.top = '20px';
    toast.style.left = '50%';
    toast.style.transform = 'translateX(-50%)';
    toast.style.padding = '10px 20px';
    toast.style.borderRadius = '8px';
    toast.style.fontWeight = '600';
    toast.style.zIndex = '9999';
    toast.style.boxShadow = '0 4px 10px rgba(0,0,0,0.1)';
    
    if (type === 'success') {
        toast.style.background = '#ecfdf5';
        toast.style.color = '#059669';
        toast.style.border = '1px solid #a7f3d0';
        toast.innerHTML = '<i class="fas fa-check-circle"></i> ' + message;
    } else {
        toast.style.background = '#fef2f2';
        toast.style.color = '#ef4444';
        toast.style.border = '1px solid #fecaca';
        toast.innerHTML = '<i class="fas fa-exclamation-triangle"></i> ' + message;
    }

    document.body.appendChild(toast);
    setTimeout(function() {
        toast.remove();
    }, 3000);
}

function updateCartUI(cart, tongTien) {
    var cartList = document.getElementById('cartListBody');
    cartList.innerHTML = ''; 

    if (cart.length === 0) {
        cartList.innerHTML = `
            <div style="text-align:center; color:#94a3b8; padding:40px 20px;" id="emptyCartDiv">
                <i class="fas fa-shopping-basket" style="font-size: 48px; color: #e2e8f0; margin-bottom: 15px; display: block;"></i>
                Chưa có sản phẩm nào trong giỏ hàng.
            </div>`;
    } else {
        var cartBadge = document.querySelector('.cart-badge');
        if(cartBadge) cartBadge.innerText = cart.length;

        cart.forEach(function(item) {
            var formattedPrice = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(item.donGia);
            
            var itemDiv = document.createElement('div');
            itemDiv.className = 'cart-item';
            itemDiv.innerHTML = `
                <div class="cart-item-info">
                    <div class="cart-item-title">\${item.tenSach}</div>
                    <div class="cart-item-price" style="display:flex; align-items:center; gap:8px; margin-top:5px;">
                        <form action="banhang" method="get" style="margin:0; display: flex; align-items: center;">
                            <input type="hidden" name="action" value="updateCart">
                            <input type="hidden" name="maSach" value="\${item.maSach}">
                            <input type="number" name="soLuong" value="\${item.soLuong}" min="1" onchange="this.form.submit()" style="width: 60px; padding: 4px; border: 1px solid #cbd5e1; border-radius: 4px; text-align: center; font-size:13px; font-weight: bold; outline: none;">
                        </form>
                        <span style="color: #64748b;">x</span> <span>\${formattedPrice}</span>
                    </div>
                </div>
                <form action="banhang" method="get" style="margin:0;">
                    <input type="hidden" name="action" value="removeCart">
                    <input type="hidden" name="maSach" value="\${item.maSach}">
                    <button type="submit" class="btn-remove-item"><i class="fas fa-times-circle"></i></button>
                </form>
            `;
            cartList.appendChild(itemDiv);
        });
    }

    window.currentBaseTotal = tongTien;
    calculateTotal();
}

// Camera Scanner Logic
var html5QrcodeScanner = null;
    
document.getElementById('btnOpenScanner').addEventListener('click', function() {
    document.getElementById('scannerModal').style.display = 'block';
    if (!html5QrcodeScanner) {
        html5QrcodeScanner = new Html5QrcodeScanner(
            "reader", 
            { fps: 10, qrbox: {width: 250, height: 250}, rememberLastUsedCamera: true },
            /* verbose= */ false);
        html5QrcodeScanner.render(onScanSuccess, onScanFailure);
    }
});

function closeScanner() {
    document.getElementById('scannerModal').style.display = 'none';
    if (html5QrcodeScanner) {
        html5QrcodeScanner.clear();
        html5QrcodeScanner = null;
    }
}

function onScanSuccess(decodedText, decodedResult) {
    closeScanner();
    var input = document.getElementById('barcodeScanner');
    input.value = decodedText;
    
    try {
        var audio = new Audio('https://www.soundjay.com/buttons/beep-07.wav');
        audio.play();
    } catch(e) {}
    
    var event = new Event('submit', {
        'bubbles': true,
        'cancelable': true
    });
    document.getElementById('barcodeForm').dispatchEvent(event);
}

function onScanFailure(error) {
    // console.warn(`Code scan error = ${error}`);
}
</script>

<!-- Modal Card Payment -->
<div id="cardPaymentModal" style="display:none; position:fixed; z-index:1000; left:0; top:0; width:100%; height:100%; background-color:rgba(0,0,0,0.5);">
    <div style="background-color:#fff; margin:10% auto; padding:20px; border-radius:8px; width:400px; box-shadow:0 4px 15px rgba(0,0,0,0.2); position:relative;">
        <button type="button" onclick="document.getElementById('cardPaymentModal').style.display='none'" style="position:absolute; right:15px; top:15px; background:none; border:none; font-size:20px; cursor:pointer; color:#94a3b8;"><i class="fas fa-times"></i></button>
        <h3 style="margin-top:0; color:#1e293b; font-weight:800; border-bottom: 2px dashed #e2e8f0; padding-bottom:15px; margin-bottom:20px; text-align:center;">THANH TOÁN THẺ</h3>
        
        <div style="text-align:center; margin-bottom:20px; font-size:30px; color:#cbd5e1; gap:15px; display:flex; justify-content:center;">
            <i class="fab fa-cc-visa" style="color:#1434CB;"></i>
            <i class="fab fa-cc-mastercard" style="color:#EB001B;"></i>
            <i class="fab fa-cc-jcb" style="color:#0079E2;"></i>
        </div>

        <div style="margin-bottom:15px;">
            <label style="display:block; font-size:13px; color:#64748b; margin-bottom:5px;">Loại thẻ</label>
            <select style="width:100%; padding:10px; border:1px solid #cbd5e1; border-radius:6px; outline:none; background:#f8fafc;">
                <option>Visa</option>
                <option>MasterCard</option>
                <option>ATM Nội địa</option>
                <option>JCB</option>
            </select>
        </div>
        <div style="margin-bottom:15px;">
            <label style="display:block; font-size:13px; color:#64748b; margin-bottom:5px;">Tên chủ thẻ</label>
            <input type="text" placeholder="NGUYEN VAN A" style="width:100%; padding:10px; border:1px solid #cbd5e1; border-radius:6px; outline:none; text-transform:uppercase;">
        </div>
        <div style="margin-bottom:15px;">
            <label style="display:block; font-size:13px; color:#64748b; margin-bottom:5px;">Số thẻ</label>
            <input type="text" placeholder="**** **** **** ****" style="width:100%; padding:10px; border:1px solid #cbd5e1; border-radius:6px; outline:none;">
        </div>
        <div style="display:flex; gap:15px; margin-bottom:20px;">
            <div style="flex:1;">
                <label style="display:block; font-size:13px; color:#64748b; margin-bottom:5px;">Ngày hết hạn</label>
                <input type="text" placeholder="MM / YY" style="width:100%; padding:10px; border:1px solid #cbd5e1; border-radius:6px; outline:none; text-align:center;">
            </div>
            <div style="flex:1;">
                <label style="display:block; font-size:13px; color:#64748b; margin-bottom:5px;">CVV</label>
                <input type="password" placeholder="***" style="width:100%; padding:10px; border:1px solid #cbd5e1; border-radius:6px; outline:none; text-align:center;">
            </div>
        </div>
        
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:25px; padding:15px; background:#f1f5f9; border-radius:8px;">
            <span style="color:#64748b; font-size:14px; font-weight:bold;">Số tiền thanh toán:</span>
            <strong id="cardAmount" style="color:#ef4444; font-size:20px;">0 VNĐ</strong>
        </div>

        <button type="button" id="btnProcessCard" onclick="simulateCardPayment()" style="width:100%; padding:12px; background:#2d6652; color:white; border:none; border-radius:6px; font-weight:bold; font-size:15px; cursor:pointer; position:relative; overflow:hidden;">
            <i class="fas fa-credit-card"></i> Thanh toán ngay
        </button>
    </div>
</div>

<style>
    @keyframes pulse {
        0% { opacity: 1; }
        50% { opacity: 0.5; }
        100% { opacity: 1; }
    }
</style>

<script>
    function simulateCardPayment() {
        let btn = document.getElementById('btnProcessCard');
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
        btn.style.background = '#94a3b8';
        btn.disabled = true;
        
        setTimeout(() => {
            btn.innerHTML = '<i class="fas fa-check-circle"></i> Thanh toán thành công';
            btn.style.background = '#10b981';
            
            setTimeout(() => {
                document.getElementById('checkoutForm').submit();
            }, 800);
        }, 1500);
    }
</script>

</body>
</html>
