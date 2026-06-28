<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm nhân viên</title>

    <style>

.button-group{
    margin-top:35px;
    display:flex;
    justify-content:space-between;
    align-items:center;
}

.btn-save,
.btn-back{
    width:180px;
    height:45px;
    display:flex;
    justify-content:center;
    align-items:center;
    border:none;
    border-radius:8px;
    font-size:16px;
    font-weight:bold;
    text-decoration:none;
    cursor:pointer;
    transition:.3s;
}

.btn-save{
    background:#009688;
    color:white;
}

.btn-save:hover{
    background:#00796b;
}

.btn-back{
    background:#f44336;
    color:white;
}

.btn-back:hover{
    background:#d32f2f;
}
    </style>

</head>

<body>

<jsp:include page="menu.jsp"/>

<main class="content">

<h1 class="title">THÊM NHÂN VIÊN</h1>

<div class="form-container">

<form action="themNhanVien" method="post">

<div class="form-grid">

<div class="form-group">
<label>Mã nhân viên</label>
<input type="text" name="maNV">
</div>

<div class="form-group">
<label>Họ tên</label>
<input type="text" name="hoTen">
</div>

<div class="form-group">
<label>Ngày sinh</label>
<input type="date" name="ngaySinh">
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
<input type="text" name="sdt">
</div>

<div class="form-group">
<label>Email</label>
<input type="email" name="email">
</div>

<div class="form-group">
<label>Địa chỉ</label>
<input type="text" name="diaChi">
</div>

<div class="form-group">
<label>CCCD</label>
<input type="text" name="cccd">
</div>

<div class="form-group">
<label>Ngày cấp CCCD</label>
<input type="date" name="ngayCapCCCD">
</div>

<div class="form-group">
<label>Đặc điểm nhận dạng</label>
<input type="text" name="dacDiemNhanDang">
</div>

<div class="form-group">

<label>Trạng thái</label>

<select name="maTrangThai">
<option value="1">Đang làm</option>
<option value="2">Đã nghỉ</option>
</select>

</div>

</div>

<div class="button-group">

<button class="btn-save" type="submit">

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