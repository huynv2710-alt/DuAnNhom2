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

        <form action="suanhanvien" method="POST" onsubmit="return validateNV()">
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
                    <input type="text" name="sdt" id="sdt" class="form-input" value="${sessionScope.sdt}" oninput="validateNV()">
                    <span id="errSdt" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
                </div>
                <div class="info-item">
                    <label>Email</label>
                    <input type="email" name="email" id="email" class="form-input" value="${sessionScope.email}" oninput="validateNV()">
                    <span id="errEmail" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
                </div>
                <div class="info-item">
                    <label>Địa chỉ</label>
                    <input type="text" name="diaChi" class="form-input" value="${sessionScope.diaChi}">
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

<script>
    function validateNV() {
        let isValid = true;
        let sdt = document.getElementById('sdt').value.trim();
        let phoneRegex = /^(0|\+84)[0-9]{9}$/;
        if(sdt.length > 0 && !phoneRegex.test(sdt)) {
            document.getElementById('errSdt').innerText = "Số điện thoại phải bắt đầu bằng 0 hoặc +84 và đủ 10 số!";
            document.getElementById('errSdt').style.display = 'block';
            isValid = false;
        } else {
            document.getElementById('errSdt').style.display = 'none';
        }

        let email = document.getElementById('email').value.trim();
        let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if(email.length > 0 && !emailRegex.test(email)) {
            document.getElementById('errEmail').innerText = "Email không hợp lệ!";
            document.getElementById('errEmail').style.display = 'block';
            isValid = false;
        } else {
            document.getElementById('errEmail').style.display = 'none';
        }

        document.querySelector('.btn-submit').disabled = !isValid;
        return isValid;
    }
</script>

</body>
</html>