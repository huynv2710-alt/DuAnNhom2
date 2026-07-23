<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Khách Hàng</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="css/qlnv.css">
    <style>
        .search-box{
            margin-bottom:20px;
            text-align:right;
        }

        .search-box input{
            padding:10px 12px;
            border:1px solid #ccc;
            border-radius:4px;
            width:250px;
            font-size:14px;
        }

        .search-box button{
            padding:10px 15px;
            background:#00897b;
            color:#fff;
            border:none;
            border-radius:4px;
            cursor:pointer;
            font-weight:bold;
        }

        .btn-add{
            float:left;
            background:#00897b;
            color:white;
            padding:10px 20px;
            border:none;
            border-radius:4px;
            cursor:pointer;
            font-weight:bold;
        }

        .modal{
            display:none;
            position:fixed;
            left:0;
            top:0;
            width:100%;
            height:100%;
            background:rgba(0,0,0,.5);
            z-index:999;
        }

        .modal-content{
            width:520px;
            margin:40px auto;
            background:white;
            padding:25px;
            border-radius:8px;
        }

        .modal-header{
            font-size:22px;
            color:#00897b;
            margin-bottom:20px;
            font-weight:bold;
            border-bottom:2px solid #00897b;
            padding-bottom:10px;
        }

        .form-group{
            margin-bottom:15px;
        }

        .form-group label{
            display:block;
            margin-bottom:5px;
            font-weight:bold;
        }

        .form-group input{
            width:100%;
            padding:10px;
            border:1px solid #ccc;
            border-radius:4px;
            box-sizing:border-box;
        }

        .modal-footer{
            margin-top:25px;
            text-align:right;
        }

        .btn-save{
            background:#00897b;
            color:white;
            padding:10px 15px;
            border:none;
            border-radius:4px;
            cursor:pointer;
        }

        .btn-cancel{
            background:#ccc;
            padding:10px 15px;
            border:none;
            border-radius:4px;
            cursor:pointer;
            margin-right:10px;
        }
     </style>
</head>
<body>
<jsp:include page="menu.jsp"/>

<c:if test="${not empty success}">
<script>
    Swal.fire({
        icon:'success',
        title:'Thành công',
        text:'${success}',
        confirmButtonColor:'#00897b'
    });
</script>
<c:remove var="success" scope="session"/>
</c:if>

<c:if test="${not empty error}">
<script>
    Swal.fire({
        icon:'error',
        title:'Lỗi',
        text:'${error}',
        confirmButtonColor:'#d33'
    });
</script>
</c:if>

<main class="content">

<div class="header">
    <h1>QUẢN LÝ KHÁCH HÀNG</h1>
</div>

<div class="search-box">
    <button class="btn-add" onclick="openAddModal()"> + Thêm Khách Hàng</button>
    <form action="quanlykhachhang" method="get" style="display:inline-block;">
        <input type="text" name="search" value="${search}" placeholder="Tìm tên KH, số điện thoại">
        <button type="submit">Tìm kiếm</button>
    </form>
</div>

<div class="table-container">
<table>
<thead>
<tr>
<th>Mã KH</th>
<th>Họ tên</th>
<th>SĐT</th>
<th>Địa chỉ</th>
<th>Email</th>
<th>Thao tác</th>
</tr>
</thead>
<tbody>

<c:forEach items="${listKH}" var="kh">
<tr>
<td><b>${kh.maKH}</b></td>
<td>${kh.hoTen}</td>
<td>${kh.sdt}</td>
<td>${kh.diaChi}</td>
<td>${kh.email}</td>
<td>
<button class="btn-edit" style="border:none;cursor:pointer"
onclick="openEditModal('${kh.maKH}','${kh.hoTen}','${kh.sdt}','${kh.diaChi}','${kh.email}')">Sửa</button>
</td>
</tr>

</c:forEach>

<c:if test="${empty listKH}">
<tr>
<td colspan="6" style="text-align:center">Không tìm thấy khách hàng.</td>
</tr>
</c:if>

</tbody>
</table>
</div>
</main>

<div id="khModal" class="modal">
<div class="modal-content">
<div class="modal-header" id="modalTitle">Thêm Khách Hàng</div>

<form id="khForm" action="quanlykhachhang" method="post">

<input type="hidden" name="action" id="formAction" value="add">
<input type="hidden" name="maKH" id="maKH" value="0">

<div class="form-group">
<label>Họ tên <span style="color:red">*</span></label>
<input type="text" id="hoTen" name="hoTen" maxlength="50" required value="${hoTen}">
</div>

<div class="form-group">
<label>Số điện thoại <span style="color:red">*</span></label>
<input type="text" id="sdt" name="sdt" maxlength="10" required value="${sdt}">
</div>

<div class="form-group">
<label>Địa chỉ</label>
<input type="text" id="diaChi" name="diaChi" value="${diaChi}">
</div>

<div class="form-group">
<label>Email</label>
<input type="email" id="email" name="email" value="${email}">
</div>

<div class="modal-footer">
<button type="button" class="btn-cancel" onclick="closeModal()">Hủy</button>
<button type="submit" class="btn-save"> Lưu Khách Hàng</button>
</div>

</form>
</div>
</div>

<script>

document.getElementById("sdt").addEventListener("input",function(){
    this.value=this.value.replace(/\D/g,'');
});
document.getElementById("hoTen").addEventListener("input",function(){
    this.value=this.value.replace(/[0-9]/g,'');
});

document.getElementById("khForm").addEventListener("submit",function(e){
    let hoTen=document.getElementById("hoTen").value.trim();
    let sdt=document.getElementById("sdt").value.trim();
    let email=document.getElementById("email").value.trim();
    let diaChi=document.getElementById("diaChi").value.trim();

    if(hoTen.length<2){
        e.preventDefault();
        Swal.fire({
            icon:'error',
            title:'Lỗi',
            text:'Họ tên phải từ 2 ký tự trở lên'
        });
        return;
    }

    if(!/^[A-Za-zÀ-ỹ\s]+$/.test(hoTen)){
        e.preventDefault();
        Swal.fire({
            icon:'error',
            title:'Lỗi',
            text:'Họ tên không được chứa số'
        });
        return;
    }

    if(!/^0\d{9}$/.test(sdt)){
        e.preventDefault();
        Swal.fire({
            icon:'error',
            title:'Lỗi',
            text:'Số điện thoại phải gồm 10 số'
        });
        return;
    }

    if(email!=""){
        let reg=/^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/;
        if(!reg.test(email)){
            e.preventDefault();
            Swal.fire({
                icon:'error',
                title:'Lỗi',
                text:'Email không hợp lệ'
            });
            return;
        }
    }

    if(diaChi!=""&&diaChi.length<5){
        e.preventDefault();

        Swal.fire({
            icon:'error',
            title:'Lỗi',
            text:'Địa chỉ phải từ 5 ký tự'
        });
        return;
    }
});

function openAddModal(){
    document.getElementById("modalTitle").innerHTML="Thêm Khách Hàng";
    document.getElementById("formAction").value="add";
    document.getElementById("maKH").value="0";
    document.getElementById("khModal").style.display="block";
}

function openEditModal(maKH,hoTen,sdt,diaChi,email){
    document.getElementById("modalTitle").innerHTML="Cập nhật Khách Hàng";
    document.getElementById("formAction").value="edit";
    document.getElementById("maKH").value=maKH;
    document.getElementById("hoTen").value=hoTen;
    document.getElementById("sdt").value=sdt;
    document.getElementById("diaChi").value=diaChi;
    document.getElementById("email").value=email;
    document.getElementById("khModal").style.display="block";
}

function closeModal(){
    document.getElementById("khModal").style.display="none";
}

window.onclick=function(event){
    let modal=document.getElementById("khModal");
    if(event.target==modal){
        modal.style.display="none";
    }
};
<c:if test="${showModal}">
    window.onload = function () {
        document.getElementById("khModal").style.display = "block";
    };
</c:if>

<c:if test="${!showModal}">
    window.onload = function(){};
</c:if>

</script>

</body>
</html>