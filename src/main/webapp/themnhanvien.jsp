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
    String pNoiCap   = request.getParameter("noiCapCCCD")      != null ? request.getParameter("noiCapCCCD")      : "";
    String pNgayHetHan= request.getParameter("ngayHetHanCCCD") != null ? request.getParameter("ngayHetHanCCCD")  : "";
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
                    <input type="date" id="ngaySinh" name="ngaySinh" value="<%= pNgaySinh %>" required oninput="validateNV()">
                    <span id="errNgaySinh" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
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
                    <input type="text" id="sdt" name="sdt" value="<%= pSdt %>" required oninput="validateNV()">
                    <span id="errSdt" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email" id="email" name="email" value="<%= pEmail %>" required oninput="validateNV()">
                    <span id="errEmail" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
                </div>

                <div class="form-group">
                    <label>CCCD</label>
                    <input type="text" id="cccd" name="cccd" value="<%= pCccd %>" required oninput="validateNV()">
                    <span id="errCccd" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
                </div>

<div class="form-group" style="grid-column: span 2;">
<label>Địa chỉ</label>
<div style="display: flex; gap: 10px; margin-bottom: 10px;">
    <select id="city" required style="flex:1; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
        <option value="" selected>Chọn Tỉnh Thành</option>
    </select>
    <select id="ward" required style="flex:1; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
        <option value="" selected>Chọn Phường Xã</option>
    </select>
</div>
<input type="text" id="addressDetail" placeholder="Nhập bổ sung: Số nhà, Thôn xóm, Tên đường..." required style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
<input type="hidden" name="diaChi" id="diaChiHidden">
</div>

<div class="form-group">
<label>Ngày cấp CCCD</label>
<input type="date" id="ngayCapCCCD" name="ngayCapCCCD" value="<%= pNgayCap %>" required oninput="validateNV()">
<span id="errNgayCapCCCD" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
</div>

<div class="form-group">
    <label>Nơi cấp CCCD</label>
    <select name="noiCapCCCD" required style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;">
        <option value="Bộ Công an" <%= pNoiCap.equals("Bộ Công an") ? "selected" : "" %>>Bộ Công an</option>
        <option value="Cục Cảnh sát quản lý hành chính về trật tự xã hội" <%= pNoiCap.equals("Cục Cảnh sát quản lý hành chính về trật tự xã hội") ? "selected" : "" %>>Cục Cảnh sát quản lý hành chính về trật tự xã hội</option>
        <option value="Cục Cảnh sát ĐKQL cư trú và DLQG về dân cư" <%= pNoiCap.equals("Cục Cảnh sát ĐKQL cư trú và DLQG về dân cư") ? "selected" : "" %>>Cục Cảnh sát ĐKQL cư trú và DLQG về dân cư</option>
    </select>
</div>

<div class="form-group">
    <label>Ngày hết hạn CCCD</label>
    <input type="date" id="ngayHetHanCCCD" name="ngayHetHanCCCD" value="<%= pNgayHetHan %>" oninput="validateNV()">
    <span id="errNgayHetHanCCCD" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
</div>

<div class="form-group">
    <label>Đặc điểm nhận dạng</label>
    <input type="text" name="dacDiemNhanDang" value="<%= pDacDiem %>" required>
</div>

                <div class="form-group">
                    <label>Tên đăng nhập (Tài khoản)</label>
                    <input type="text" name="username" value="<%= pUsername %>" required>
                </div>

                <div class="form-group">
                    <label>Trạng thái</label>
                    <select name="maTrangThai">
                        <option value="1" <%= pTrangThai.equals("1") ? "selected" : "" %>>Đang làm</option>
                        <option value="2" <%= pTrangThai.equals("2") ? "selected" : "" %>>Thử việc</option>
                        <option value="3" <%= pTrangThai.equals("3") ? "selected" : "" %>>Nghỉ việc</option>
                    </select>
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
                if(document.getElementById('errNgaySinh')) document.getElementById('errNgaySinh').style.display = 'none';
            }
        }

        let sdt = document.getElementById('sdt').value.trim();
        let phoneRegex = /^(0|\+84)[0-9]{9}$/;
        if(sdt.length > 0 && !phoneRegex.test(sdt)) {
            if(document.getElementById('errSdt')) {
                document.getElementById('errSdt').innerText = "Số điện thoại phải bắt đầu bằng 0 hoặc +84 và đủ 10 số!";
                document.getElementById('errSdt').style.display = 'block';
            }
            isValid = false;
        } else {
            if(document.getElementById('errSdt')) document.getElementById('errSdt').style.display = 'none';
        }

        let email = document.getElementById('email').value.trim();
        let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if(email.length > 0 && !emailRegex.test(email)) {
            if(document.getElementById('errEmail')) {
                document.getElementById('errEmail').innerText = "Email không hợp lệ!";
                document.getElementById('errEmail').style.display = 'block';
            }
            isValid = false;
        } else {
            if(document.getElementById('errEmail')) document.getElementById('errEmail').style.display = 'none';
        }

        let cccd = document.getElementById('cccd') ? document.getElementById('cccd').value.trim() : '';
        let cccdRegex = /^[0-9]{12}$/;
        if(cccd.length > 0 && !cccdRegex.test(cccd)) {
            if(document.getElementById('errCccd')) {
                document.getElementById('errCccd').innerText = "CCCD phải bao gồm đúng 12 chữ số!";
                document.getElementById('errCccd').style.display = 'block';
            }
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
        
        // Load API Tỉnh/Thành
        fetch('https://provinces.open-api.vn/api/?depth=2')
            .then(response => response.json())
            .then(data => {
                let citySelect = document.getElementById('city');
                let wardSelect = document.getElementById('ward');
                
                if(!citySelect) return;

                data.forEach(city => {
                    let opt = document.createElement('option');
                    opt.value = city.name;
                    opt.setAttribute('data-code', city.code);
                    opt.textContent = city.name;
                    citySelect.appendChild(opt);
                });

                citySelect.addEventListener('change', function() {
                    wardSelect.innerHTML = '<option value="">Chọn Phường Xã</option>';
                    
                    let selectedCity = data.find(c => c.code == citySelect.options[citySelect.selectedIndex].getAttribute('data-code'));
                    if (selectedCity && selectedCity.districts) {
                        selectedCity.districts.forEach(d => {
                            let opt = document.createElement('option');
                            opt.value = d.name;
                            opt.setAttribute('data-code', d.code);
                            opt.textContent = d.name;
                            wardSelect.appendChild(opt);
                        });
                    }
                    updateAddress();
                });

                wardSelect.addEventListener('change', updateAddress);
                if(document.getElementById('addressDetail')) {
                    document.getElementById('addressDetail').addEventListener('input', updateAddress);
                }
            })
            .catch(error => {
                console.error("Lỗi tải API: ", error);
            });
    });

    function updateAddress() {
        let city = document.getElementById('city') ? document.getElementById('city').value : '';
        let ward = document.getElementById('ward') ? document.getElementById('ward').value : '';
        let detail = document.getElementById('addressDetail') ? document.getElementById('addressDetail').value : '';
        
        let fullAddress = [];
        if (detail) fullAddress.push(detail);
        if (ward) fullAddress.push(ward);
        if (city) fullAddress.push(city);
        
        if(document.getElementById('diaChiHidden')) {
            document.getElementById('diaChiHidden').value = fullAddress.join(', ');
        }
    }
</script>

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
