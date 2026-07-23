<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Khách Hàng</title>
    <link rel="stylesheet" href="css/qlnv.css">
    <style>
        .search-box { margin-bottom: 20px; text-align: right; }
        .search-box input { padding: 10px 12px; border: 1px solid #ccc; border-radius: 4px; font-size: 14px; width: 250px; outline: none; }
        .search-box button { padding: 10px 15px; background: #00897b; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
        
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 2000; overflow-y: auto; }
        .modal-content { background: white; width: 500px; margin: 50px auto; padding: 25px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); }
        .modal-header { font-size: 22px; font-weight: bold; margin-bottom: 20px; color: #00897b; border-bottom: 2px solid #00897b; padding-bottom: 10px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #333; }
        .form-group input { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; outline: none; box-sizing: border-box; }
        .modal-footer { text-align: right; margin-top: 25px; }
        .btn-cancel { padding: 10px 15px; background: #ccc; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px; font-weight: bold; }
        .btn-save { padding: 10px 15px; background: #00897b; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
        
        .btn-add { padding: 10px 20px; background: #00897b; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; float: left; }
    </style>
</head>

<body>

<jsp:include page="menu.jsp"/>

<main class="content">

    <div class="header">
        <h1>QUẢN LÝ KHÁCH HÀNG</h1>
    </div>

    <div class="search-box">
        <button class="btn-add" onclick="openAddModal()">+ Thêm Khách Hàng</button>
        <form action="quanlykhachhang" method="get" style="display: inline-block;">
            <input type="text" name="search" value="${search}" placeholder="Tìm tên KH, Số điện thoại...">
            <button type="submit">Tìm kiếm</button>
        </form>
    </div>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Mã KH</th>
                    <th>Họ Tên</th>
                    <th>Số Điện Thoại</th>
                    <th>Địa Chỉ</th>
                    <th>Email</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="kh" items="${listKH}">
                    <tr>
                        <td><b>${kh.maKH}</b></td>
                        <td>${kh.hoTen}</td>
                        <td>${kh.sdt}</td>
                        <td>${kh.diaChi}</td>
                        <td>${kh.email}</td>
                        <td>
                            <button class="btn-edit" style="border:none; cursor:pointer;" 
                                onclick="openEditModal(${kh.maKH}, '${kh.hoTen}', '${kh.sdt}', '${kh.diaChi}', '${kh.email}')">
                                Sửa
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty listKH}">
                    <tr><td colspan="6" style="text-align:center;">Không tìm thấy khách hàng nào!</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>

</main>

<!-- Modal Thêm/Sửa KH -->
<div id="khModal" class="modal">
    <div class="modal-content">
        <div class="modal-header" id="modalTitle">Thêm Khách Hàng</div>
        <form action="quanlykhachhang" method="post" onsubmit="return validateKH()">
            <input type="hidden" name="action" id="formAction" value="add">
            <input type="hidden" name="maKH" id="maKH" value="0">
            
            <div class="form-group">
                <label>Họ Tên Khách Hàng <span style="color:red">*</span></label>
                <input type="text" id="hoTen" name="hoTen" required>
            </div>
            <div class="form-group">
                <label>Số Điện Thoại <span style="color:red">*</span></label>
                <input type="text" id="sdt" name="sdt" required oninput="validateKH()">
                <span id="errSdtKH" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
            </div>
            <div class="form-group">
                <label>Địa Chỉ</label>
                <div style="display: flex; gap: 10px; margin-bottom: 10px;">
                    <select id="cityKH" style="flex:1; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
                        <option value="" selected>Chọn Tỉnh Thành</option>
                    </select>
                    <select id="wardKH" style="flex:1; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
                        <option value="" selected>Chọn Phường Xã</option>
                    </select>
                </div>
                <input type="text" id="addressDetailKH" placeholder="Nhập bổ sung: Số nhà, Thôn xóm..." style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
                <input type="hidden" name="diaChi" id="diaChiKH">
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" id="email" name="email" oninput="validateKH()">
                <span id="errEmailKH" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal()">Hủy</button>
                <button type="submit" class="btn-save">Lưu Khách Hàng</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openAddModal() {
        document.getElementById('modalTitle').innerText = 'Thêm Khách Hàng Mới';
        document.getElementById('formAction').value = 'add';
        document.getElementById('maKH').value = '0';
        document.getElementById('hoTen').value = '';
        document.getElementById('sdt').value = '';
        document.getElementById('diaChiKH').value = '';
        document.getElementById('email').value = '';
        
        if(document.getElementById('errSdtKH')) document.getElementById('errSdtKH').style.display = 'none';
        if(document.getElementById('errEmailKH')) document.getElementById('errEmailKH').style.display = 'none';
        let btnSubmit = document.querySelector(".btn-save");
        if(btnSubmit) btnSubmit.disabled = false;

        document.getElementById('khModal').style.display = 'block';
    }

    function openEditModal(maKH, hoTen, sdt, diaChi, email) {
        document.getElementById('modalTitle').innerText = 'Cập nhật Khách Hàng';
        document.getElementById('formAction').value = 'edit';
        document.getElementById('maKH').value = maKH;
        document.getElementById('hoTen').value = hoTen;
        document.getElementById('sdt').value = sdt;
        document.getElementById('diaChiKH').value = diaChi;
        document.getElementById('email').value = email;
        document.getElementById('khModal').style.display = 'block';
    }

    function closeModal() {
        document.getElementById('khModal').style.display = 'none';
    }

    function validateKH() {
        let isValid = true;
        let sdt = document.getElementById('sdt').value.trim();
        let phoneRegex = /^(0|\+84)[0-9]{9}$/;
        if(sdt.length > 0 && !phoneRegex.test(sdt)) {
            if(document.getElementById('errSdtKH')) {
                document.getElementById('errSdtKH').innerText = "Số điện thoại phải bắt đầu bằng 0 hoặc +84 và đủ 10 số!";
                document.getElementById('errSdtKH').style.display = 'block';
            }
            isValid = false;
        } else {
            if(document.getElementById('errSdtKH')) document.getElementById('errSdtKH').style.display = 'none';
        }

        let email = document.getElementById('email').value.trim();
        let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if(email.length > 0 && !emailRegex.test(email)) {
            if(document.getElementById('errEmailKH')) {
                document.getElementById('errEmailKH').innerText = "Email không hợp lệ!";
                document.getElementById('errEmailKH').style.display = 'block';
            }
            isValid = false;
        } else {
            if(document.getElementById('errEmailKH')) document.getElementById('errEmailKH').style.display = 'none';
        }

        let btnSubmit = document.querySelector(".btn-save");
        if(btnSubmit) btnSubmit.disabled = !isValid;
        
        return isValid;
    }

    // Load API Tỉnh/Thành
    document.addEventListener("DOMContentLoaded", function() {
        fetch('https://provinces.open-api.vn/api/?depth=2')
            .then(response => response.json())
            .then(data => {
                let citySelect = document.getElementById('cityKH');
                let wardSelect = document.getElementById('wardKH');
                
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
                    updateAddressKH();
                });

                wardSelect.addEventListener('change', updateAddressKH);
                document.getElementById('addressDetailKH').addEventListener('input', updateAddressKH);
            })
            .catch(error => {
                console.error("Lỗi tải API: ", error);
            });
    });

    function updateAddressKH() {
        let city = document.getElementById('cityKH').value;
        let ward = document.getElementById('wardKH').value;
        let detail = document.getElementById('addressDetailKH').value;
        
        let fullAddress = [];
        if (detail) fullAddress.push(detail);
        if (ward) fullAddress.push(ward);
        if (city) fullAddress.push(city);
        
        document.getElementById('diaChiKH').value = fullAddress.join(', ');
    }
</script>

</body>
</html>
