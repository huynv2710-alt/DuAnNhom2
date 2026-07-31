<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đổi Mật Khẩu - Book Store</title>
    <link rel="stylesheet" href="css/nv.css">
    <style>
        body { margin: 0 !important; padding: 0 !important; display: flex !important; align-items: flex-start !important; min-height: 100vh !important; background-color: #f4f6f9 !important; }
        .sidebar { position: sticky !important; top: 0 !important; height: 100vh !important; width: 260px !important; min-width: 260px !important; overflow-y: auto !important; z-index: 1000 !important; }
        .content { flex: 1 !important; width: calc(100% - 260px) !important; padding: 30px !important; box-sizing: border-box !important; min-height: 100vh !important; margin: 0 !important; }
        
        .form-container { background: white; padding: 40px; border-radius: 14px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); width: 100%; max-width: 500px; margin: 0 auto; margin-top: 20px; }
        .form-container h2 { color: #00897b; font-size: 24px; margin-bottom: 30px; text-align: center; border-bottom: 2px solid #e0f2f1; padding-bottom: 15px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 500; color: #444; }
        .form-group input { width: 100%; padding: 14px; border: 2px solid #eee; border-radius: 8px; font-size: 15px; transition: 0.3s; outline: none; }
        .form-group input:focus { border-color: #00897b; }
        
        .btn-primary { background-color: #00897b; color: white; padding: 14px; border: none; border-radius: 8px; cursor: pointer; width: 100%; font-size: 16px; font-weight: bold; margin-top: 10px; transition: 0.3s; }
        .btn-primary:hover { background-color: #00695c; transform: translateY(-2px); box-shadow: 0 4px 10px rgba(0,137,123,0.2); }
        
        .alert { padding: 14px 18px; border-radius: 8px; margin-bottom: 25px; font-weight: 500; font-size: 15px; }
        .alert-error { background-color: #ffebee; color: #c62828; border: 1px solid #ef9a9a; }
        .alert-success { background-color: #e8f5e9; color: #2e7d32; border: 1px solid #a5d6a7; }
    </style>
</head>
<body>

<jsp:include page="menu.jsp"/>

<main class="content">
    <div class="page-header">
        <h1>Đổi Mật Khẩu</h1>
        <p>Bảo mật tài khoản của bạn bằng cách cập nhật mật khẩu thường xuyên</p>
    </div>

    <div class="form-container">
        <h2>Thiết Lập Mật Khẩu Mới</h2>
        
        <c:if test="${not empty error}">
            <div class="alert alert-error">⚠️ ${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert alert-success">✅ ${success}</div>
        </c:if>

        <form action="doimatkhau" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label>Mật Khẩu Cũ</label>
                <div class="password-wrapper">
                    <input type="password" id="oldPass" name="oldPass" required placeholder="Nhập mật khẩu hiện tại">
                    <i class="fa-solid fa-eye toggle-eye" onclick="togglePassword('oldPass', this)"></i>
                </div>
            </div>
            <div class="form-group">
                <label>Mật Khẩu Mới</label>
                <div class="password-wrapper">
                    <input type="password" name="newPass" id="newPass" required placeholder="Nhập mật khẩu mới">
                    <i class="fa-solid fa-eye toggle-eye" onclick="togglePassword('newPass', this)"></i>
                </div>
            </div>
            <div class="form-group">
                <label>Xác Nhận Mật Khẩu Mới</label>
                <div class="password-wrapper">
                    <input type="password" name="confirmPass" id="confirmPass" required placeholder="Nhập lại mật khẩu mới">
                    <i class="fa-solid fa-eye toggle-eye" onclick="togglePassword('confirmPass', this)"></i>
                </div>
            </div>
            <button type="submit" class="btn-primary">Lưu Thay Đổi</button>
        </form>
    </div>
</main>

<script src="js/togglePassword.js"></script>
<script>
    function validateForm() {
        var newPass = document.getElementById("newPass").value;
        var confirmPass = document.getElementById("confirmPass").value;
        if (newPass !== confirmPass) {
            alert("Mat khau xac nhan khong khop!");
            return false;
        }
        return true;
    }
</script>

</body>
</html>
