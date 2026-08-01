<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý tài khoản</title>
    <link rel="stylesheet" href="css/qlnv.css">
    <style>
        .search-box { margin-bottom: 20px; text-align: right; }
        .search-box input { padding: 10px 12px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; width: 250px; outline: none; }
        .search-box button { padding: 10px 15px; background: #00897b; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
        
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 2000; }
        .modal-content { background: white; width: 400px; margin: 100px auto; padding: 25px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); }
        .modal-header { font-size: 22px; font-weight: bold; margin-bottom: 20px; color: #00897b; border-bottom: 2px solid #00897b; padding-bottom: 10px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #333; }
        .form-group input, .form-group select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; outline: none; }
        .modal-footer { text-align: right; margin-top: 25px; }
        .btn-cancel { padding: 10px 15px; background: #ccc; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px; font-weight: bold; }
        .btn-save { padding: 10px 15px; background: #00897b; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
    </style>
</head>

<body>

<jsp:include page="menu.jsp"/>

<main class="content">

    <div class="header">
        <h1>QUẢN LÝ TÀI KHOẢN</h1>
    </div>

    <div class="search-box">
        <form action="quanlytaikhoan" method="get">
            <input type="text" name="search" value="${search}" placeholder="Tìm username hoặc họ tên...">
            <button type="submit">Tìm kiếm</button>
        </form>
    </div>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Username</th>
                    <th>Mật khẩu</th>
                    <th>Họ tên</th>
                    <th>Quyền</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="tk" items="${listTK}" varStatus="status">
                    <tr>
                        <td><b>${tk.username}</b></td>
                        <td style="color: #ef4444; font-weight: bold; font-family: monospace;">
                            <span id="passMask${status.index}">••••••</span>
                            <span id="passReal${status.index}" style="display:none;">${tk.pass}</span>
                            <i class="fa-solid fa-eye toggle-eye" style="position:static; margin-left:6px;"
                               onclick="toggleRowPassword(${status.index})"></i>
                        </td>
                        <td>${tk.hoTen}</td>
                        <td>${tk.tenQuyen}</td>
                        <td class="${tk.trangThai == 1 ? 'status-active' : 'status-leave'}">
                            ${tk.trangThai == 1 ? 'Hoạt động' : 'Ngừng hoạt động'}
                        </td>
                        <td>
                            <button class="btn-edit" style="border:none; cursor:pointer;" onclick="openEditModal('${tk.username}', '${tk.pass}', ${tk.maQuyen})">
                                Sửa
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

</main>

<!-- Edit Modal -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <div class="modal-header">Sửa Tài Khoản</div>
        <form action="quanlytaikhoan" method="post">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="oldUsername" id="oldUsername">
            <div class="form-group">
                <label>Tên đăng nhập mới</label>
                <input type="text" id="editUsername" name="newUsername" required>
            </div>
            <div class="form-group">
                <label>Mật Khẩu</label>
                <div class="password-wrapper">
                    <input type="password" id="editPassword" name="password" required>
                    <i class="fa-solid fa-eye toggle-eye" onclick="togglePassword('editPassword', this)"></i>
                </div>
            </div>
            <div class="form-group">
                <label>Vai trò</label>
                <select name="maQuyen" id="editMaQuyen">
                    <option value="1">Admin</option>
                    <option value="2">Nhân Viên</option>
                </select>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal('editModal')">Hủy</button>
                <button type="submit" class="btn-save">Cập nhật</button>
            </div>
        </form>
    </div>
</div>

<script src="js/togglePassword.js"></script>
<script>
    function openModal(id) {
        document.getElementById(id).style.display = 'block';
    }
    function closeModal(id) {
        document.getElementById(id).style.display = 'none';
    }
    function openEditModal(username, pass, maQuyen) {
        document.getElementById('oldUsername').value = username;
        document.getElementById('editUsername').value = username;
        document.getElementById('editPassword').value = pass;
        document.getElementById('editMaQuyen').value = maQuyen;
        openModal('editModal');
    }
</script>

</body>
</html>
