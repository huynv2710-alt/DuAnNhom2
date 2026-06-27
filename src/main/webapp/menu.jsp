<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý bán hàng</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: sans-serif; }

        .sidebar {
            width: 260px;
            background-color: #002d28;
            color: white;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .sidebar-header {
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 600;
        }

        .logo-box { background: #00897b; padding: 10px; border-radius: 6px; }

        .nav-links { list-style: none; flex-grow: 1; margin: 0; padding: 0; }
        .nav-links li a {
            display: block;
            padding: 15px 25px;
            color: #b0bec5;
            text-decoration: none;
            transition: 0.3s;
        }
        .nav-links li.active { background-color: #004d40; border-left: 4px solid #00c853; }
        .nav-links li.active a { color: white; }
        .nav-links li a:hover { color: white; background: #004d40; }

        .sidebar-footer {
            padding: 20px;
            background-color: #00201d;
        }

        .user-info { display: flex; align-items: center; gap: 10px; margin-bottom: 15px; }
        .avatar {
            width: 35px; height: 35px; background: #009688;
            border-radius: 50%; display: flex;
            align-items: center; justify-content: center; font-weight: bold;
        }

        .logout-btn {
            width: 100%;
            padding: 8px;
            background: transparent;
            border: 1px solid #d32f2f;
            color: #ff5252;
            cursor: pointer;
            border-radius: 4px;
            transition: 0.3s;
        }
        .logout-btn:hover { background: #d32f2f; color: white; }
    </style>
</head>
<body>

    <nav class="sidebar">
        <div class="sidebar-header">
            <div class="logo-box">🛒</div>
            <span class="brand-name">Quản Lý Bán Hàng</span>
        </div>

        <ul class="nav-links">
            <li class="active"><a href="#">Đơn hàng</a></li>
            <li><a href="">Khách hàng</a></li>
            <li><a href="quanlinhanvien.jsp">Sản phẩm</a></li>
            <li><a href="#">Nhập kho</a></li>
            <li><a href="#">Báo cáo</a></li>
        </ul>

        <div class="sidebar-footer">
            <div class="user-info">
                <div class="avatar">A</div>
                <div>
                    <div class="name">Admin</div>
                    <div class="role">Quản trị viên</div>
                </div>
            </div>
            <button class="logout-btn" onclick="alert('Đang đăng xuất...')">Đăng xuất</button>
        </div>
    </nav>

</body>
</html>