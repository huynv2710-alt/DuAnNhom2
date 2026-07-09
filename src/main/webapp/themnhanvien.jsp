<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Thêm nhân viên</title>
<link rel="stylesheet" href="css/themnv.css">
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
<input type="text" name="maNV" required>
</div>

<div class="form-group">
<label>Họ tên</label>
<input type="text" name="hoTen" required>
</div>

<div class="form-group">
<label>Ngày sinh</label>
<input type="date" name="ngaySinh" required>
</div>

<div class="form-group">
<label>Giới tính</label>
<select name="gioiTinh">
<option value="Nam">Nam</option>
<option value="Nữ">Nữ</option>
</select>
</div>

<div class="form-group">
<label>Số điện thoại</label>
<input type="text" name="sdt" required>
</div>

<div class="form-group">
<label>Email</label>
<input type="email" name="email" required>
</div>

<div class="form-group">
<label>Địa chỉ</label>
<input type="text" name="diaChi" required>
</div>

<div class="form-group">
<label>CCCD</label>
<input type="text" name="cccd" required>
</div>

<div class="form-group">
<label>Ngày cấp CCCD</label>
<input type="date" name="ngayCapCCCD" required>
</div>

<div class="form-group">
<label>Đặc điểm nhận dạng</label>
<input type="text" name="dacDiemNhanDang" required>
</div>

<div class="form-group">
<label>Trạng thái</label>
<select name="maTrangThai" >
<option value="1">Đang làm</option>
<option value="2">Thử việc</option>
</select>
</div>

<div class="form-group">
<label>Tên đăng nhập (Tài khoản)</label>
<input type="text" name="username" required>
</div>

<div class="form-group">
<label>Mật khẩu</label>
<input type="password" name="password" required>
</div>

<div class="form-group">
<label>Vai trò</label>
<select name="maQuyen">
<option value="2">Nhân viên</option>
<option value="1">Admin</option>
</select>
</div>

</div>

<div class="button-group">

<button type="submit" class="btn-save">
Thêm nhân viên
</button>

<a href="quanlinhanvien" class="btn-back">
Quay lại
</a>

</div>

</form>

</div>

</main>

</body>
</html>