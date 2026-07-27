<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Nhà Xuất Bản</title>
    <link rel="stylesheet" href="css/qlnv.css?v=2.0">
    <style>
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 2000; overflow-y: auto; }
        .modal-content { background: white; width: 500px; margin: 100px auto; padding: 25px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); }
        .modal-header { font-size: 22px; font-weight: bold; margin-bottom: 20px; color: #0f2820; border-bottom: 2px solid #2d6652; padding-bottom: 10px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #333; }
        .form-group input, .form-group select { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; outline: none; box-sizing: border-box; }
        .modal-footer { text-align: right; margin-top: 25px; }
        .btn-cancel { padding: 10px 15px; background: #ccc; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px; font-weight: bold; }
        .btn-save { padding: 10px 15px; background: #2d6652; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
    </style>
</head>

<body>

<jsp:include page="menu.jsp"/>

<main class="content">
    <div class="header">
        <h1>QUẢN LÝ NHÀ XUẤT BẢN</h1>
        <button class="btn-add" onclick="openModal(0, '', '', '')">+ Thêm NXB</button>
    </div>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Mã NXB</th>
                    <th>Tên Nhà Xuất Bản</th>
                    <th>Số Điện Thoại</th>
                    <th>Địa Chỉ</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="nxb" items="${listNXB}">
                    <tr>
                        <td><b>${nxb.maNXB}</b></td>
                        <td>${nxb.tenNXB}</td>
                        <td>${nxb.sdt}</td>
                        <td>${nxb.diaChi}</td>
                        <td>
                            <button class="btn-edit" style="border:none; cursor:pointer;" onclick="openModal(${nxb.maNXB}, '${nxb.tenNXB}', '${nxb.diaChi}', '${nxb.sdt}')">
                                Sửa
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty listNXB}">
                    <tr><td colspan="5" style="text-align:center;">Chưa có dữ liệu</td></tr>
                </c:if>
            </tbody>
        </table>
    </div>
</main>

<div id="nxbModal" class="modal">
    <div class="modal-content">
        <div class="modal-header" id="modalTitle">Thêm Nhà Xuất Bản</div>
        <form action="quanlynxb" method="post" onsubmit="return validateNXB()">
            <input type="hidden" name="action" id="action" value="add">
            <input type="hidden" name="maNXB" id="maNXB" value="0">
            <div class="form-group">
                <label>Tên NXB <span style="color:red">*</span></label>
                <input type="text" id="tenNXB" name="tenNXB" required>
            </div>
            <div class="form-group">
                <label>Số Điện Thoại <span style="color:red">*</span></label>
                <input type="text" id="sdt" name="sdt" required oninput="validateNXB()">
                <span id="errSdtNXB" style="color:red; font-size:12px; display:none; margin-top:4px;"></span>
            </div>
            <div class="form-group">
                <label>Địa Chỉ</label>
                <div style="display: flex; gap: 10px; margin-bottom: 10px;">
                    <select id="cityNXB" style="flex:1; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
                        <option value="" selected>Chọn Tỉnh Thành</option>
                    </select>
                    <select id="wardNXB" style="flex:1; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
                        <option value="" selected>Chọn Phường Xã</option>
                    </select>
                </div>
                <input type="text" id="addressDetailNXB" placeholder="Nhập bổ sung: Số nhà, Thôn xóm..." style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
                <input type="hidden" name="diaChi" id="diaChiNXB">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal()">Hủy</button>
                <button type="submit" class="btn-save">Lưu</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openModal(id, name, address, phone) {
        document.getElementById('modalTitle').innerText = id == 0 ? 'Thêm NXB' : 'Sửa NXB';
        document.getElementById('action').value = id == 0 ? 'add' : 'edit';
        document.getElementById('maNXB').value = id;
        document.getElementById('tenNXB').value = name;
        document.getElementById('diaChiNXB').value = address;
        document.getElementById('sdt').value = phone;
        
        if (id == 0) {
            document.getElementById('addressDetailNXB').value = '';
            document.getElementById('cityNXB').value = '';
            document.getElementById('wardNXB').innerHTML = '<option value="">Chọn Phường Xã</option>';
        }
        
        if(document.getElementById('errSdtNXB')) document.getElementById('errSdtNXB').style.display = 'none';
        let btnSubmit = document.querySelector(".btn-save");
        if(btnSubmit) btnSubmit.disabled = false;

        document.getElementById('nxbModal').style.display = 'block';
    }
    
    function closeModal() {
        document.getElementById('nxbModal').style.display = 'none';
    }

    function validateNXB() {
        let isValid = true;
        let sdt = document.getElementById('sdt').value.trim();
        let phoneRegex = /^(0|\+84)[0-9]{9}$/;
        if(sdt.length > 0 && !phoneRegex.test(sdt)) {
            if(document.getElementById('errSdtNXB')) {
                document.getElementById('errSdtNXB').innerText = "Số điện thoại phải bắt đầu bằng 0 hoặc +84 và đủ 10 số!";
                document.getElementById('errSdtNXB').style.display = 'block';
            }
            isValid = false;
        } else {
            if(document.getElementById('errSdtNXB')) document.getElementById('errSdtNXB').style.display = 'none';
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
                let citySelect = document.getElementById('cityNXB');
                let wardSelect = document.getElementById('wardNXB');
                
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
                    updateAddressNXB();
                });

                wardSelect.addEventListener('change', updateAddressNXB);
                document.getElementById('addressDetailNXB').addEventListener('input', updateAddressNXB);
            })
            .catch(error => {
                console.error("Lỗi tải API: ", error);
            });
    });

    function updateAddressNXB() {
        let city = document.getElementById('cityNXB').value;
        let ward = document.getElementById('wardNXB').value;
        let detail = document.getElementById('addressDetailNXB').value;
        
        let fullAddress = [];
        if (detail) fullAddress.push(detail);
        if (ward) fullAddress.push(ward);
        if (city) fullAddress.push(city);
        
        document.getElementById('diaChiNXB').value = fullAddress.join(', ');
    }
</script>

</body>
</html>
