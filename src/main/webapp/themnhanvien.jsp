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

<form action="themnhanvien" method="post" onsubmit="return validateNV()">

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
<input type="date" id="ngaySinh" name="ngaySinh" required oninput="validateNV()">
<span id="errNgaySinh" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
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
<input type="text" id="sdt" name="sdt" required oninput="validateNV()">
<span id="errSdt" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
</div>

<div class="form-group">
<label>Email</label>
<input type="email" id="email" name="email" required oninput="validateNV()">
<span id="errEmail" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
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

<script>
    function validateNV() {
        let isValid = true;
        
        let ngaySinh = document.getElementById('ngaySinh').value;
        if(ngaySinh) {
            let birthDate = new Date(ngaySinh);
            let today = new Date();
            let age = today.getFullYear() - birthDate.getFullYear();
            let m = today.getMonth() - birthDate.getMonth();
            if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                age--;
            }
            if(age < 16) {
                document.getElementById('errNgaySinh').innerText = "Nhân viên phải từ 16 tuổi trở lên!";
                document.getElementById('errNgaySinh').style.display = 'block';
                isValid = false;
            } else {
                document.getElementById('errNgaySinh').style.display = 'none';
            }
        }

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

        document.querySelector('.btn-save').disabled = !isValid;
        return isValid;
    }
</script>

</body>
</html>