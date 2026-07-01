<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sửa nhân viên</title>
<link rel="stylesheet" href="css/suanv.css">
</head>

<body>

<jsp:include page="menu.jsp"/>

<main class="content">

<h1 class="title">SỬA NHÂN VIÊN</h1>

<div class="form-container">

<form action="suanhanvien" method="post">

<input type="hidden" name="maNV" value="${nv.maNV}">

<div class="form-grid">

<div class="form-group">
<label>Mã nhân viên</label>
<input type="text" value="${nv.maNV}" readonly>
</div>

<div class="form-group">
<label>Họ tên</label>
<input type="text" name="hoTen" value="${nv.hoTen}" required>
</div>

<div class="form-group">
<label>Ngày sinh</label>
<input type="date" name="ngaySinh" value="${nv.ngaySinh}" required>
</div>

<div class="form-group">
<label>Giới tính</label>
<select name="gioiTinh">
    <option value="Nam" ${nv.gioiTinh=="Nam"?"selected":""}>Nam</option>
    <option value="Nữ" ${nv.gioiTinh=="Nữ"?"selected":""}>Nữ</option>
</select>
</div>

<div class="form-group">
<label>Số điện thoại</label>
<input type="text" name="sdt" value="${nv.sdt}" required>
</div>

<div class="form-group">
<label>Email</label>
<input type="email" name="email" value="${nv.email}" required>
</div>

<div class="form-group">
<label>Địa chỉ</label>
<input type="text" name="diaChi" value="${nv.diaChi}" required>
</div>

<div class="form-group">
<label>CCCD</label>
<input type="text" name="cccd" value="${nv.cccd}" required>
</div>

<div class="form-group">
<label>Ngày cấp CCCD</label>
<input type="date" name="ngayCapCCCD" value="${nv.ngayCapCCCD}" required>
</div>

<div class="form-group">
<label>Đặc điểm nhận dạng</label>
<input type="text" name="dacDiemNhanDang" value="${nv.dacDiemNhanDang}" required>
</div>

<div class="form-group">
<label>Trạng thái</label>
<select name="maTrangThai">
          <option value="1" ${nv.maTrangThai==1?"selected":""}>Đang làm</option>
          <option value="2" ${nv.maTrangThai==2?"selected":""}>Thử việc</option>
          <option value="3" ${nv.maTrangThai==3?"selected":""}>Nghỉ việc</option>
      </select>
      </div>

</div>

<div class="button-group">

<button type="submit" class="btn-save">
Cập nhật
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