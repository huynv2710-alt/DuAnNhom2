<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý nhân viên</title>
    <link rel="stylesheet" href="css/qlnv.css?v=2.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .contact-info { font-size: 13px; color: #64748b; margin-top: 4px; }
        .main-info { font-weight: 600; color: #1e293b; font-size: 14px; }
    </style>
</head>

<body>
<%
    String successMsg = (String) session.getAttribute("successMsg");
    if (successMsg != null) {
%>
    <script>
        alert("<%= successMsg %>");
    </script>
<%
        session.removeAttribute("successMsg");
    }
%>

<jsp:include page="menu.jsp"/>

<main class="content">

    <div class="header">
        <h1>Quản Lý Nhân Viên</h1>
        <a href="themnhanvien.jsp" class="btn-add">
            <i class="fas fa-plus"></i> Thêm Nhân Viên Mới
        </a>
    </div>

    <!-- Tạm thời ẩn thanh tìm kiếm vì chưa có code search backend
    <div class="filter-card">
        <div class="filter-group" style="flex: 1;">
            <label>TÌM KIẾM NHÂN VIÊN</label>
            <input type="text" placeholder="Tên, SĐT, Email...">
        </div>
        <button class="btn-filter" style="margin-bottom: 2px;">Lọc</button>
    </div>
    -->

    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th style="text-align: center;">Mã NV</th>
                <th>Họ Tên</th>
                <th>Giới Tính</th>
                <th>Ngày Sinh</th>
                <th>Điện Thoại</th>
                <th>Email</th>
                <th>Địa Chỉ</th>
                <th style="text-align: center;">Trạng Thái</th>
                <th style="text-align: center;">Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="nv" items="${lst}">
                <tr>
                    <td style="text-align: center; font-weight: bold;">#${nv.maNV}</td>
                    <td style="font-weight: 600;">${nv.hoTen}</td>
                    <td>${nv.gioiTinh}</td>
                    <td>${nv.ngaySinh}</td>
                    <td>${nv.sdt}</td>
                    <td>${nv.email}</td>
                    <td>${nv.diaChi}</td>
                    <td style="text-align: center;">
                        <span style="display:inline-block; padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 700; 
                            ${nv.maTrangThai == 1 ? 'background:#ecfdf5; color:#059669;' : 
                              nv.maTrangThai == 2 ? 'background:#fffbeb; color:#d97706;' : 
                              'background:#fef2f2; color:#ef4444;'}">
                            ${nv.maTrangThai == 1 ? 'ĐANG LÀM VIỆC' : (nv.maTrangThai == 2 ? 'THỬ VIỆC' : 'NGHỈ VIỆC')}
                        </span>
                    </td>
                    <td style="text-align: center; display: flex; gap: 8px; justify-content: center; align-items: center; border-bottom: none;">
                        <a href="suanhanvien?action=edit&id=${nv.maNV}" class="btn-edit" style="text-decoration: none;" title="Sửa thông tin">
                            Sửa
                        </a>
                        <button onclick="openDetailsModal('${nv.hoTen}', '${nv.cccd}', '${nv.ngayCapCCCD}', '${nv.dacDiemNhanDang}')" class="btn-edit" style="text-decoration: none;" title="Xem chi tiết">
                            Chi tiết
                        </button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty lst}">
                <tr><td colspan="9" style="text-align:center; padding: 40px; color: #64748b;">Không có dữ liệu nhân viên!</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

</main>

<!-- Modal Chi Tiết -->
<div id="detailsModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:2000;">
    <div style="background:white; width:450px; margin:100px auto; padding:25px; border-radius:8px; box-shadow:0 4px 15px rgba(0,0,0,0.2);">
        <h2 style="color:#00897b; border-bottom:2px solid #00897b; padding-bottom:10px; margin-bottom:20px;">Chi Tiết Nhân Viên</h2>
        <div style="margin-bottom: 15px;">
            <label style="font-weight: bold; color: #64748b; font-size: 13px;">Họ và tên</label>
            <div id="detHoTen" style="font-size: 15px; font-weight: 600; color: #1e293b; margin-top: 5px;"></div>
        </div>
        <div style="margin-bottom: 15px;">
            <label style="font-weight: bold; color: #64748b; font-size: 13px;">Số CCCD</label>
            <div id="detCCCD" style="font-size: 15px; color: #1e293b; margin-top: 5px;"></div>
        </div>
        <div style="margin-bottom: 15px;">
            <label style="font-weight: bold; color: #64748b; font-size: 13px;">Ngày cấp CCCD</label>
            <div id="detNgayCap" style="font-size: 15px; color: #1e293b; margin-top: 5px;"></div>
        </div>
        <div style="margin-bottom: 25px;">
            <label style="font-weight: bold; color: #64748b; font-size: 13px;">Đặc điểm nhận dạng</label>
            <div id="detDacDiem" style="font-size: 15px; color: #1e293b; margin-top: 5px;"></div>
        </div>
        <div style="text-align: right;">
            <button onclick="document.getElementById('detailsModal').style.display='none'" style="padding:10px 20px; background:#e2e8f0; color:#334155; border:none; border-radius:6px; cursor:pointer; font-weight:bold;">Đóng</button>
        </div>
    </div>
</div>

<script>
    function openDetailsModal(hoten, cccd, ngaycap, dacdiem) {
        document.getElementById('detHoTen').innerText = hoten;
        document.getElementById('detCCCD').innerText = cccd;
        document.getElementById('detNgayCap').innerText = ngaycap;
        document.getElementById('detDacDiem').innerText = dacdiem;
        document.getElementById('detailsModal').style.display = 'block';
    }
</script>

</body>
</html>