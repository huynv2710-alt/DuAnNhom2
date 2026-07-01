<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page isELIgnored="false"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thông tin cá nhân</title>
    <link rel="stylesheet" href="css/nv.css">
</head>

<body>

<jsp:include page="menu.jsp"/>

<main class="content">

    <div class="page-header">
        <h1>Thông Tin Cá Nhân</h1>
        <p>Xin chào ${nv.hoTen} 👋</p>
    </div>

    <div class="welcome-card">

        <div class="welcome-avatar">
            ${fn:substring(nv.hoTen,0,1)}
        </div>

        <div class="welcome-text">
            <h2>${nv.hoTen}</h2>
            <p>
                Mã nhân viên:
                <strong>${nv.maNV}</strong>
            </p>
        </div>

        <div class="welcome-badge">
            ${nv.tenTrangThai}
        </div>

    </div>

    <div class="info-card">

        <h2>👤 Thông Tin Cá Nhân</h2>

        <div class="info-grid">

            <div class="info-item">
                <label>Mã nhân viên</label>
                <span>${nv.maNV}</span>
            </div>

            <div class="info-item">
                <label>Họ và tên</label>
                <span>${nv.hoTen}</span>
            </div>

            <div class="info-item">
                <label>Ngày sinh</label>
                <span>${nv.ngaySinh}</span>
            </div>

            <div class="info-item">
                <label>Giới tính</label>
                <span>${nv.gioiTinh}</span>
            </div>

            <div class="info-item">
                <label>Số điện thoại</label>
                <span>${nv.sdt}</span>
            </div>

            <div class="info-item">
                <label>Email</label>
                <span>${nv.email}</span>
            </div>

            <div class="info-item">
                <label>Địa chỉ</label>
                <span>${nv.diaChi}</span>
            </div>

            <div class="info-item">
                <label>CCCD</label>
                <span>${nv.cccd}</span>
            </div>

            <div class="info-item">
                <label>Ngày cấp CCCD</label>
                <span>${nv.ngayCapCCCD}</span>
            </div>

            <div class="info-item">
                <label>Đặc điểm nhận dạng</label>
                <span>${nv.dacDiemNhanDang}</span>
            </div>

            <div class="info-item">
                <label>Trạng thái</label>
                <span>${nv.tenTrangThai}</span>
            </div>

        </div>

    </div>

</main>

</body>
</html>