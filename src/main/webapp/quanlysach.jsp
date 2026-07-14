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
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #333; }
        .form-group input, .form-group select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; outline: none; box-sizing: border-box; }
        .modal-footer { text-align: right; margin-top: 25px; }
        .btn-cancel { padding: 10px 15px; background: #ccc; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px; font-weight: bold; }
        .btn-save { padding: 10px 15px; background: #2d6652; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .product-thumb { width: 45px; height: 60px; object-fit: cover; border-radius: 4px; border: 1px solid #e2e8f0; }
        .product-thumb-placeholder { width: 45px; height: 60px; background: #f1f5f9; border-radius: 4px; display: flex; align-items: center; justify-content: center; font-size: 10px; color: #94a3b8; border: 1px solid #e2e8f0; }
    </style>
</head>

<body>

<jsp:include page="menu.jsp"/>

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
                <select>
                    <option>-- Tất cả thể loại --</option>
                    <c:forEach var="tl" items="${listTL}">
                        <option value="${tl.maTheLoai}">${tl.tenTheLoai}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="filter-group" style="flex: 1;">
                <label>TÁC GIẢ</label>
                <input type="text" placeholder="Tên tác giả...">
            </div>
            <div class="filter-group" style="flex: 1;">
                <label>NHÀ XUẤT BẢN</label>
                <select>
                    <option>-- Tất cả NXB --</option>
                    <c:forEach var="nxb" items="${listNXB}">
                        <option value="${nxb.maNXB}">${nxb.tenNXB}</option>
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
                        <td style="color: #64748b;">${s.tacGia}</td>
                        <td style="font-weight: 500; color: #0f2820;">${s.tenTheLoai}</td>
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
                            <span style="display:inline-block; padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 700; ${s.trangThai == 1 ? 'background:#ecfdf5; color:#059669;' : 'background:#fef2f2; color:#ef4444;'}">
                                ${s.trangThai == 1 ? 'ĐANG BÁN' : 'NGỪNG KD'}
                            </span>
                        </td>
                        <td style="text-align: center;">
                            <button class="btn-edit" title="Sửa"
                                onclick="openEditModal(${s.maSach}, '${s.tenSach}', '${s.tacGia}', '${s.isbn}', ${s.maTheLoai}, ${s.maNXB}, ${s.giaNhap}, ${s.giaBan}, ${s.soLuongTon}, '${s.hinhAnh}', ${s.trangThai})">
                                <i class="fas fa-edit"></i>
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
        <form action="quanlysach" method="post" onsubmit="return validateSach()">
            <input type="hidden" name="action" id="formAction" value="add">
            <input type="hidden" name="maSach" id="maSach" value="0">
            
            <div style="display: flex; gap: 15px;">
                <div class="form-group" style="flex: 2;">
                    <label>Tên Sách <span style="color:red">*</span></label>
                    <input type="text" id="tenSach" name="tenSach" required>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>Mã ISBN</label>
                    <input type="text" id="isbn" name="isbn">
                </div>
            </div>
            <div class="form-group">
                <label>Tác Giả</label>
                <input type="text" id="tacGia" name="tacGia">
            </div>
            <div style="display: flex; gap: 15px;">
                <div class="form-group" style="flex: 1;">
                    <label>Thể Loại <span style="color:red">*</span></label>
                    <select name="maTheLoai" id="maTheLoai" required>
                        <c:forEach var="tl" items="${listTL}">
                            <option value="${tl.maTheLoai}">${tl.tenTheLoai}</option>
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
                    <input type="number" id="giaNhap" name="giaNhap" min="0" required oninput="validateSach()">
                    <span id="errGiaNhap" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>Giá Bán (VNĐ) <span style="color:red">*</span></label>
                    <input type="number" id="giaBan" name="giaBan" min="0" required oninput="validateSach()">
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>Tồn Kho <span style="color:red">*</span></label>
                    <input type="number" id="soLuongTon" name="soLuongTon" min="0" required oninput="validateSach()">
                    <span id="errSoLuong" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
                </div>
            </div>
            <div class="form-group">
                <label>Link Ảnh Bìa (URL)</label>
                <input type="text" id="hinhAnh" name="hinhAnh" placeholder="https://...">
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
        document.getElementById('tacGia').value = '';
        document.getElementById('isbn').value = '';
        document.getElementById('giaNhap').value = '';
        document.getElementById('giaBan').value = '';
        document.getElementById('soLuongTon').value = '';
        document.getElementById('hinhAnh').value = '';
        document.getElementById('trangThai').value = '1';
        document.getElementById('sachModal').style.display = 'block';
    }

    function openEditModal(maSach, tenSach, tacGia, isbn, maTheLoai, maNXB, giaNhap, giaBan, soLuong, hinhAnh, trangThai) {
        document.getElementById('modalTitle').innerText = 'Cập nhật Thông tin Sách';
        document.getElementById('formAction').value = 'edit';
        document.getElementById('maSach').value = maSach;
        document.getElementById('tenSach').value = tenSach;
        document.getElementById('tacGia').value = tacGia;
        document.getElementById('isbn').value = (isbn !== 'null' && isbn) ? isbn : '';
        document.getElementById('maTheLoai').value = maTheLoai;
        document.getElementById('maNXB').value = maNXB;
        document.getElementById('giaNhap').value = giaNhap;
        document.getElementById('giaBan').value = giaBan;
        document.getElementById('soLuongTon').value = soLuong;
        document.getElementById('hinhAnh').value = hinhAnh;
        document.getElementById('trangThai').value = trangThai;
        document.getElementById('sachModal').style.display = 'block';
    }

    function closeModal() {
        document.getElementById('sachModal').style.display = 'none';
        document.getElementById('errGiaNhap').style.display = 'none';
        document.getElementById('errSoLuong').style.display = 'none';
        document.querySelector('#sachModal .btn-save').disabled = false;
    }

    function validateSach() {
        let isValid = true;
        let giaNhap = parseFloat(document.getElementById('giaNhap').value);
        let giaBan = parseFloat(document.getElementById('giaBan').value);
        let soLuongTon = parseInt(document.getElementById('soLuongTon').value);

        if (!isNaN(giaNhap) && !isNaN(giaBan)) {
            if (giaNhap >= giaBan) {
                document.getElementById('errGiaNhap').innerText = "Giá nhập phải nhỏ hơn giá bán";
                document.getElementById('errGiaNhap').style.display = 'block';
                isValid = false;
            } else {
                document.getElementById('errGiaNhap').style.display = 'none';
            }
        }
        
        if (!isNaN(soLuongTon) && soLuongTon < 0) {
            document.getElementById('errSoLuong').innerText = "Tồn kho không được âm";
            document.getElementById('errSoLuong').style.display = 'block';
            isValid = false;
        } else {
            document.getElementById('errSoLuong').style.display = 'none';
        }

        const btnSave = document.querySelector('#sachModal .btn-save');
        if (btnSave) btnSave.disabled = !isValid;
        
        return isValid;
    }
</script>

</body>
</html>
