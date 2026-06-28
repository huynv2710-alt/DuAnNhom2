<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Thêm nhân viên</title>

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial,sans-serif;
}

body{
    display:flex;
    min-height:100vh;
    background:#f4f4f4;
}

.content{
    flex:1;
    padding:25px;
}

.title{
    color:#00897b;
    font-size:38px;
    margin-bottom:20px;
    font-weight:bold;
}

.form-container{
    width:850px;
    margin:auto;
    background:#fff;
    border-radius:12px;
    padding:20px 25px;
    box-shadow:0 2px 10px rgba(0,0,0,.12);
}

.form-grid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:15px 25px;
}

.form-group{
    display:flex;
    flex-direction:column;
}

.form-group label{
    font-size:15px;
    font-weight:bold;
    margin-bottom:5px;
    color:#333;
}

.form-group input,
.form-group select{
    height:36px;
    border:1px solid #ccc;
    border-radius:6px;
    padding:0 10px;
    font-size:14px;
}

.form-group input:focus,
.form-group select:focus{
    outline:none;
    border-color:#009688;
}

.button-group{
    margin-top:20px;
    display:flex;
    justify-content:space-between;
}

.btn-save,
.btn-back{
    width:150px;
    height:40px;
    border:none;
    border-radius:6px;
    color:#fff;
    text-decoration:none;
    display:flex;
    justify-content:center;
    align-items:center;
    font-size:15px;
    font-weight:bold;
    cursor:pointer;
    transition:.3s;
}

.btn-save{
    background:#009688;
}

.btn-save:hover{
    background:#00796b;
}

.btn-back{
    background:#f44336;
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

<form action="themnhanvien" method="post">

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
<option value="2">Thử việc</option>
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