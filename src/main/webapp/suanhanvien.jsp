<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sửa Thông Tin - Book Store</title>
    <link rel="stylesheet" href="css/nv.css">
    <style>
        body { margin: 0 !important; padding: 0 !important; display: flex !important; align-items: flex-start !important; min-height: 100vh !important; background-color: #f4f6f9 !important; }
        .sidebar { position: sticky !important; top: 0 !important; height: 100vh !important; width: 260px !important; min-width: 260px !important; overflow-y: auto !important; z-index: 1000 !important; }
        .content { flex: 1 !important; width: calc(100% - 260px) !important; padding: 30px !important; box-sizing: border-box !important; min-height: 100vh !important; margin: 0 !important; }
        .form-input { width: 100%; padding: 8px; margin-top: 5px; border: 1px solid #ccc; border-radius: 4px; }
        .btn-submit { margin-top: 20px; padding: 10px 20px; background-color: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: bold; }
        .btn-submit:hover { background-color: #0056b3; }
    </style>
</head>
<body>

<jsp:include page="menu2.jsp"/>

<main class="content">
    <div class="page-header">
        <h1>Sửa Thông Tin Cá Nhân</h1>
    </div>

    <div class="info-card">
        <h2>✏️ Cập nhật thông tin</h2>

        <form action="suanhanvien" method="POST">
            <input type="hidden" name="action" value="update">

            <div class="info-grid">
                <div class="info-item">
                    <label>Tên đăng nhập (Không được sửa)</label>
                    <input type="text" name="username" class="form-input" value="${sessionScope.username}" readonly style="background: #e9ecef;">
                </div>
                <div class="info-item">
                    <label>Họ và tên</label>
                    <input type="text" name="hoTen" class="form-input" value="${sessionScope.tenTK}">
                </div>
                <div class="info-item">
                    <label>Số điện thoại</label>
                    <input type="text" name="sdt" class="form-input" value="${sessionScope.sdt}">
                </div>
                <div class="info-item">
                    <label>Email</label>
                    <input type="email" name="email" class="form-input" value="${sessionScope.email}">
                </div>
                <div class="info-item" style="grid-column: 1 / -1;">
                    <label>Địa chỉ</label>
                    <input type="text" name="diaChi" class="form-input" value="${sessionScope.diaChi}" placeholder="Nhập địa chỉ..." required>
                </div>
                <div class="info-item">
                    <label>CCCD (Không được sửa)</label>
                    <input type="text" class="form-input" value="${sessionScope.cccd}" readonly style="background: #e9ecef;">
                </div>
                <div class="info-item">
                    <label>Trạng thái (Không được sửa)</label>
                    <input type="text" class="form-input" value="${sessionScope.tenTrangThai}" readonly style="background: #e9ecef; font-weight: bold; color: #2e7d32;">
                </div>
            </div>

            <button type="submit" class="btn-submit">Lưu Thay Đổi</button>
        </form>
    </div>
</main>


</body>
</html>