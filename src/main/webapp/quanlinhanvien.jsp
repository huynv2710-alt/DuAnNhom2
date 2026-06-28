<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>

<head>
    <meta charset="UTF-8">
    <title>Quản lý nhân viên</title>

    <style>

{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Arial, sans-serif;
}

body{
    display:flex;
    min-height:100vh;
    background:#f4f4f4;
}

.content{
    flex:1;
    padding:25px;
    overflow:hidden;
}

h1{
    margin-bottom:25px;
    color:#00897b;
    font-size:55px;
    font-weight:bold;
    letter-spacing:2px;
}

.table-container{
    background:#fff;
    padding:20px;
    border-radius:12px;
    box-shadow:0 2px 10px rgba(0,0,0,0.1);
    overflow-x:auto;
}

table{
    width:100%;
    min-width:1200px;
    border-collapse:collapse;
}

th{
    background:#00897b;
    color:white;
    padding:15px 12px;
    border:1px solid #ddd;
    white-space:nowrap;
    font-size:18px;
}

td{
    padding:12px;
    border:1px solid #ddd;
    text-align:center;
    white-space:nowrap;
    font-size:16px;
}

tr:nth-child(even){
    background:#fafafa;
}

tr:hover{
    background:#f2f2f2;
}

.status-active{
    color:#2e7d32;
    font-weight:bold;
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