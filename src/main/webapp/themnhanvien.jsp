<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String errorMsg   = (String) request.getAttribute("error");
    String successMsg = (String) request.getAttribute("success");

    // Giữ lại giá trị form
    String pMaNV     = request.getParameter("maNV")            != null ? request.getParameter("maNV")            : "";
    String pHoTen    = request.getParameter("hoTen")           != null ? request.getParameter("hoTen")           : "";
    String pNgaySinh = request.getParameter("ngaySinh")        != null ? request.getParameter("ngaySinh")        : "";
    String pGioiTinh = request.getParameter("gioiTinh")        != null ? request.getParameter("gioiTinh")        : "Nam";
    String pSdt      = request.getParameter("sdt")             != null ? request.getParameter("sdt")             : "";
    String pEmail    = request.getParameter("email")           != null ? request.getParameter("email")           : "";
    String pDiaChi   = request.getParameter("diaChi")          != null ? request.getParameter("diaChi")          : "";
    String pCccd     = request.getParameter("cccd")            != null ? request.getParameter("cccd")            : "";
    String pNgayCap  = request.getParameter("ngayCapCCCD")     != null ? request.getParameter("ngayCapCCCD")     : "";
    String pDacDiem  = request.getParameter("dacDiemNhanDang") != null ? request.getParameter("dacDiemNhanDang") : "";
    String pUsername = request.getParameter("username")        != null ? request.getParameter("username")        : "";
    String pTrangThai= request.getParameter("maTrangThai")     != null ? request.getParameter("maTrangThai")     : "1";
    String pQuyen    = request.getParameter("maQuyen")         != null ? request.getParameter("maQuyen")         : "2";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm nhân viên</title>
    <link rel="stylesheet" href="css/themnv.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>

<jsp:include page="menu.jsp"/>

<main class="content">

    <h1 class="title">THÊM NHÂN VIÊN</h1>

    <div class="form-container">
        <form action="themnhanvien" method="post">
            <div class="form-grid">

                <div class="form-group">
                    <label>Mã nhân viên</label>
                    <input type="text" name="maNV" value="<%= pMaNV %>" required>
                </div>

                <div class="form-group">
                    <label>Họ tên</label>
                    <input type="text" name="hoTen" value="<%= pHoTen %>" required>
                </div>

                <div class="form-group">
                    <label>Ngày sinh</label>
                    <input type="date" name="ngaySinh" value="<%= pNgaySinh %>" required>
                </div>

                <div class="form-group">
                    <label>Giới tính</label>
                    <select name="gioiTinh">
                        <option value="Nam" <%= pGioiTinh.equals("Nam") ? "selected" : "" %>>Nam</option>
                        <option value="Nữ"  <%= pGioiTinh.equals("Nữ")  ? "selected" : "" %>>Nữ</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="text" name="sdt" value="<%= pSdt %>" required>
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" value="<%= pEmail %>" required>
                </div>

                <div class="form-group">
                    <label>Địa chỉ</label>
                    <input type="text" name="diaChi" value="<%= pDiaChi %>" required>
                </div>

                <div class="form-group">
                    <label>CCCD</label>
                    <input type="text" name="cccd" value="<%= pCccd %>" required>
                </div>

                <div class="form-group">
                    <label>Ngày cấp CCCD</label>
                    <input type="date" name="ngayCapCCCD" value="<%= pNgayCap %>" required>
                </div>

                <div class="form-group">
                    <label>Đặc điểm nhận dạng</label>
                    <input type="text" name="dacDiemNhanDang" value="<%= pDacDiem %>" required>
                </div>

                <div class="form-group">
                    <label>Trạng thái</label>
                    <select name="maTrangThai">
                        <option value="1" <%= pTrangThai.equals("1") ? "selected" : "" %>>Đang làm</option>
                        <option value="2" <%= pTrangThai.equals("2") ? "selected" : "" %>>Thử việc</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Tên đăng nhập (Tài khoản)</label>
                    <input type="text" name="username" value="<%= pUsername %>" required>
                </div>

                <div class="form-group">
                    <label>Mật khẩu</label>
                    <input type="password" name="password" required>
                </div>

                <div class="form-group">
                    <label>Vai trò</label>
                    <select name="maQuyen">
                        <option value="2" <%= pQuyen.equals("2") ? "selected" : "" %>>Nhân viên</option>
                        <option value="1" <%= pQuyen.equals("1") ? "selected" : "" %>>Admin</option>
                    </select>
                </div>

            </div>

            <div class="button-group">
                <button type="submit" class="btn-save">Thêm nhân viên</button>
                <a href="quanlinhanvien" class="btn-back">Quay lại</a>
            </div>
        </form>
    </div>

</main>

<% if (errorMsg != null && !errorMsg.isEmpty()) { %>
<script>
    window.addEventListener('DOMContentLoaded', function () {
        Swal.fire({
            icon: 'error',
            title: 'Lỗi',
            text: '<%= errorMsg.replace("'", "\\'") %>',
            confirmButtonColor: '#00897b',
            confirmButtonText: 'Đóng'
        });
    });
</script>
<% } %>

<% if (successMsg != null && !successMsg.isEmpty()) { %>
<script>
    window.addEventListener('DOMContentLoaded', function () {
        Swal.fire({
            icon: 'success',
            title: 'Thành công',
            text: '<%= successMsg %>',
            confirmButtonColor: '#00897b',
            confirmButtonText: 'OK'
        });
    });
</script>
<% } %>

</body>
</html>
