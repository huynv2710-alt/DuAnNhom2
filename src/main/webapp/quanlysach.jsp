<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Kho Sách</title>
    <link rel="stylesheet" href="css/qlnv.css?v=2.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 2000; overflow-y: auto; }
        .modal-content { background: white; width: 500px; margin: 50px auto; padding: 25px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); }
        .modal-header { font-size: 22px; font-weight: bold; margin-bottom: 20px; color: #0f2820; border-bottom: 2px solid #2d6652; padding-bottom: 10px; }
        .form-group { margin-bottom: 15px; min-width: 0; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #333; }
        .form-group input, .form-group select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; outline: none; box-sizing: border-box; }
        .modal-footer { text-align: right; margin-top: 25px; }
        .btn-cancel { padding: 10px 15px; background: #ccc; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px; font-weight: bold; }
        .btn-save { padding: 10px 15px; background: #2d6652; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .product-thumb { width: 45px; height: 60px; object-fit: cover; border-radius: 4px; border: 1px solid #e2e8f0; }
        .product-thumb-placeholder { width: 45px; height: 60px; background: #f1f5f9; border-radius: 4px; display: flex; align-items: center; justify-content: center; font-size: 10px; color: #94a3b8; border: 1px solid #e2e8f0; }
        .product-thumb-placeholder { width: 45px; height: 60px; background: #f1f5f9; border-radius: 4px; display: flex; align-items: center; justify-content: center; font-size: 10px; color: #94a3b8; border: 1px solid #e2e8f0; }
        
        .toast { position: fixed; top: 20px; right: 20px; padding: 15px 25px; border-radius: 6px; color: white; font-weight: bold; box-shadow: 0 4px 12px rgba(0,0,0,0.15); z-index: 9999; opacity: 0; transform: translateY(-20px); transition: all 0.3s ease; }
        .toast.show { opacity: 1; transform: translateY(0); }
        .toast-success { background-color: #10b981; border-left: 5px solid #059669; }
        .toast-error { background-color: #ef4444; border-left: 5px solid #b91c1c; }
    </style>
</head>

<body>

<jsp:include page="menu.jsp"/>

<c:if test="${not empty param.success}">
    <div id="toast" class="toast toast-success">
        <i class="fas fa-check-circle"></i> 
        <c:choose>
            <c:when test="${param.success == 'add'}">Thêm sách thành công!</c:when>
            <c:when test="${param.success == 'edit'}">Cập nhật sách thành công!</c:when>
            <c:otherwise>Thao tác thành công!</c:otherwise>
        </c:choose>
    </div>
</c:if>
<c:if test="${not empty param.error}">
    <div id="toast" class="toast toast-error">
        <i class="fas fa-exclamation-circle"></i> Có lỗi xảy ra, vui lòng thử lại!
    </div>
</c:if>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        var toast = document.getElementById("toast");
        if (toast) {
            setTimeout(function() { toast.classList.add("show"); }, 100);
            setTimeout(function() { toast.classList.remove("show"); }, 4000);
        }
    });
</script>

<main class="content">

    <div class="header">
        <h1>Quản Lý Kho Sách</h1>
        <button class="btn-add" onclick="openAddModal()"><i class="fas fa-plus"></i> Thêm Sách Mới</button>
    </div>

    <form action="quanlysach" method="get">
        <div class="filter-card">
            <div class="filter-group" style="flex: 2;">
                <label>TÌM KIẾM</label>
                <input type="text" name="search" value="${search}" placeholder="Tên sách, mã sách..." style="width: 100%;">
            </div>
            <div class="filter-group" style="flex: 1;">
                <label>THỂ LOẠI</label>
                <select name="maTheLoai" style="padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
                    <option value="">-- Tất cả thể loại --</option>
                    <c:forEach var="parent" items="${listTL}">
                        <c:if test="${empty parent.maTheLoaiCha}">
                            <option value="${parent.maTheLoai}" style="font-weight: bold; background: #f8fafc;" ${param.maTheLoai == parent.maTheLoai ? 'selected' : ''}>■ ${parent.tenTheLoai}</option>
                            <c:forEach var="child" items="${listTL}">
                                <c:if test="${child.maTheLoaiCha == parent.maTheLoai}">
                                    <option value="${child.maTheLoai}" ${param.maTheLoai == child.maTheLoai ? 'selected' : ''}>&nbsp;&nbsp;&nbsp;&nbsp;↳ ${child.tenTheLoai}</option>
                                </c:if>
                            </c:forEach>
                        </c:if>
                    </c:forEach>
                </select>
            </div>
            <div class="filter-group" style="flex: 1;">
                <label>TÁC GIẢ</label>
                <select name="maTacGia" style="padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
                    <option value="0">-- Tất cả tác giả --</option>
                    <c:forEach var="tg" items="${listTG}">
                        <option value="${tg.maTacGia}" ${param.maTacGia == tg.maTacGia ? 'selected' : ''}>${tg.tenTacGia}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="filter-group" style="flex: 1;">
                <label>NHÀ XUẤT BẢN</label>
                <select name="maNXB" style="padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
                    <option value="0">-- Tất cả NXB --</option>
                    <c:forEach var="nxb" items="${listNXB}">
                        <option value="${nxb.maNXB}" ${param.maNXB == nxb.maNXB ? 'selected' : ''}>${nxb.tenNXB}</option>
                    </c:forEach>
                </select>
            </div>
            <button type="submit" class="btn-filter" style="margin-bottom: 2px;">Lọc</button>
            <a href="quanlysach" class="btn-reset" style="margin-bottom: 2px; display: inline-flex; align-items: center; justify-content: center; text-decoration: none;"><i class="fas fa-undo"></i></a>
        </div>
    </form>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th style="width: 60px; text-align: center;">BÌA SÁCH</th>
                    <th>TÊN SÁCH</th>
                    <th>TÁC GIẢ</th>
                    <th>THỂ LOẠI</th>
                    <th>NHÀ XUẤT BẢN</th>
                    <th>GIÁ NHẬP</th>
                    <th>GIÁ BÁN</th>
                    <th style="text-align: center;">TỒN KHO</th>
                    <th style="text-align: center;">TRẠNG THÁI</th>
                    <th style="text-align: center; width: 100px;">HÀNH ĐỘNG</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="s" items="${listSach}">
                    <tr>
                        <td style="text-align: center;">
                            <c:choose>
                                <c:when test="${not empty s.hinhAnh}">
                                    <img src="${s.hinhAnh}" class="product-thumb">
                                </c:when>
                                <c:otherwise>
                                    <div class="product-thumb-placeholder">No Img</div>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="font-weight: 600; color: #1e293b;">${s.tenSach}</td>
                        <td style="color: #64748b;">${s.tacGiaString}</td>
                        <td style="font-weight: 500; color: #0f2820;">
                            <c:set var="currentChild" value="${null}" />
                            <c:set var="currentParent" value="${null}" />
                            <c:forEach var="tl" items="${listTL}">
                                <c:if test="${tl.maTheLoai == s.maTheLoai}">
                                    <c:set var="currentChild" value="${tl}" />
                                </c:if>
                            </c:forEach>
                            <c:forEach var="tl" items="${listTL}">
                                <c:if test="${not empty currentChild and tl.maTheLoai == currentChild.maTheLoaiCha}">
                                    <c:set var="currentParent" value="${tl}" />
                                </c:if>
                            </c:forEach>
                            
                            <c:choose>
                                <c:when test="${not empty currentParent}">
                                    <div style="font-size: 13px;">
                                        <span style="color: #64748b;">${currentParent.tenTheLoai}</span>
                                        <span style="color: #cbd5e1; margin: 0 4px;">/</span>
                                        <span style="font-weight: 600; color: #0f2820;">${currentChild.tenTheLoai}</span>
                                    </div>
                                </c:when>
                                <c:when test="${not empty currentChild}">
                                    <span style="font-weight: 600; color: #0f2820;">${currentChild.tenTheLoai}</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="font-weight: 500; color: #0f2820;">${s.tenTheLoai}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="color: #64748b;">${s.tenNXB}</td>
                        <td style="font-weight: 600; color: #ca8a04;">
                            <fmt:formatNumber value="${s.giaNhap}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                        </td>
                        <td style="font-weight: 700; color: #2d6652;">
                            <fmt:formatNumber value="${s.giaBan}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                        </td>
                        <td style="text-align: center; font-weight: 600; color: #1e293b;">
                            ${s.soLuongTon}
                        </td>
                        <td style="text-align: center;">
                            <c:choose>
                                <c:when test="${s.trangThai == 0}">
                                    <span style="display:inline-block; padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 700; background:#fef2f2; color:#ef4444;">NGỪNG KD</span>
                                </c:when>
                                <c:when test="${s.soLuongTon <= 0}">
                                    <span style="display:inline-block; padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 700; background:#fff7ed; color:#ea580c;">HẾT HÀNG</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="display:inline-block; padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 700; background:#ecfdf5; color:#059669;">ĐANG BÁN</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="text-align: center; display: flex; gap: 8px; justify-content: center; align-items: center; border-bottom: none;">
                            <button title="Sửa" style="background: white; border: 1px solid #cbd5e1; padding: 6px 12px; border-radius: 6px; cursor: pointer; color: #334155; font-size: 13px; font-weight: 600; transition: all 0.3s ease; box-shadow: 0 2px 4px rgba(0,0,0,0.05);" onmouseover="this.style.background='#f1f5f9'; this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 6px rgba(0,0,0,0.1)';" onmouseout="this.style.background='white'; this.style.transform='translateY(0)'; this.style.boxShadow='0 2px 4px rgba(0,0,0,0.05)';"
                                onclick="openEditModal(${s.maSach}, '${s.tenSach}', '${s.tacGiaString}', '${s.isbn}', ${s.maTheLoai}, ${s.maNXB}, ${s.giaNhap}, ${s.giaBan}, ${s.soLuongTon}, '${s.hinhAnh}', ${s.trangThai}, ${s.soTrang}, '${s.kichThuoc}', ${s.trongLuong}, '${s.ngonNgu}', '${s.moTa}')">
                                Sửa
                            </button>
                            <button title="Chi tiết" style="background: #0ea5e9; border: none; padding: 6px 12px; border-radius: 6px; cursor: pointer; color: white; font-size: 13px; font-weight: 600; transition: all 0.3s ease; box-shadow: 0 2px 4px rgba(14,165,233,0.3);" onmouseover="this.style.background='#0284c7'; this.style.transform='translateY(-2px)'; this.style.boxShadow='0 4px 6px rgba(14,165,233,0.4)';" onmouseout="this.style.background='#0ea5e9'; this.style.transform='translateY(0)'; this.style.boxShadow='0 2px 4px rgba(14,165,233,0.3)';"
                                data-ten="${s.tenSach}" data-tg="${s.tacGiaString}" data-isbn="${s.isbn}" data-sotrang="${s.soTrang}" data-kt="${s.kichThuoc}" data-tl="${s.trongLuong}" data-nn="${s.ngonNgu}" data-mota="${s.moTa}" data-loai="${s.tenTheLoai}" data-nxb="${s.tenNXB}" data-gianhap="${s.giaNhap}" data-giaban="${s.giaBan}" data-ton="${s.soLuongTon}" data-img="${s.hinhAnh}"
                                onclick="openBookDetails(this)">
                                Chi tiết
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty listSach}">
                    <tr><td colspan="7" style="text-align:center; padding: 40px; color: #64748b;">Không tìm thấy sách nào!</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>

</main>

<!-- Modal Thêm/Sửa Sách -->
<div id="sachModal" class="modal">
    <div class="modal-content">
        <div class="modal-header" id="modalTitle">Thêm Sách Mới</div>
        <form action="quanlysach" method="post" id="bookForm" enctype="multipart/form-data" onsubmit="return validateSachForm()">
            <input type="hidden" name="action" id="formAction" value="add">
            <input type="hidden" name="maSach" id="maSach" value="0">
            
            <div style="display: flex; gap: 15px;">
                <div class="form-group" style="flex: 2;">
                    <label>Tên Sách <span style="color:red">*</span></label>
                    <input type="text" name="tenSach" id="tenSach" required>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>Mã ISBN</label>
                    <input type="text" name="isbn" id="isbn" placeholder="VD: 978-604-1-12345-6">
                </div>
            </div>
            <div class="form-group">
                <label>Tác Giả (Nhập tên, cách nhau bởi dấu phẩy)</label>
                <input type="text" name="tacGias" id="tacGias" required placeholder="VD: Nguyễn Nhật Ánh, Nam Cao">
            </div>
            <div style="display: flex; gap: 15px;">
                <div class="form-group" style="flex: 1;">
                    <label>Thể Loại <span style="color:red">*</span></label>
                    <select name="maTheLoai" id="maTheLoai" required>
                        <option value="">-- Chọn Thể Loại --</option>
                        <c:forEach var="parent" items="${listTL}">
                            <c:if test="${empty parent.maTheLoaiCha}">
                                <option value="${parent.maTheLoai}" style="font-weight: bold; background: #f8fafc;">■ ${parent.tenTheLoai}</option>
                                <c:forEach var="child" items="${listTL}">
                                    <c:if test="${child.maTheLoaiCha == parent.maTheLoai}">
                                        <option value="${child.maTheLoai}">&nbsp;&nbsp;&nbsp;&nbsp;↳ ${child.tenTheLoai}</option>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>Nhà Xuất Bản <span style="color:red">*</span></label>
                    <select name="maNXB" id="maNXB" required>
                        <c:forEach var="nxb" items="${listNXB}">
                            <option value="${nxb.maNXB}">${nxb.tenNXB}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div style="display: flex; gap: 15px;">
                <div class="form-group" style="flex: 1;">
                    <label>Giá Nhập (VNĐ) <span style="color:red">*</span></label>
                    <input type="number" id="giaNhap" name="giaNhap" min="0" step="100" required>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>Giá Bán (VNĐ) <span style="color:red">*</span></label>
                    <input type="number" id="giaBan" name="giaBan" min="0" step="100" required>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>Tồn Kho <span style="color:red">*</span></label>
                    <input type="number" id="soLuongTon" name="soLuongTon" min="0" required>
                </div>
            </div>
            <div style="display: flex; gap: 15px;">
                <div class="form-group" style="flex: 1;">
                    <label>Số Trang</label>
                    <input type="number" id="soTrang" name="soTrang" min="0">
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>Kích Thước</label>
                    <input type="text" id="kichThuoc" name="kichThuoc" placeholder="VD: 14 x 20 cm">
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>Trọng Lượng (g)</label>
                    <input type="number" id="trongLuong" name="trongLuong" min="0">
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>Ngôn Ngữ</label>
                    <input type="text" id="ngonNgu" name="ngonNgu" placeholder="Tiếng Việt">
                </div>
            </div>
            <div class="form-group">
                <label>Mô Tả Nội Dung</label>
                <textarea id="moTa" name="moTa" rows="3" style="width:100%; padding:10px; border:1px solid #ccc; border-radius:4px; outline:none; resize:vertical;"></textarea>
            </div>
            <div style="display: flex; gap: 15px;">
                <div class="form-group" style="flex: 1;">
                    <label>Link Ảnh Bìa (URL)</label>
                    <input type="text" id="hinhAnh" name="hinhAnh" placeholder="https://...">
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>Hoặc Tải Tệp Lên</label>
                    <input type="file" id="hinhAnhFile" name="hinhAnhFile" accept="image/*" style="width:100%; padding: 8px 10px; border:1px solid #ccc; border-radius:4px;">
                </div>
            </div>
            <div class="form-group">
                <label>Trạng Thái</label>
                <select name="trangThai" id="trangThai">
                    <option value="1">Đang bán</option>
                    <option value="0">Ngừng kinh doanh</option>
                </select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal()">Hủy</button>
                <button type="submit" class="btn-save">Lưu Sách</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openAddModal() {
        document.getElementById('modalTitle').innerText = 'Thêm Sách Mới';
        document.getElementById('formAction').value = 'add';
        document.getElementById('maSach').value = '0';
        document.getElementById('tenSach').value = '';
        
        document.getElementById('tacGias').value = '';
        
        document.getElementById('isbn').value = '';
        document.getElementById('giaNhap').value = '';
        document.getElementById('giaBan').value = '';
        document.getElementById('soLuongTon').value = '';
        document.getElementById('hinhAnh').value = '';
        document.getElementById('hinhAnhFile').value = '';
        document.getElementById('soTrang').value = '';
        document.getElementById('kichThuoc').value = '';
        document.getElementById('trongLuong').value = '';
        document.getElementById('ngonNgu').value = '';
        document.getElementById('moTa').value = '';
        document.getElementById('trangThai').value = '1';
        document.getElementById('sachModal').style.display = 'block';
    }

    function openEditModal(maSach, tenSach, tacGiaString, isbn, maTheLoai, maNXB, giaNhap, giaBan, soLuong, hinhAnh, trangThai, soTrang, kichThuoc, trongLuong, ngonNgu, moTa) {
        document.getElementById('modalTitle').innerText = 'Cập nhật Thông tin Sách';
        document.getElementById('formAction').value = 'edit';
        document.getElementById('maSach').value = maSach;
        document.getElementById('tenSach').value = tenSach;
        
        document.getElementById('tacGias').value = tacGiaString;
        
        document.getElementById('isbn').value = (isbn !== 'null' && isbn) ? isbn : '';
        document.getElementById('maTheLoai').value = maTheLoai;
        document.getElementById('maNXB').value = maNXB;
        document.getElementById('giaNhap').value = giaNhap;
        document.getElementById('giaBan').value = giaBan;
        document.getElementById('soLuongTon').value = soLuong;
        document.getElementById('hinhAnh').value = (hinhAnh !== 'null' && hinhAnh) ? hinhAnh : '';
        document.getElementById('hinhAnhFile').value = '';
        document.getElementById('soTrang').value = soTrang;
        document.getElementById('kichThuoc').value = (kichThuoc !== 'null' && kichThuoc) ? kichThuoc : '';
        document.getElementById('trongLuong').value = trongLuong;
        document.getElementById('ngonNgu').value = (ngonNgu !== 'null' && ngonNgu) ? ngonNgu : '';
        document.getElementById('moTa').value = (moTa !== 'null' && moTa) ? moTa : '';
        document.getElementById('trangThai').value = trangThai;
        document.getElementById('sachModal').style.display = 'block';
    }

    function closeModal() {
        document.getElementById('sachModal').style.display = 'none';
    }

    function openBookDetails(btn) {
        document.getElementById('detTenSach').innerText = btn.getAttribute('data-ten') || 'Không rõ';
        document.getElementById('detTacGia').innerText = btn.getAttribute('data-tg') || 'Không rõ';
        document.getElementById('detIsbn').innerText = (btn.getAttribute('data-isbn') !== 'null' && btn.getAttribute('data-isbn')) ? btn.getAttribute('data-isbn') : 'Chưa cập nhật';
        document.getElementById('detSoTrang').innerText = btn.getAttribute('data-sotrang') || '0';
        document.getElementById('detKichThuoc').innerText = (btn.getAttribute('data-kt') !== 'null' && btn.getAttribute('data-kt')) ? btn.getAttribute('data-kt') : 'Chưa cập nhật';
        document.getElementById('detTrongLuong').innerText = btn.getAttribute('data-tl') ? (btn.getAttribute('data-tl') + ' g') : '0 g';
        document.getElementById('detNgonNgu').innerText = (btn.getAttribute('data-nn') !== 'null' && btn.getAttribute('data-nn')) ? btn.getAttribute('data-nn') : 'Chưa cập nhật';
        document.getElementById('detMoTa').innerText = (btn.getAttribute('data-mota') !== 'null' && btn.getAttribute('data-mota')) ? btn.getAttribute('data-mota') : 'Chưa có mô tả';
        
        document.getElementById('detTheLoai').innerText = btn.getAttribute('data-loai') || 'Không rõ';
        document.getElementById('detNXB').innerText = btn.getAttribute('data-nxb') || 'Không rõ';
        
        let giaNhap = parseFloat(btn.getAttribute('data-gianhap')).toLocaleString('vi-VN') + ' đ';
        let giaBan = parseFloat(btn.getAttribute('data-giaban')).toLocaleString('vi-VN') + ' đ';
        document.getElementById('detGiaNhap').innerText = giaNhap;
        document.getElementById('detGiaBan').innerText = giaBan;
        document.getElementById('detTonKho').innerText = btn.getAttribute('data-ton') || '0';
        
        let imgUrl = btn.getAttribute('data-img');
        if (imgUrl && imgUrl !== 'null' && imgUrl.trim() !== '') {
            document.getElementById('detImage').src = imgUrl;
            document.getElementById('detImage').style.display = 'block';
            document.getElementById('detNoImage').style.display = 'none';
        } else {
            document.getElementById('detImage').style.display = 'none';
            document.getElementById('detNoImage').style.display = 'flex';
        }

        document.getElementById('bookDetailsModal').style.display = 'block';
    }

    function validateSachForm() {
        let giaNhap = parseFloat(document.getElementById('giaNhap').value);
        let giaBan = parseFloat(document.getElementById('giaBan').value);
        
        if (isNaN(giaNhap) || giaNhap <= 0) {
            alert("Lỗi: Giá nhập phải lớn hơn 0!");
            return false;
        }
        if (isNaN(giaBan) || giaBan <= 0) {
            alert("Lỗi: Giá bán phải lớn hơn 0!");
            return false;
        }
        if (giaBan <= giaNhap) {
            alert("Lỗi: Giá bán phải LỚN HƠN giá nhập!");
            return false;
        }
        if (giaNhap % 100 !== 0 || giaBan % 100 !== 0) {
            alert("Lỗi: Giá tiền phải làm tròn đến hàng trăm đồng (VD: 12000, 15500)!");
            return false;
        }
        return true;
    }
</script>

<!-- Modal Chi Tiết Sách -->
<div id="bookDetailsModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:2000;">
    <div style="background:white; width:600px; margin:100px auto; padding:25px; border-radius:8px; box-shadow:0 4px 15px rgba(0,0,0,0.2);">
        <h2 style="color:#00897b; border-bottom:2px solid #00897b; padding-bottom:10px; margin-bottom:20px;">Chi Tiết Sách</h2>
        
        <div style="display: flex; gap: 20px;">
            <div style="width: 150px; flex-shrink: 0;">
                <img id="detImage" src="" style="width: 100%; border-radius: 6px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); display: none;">
                <div id="detNoImage" style="width: 100%; height: 200px; background: #f1f5f9; border-radius: 6px; display: flex; align-items: center; justify-content: center; color: #94a3b8; font-weight: bold;">No Image</div>
            </div>
            <div style="flex: 1;">
                <div style="font-size: 20px; font-weight: bold; color: #1e293b; margin-bottom: 5px;" id="detTenSach"></div>
                <div style="color: #64748b; margin-bottom: 15px;" id="detTacGia"></div>
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; font-size: 14px;">
                    <div style="grid-column: span 2;"><span style="color:#64748b; font-weight:bold;">Thể Loại:</span> <span id="detTheLoai"></span></div>
                    <div style="grid-column: span 2;"><span style="color:#64748b; font-weight:bold;">Nhà Xuất Bản:</span> <span id="detNXB"></span></div>
                    
                    <div><span style="color:#64748b; font-weight:bold;">Giá Nhập:</span> <span id="detGiaNhap" style="color:#ca8a04; font-weight:bold;"></span></div>
                    <div><span style="color:#64748b; font-weight:bold;">Giá Bán:</span> <span id="detGiaBan" style="color:#2d6652; font-weight:bold;"></span></div>
                    
                    <div><span style="color:#64748b; font-weight:bold;">Tồn Kho:</span> <span id="detTonKho" style="font-weight:bold;"></span></div>
                    <div><span style="color:#64748b; font-weight:bold;">Mã ISBN:</span> <span id="detIsbn"></span></div>
                    
                    <div><span style="color:#64748b; font-weight:bold;">Số Trang:</span> <span id="detSoTrang"></span></div>
                    <div><span style="color:#64748b; font-weight:bold;">Kích Thước:</span> <span id="detKichThuoc"></span></div>
                    
                    <div><span style="color:#64748b; font-weight:bold;">Trọng Lượng:</span> <span id="detTrongLuong"></span></div>
                    <div><span style="color:#64748b; font-weight:bold;">Ngôn Ngữ:</span> <span id="detNgonNgu"></span></div>
                </div>
                
                <div style="margin-top: 15px;">
                    <div style="color:#64748b; font-weight:bold; margin-bottom:5px;">Mô Tả:</div>
                    <div id="detMoTa" style="font-size: 13px; color: #334155; line-height: 1.5; background: #f8fafc; padding: 10px; border-radius: 6px; max-height: 100px; overflow-y: auto;"></div>
                </div>
            </div>
        </div>
        
        <div style="text-align: right; margin-top: 25px;">
            <button onclick="document.getElementById('bookDetailsModal').style.display='none'" style="padding:10px 20px; background:#e2e8f0; border:none; border-radius:6px; cursor:pointer; font-weight:bold;">Đóng</button>
        </div>
    </div>
</div>

</body>
</html>
