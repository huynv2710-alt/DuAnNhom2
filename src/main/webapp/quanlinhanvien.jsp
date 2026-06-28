<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>

<head>
    <meta charset="UTF-8">
    <title>Quản lý nhân viên</title>

    <style>
*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial, sans-serif;
}

body{
    display:flex;
    min-height:100vh;
    background:#f4f6f9;
}

.content{
    flex:1;
    padding:30px;
    overflow:hidden;
}

h1{
    margin-bottom:25px;
    color:#00897b;
    font-size:48px;
    font-weight:bold;
    letter-spacing:3px;
}

.table-container{
    background:#fff;
    padding:20px;
    border-radius:12px;
    box-shadow:0 2px 10px rgba(0,0,0,0.1);
    overflow-x:auto;
}

/* Thanh cuộn đẹp hơn */
.table-container::-webkit-scrollbar{
    height:8px;
}

.table-container::-webkit-scrollbar-thumb{
    background:#bdbdbd;
    border-radius:10px;
}

.table-container::-webkit-scrollbar-track{
    background:#f1f1f1;
}

table{
    width:100%;
    border-collapse:collapse;
    table-layout:fixed;
}

th{
    background:#00897b;
    color:white;
    padding:14px 10px;
    font-size:16px;
    font-weight:600;
    border:1px solid #ddd;
}

td{
    padding:12px 10px;
    border:1px solid #ddd;
    font-size:15px;
    text-align:center;
    word-break:break-word;
}

tr:nth-child(even){
    background:#fafafa;
}

tr:hover{
    background:#f0f8f8;
    transition:0.2s;
}

.status-active{
    color:#2e7d32;
    font-weight:bold;
}

/* Độ rộng từng cột */
th:nth-child(1),
td:nth-child(1){
    width:80px;
}

th:nth-child(2),
td:nth-child(2){
    width:180px;
}

th:nth-child(5),
td:nth-child(5){
    width:130px;
}

th:nth-child(6),
td:nth-child(6){
    width:220px;
}

th:nth-child(7),
td:nth-child(7){
    width:180px;
}

th:nth-child(8),
td:nth-child(8){
    width:170px;
}

th:nth-child(9),
td:nth-child(9){
    width:150px;
}

th:nth-child(10),
td:nth-child(10){
    width:220px;
}

th:nth-child(11),
td:nth-child(11){
    width:120px;
}
    </style>

</head>

<body>

<jsp:include page="menu.jsp"/>

<main class="content">

    <h1>Quản lý nhân viên</h1>

    <div class="table-container">

        <table>

            <thead>

            <tr>
                <th>Mã NV</th>
                <th>Họ tên</th>
                <th>Ngày sinh</th>
                <th>Giới tính</th>
                <th>SĐT</th>
                <th>Email</th>
                <th>Địa chỉ</th>
                <th>CCCD</th>
                <th>Ngày cấp CCCD</th>
                <th>Đặc điểm nhận dạng</th>
                <th>Trạng thái</th>
            </tr>

            </thead>

            <tbody>

            <c:forEach var="nv" items="${lst}">

                <tr>

                    <td>${nv.maNV}</td>

                    <td>${nv.hoTen}</td>

                    <td>${nv.ngaySinh}</td>

                    <td>${nv.gioiTinh}</td>

                    <td>${nv.sdt}</td>

                    <td>${nv.email}</td>

                    <td>${nv.diaChi}</td>

                    <td>${nv.cccd}</td>

                    <td>${nv.ngayCapCCCD}</td>

                    <td>${nv.dacDiemNhanDang}</td>

                    <td class="status-active">${nv.tenTrangThai}</td>

                </tr>

            </c:forEach>

            </tbody>

        </table>

    </div>

</main>

</body>
</html>