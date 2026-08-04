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
    <select id="city" style="flex:1; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
        <option value="" selected>Chọn Tỉnh Thành</option>
    </select>
    <select id="ward" style="flex:1; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
        <option value="" selected>Chọn Phường Xã</option>
    </select>
</div>
<input type="text" id="addressDetail" placeholder="Nhập bổ sung: Số nhà, Thôn xóm, Tên đường..." required style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
<input type="hidden" name="diaChi" id="diaChiHidden" value="${nv.diaChi}">
</div>

<div class="form-group">
<label>CCCD</label>
<input type="text" id="cccd" name="cccd" value="${nv.cccd}" required oninput="validateNV()">
<span id="errCccd" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
</div>

<div class="form-group">
<label>Ngày cấp CCCD</label>
<input type="date" id="ngayCapCCCD" name="ngayCapCCCD" value="${nv.ngayCapCCCD}" required oninput="validateNV()">
<span id="errNgayCapCCCD" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
</div>

<div class="form-group">
<label>Nơi cấp CCCD</label>
<select name="noiCapCCCD" required style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;">
    <option value="Bộ Công an" ${nv.noiCapCCCD == 'Bộ Công an' ? 'selected' : ''}>Bộ Công an</option>
    <option value="Cục Cảnh sát quản lý hành chính về trật tự xã hội" ${nv.noiCapCCCD == 'Cục Cảnh sát quản lý hành chính về trật tự xã hội' ? 'selected' : ''}>Cục Cảnh sát quản lý hành chính về trật tự xã hội</option>
    <option value="Cục Cảnh sát ĐKQL cư trú và DLQG về dân cư" ${nv.noiCapCCCD == 'Cục Cảnh sát ĐKQL cư trú và DLQG về dân cư' ? 'selected' : ''}>Cục Cảnh sát ĐKQL cư trú và DLQG về dân cư</option>
</select>
</div>

<div class="form-group">
<label>Ngày hết hạn CCCD</label>
<input type="date" id="ngayHetHanCCCD" name="ngayHetHanCCCD" value="${nv.ngayHetHanCCCD}" oninput="validateNV()">
<span id="errNgayHetHanCCCD" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
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
                <option value="1" ${nv.maTrangThai == 1 ? 'selected' : ''}>Đang làm việc</option>
                <option value="2" ${nv.maTrangThai == 2 ? 'selected' : ''}>Nghỉ việc</option>
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

        let cccd = document.getElementById('cccd') ? document.getElementById('cccd').value.trim() : '';
        let cccdRegex = /^[0-9]{12}$/;
        if(cccd.length > 0 && !cccdRegex.test(cccd)) {
            document.getElementById('errCccd').innerText = "CCCD phải bao gồm đúng 12 chữ số!";
            document.getElementById('errCccd').style.display = 'block';
            isValid = false;
        } else if(document.getElementById('errCccd')) {
            document.getElementById('errCccd').style.display = 'none';
        }

        let ngayCapStr = document.getElementById('ngayCapCCCD') ? document.getElementById('ngayCapCCCD').value : '';
        let ngayHetHanStr = document.getElementById('ngayHetHanCCCD') ? document.getElementById('ngayHetHanCCCD').value : '';
        
        if (!ngayCapStr) {
            if(document.getElementById('errNgayCapCCCD')) {
                document.getElementById('errNgayCapCCCD').innerText = "Vui lòng nhập ngày cấp hợp lệ!";
                document.getElementById('errNgayCapCCCD').style.display = 'block';
            }
            isValid = false;
        } else {
            if(document.getElementById('errNgayCapCCCD')) document.getElementById('errNgayCapCCCD').style.display = 'none';
        }

        if(ngaySinh && ngayCapStr) {
            let birthDate = new Date(ngaySinh);
            let issueDate = new Date(ngayCapStr);
            let today = new Date();
            
            let ageAtIssue = issueDate.getFullYear() - birthDate.getFullYear();
            let mIssue = issueDate.getMonth() - birthDate.getMonth();
            if (mIssue < 0 || (mIssue === 0 && issueDate.getDate() < birthDate.getDate())) {
                ageAtIssue--;
            }
            
            if (issueDate > today) {
                if(document.getElementById('errNgayCapCCCD')) {
                    document.getElementById('errNgayCapCCCD').innerText = "Ngày cấp không được ở tương lai!";
                    document.getElementById('errNgayCapCCCD').style.display = 'block';
                }
                isValid = false;
            } else if (issueDate < birthDate) {
                if(document.getElementById('errNgayCapCCCD')) {
                    document.getElementById('errNgayCapCCCD').innerText = "Ngày cấp không hợp lý (trước ngày sinh)!";
                    document.getElementById('errNgayCapCCCD').style.display = 'block';
                }
                isValid = false;
            } else if (ageAtIssue < 14) {
                if(document.getElementById('errNgayCapCCCD')) {
                    document.getElementById('errNgayCapCCCD').innerText = "Tuổi lúc cấp CCCD phải từ đủ 14 tuổi!";
                    document.getElementById('errNgayCapCCCD').style.display = 'block';
                }
                isValid = false;
            }
            
            if (ngayHetHanStr) {
                let expDate = new Date(ngayHetHanStr);
                let expectedExpYear = null;
                if (ageAtIssue >= 14 && ageAtIssue < 23) expectedExpYear = birthDate.getFullYear() + 25;
                else if (ageAtIssue >= 23 && ageAtIssue < 38) expectedExpYear = birthDate.getFullYear() + 40;
                else if (ageAtIssue >= 38 && ageAtIssue < 58) expectedExpYear = birthDate.getFullYear() + 60;

                if (expectedExpYear !== null) {
                    if (expDate.getFullYear() !== expectedExpYear) {
                        if(document.getElementById('errNgayHetHanCCCD')) {
                            document.getElementById('errNgayHetHanCCCD').innerText = "Ngày hết hạn chưa phù hợp với độ tuổi lúc cấp (phải là năm " + expectedExpYear + ")!";
                            document.getElementById('errNgayHetHanCCCD').style.display = 'block';
                        }
                        isValid = false;
                    } else if (issueDate >= expDate) {
                        if(document.getElementById('errNgayHetHanCCCD')) {
                            document.getElementById('errNgayHetHanCCCD').innerText = "Ngày cấp phải nhỏ hơn ngày hết hạn!";
                            document.getElementById('errNgayHetHanCCCD').style.display = 'block';
                        }
                        isValid = false;
                    } else {
                        if(document.getElementById('errNgayHetHanCCCD')) document.getElementById('errNgayHetHanCCCD').style.display = 'none';
                    }
                } else if (ageAtIssue >= 58) {
                    if(document.getElementById('errNgayHetHanCCCD')) {
                        document.getElementById('errNgayHetHanCCCD').innerText = "Người từ đủ 58 tuổi khi cấp thẻ không có ngày hết hạn (hãy để trống)!";
                        document.getElementById('errNgayHetHanCCCD').style.display = 'block';
                    }
                    isValid = false;
                }
            } else {
                if (ageAtIssue >= 14 && ageAtIssue < 58) {
                    if(document.getElementById('errNgayHetHanCCCD')) {
                        document.getElementById('errNgayHetHanCCCD').innerText = "Vui lòng nhập ngày hết hạn hợp lệ!";
                        document.getElementById('errNgayHetHanCCCD').style.display = 'block';
                    }
                    isValid = false;
                } else if (ageAtIssue >= 58) {
                    if(document.getElementById('errNgayHetHanCCCD')) document.getElementById('errNgayHetHanCCCD').style.display = 'none';
                }
            }
        }

        let btnSubmit = document.querySelector(".btn-save");
        if(btnSubmit) btnSubmit.disabled = !isValid;
        
        return isValid;
    }

    // Set max date for ngaySinh (16 years ago)
    document.addEventListener("DOMContentLoaded", function() {
        let today = new Date();
        let maxDate = new Date(today.getFullYear() - 16, today.getMonth(), today.getDate());
        if(document.getElementById("ngaySinh")) {
            document.getElementById("ngaySinh").max = maxDate.toISOString().split("T")[0];
        }
        if(document.getElementById("ngayCapCCCD")) {
            document.getElementById("ngayCapCCCD").max = today.toISOString().split("T")[0];
        }
        
        // Tích hợp API Tỉnh thành
        if (typeof init34TinhThanhAddress === 'function') {
            init34TinhThanhAddress('city', 'ward', 'addressDetail', 'diaChiHidden');
        }
    });
</script>
<script src="js/address-data.js"></script>

</body>
</html>
