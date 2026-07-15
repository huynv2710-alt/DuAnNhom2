<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Sửa nhân viên</title>
<link rel="stylesheet" href="css/themnv.css">
</head>

<body>

<jsp:include page="menu.jsp"/>

<main class="content">

<h1 class="title">SỬA THÔNG TIN NHÂN VIÊN</h1>

<div class="form-container">

<form action="suanhanvien" method="post" onsubmit="return validateNV()">
<input type="hidden" name="action" value="adminUpdate">
<input type="hidden" name="maNV" value="${nv.maNV}">

<div class="form-grid">

<div class="form-group">
<label>Mã nhân viên (Không sửa)</label>
<input type="text" value="${nv.maNV}" disabled style="background:#e9ecef;">
</div>

<div class="form-group">
<label>Họ tên</label>
<input type="text" name="hoTen" value="${nv.hoTen}" required>
</div>

<div class="form-group">
<label>Ngày sinh</label>
<input type="date" id="ngaySinh" name="ngaySinh" value="${nv.ngaySinh}" required oninput="validateNV()">
<span id="errNgaySinh" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
</div>

<div class="form-group">
<label>Giới tính</label>
<select name="gioiTinh">
<option value="Nam" ${nv.gioiTinh == 'Nam' ? 'selected' : ''}>Nam</option>
<option value="Nữ" ${nv.gioiTinh == 'Nữ' ? 'selected' : ''}>Nữ</option>
</select>
</div>

<div class="form-group">
<label>Số điện thoại</label>
<input type="text" id="sdt" name="sdt" value="${nv.sdt}" required oninput="validateNV()">
<span id="errSdt" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
</div>

<div class="form-group">
<label>Email</label>
<input type="email" id="email" name="email" value="${nv.email}" required oninput="validateNV()">
<span id="errEmail" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
</div>

<div class="form-group" style="grid-column: span 2;">
<label>Địa chỉ</label>
<div style="display: flex; gap: 10px; margin-bottom: 10px;">
    <select id="city" required style="flex:1; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
        <option value="" selected>Chọn Tỉnh Thành</option>
    </select>
    <select id="district" required style="flex:1; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
        <option value="" selected>Chọn Quận Huyện</option>
    </select>
    <select id="ward" required style="flex:1; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
        <option value="" selected>Chọn Phường Xã</option>
    </select>
</div>
<input type="text" id="addressDetail" placeholder="Số nhà, Tên đường..." required style="width: 100%;">
<input type="hidden" name="diaChi" id="diaChiHidden" value="${nv.diaChi}">
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

<c:choose>
    <c:when test="${sessionScope.maNV == nv.maNV}">
        <input type="hidden" name="maTrangThai" value="${nv.maTrangThai}">
        <div class="form-group">
            <label>Trạng thái</label>
            <input type="text" value="Đang làm (Admin)" disabled style="background:#e9ecef;">
        </div>
    </c:when>
    <c:otherwise>
        <div class="form-group">
            <label>Trạng thái</label>
            <select name="maTrangThai" >
                <option value="1" ${nv.maTrangThai == 1 ? 'selected' : ''}>Hoạt động</option>
                <option value="2" ${nv.maTrangThai == 2 ? 'selected' : ''}>Thử việc</option>
                <option value="3" ${nv.maTrangThai == 3 ? 'selected' : ''}>Nghỉ việc</option>
            </select>
        </div>
    </c:otherwise>
</c:choose>

</div>

<div class="button-group">

<button type="submit" class="btn-save">
Lưu thay đổi
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

    document.addEventListener("DOMContentLoaded", function() {
        let today = new Date();
        let maxDate = new Date(today.getFullYear() - 16, today.getMonth(), today.getDate());
        document.getElementById("ngaySinh").max = maxDate.toISOString().split("T")[0];
        
        let oldAddress = document.getElementById('diaChiHidden').value;
        document.getElementById('addressDetail').value = oldAddress; // Tạm thời để toàn bộ vào ô chi tiết

        fetch('https://provinces.open-api.vn/api/?depth=3')
            .then(response => response.json())
            .then(data => {
                let citySelect = document.getElementById('city');
                let districtSelect = document.getElementById('district');
                let wardSelect = document.getElementById('ward');
                
                data.forEach(city => {
                    citySelect.innerHTML += `<option value="${city.name}" data-code="${city.code}">${city.name}</option>`;
                });

                citySelect.addEventListener('change', function() {
                    districtSelect.innerHTML = '<option value="">Chọn Quận Huyện</option>';
                    wardSelect.innerHTML = '<option value="">Chọn Phường Xã</option>';
                    let selectedCity = data.find(c => c.code == citySelect.options[citySelect.selectedIndex].getAttribute('data-code'));
                    if (selectedCity) {
                        selectedCity.districts.forEach(d => {
                            districtSelect.innerHTML += `<option value="${d.name}" data-code="${d.code}">${d.name}</option>`;
                        });
                    }
                    updateAddress();
                });

                districtSelect.addEventListener('change', function() {
                    wardSelect.innerHTML = '<option value="">Chọn Phường Xã</option>';
                    let selectedCity = data.find(c => c.code == citySelect.options[citySelect.selectedIndex].getAttribute('data-code'));
                    if (selectedCity) {
                        let selectedDistrict = selectedCity.districts.find(d => d.code == districtSelect.options[districtSelect.selectedIndex].getAttribute('data-code'));
                        if (selectedDistrict) {
                            selectedDistrict.wards.forEach(w => {
                                wardSelect.innerHTML += `<option value="${w.name}">${w.name}</option>`;
                            });
                        }
                    }
                    updateAddress();
                });

                wardSelect.addEventListener('change', updateAddress);
                document.getElementById('addressDetail').addEventListener('input', updateAddress);
            });
    });

    function updateAddress() {
        let city = document.getElementById('city').value;
        let district = document.getElementById('district').value;
        let ward = document.getElementById('ward').value;
        let detail = document.getElementById('addressDetail').value;
        
        let fullAddress = [];
        if (detail) fullAddress.push(detail);
        if (ward) fullAddress.push(ward);
        if (district) fullAddress.push(district);
        if (city) fullAddress.push(city);
        
        document.getElementById('diaChiHidden').value = fullAddress.join(', ');
    }
</script>

</body>
</html>
