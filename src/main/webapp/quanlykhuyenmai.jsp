<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Khuyến Mãi</title>
    <link rel="stylesheet" href="css/nv.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        .modal {
            display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%;
            overflow: auto; background-color: rgba(0,0,0,0.5);
        }
        .modal-content {
            background-color: #fefefe; margin: 5% auto; padding: 20px; border: 1px solid #888;
            width: 50%; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .close { color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer; }
        .close:hover { color: black; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 5px; }
        .form-group input, .form-group select { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
        .btn { padding: 8px 15px; border: none; border-radius: 4px; cursor: pointer; color: white; }
        .btn-add { background-color: #00897b; }
        .btn-edit { background-color: #ff9800; }
        .btn-toggle { background-color: #f44336; }
        .btn-active { background-color: #4CAF50; }
        .action-btns { display: flex; gap: 5px; }
    </style>
</head>
<body>

<jsp:include page="menu.jsp"/>

<main class="content">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        <h1 class="title">QUẢN LÝ KHUYẾN MÃI</h1>
        <button class="btn btn-add" onclick="openModal('add')">+ Thêm Khuyến Mãi</button>
    </div>

    <table class="table">
        <thead>
        <tr>
            <th>Mã KM</th>
            <th>Tên Khuyến Mãi</th>
            <th>% Giảm</th>
            <th>Ngày Bắt Đầu</th>
            <th>Ngày Kết Thúc</th>
            <th>Trạng Thái</th>
            <th>Hành Động</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="km" items="${dsKhuyenMai}">
            <tr>
                <td>#KM${km.maKM}</td>
                <td>${km.tenKM}</td>
                <td><fmt:formatNumber value="${km.phanTramGiam}" maxFractionDigits="0"/>%</td>
                <td><fmt:formatDate value="${km.ngayBatDau}" pattern="dd/MM/yyyy HH:mm"/></td>
                <td><fmt:formatDate value="${km.ngayKetThuc}" pattern="dd/MM/yyyy HH:mm"/></td>
                <td>
                    <span style="color: ${km.trangThai == 1 ? 'green' : 'red'}; font-weight: bold;">
                        ${km.trangThai == 1 ? 'Đang hoạt động' : 'Ngừng áp dụng'}
                    </span>
                </td>
                <td>
                    <div class="action-btns">
                        <button class="btn btn-edit" onclick="openModal('edit', ${km.maKM}, '${km.tenKM}', ${km.phanTramGiam}, '${km.ngayBatDau}', '${km.ngayKetThuc}', ${km.trangThai})">Sửa</button>
                        <form action="quanlykhuyenmai" method="post" style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn đổi trạng thái mã này?');">
                            <input type="hidden" name="action" value="toggle">
                            <input type="hidden" name="maKM" value="${km.maKM}">
                            <button type="submit" class="btn ${km.trangThai == 1 ? 'btn-toggle' : 'btn-active'}">
                                ${km.trangThai == 1 ? 'Tắt' : 'Bật'}
                            </button>
                        </form>
                    </div>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</main>

<!-- Modal Thêm/Sửa Khuyến Mãi -->
<div id="kmModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <h2 id="modalTitle">Thêm Khuyến Mãi</h2>
        <form action="quanlykhuyenmai" method="post" onsubmit="return validateForm()">
            <input type="hidden" id="action" name="action" value="add">
            <input type="hidden" id="maKM" name="maKM" value="">

            <div class="form-group">
                <label>Tên Khuyến Mãi</label>
                <input type="text" id="tenKM" name="tenKM" required>
            </div>
            <div class="form-group">
                <label>Phần Trăm Giảm (%)</label>
                <input type="number" id="phanTramGiam" name="phanTramGiam" min="1" max="90" required>
            </div>
            <div class="form-group">
                <label>Thời Gian Bắt Đầu</label>
                <input type="datetime-local" id="ngayBatDau" name="ngayBatDau" required>
            </div>
            <div class="form-group">
                <label>Thời Gian Kết Thúc</label>
                <input type="datetime-local" id="ngayKetThuc" name="ngayKetThuc" required>
            </div>
            <div class="form-group">
                <label>Trạng Thái</label>
                <select id="trangThai" name="trangThai">
                    <option value="1">Hoạt động</option>
                    <option value="0">Ngừng áp dụng</option>
                </select>
            </div>

            <div style="text-align: right; margin-top: 20px;">
                <button type="button" class="btn" style="background-color:#ccc; color:black;" onclick="closeModal()">Hủy</button>
                <button type="submit" class="btn btn-add" id="btnSubmit">Lưu</button>
            </div>
        </form>
    </div>
</div>

<script>
    function formatDateForInput(dateStr) {
        if(!dateStr) return '';
        let d = new Date(dateStr);
        let pad = (n) => n < 10 ? '0'+n : n;
        return d.getFullYear() + '-' + pad(d.getMonth()+1) + '-' + pad(d.getDate()) + 'T' + pad(d.getHours()) + ':' + pad(d.getMinutes());
    }

    function openModal(type, id, ten, phanTram, start, end, status) {
        document.getElementById('kmModal').style.display = "block";
        if (type === 'add') {
            document.getElementById('modalTitle').innerText = "Thêm Khuyến Mãi Mới";
            document.getElementById('action').value = "add";
            document.getElementById('maKM').value = "";
            document.getElementById('tenKM').value = "";
            document.getElementById('phanTramGiam').value = "";
            document.getElementById('ngayBatDau').value = "";
            document.getElementById('ngayKetThuc').value = "";
            document.getElementById('trangThai').value = "1";
        } else {
            document.getElementById('modalTitle').innerText = "Cập Nhật Khuyến Mãi";
            document.getElementById('action').value = "update";
            document.getElementById('maKM').value = id;
            document.getElementById('tenKM').value = ten;
            document.getElementById('phanTramGiam').value = phanTram;
            document.getElementById('ngayBatDau').value = formatDateForInput(start);
            document.getElementById('ngayKetThuc').value = formatDateForInput(end);
            document.getElementById('trangThai').value = status;
        }
    }

    function closeModal() {
        document.getElementById('kmModal').style.display = "none";
    }

    function validateForm() {
        let start = new Date(document.getElementById('ngayBatDau').value);
        let end = new Date(document.getElementById('ngayKetThuc').value);
        if (end <= start) {
            Swal.fire('Lỗi', 'Thời gian kết thúc phải lớn hơn thời gian bắt đầu!', 'error');
            return false;
        }
        return true;
    }

    <c:if test="${not empty sessionScope.error}">
        Swal.fire({ icon: 'error', title: 'Lỗi', text: '${sessionScope.error}' });
        <c:remove var="error" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.success}">
        Swal.fire({ icon: 'success', title: 'Thành công', text: '${sessionScope.success}' });
        <c:remove var="success" scope="session"/>
    </c:if>
</script>
</body>
</html>
