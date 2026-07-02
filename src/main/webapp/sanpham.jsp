<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Menu - Book Store</title>
    <link rel="stylesheet" href="css/sp.css">
    <style>
        body {
                    display: block !important;
                    background: #f4f4f4;
                }
                .content {
                    margin-left: 260px;
                    padding: 25px;
                    display: flex;
                    flex-direction: column;
                    gap: 20px;
                    min-height: 100vh;
                    box-sizing: border-box;
                }
                .main-layout {
                    display: flex;
                    gap: 20px;
                    flex: 1;
                }
                .book-panel {
                    flex: 1.5;
                    min-height: 500px;
                }
                .book-table-wrap {
                    max-height: calc(100vh - 200px);
                    overflow-y: auto;
                }
                .cart-panel {
                    width: 320px;
                    flex-shrink: 0;
                }
                .cart-box {
                    max-height: calc(100vh - 350px);
                    min-height: 200px;
                }
    </style>
</head>
<body>

<jsp:include page="menu2.jsp"/>

<main class="content">

    <h1 class="page-title">📄 LẬP HÓA ĐƠN</h1>

    <div class="main-layout">

        <!-- DANH SÁCH SÁCH -->
        <div class="book-panel">
            <div class="panel-header">
                <h2>📚 Danh sách sách</h2>
            </div>
            <div class="book-table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>Mã sách</th>
                            <th>Tên sách</th>
                            <th>Tác giả</th>
                            <th>Thể loại</th>
                            <th>Đơn giá</th>
                            <th>Tồn kho</th>
                            <th>Thêm</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty dsSach}">
                                <c:forEach var="s" items="${dsSach}">
                                    <tr>
                                        <td>${s.maSach}</td>
                                        <td class="td-name">${s.tenSach}</td>
                                        <td>${s.tacGia}</td>
                                        <td>${s.theLoai}</td>
                                        <td class="td-price">${s.donGia}đ</td>
                                        <td>${s.tonKho}</td>
                                        <td>
                                            <button class="btn-add"
                                                onclick="addToCart('${s.maSach}','${s.tenSach}',${s.donGia},${s.tonKho})">
                                                + Thêm
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <%-- Dữ liệu mẫu --%>
                                <tr><td>S001</td><td class="td-name">Lập trình Java căn bản</td><td>Nguyễn Văn A</td><td>Công nghệ</td><td class="td-price">120.000đ</td><td>50</td><td><button class="btn-add" onclick="addToCart('S001','Lập trình Java căn bản',120000,50)">+ Thêm</button></td></tr>
                                <tr><td>S002</td><td class="td-name">Đắc nhân tâm</td><td>Dale Carnegie</td><td>Kỹ năng sống</td><td class="td-price">85.000đ</td><td>120</td><td><button class="btn-add" onclick="addToCart('S002','Đắc nhân tâm',85000,120)">+ Thêm</button></td></tr>
                                <tr><td>S003</td><td class="td-name">Nhà giả kim</td><td>Paulo Coelho</td><td>Văn học</td><td class="td-price">95.000đ</td><td>80</td><td><button class="btn-add" onclick="addToCart('S003','Nhà giả kim',95000,80)">+ Thêm</button></td></tr>
                                <tr><td>S004</td><td class="td-name">Harry Potter và Hòn Đá Phù Thủy</td><td>J.K. Rowling</td><td>Văn học</td><td class="td-price">140.000đ</td><td>35</td><td><button class="btn-add" onclick="addToCart('S004','Harry Potter và Hòn Đá Phù Thủy',140000,35)">+ Thêm</button></td></tr>
                                <tr><td>S005</td><td class="td-name">Toán rời rạc ứng dụng tin học</td><td>Nguyễn Thị B</td><td>Giáo khoa</td><td class="td-price">75.000đ</td><td>60</td><td><button class="btn-add" onclick="addToCart('S005','Toán rời rạc ứng dụng tin học',75000,60)">+ Thêm</button></td></tr>
                                <tr><td>S006</td><td class="td-name">Tâm lý học đám đông</td><td>Gustave Le Bon</td><td>Tâm lý</td><td class="td-price">68.000đ</td><td>90</td><td><button class="btn-add" onclick="addToCart('S006','Tâm lý học đám đông',68000,90)">+ Thêm</button></td></tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- GIỎ HÀNG -->
        <div class="cart-panel">
            <div class="cart-box">
                <div class="cart-header">
                    <h2>🛒 Giỏ hàng (<span id="cartCount">0</span>)</h2>
                    <button class="btn-clear" onclick="clearCart()">🗑 Xóa</button>
                </div>
                <div class="cart-list" id="cartList">
                    <div class="cart-empty" id="cartEmpty">Chưa có sách nào</div>
                </div>
            </div>

            <div class="summary-box">
                <div class="summary-row">
                    <span>Số lượng:</span>
                    <span id="sumQty">0 cuốn</span>
                </div>
                <div class="summary-total">
                    <span>TỔNG TIỀN:</span>
                    <span id="sumTotal">0đ</span>
                </div>

                <div class="customer-section">
                    <label>Tên khách hàng</label>
                    <input type="text" id="tenKH" placeholder="Nhập tên khách hàng...">
                    <label>Số điện thoại</label>
                    <input type="text" id="sdtKH" placeholder="Nhập số điện thoại...">
                </div>

                <button class="btn-confirm" id="btnConfirm" onclick="confirmOrder()" disabled>
                    ✅ Xác nhận hóa đơn
                </button>
            </div>
        </div>

    </div>
</main>

<div class="toast" id="toast"></div>

<script>
    var cart = {};

    function addToCart(id, ten, gia, ton) {
        gia = Number(gia);
        ton = Number(ton);
        if (cart[id]) {
            if (cart[id].soLuong >= ton) {
                showToast('Không đủ tồn kho!', '#e53935');
                return;
            }
            cart[id].soLuong++;
        } else {
            cart[id] = { id: id, ten: ten, gia: gia, soLuong: 1, tonKho: ton };
        }
        renderCart();
        showToast('Đã thêm: ' + ten);
    }

    function changeQty(id, delta) {
        if (!cart[id]) return;
        cart[id].soLuong += delta;
        if (cart[id].soLuong <= 0) {
            delete cart[id];
        } else if (cart[id].soLuong > cart[id].tonKho) {
            cart[id].soLuong = cart[id].tonKho;
            showToast('Đã đạt tối đa tồn kho!', '#e65100');
        }
        renderCart();
    }

    function removeItem(id) {
        delete cart[id];
        renderCart();
    }

    function clearCart() {
        cart = {};
        renderCart();
    }

    function renderCart() {
        var list    = document.getElementById('cartList');
        var empty   = document.getElementById('cartEmpty');
        var keys    = Object.keys(cart);
        var total   = 0;
        var totalQty = 0;

        list.innerHTML = '';

        if (keys.length === 0) {
            empty.style.display = 'block';
            list.appendChild(empty);
        } else {
            empty.style.display = 'none';
            for (var i = 0; i < keys.length; i++) {
                var item = cart[keys[i]];
                var sub  = item.gia * item.soLuong;
                total    += sub;
                totalQty += item.soLuong;

                var div = document.createElement('div');
                div.className = 'cart-item';
                div.innerHTML =
                    '<div class="cart-item-name">' + item.ten + '</div>' +
                    '<div class="qty-ctrl">' +
                        '<button class="qty-btn" onclick="changeQty(\'' + item.id + '\',-1)">-</button>' +
                        '<span class="qty-num">' + item.soLuong + '</span>' +
                        '<button class="qty-btn" onclick="changeQty(\'' + item.id + '\',1)">+</button>' +
                    '</div>' +
                    '<div class="cart-item-price">' + fmtNum(sub) + 'đ</div>' +
                    '<button class="btn-remove" onclick="removeItem(\'' + item.id + '\')" title="Xóa">✕</button>';
                list.appendChild(div);
            }
        }

        document.getElementById('cartCount').textContent = keys.length;
        document.getElementById('sumQty').textContent    = totalQty + ' cuốn';
        document.getElementById('sumTotal').textContent  = fmtNum(total) + 'đ';
        document.getElementById('btnConfirm').disabled   = keys.length === 0;
    }

    function confirmOrder() {
        var tenKH = document.getElementById('tenKH').value.trim() || 'Khách lẻ';
        showToast('Hóa đơn cho ' + tenKH + ' đã xác nhận!');
        // TODO: gửi dữ liệu về servlet để lưu DB
    }

    function fmtNum(n) {
        return Number(n).toLocaleString('vi-VN');
    }

    function showToast(msg, color) {
        var t = document.getElementById('toast');
        t.textContent = msg;
        t.style.background = color || '#00897b';
        t.classList.add('show');
        setTimeout(function(){ t.classList.remove('show'); }, 2200);
    }
</script>

</body>
</html>