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
        .product-card { background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.04); transition: 0.2s; border: 1px solid #f1f5f9; display: flex; flex-direction: column; }
        .product-card:hover { transform: translateY(-3px); box-shadow: 0 8px 20px rgba(0,0,0,0.08); }
        .product-img { width: 100%; height: 200px; object-fit: cover; }
        .product-info { padding: 15px; display: flex; flex-direction: column; flex: 1; }
        .product-name { font-weight: 700; font-size: 14px; color: #1e293b; margin-bottom: 5px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .product-author { font-size: 12px; color: #64748b; margin-bottom: 10px; }
        .product-price { color: #2d6652; font-weight: 800; font-size: 16px; margin-bottom: 5px; }
        .product-stock { font-size: 12px; color: #64748b; margin-bottom: 15px; }
        .btn-add-cart { display: block; width: 100%; padding: 10px 0; background: #2d6652; color: white; border: none; border-radius: 6px; text-decoration: none; font-weight: 600; text-align: center; margin-top: auto; transition: 0.2s; }
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

    <div class="pos-container">
        <!-- CỘT TRÁI: DANH SÁCH SẢN PHẨM -->
        <div class="pos-left">
            <div class="pos-header-actions">
                <form class="search-bar" action="banhang" method="get">
                    <input type="text" name="searchSach" value="${searchSach}" placeholder="Tìm kiếm sách bằng tên...">
                    <select>
                        <option>-- Tất cả danh mục --</option>
                    </select>
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
                            <div class="product-author">${s.tacGia}</div>
                            <div class="product-price"><fmt:formatNumber value="${s.giaBan}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></div>
                            <div class="product-stock">Tồn kho: ${s.soLuongTon}</div>
                            
                            <c:if test="${s.soLuongTon > 0}">
                                <a href="banhang?action=addCart&maSach=${s.maSach}" class="btn-add-cart"><i class="fas fa-cart-plus"></i> Thêm vào giỏ</a>
                            </c:if>
                            <c:if test="${s.soLuongTon <= 0}">
                                <button class="btn-add-cart" style="background:#e2e8f0; color:#94a3b8; cursor:not-allowed;" disabled>Hết hàng</button>
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
            
            <div class="cart-list">
                <c:forEach var="item" items="${sessionScope.cart}">
                    <div class="cart-item">
                        <div class="cart-item-info">
                            <div class="cart-item-title">${item.tenSach}</div>
                            <div class="cart-item-price">
                                ${item.soLuong} x <fmt:formatNumber value="${item.donGia}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
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
                    <div style="text-align:center; color:#94a3b8; padding:40px 20px;">
                        <i class="fas fa-shopping-basket" style="font-size: 48px; color: #e2e8f0; margin-bottom: 15px; display: block;"></i>
                        Chưa có sản phẩm nào trong giỏ hàng.
                    </div>
                </c:if>
            </div>
            
            <div class="checkout-section">
                <form action="banhang" method="post">
                    <input type="hidden" name="action" value="checkout">
                    
                    <div class="checkout-group">
                        <label>KHÁCH HÀNG</label>
                        <select name="maKH" required>
                            <option value="">-- Chọn khách hàng --</option>
                            <c:forEach var="kh" items="${dsKhachHang}">
                                <option value="${kh.maKH}">${kh.hoTen} - ${kh.sdt}</option>
                            </c:forEach>
                        </select>
                        <div style="text-align:right; margin-top:5px;">
                            <a href="quanlykhachhang" style="font-size:12px; color:#2d6652; font-weight:600;"><i class="fas fa-plus"></i> Thêm khách hàng mới</a>
                        </div>
                    </div>
                    
                    <div class="checkout-group">
                        <label>GHI CHÚ HÓA ĐƠN</label>
                        <textarea rows="2" placeholder="Nhập ghi chú (nếu có)..."></textarea>
                    </div>
                    
                    <div class="checkout-total">
                        <span>Tạm tính:</span>
                        <span id="tamTinh"><fmt:formatNumber value="${tongTien}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                    </div>
                    <div class="checkout-total" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                        <span>Giảm giá:</span>
                        <div style="display: flex; align-items: center; gap: 5px;">
                            <input type="number" id="giamGia" name="giamGia" value="0" min="0" style="width: 80px; padding: 5px; border-radius: 4px; border: 1px solid #cbd5e1; text-align: right;" oninput="calculateTotal()">
                            <span>đ</span>
                        </div>
                    </div>
                    <div class="checkout-total final">
                        <span>Tổng cộng:</span>
                        <span id="tongCong"><fmt:formatNumber value="${tongTien}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></span>
                    </div>
                    
                    <div class="checkout-group">
                        <label>Phương thức thanh toán</label>
                        <select name="phuongThucTT" id="phuongThucTT" onchange="togglePaymentFields()">
                            <option value="TienMat">Tiền mặt</option>
                            <option value="ChuyenKhoan">Chuyển khoản</option>
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
                    
                    <button type="submit" class="btn-checkout" ${empty sessionScope.cart ? 'disabled' : ''}>
                        <i class="fas fa-check-circle"></i> THANH TOÁN & IN HĐ
                    </button>
                </form>
                
                <script>
                    const baseTotal = ${tongTien != null ? tongTien : 0};
                    
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
                        let giamGia = parseFloat(document.getElementById('giamGia').value) || 0;
                        let finalTotal = baseTotal - giamGia;
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

</body>
</html>
